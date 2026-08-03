import { readFile } from "node:fs/promises";
import assert from "node:assert/strict";

const html = await readFile(new URL("./index.html", import.meta.url), "utf8");
const css = await readFile(new URL("./styles.css", import.meta.url), "utf8");
const config = JSON.parse(await readFile(new URL("./vercel.json", import.meta.url), "utf8"));

assert.doesNotMatch(html, /\bCLI\b|brew install|copysight-cli/i);
assert.match(html, /CopySight-1\.1\.0\.dmg/g);
assert.match(html, /https:\/\/apps\.apple\.com\/app\/id6797554906/g);
assert.match(html, /⌃ ⌘ 2/);
assert.match(html, /Screen text\. Copied\./);
assert.match(html, /canonical.*copysight\.guillermozubikarai\.dev/);
assert.match(html, /application\/ld\+json/);
assert.match(css, /@media \(max-width: 600px\)/);
assert.equal(config.headers[0].headers.some(({ key }) => key === "Content-Security-Policy"), true);
console.log("web contract: ok");
