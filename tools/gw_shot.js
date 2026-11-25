// gw_shot.js: screenshots of the Web build for the art check (CLAUDE.md "Check by eye").
// Usage: node tools/gw_shot.js <build_dir> <out_dir> <name>:<query>:<wait_ms> ...   e.g. sanctum:gw_autotest=--map=sanctum,--speed=2:40000
// Serves build_dir, opens 1280x720, taps the Play gate, waits, saves <out_dir>/art_<name>.png. Playwright from NODE_PATH.
const http = require('http'), fs = require('fs'), path = require('path');
const { chromium } = require('playwright');
const [buildDir, outDir, ...jobs] = process.argv.slice(2);
const T = { '.html': 'text/html', '.js': 'application/javascript', '.wasm': 'application/wasm', '.png': 'image/png' };
const server = http.createServer((q, r) => {
  const f = path.join(buildDir, decodeURIComponent(q.url.split('?')[0]) === '/' ? 'index.html' : decodeURIComponent(q.url.split('?')[0]));
  fs.readFile(f, (e, d) => { if (e) { r.writeHead(404); r.end(); return; } r.writeHead(200, { 'Content-Type': T[path.extname(f)] || 'application/octet-stream' }); r.end(d); });
});
(async () => {
  fs.mkdirSync(outDir, { recursive: true });
  await new Promise((r) => server.listen(0, '127.0.0.1', r));
  const browser = await chromium.launch();
  for (const j of jobs) {
    const [name, query, wait] = j.split(':');
    const page = await (await browser.newContext({ viewport: { width: 1280, height: 720 } })).newPage();
    page.on('pageerror', (e) => console.log('PAGEERROR', e.message));
    await page.goto(`http://127.0.0.1:${server.address().port}/index.html${query ? '?' + query : ''}`);
    const play = page.locator('#status-play');
    await play.waitFor({ state: 'visible', timeout: 120000 }).catch(() => {});
    await play.click().catch(() => {});
    await page.waitForTimeout(Number(wait));
    await page.screenshot({ path: path.join(outDir, `art_${name}.png`) });
    console.log('saved', name);
    await page.close();
  }
  await browser.close(); server.close();
})();
