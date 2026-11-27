// gw_phone.js: the phone measurement of the Web build (docs/PHONE.md, DECISIONS P3).
// Usage: node tools/gw_phone.js <build_dir> <shot_dir> [title] [<map>:<wave> ...] [--no-music]
//   e.g. node tools/gw_phone.js build/web /home/user/gw_shots/phone title sanctum:20 world_tree:20
// Headless Chromium (software GL) emulating a phone in landscape (844 x 390, touch, DPR 2).
// "title": loads the page with no flags, taps Play and waits for the title screen's music
//   line; prints the bytes downloaded, ms to the Play gate, ms from Play to the title, and
//   the page memory (JS heap incl. array buffers / wasm, renderer RSS) 3 s later.
// "<map>:<wave>": the bot hurries to <wave> (?gw_autotest=--map=,--speed=64,--perf-wave=),
//   then plays at x1; 3 s later it samples requestAnimationFrame for 8 s and prints mean /
//   p90 frame ms, memory, every music/*.ogg response (status, bytes) and the game's
//   "[audio] song" lines (the stream on the player and its playing state).
// "menu:<x>,<y>/<x>,<y>/...": from the title, taps those points (CSS px) in turn, 1.5 s apart (a
//   player's path into a run: the bot skips Main, so it never asks for music), shoots each
//   step (menu_<i>.png), waits 15 s and prints the music responses, "[audio] song" lines and memory.
// --no-music: the server answers 404 for music/*.ogg (the failed-fetch check).
// A shot of each step goes to <shot_dir>/<step>.png. Run one page at a time on a quiet machine.
const http = require('http'), fs = require('fs'), path = require('path'), { execSync } = require('child_process');
const { chromium } = require('playwright');
const args = process.argv.slice(2);
const noMusic = args.includes('--no-music');
const [buildDir, shotDir, ...jobs] = args.filter((a) => a !== '--no-music');
const T = { '.html': 'text/html', '.js': 'application/javascript', '.wasm': 'application/wasm', '.png': 'image/png', '.ogg': 'audio/ogg' };
let served = 0;  // Bytes the server sent since the last reset.
const server = http.createServer((q, r) => {
  const u = decodeURIComponent(q.url.split('?')[0]);
  const f = path.join(buildDir, u === '/' ? 'index.html' : u);
  if (noMusic && u.startsWith('/music/')) { r.writeHead(404); r.end(); return; }
  fs.readFile(f, (e, d) => { if (e) { r.writeHead(404); r.end(); return; } served += d.length; r.writeHead(200, { 'Content-Type': T[path.extname(f)] || 'application/octet-stream' }); r.end(d); });
});
// Sum of the RSS of Chromium's renderer processes (MB; one page open at a time).
function rendererMb() {
  try {
    const out = execSync("ps -eo rss,args | grep -- '--type=renderer' | grep -v grep", { encoding: 'utf8' });
    return out.trim().split('\n').reduce((s, l) => s + Number(l.trim().split(/\s+/)[0]), 0) / 1024;
  } catch (e) { return 0; }
}
async function memory(page) {
  const cdp = await page.context().newCDPSession(page);
  const h = await cdp.send('Runtime.getHeapUsage');
  const mb = (b) => (b / 1048576).toFixed(0);
  return `heap=${mb(h.usedSize)}MB buffers=${mb(h.backingStorageSize || 0)}MB renderer_rss=${rendererMb().toFixed(0)}MB`;
}
(async () => {
  fs.mkdirSync(shotDir, { recursive: true });
  await new Promise((r) => server.listen(0, '127.0.0.1', r));
  const browser = await chromium.launch();
  for (const j of jobs) {
    const ctx = await browser.newContext({ viewport: { width: 844, height: 390 }, hasTouch: true, isMobile: true, deviceScaleFactor: 2 });
    const page = await ctx.newPage();
    const lines = [];  // "[audio] song" console lines.
    let errors = 0;  // Console errors and page errors.
    let perf = '';  // Latest PERF line.
    let menuSeen = null, perfSeen = null;
    const menu = new Promise((r) => { menuSeen = r; });
    const first = new Promise((r) => { perfSeen = r; });
    page.on('console', (m) => {
      const t = m.text();
      if (m.type() === 'error') { errors++; console.log('  console error:', t.slice(0, 160)); }
      if (t.startsWith('[audio] song')) lines.push(t);
      if (t.startsWith('[audio] main-thread startup')) menuSeen();
      if (t.startsWith('PERF')) { perf = t; perfSeen(); }
    });
    page.on('pageerror', (e) => { errors++; console.log('PAGEERROR', e.message); });
    const songs = [];  // music/*.ogg responses.
    page.on('response', async (r) => { if (r.url().includes('/music/')) songs.push(`${r.status()} ${path.basename(r.url())} ${(await r.body().catch(() => Buffer.alloc(0))).length}B`); });
    served = 0;
    const t0 = Date.now();
    const menuTaps = j.startsWith('menu:') ? j.slice(5).split('/') : null;
    const title = j === 'title' || menuTaps !== null;
    const [map, wave] = j.split(':');
    await page.goto(`http://127.0.0.1:${server.address().port}/index.html` + (title ? '' : `?gw_autotest=--map=${map},--speed=64,--perf-wave=${wave}`));
    const play = page.locator('#status-play');
    await play.waitFor({ state: 'visible', timeout: 300000 }).catch(() => {});
    const tGate = Date.now() - t0, gateBytes = served;
    await play.tap().catch(() => {});
    const t1 = Date.now();
    if (title) {
      const ok = await Promise.race([menu.then(() => true), new Promise((r) => setTimeout(() => r(false), 120000))]);
      const tTitle = Date.now() - t1;
      await page.waitForTimeout(3000);
      if (menuTaps) {
        for (let i = 0; i < menuTaps.length; i++) {
          const [x, y] = menuTaps[i].split(',').map(Number);
          await page.touchscreen.tap(x, y);
          await page.waitForTimeout(1500);
          await page.screenshot({ path: path.join(shotDir, `menu_${i + 1}${noMusic ? '_nomusic' : ''}.png`) });
        }
        await page.waitForTimeout(15000);
        await page.screenshot({ path: path.join(shotDir, `menu_run${noMusic ? '_nomusic' : ''}.png`) });
        console.log(`menu ${await memory(page)} errors=${errors}`);
        console.log(`  music responses: ${songs.join(', ') || 'none'}`);
        for (const l of lines) console.log(`  ${l}`);
        await ctx.close();
        continue;
      }
      console.log(`title download=${(gateBytes / 1048576).toFixed(1)}MB gate=${tGate}ms play_to_title=${ok ? tTitle : 'TIMEOUT'}ms ${await memory(page)} errors=${errors}`);
      await page.screenshot({ path: path.join(shotDir, 'title.png') });
      await ctx.close();
      continue;
    }
    const ok = await Promise.race([first.then(() => true), new Promise((r) => setTimeout(() => r(false), 900000))]);
    if (!ok) { console.log(`${map} TIMEOUT before wave ${wave}`); await ctx.close(); continue; }
    await page.waitForTimeout(3000);
    const f = await page.evaluate(() => new Promise((res) => {
      const d = []; let p = performance.now(); const end = p + 8000;
      const step = (t) => { d.push(t - p); p = t; if (t < end) requestAnimationFrame(step); else res(d); };
      requestAnimationFrame(step);
    }));
    f.sort((a, b) => a - b);
    const mean = f.reduce((a, b) => a + b, 0) / f.length;
    console.log(`${map.padEnd(12)} mean=${mean.toFixed(1)}ms p90=${f[Math.floor(f.length * 0.9)].toFixed(1)}ms ${await memory(page)} total_download=${(served / 1048576).toFixed(1)}MB errors=${errors} ${perf}`);
    console.log(`  music responses: ${songs.join(', ') || 'none'}`);
    for (const l of lines) console.log(`  ${l}`);
    await page.screenshot({ path: path.join(shotDir, `${map}_w${wave}${noMusic ? '_nomusic' : ''}.png`) });
    await ctx.close();
  }
  await browser.close(); server.closeAllConnections(); server.close();
  process.exit(0);
})();
