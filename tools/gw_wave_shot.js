// gw_wave_shot.js: screenshots of the bot at a chosen wave (layout and look checks, DECISIONS X6).
// Usage: node tools/gw_wave_shot.js <build_dir> <out_dir> <W>x<H>[t] <name>:<map>:<wave>:<delay_ms> ...
//   e.g. node tools/gw_wave_shot.js build/web /home/user/gw_shots 844x390t sun_road_boss:sun_road:24:15000
// "t" = touch (a phone in landscape). The bot hurries (speed 64) to <wave> and then
// plays at x1 (--perf-wave, the frame-time probe's switch); the shot is taken
// <delay_ms> after the switch and saved as <out_dir>/<name>.png. Playwright from NODE_PATH.
// An optional fifth field <x>,<y> (viewport px) clicks / taps there first and waits 0.7 s
// (opens a spot's build menu: the menu layout check, DECISIONS Y8).
const http = require('http'), fs = require('fs'), path = require('path');
const { chromium } = require('playwright');
const [buildDir, outDir, size, ...jobs] = process.argv.slice(2);
const T = { '.html': 'text/html', '.js': 'application/javascript', '.wasm': 'application/wasm', '.png': 'image/png' };
const server = http.createServer((q, r) => {
  const u = decodeURIComponent(q.url.split('?')[0]);
  const f = path.join(buildDir, u === '/' ? 'index.html' : u);
  fs.readFile(f, (e, d) => { if (e) { r.writeHead(404); r.end(); return; } r.writeHead(200, { 'Content-Type': T[path.extname(f)] || 'application/octet-stream' }); r.end(d); });
});
(async () => {
  fs.mkdirSync(outDir, { recursive: true });
  await new Promise((r) => server.listen(0, '127.0.0.1', r));
  const touch = size.endsWith('t');
  const [w, h] = size.replace('t', '').split('x').map(Number);
  const browser = await chromium.launch();
  for (const j of jobs) {
    const [name, map, wave, delay, tapAt] = j.split(':');
    const ctx = await browser.newContext({ viewport: { width: w, height: h }, hasTouch: touch, isMobile: touch, deviceScaleFactor: touch ? 2 : 1 });
    const page = await ctx.newPage();
    let started = null;  // Resolves on the first PERF line (the wave is reached).
    const first = new Promise((r) => { started = r; });
    page.on('console', (m) => { if (m.text().startsWith('PERF')) started(); });
    page.on('pageerror', (e) => console.log('PAGEERROR', e.message));
    await page.goto(`http://127.0.0.1:${server.address().port}/index.html?gw_autotest=--map=${map},--speed=64,--perf-wave=${wave}`);
    const play = page.locator('#status-play');
    await play.waitFor({ state: 'visible', timeout: 120000 }).catch(() => {});
    if (touch) await play.tap().catch(() => {}); else await play.click().catch(() => {});
    const ok = await Promise.race([first.then(() => true), new Promise((r) => setTimeout(() => r(false), 900000))]);
    if (ok) await page.waitForTimeout(Number(delay));
    if (tapAt) {
      const [tx, ty] = tapAt.split(',').map(Number);
      if (touch) await page.touchscreen.tap(tx, ty); else await page.mouse.click(tx, ty);
      await page.waitForTimeout(700);
    }
    await page.screenshot({ path: path.join(outDir, `${name}.png`) });
    console.log(ok ? 'saved' : 'TIMEOUT (saved anyway)', name);
    await ctx.close();
  }
  await browser.close(); server.close();
})();
