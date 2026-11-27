// gw_perf.js: late-map frame time of the Web build, one map after another (DECISIONS X5).
// Usage: node tools/gw_perf.js <build_dir> <map>:<wave> ...   e.g. sanctum:20 maelstrom:20
// Opens 1280x720 headless Chromium (software GL), runs the bot with
// ?gw_autotest=--map=<map>,--speed=64,--perf-wave=<wave>: the bot hurries to that
// wave, then drops to speed 1 and prints "PERF" lines; after 3 s the script
// samples requestAnimationFrame intervals for 8 s and prints one line per map:
// mean / p90 frame ms and the enemy count. Run it on a quiet machine, one page
// at a time; compare maps with each other (the Sanctum is the reference).
const http = require('http'), fs = require('fs'), path = require('path');
const { chromium } = require('playwright');
const [buildDir, ...jobs] = process.argv.slice(2);
const T = { '.html': 'text/html', '.js': 'application/javascript', '.wasm': 'application/wasm', '.png': 'image/png' };
const server = http.createServer((q, r) => {
  const u = decodeURIComponent(q.url.split('?')[0]);
  const f = path.join(buildDir, u === '/' ? 'index.html' : u);
  fs.readFile(f, (e, d) => { if (e) { r.writeHead(404); r.end(); return; } r.writeHead(200, { 'Content-Type': T[path.extname(f)] || 'application/octet-stream' }); r.end(d); });
});
(async () => {
  await new Promise((r) => server.listen(0, '127.0.0.1', r));
  const browser = await chromium.launch();
  for (const j of jobs) {
    const [map, wave] = j.split(':');
    const page = await (await browser.newContext({ viewport: { width: 1280, height: 720 } })).newPage();
    let last = '';  // Latest PERF line.
    let started = null;  // Resolves on the first PERF line.
    const first = new Promise((r) => { started = r; });
    page.on('console', (m) => { const t = m.text(); if (t.startsWith('PERF')) { last = t; started(); } });
    page.on('pageerror', (e) => console.log('PAGEERROR', e.message));
    await page.goto(`http://127.0.0.1:${server.address().port}/index.html?gw_autotest=--map=${map},--speed=64,--perf-wave=${wave}`);
    const play = page.locator('#status-play');
    await play.waitFor({ state: 'visible', timeout: 120000 }).catch(() => {});
    await play.click().catch(() => {});
    const ok = await Promise.race([first.then(() => true), new Promise((r) => setTimeout(() => r(false), 900000))]);
    if (!ok) { console.log(`${map} TIMEOUT before wave ${wave}`); await page.close(); continue; }
    await page.waitForTimeout(3000);
    const f = await page.evaluate(() => new Promise((res) => {
      const d = []; let p = performance.now(); const end = p + 8000;
      const step = (t) => { d.push(t - p); p = t; if (t < end) requestAnimationFrame(step); else res(d); };
      requestAnimationFrame(step);
    }));
    f.sort((a, b) => a - b);
    const mean = f.reduce((a, b) => a + b, 0) / f.length;
    console.log(`${map.padEnd(16)} mean=${mean.toFixed(1)}ms p90=${f[Math.floor(f.length * 0.9)].toFixed(1)}ms frames=${f.length} ${last}`);
    await page.close();
  }
  await browser.close(); server.closeAllConnections(); server.close();
  process.exit(0);
})();
