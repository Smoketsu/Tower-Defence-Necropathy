#!/usr/bin/env python3
"""balance_matrix.py: the repeatable balance measurement (DECISIONS B1).

Runs the autotest bot over every map (tools/map_list.tscn, the one map list) in
these sets, at most JOBS Godot processes at once (default 3: the machine is shared):
  default  the map's default order, seeds 1-12
  weak     the map's weak order, seeds 1-4
  kit      the act's kit order(s), seeds 1-4 (Act I kit_a and kit_b; Act IV has none)
  ult      the default order with each non-Rally ultimate, seeds 1-4
Each run's log is kept in <out>/runs/<key>.log and reused when it already holds a
summary (delete the folder to measure again), so an interrupted pass resumes.
Writes <out>/<name>.md: one row per map (wins / seeds and lives kept per set).

Usage: python3 tools/balance_matrix.py <out_dir> <name> [--maps=a,b] [--sets=default,weak,kit,ult]
       [--seeds=12] [--hp-end=X] [--jobs=3]
--hp-end probes one value on every listed map (its runs are cached under their own key).
"""
import os
import re
import statistics
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))  # The project folder.
GODOT = os.environ.get("GODOT", "/home/user/tools/godot/Godot_v4.3-stable_linux.x86_64")  # Engine binary.
ULTS = ["sovereigns_decree", "eclipse", "grave_tide"]  # The non-Rally ultimates (CharacterData.ULTIMATES).
# Kit orders by act index in campaign order (three maps an act); Act IV has none.
KITS = [["kit_a", "kit_b"], ["tide_kit"], ["court_kit"], [], ["shogunate_kit"], ["norse_kit"],
        ["dynasty_kit"], ["pantheon_kit"], ["inferno_kit"], ["host_kit"], ["eye_kit"],
        ["empire_kit"], ["concord_kit"], ["titans_kit"], ["year_kit"]]


def maps():
    """[(map id, weak order)] in campaign order, from tools/map_list.tscn."""
    out = subprocess.run([GODOT, "--headless", "tools/map_list.tscn"], cwd=ROOT, capture_output=True, text=True).stdout
    return [tuple(l.split()[1:3]) for l in out.splitlines() if l.startswith("MAP ")]


def run(job):
    """Runs one autotest (job = (key, args, log path)) unless its log is complete; returns the parsed row."""
    key, args, log = job
    if not (os.path.exists(log) and "stuck_enemies=" in open(log).read()):
        with open(log, "w") as f:
            subprocess.run(["timeout", "600", GODOT, "--headless", "--fixed-fps", "60", "--quit-after", "400000",
                            "--", "--autotest", "--speed=32"] + args, cwd=ROOT, stdout=f, stderr=subprocess.STDOUT)
    text = open(log).read()
    res = re.search(r"^result=(\w+)", text, re.M)
    lives = re.search(r"lives=(\d+)/\d+", text)
    stuck = re.search(r"^stuck_enemies=(\d+)", text, re.M)
    leaks = re.search(r"^leaks=(.*)$", text, re.M)
    return {"key": key, "won": bool(res and res.group(1) == "won"), "lives": int(lives.group(1)) if lives else 0,
            "errors": len(re.findall(r"SCRIPT ERROR|ERROR:|WARNING:", text)),
            "stuck": int(stuck.group(1)) if stuck else -1, "leaks": leaks.group(1) if leaks else "?"}


def cell(rows):
    """'w/n med m min k' for a list of run rows ('-' when empty)."""
    if not rows:
        return "-"
    lv = [r["lives"] for r in rows if r["won"]]
    s = "%d/%d" % (len(lv), len(rows))
    if lv:
        s += " %g (%d)" % (statistics.median(lv), min(lv))
    return s


def main():
    out, name = sys.argv[1], sys.argv[2]
    opt = dict(a[2:].split("=", 1) for a in sys.argv[3:])  # --key=value options.
    sets = opt.get("sets", "default,weak,kit,ult").split(",")
    seeds = int(opt.get("seeds", "12"))
    hp = opt.get("hp-end", "")
    want = opt.get("maps", "").split(",") if opt.get("maps") else None
    os.makedirs(os.path.join(out, "runs"), exist_ok=True)
    all_maps = maps()
    jobs, plan = [], {}  # Every job; map -> set -> [keys].
    for i, (mid, weak) in enumerate(all_maps):
        if want and mid not in want:
            continue
        plan[mid] = {}
        base = ["--map=" + mid] + (["--hp-end=" + hp] if hp else [])
        specs = []  # (set, tag, extra args, seeds)
        if "default" in sets:
            specs.append(("default", "d", [], seeds))
        if "weak" in sets:
            specs.append(("weak", "w", ["--build=" + weak], 4))
        if "kit" in sets:
            for k in KITS[i // 3]:
                specs.append(("kit", k, ["--build=" + k], 4))
        if "ult" in sets:
            for u in ULTS:
                specs.append((u, u, ["--ultimate=" + u], 4))
        for st, tag, extra, n in specs:
            for s in range(1, n + 1):
                key = "%s_%s_s%d%s" % (mid, tag, s, ("_hp" + hp) if hp else "")
                jobs.append((key, base + extra + ["--seed=%d" % s], os.path.join(out, "runs", key + ".log")))
                plan[mid].setdefault(st, []).append(key)
    with ThreadPoolExecutor(int(opt.get("jobs", "3"))) as ex:
        done = {r["key"]: r for r in ex.map(run, jobs)}
    cols = [c for c in ["default", "weak", "kit"] + ULTS if any(c in p for p in plan.values())]
    lines = ["# Balance matrix: %s%s" % (name, (" (--hp-end=%s)" % hp) if hp else ""), "",
             "Cells: wins/runs, median lives kept of wins (worst win). Default seeds 1-%d, others 1-4." % seeds, "",
             "| Map | " + " | ".join(cols) + " | default lives by seed | errors | stuck |",
             "|---|" + "---|" * (len(cols) + 3)]
    bad = []
    for mid, p in plan.items():
        rows = [done[k] for ks in p.values() for k in ks]
        d = [done[k] for k in p.get("default", [])]
        lv = ",".join(str(r["lives"]) if r["won"] else "L" for r in d)
        errs, stuck = sum(r["errors"] for r in rows), sum(1 for r in rows if r["stuck"] != 0)
        bad += [r["key"] for r in rows if r["errors"] or r["stuck"] != 0]
        lines.append("| %s | %s | %s | %d | %d |" % (mid, " | ".join(cell([done[k] for k in p.get(c, [])]) for c in cols), lv, errs, stuck))
    if bad:
        lines += ["", "Runs with errors or stuck enemies: " + ", ".join(bad)]
    path = os.path.join(out, name + ".md")
    open(path, "w").write("\n".join(lines) + "\n")
    print("\n".join(lines))


if __name__ == "__main__":
    main()
