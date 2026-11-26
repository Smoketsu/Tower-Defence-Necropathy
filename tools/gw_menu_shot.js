// gw_menu_shot.js: screenshots of the menu screens (look checks, DECISIONS M1).
// Usage: node tools/gw_menu_shot.js <build_dir> <out_dir> <W>x<H>[t] "<name>|<gw_flags>[|<steps>]" ...
//   e.g. node tools/gw_menu_shot.js build/web /home/user/gw_shots/menus 844x390t "after_codex_phone|--menu=codex,--unlock-all"
// "t" = touch (a phone in landscape, device scale 2). <gw_flags> goes to ?gw_flags= (main.gd's
// --menu=ID opens a screen at once). <steps> (optional, ";"-separated) run before the shot:
// tap:x,y (viewport px) / key:Name (Playwright key) / drag:x1,y1,x2,y2 / wait:ms / shot:name (an extra shot).
// Each job waits 6 s after Play for the screen and its entrance motion. Playwright from NODE_PATH.
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
    const [name, flags, steps] = j.split('|');
    const ctx = await browser.newContext({ viewport: { width: w, height: h }, hasTouch: touch, isMobile: touch, deviceScaleFactor: touch ? 2 : 1 });
    const page = await ctx.newPage();
    page.on('console', (m) => { const t = m.text(); if (/ERROR|SCRIPT/.test(t)) console.log('CONSOLE', t.slice(0, 300)); });
    page.on('pageerror', (e) => console.log('PAGEERROR', e.message));
    await page.goto(`http://127.0.0.1:${server.address().port}/index.html?gw_flags=${flags || ''}`);
    const play = page.locator('#status-play');
    await play.waitFor({ state: 'visible', timeout: 120000 }).catch(() => {});
    if (touch) await play.tap().catch(() => {}); else await play.click().catch(() => {});
    await page.waitForTimeout(6000);
    for (const s of (steps || '').split(';').filter(Boolean)) {
      const [op, arg] = [s.slice(0, s.indexOf(':')), s.slice(s.indexOf(':') + 1)];
      if (op === 'tap') { const [x, y] = arg.split(',').map(Number); if (touch) await page.touchscreen.tap(x, y); else await page.mouse.click(x, y); await page.waitForTimeout(600); }
      else if (op === 'key') { await page.keyboard.press(arg); await page.waitForTimeout(250); }
      else if (op === 'drag') {
        const [x1, y1, x2, y2] = arg.split(',').map(Number);
        if (touch) {
          const cdp = await ctx.newCDPSession(page);
          const pt = (x, y) => [{ x, y, id: 1 }];
          await cdp.send('Input.dispatchTouchEvent', { type: 'touchStart', touchPoints: pt(x1, y1) });
          for (let i = 1; i <= 10; i++) { await cdp.send('Input.dispatchTouchEvent', { type: 'touchMove', touchPoints: pt(x1 + (x2 - x1) * i / 10, y1 + (y2 - y1) * i / 10) }); await page.waitForTimeout(16); }
          await cdp.send('Input.dispatchTouchEvent', { type: 'touchEnd', touchPoints: [] });
        } else { await page.mouse.move(x1, y1); await page.mouse.down(); await page.mouse.move(x2, y2, { steps: 10 }); await page.mouse.up(); }
        await page.waitForTimeout(600);
      }
      else if (op === 'wait') await page.waitForTimeout(Number(arg));
      else if (op === 'shot') await page.screenshot({ path: path.join(outDir, `${arg}.png`) });
    }
    await page.screenshot({ path: path.join(outDir, `${name}.png`) });
    console.log('saved', name);
    await ctx.close();
  }
  await browser.close(); server.close();
})();
