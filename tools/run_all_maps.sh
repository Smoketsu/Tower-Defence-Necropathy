#!/usr/bin/env bash
# run_all_maps.sh: runs every registered map (tools/map_list.tscn, the one map
# list) with its default build order, two Godot processes at a time, and prints
# one line per map for the lead: map, result, lives, script errors / warnings,
# stuck enemies. Options: SEED=N (default 1), WEAK=1 (also the weak orders),
# GODOT=path. Run from anywhere; exit 1 when any run errored or did not finish.
set -uo pipefail
cd "$(dirname "$0")/.."
GODOT="${GODOT:-/home/user/tools/godot/Godot_v4.3-stable_linux.x86_64}"
SEED="${SEED:-1}"
OUT="$(mktemp -d)"
"$GODOT" --headless --import > /dev/null 2>&1
mapfile -t ROWS < <("$GODOT" --headless tools/map_list.tscn 2>&1 | grep '^MAP ')
JOBS=()
for row in "${ROWS[@]}"; do
	read -r _ id weak <<< "$row"
	JOBS+=("$id|")
	[ "${WEAK:-0}" = "1" ] && JOBS+=("$id|$weak")
done
run() {  # $1 = "map|build" ("" build = the map's default)
	local id="${1%%|*}" build="${1#*|}" log="$OUT/${1//|/_}.log"
	timeout 600 "$GODOT" --headless --fixed-fps 60 --quit-after 200000 -- --autotest --map="$id" --seed="$SEED" ${build:+--build=$build} > "$log" 2>&1
	echo $? > "$log.status"
}
for ((i = 0; i < ${#JOBS[@]}; i += 2)); do
	run "${JOBS[i]}" &
	[ $((i + 1)) -lt ${#JOBS[@]} ] && run "${JOBS[i + 1]}" &
	wait
done
fail=0
for job in "${JOBS[@]}"; do
	log="$OUT/${job//|/_}.log"
	res=$(grep -oE '^result=[a-z]+' "$log" | cut -d= -f2)
	lives=$(grep -oE 'lives=[0-9]+/[0-9]+' "$log" | head -1 | cut -d= -f2)
	errs=$(grep -cE 'SCRIPT ERROR|ERROR:|WARNING:' "$log")
	stuck=$(grep -oE '^stuck_enemies=[0-9]+' "$log" | cut -d= -f2)
	build="${job#*|}"
	printf '%-18s %-14s %-5s lives=%-6s errors=%s stuck=%s exit=%s\n' "${job%%|*}" "${build:-default}" "${res:-none}" "${lives:--}" "$errs" "${stuck:--}" "$(cat "$log.status")"
	if [ "$errs" != "0" ] || [ "$(cat "$log.status")" != "0" ] || [ "${stuck:-1}" != "0" ]; then fail=1; fi
done
rm -rf "$OUT"
exit $fail
