import { readFile } from "node:fs/promises";
import assert from "node:assert/strict";

const [root, english, spanish, css, sitemap, config] = await Promise.all([
  readFile(new URL("./index.html", import.meta.url), "utf8"),
  readFile(new URL("./en.html", import.meta.url), "utf8"),
  readFile(new URL("./es.html", import.meta.url), "utf8"),
  readFile(new URL("./styles.css", import.meta.url), "utf8"),
  readFile(new URL("./sitemap.xml", import.meta.url), "utf8"),
  readFile(new URL("./vercel.json", import.meta.url), "utf8").then(JSON.parse),
]);

for (const html of [english, spanish]) {
  assert.doesNotMatch(html, /\bCLI\b|brew install|copysight-cli/i);
  assert.match(html, /\/downloads\/CopySight-1\.1\.0\.dmg/g);
  assert.equal((html.match(/https:\/\/github\.com\/copysightapp\/copysight/g) ?? []).length, 2);
  assert.match(html, /https:\/\/apps\.apple\.com\/app\/id6797554906/g);
  assert.match(html, /⌃ ⌘ 2/);
  assert.match(html, /application\/ld\+json/);
  assert.match(html, /hreflang="en"/);
  assert.match(html, /hreflang="es"/);
}

assert.match(root, /url=\/en/);
assert.match(english, /<html lang="en">/);
assert.match(english, /Screen text\. Copied\./);
assert.match(english, /Privacy policy/);
assert.match(english, /never written to disk, retained after recognition, uploaded, or sent to a server/);
assert.match(english, /does not collect, receive, store, sell, or share/);
assert.match(spanish, /<html lang="es">/);
assert.match(spanish, /Texto en pantalla\. Copiado\./);
assert.match(spanish, /Política de privacidad/);
assert.match(spanish, /Nunca se escribe en disco, se conserva después del reconocimiento, se sube ni se envía a un servidor/);
assert.match(spanish, /no recoge, recibe, almacena, vende ni comparte con terceros/);
assert.match(css, /@media \(max-width: 600px\)/);
assert.match(sitemap, /\/en</);
assert.match(sitemap, /\/es</);
assert.equal(config.redirects[0].has[0].key, "accept-language");
assert.equal(config.redirects[0].destination, "/es");
assert.equal(config.redirects[1].destination, "/en");
assert.equal(config.headers[0].headers.some(({ key }) => key === "Content-Security-Policy"), true);
assert.equal(config.headers.some(({ source }) => source === "/downloads/(.*)"), true);
console.log("web contract: ok");
