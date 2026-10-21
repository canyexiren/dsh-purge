/**
 * 把仓库里的 canyexiren 占位统一替换成真实 GitHub 账号。
 * 用法：node scripts/set-owner.mjs <github-owner>
 * 例：  node scripts/set-owner.mjs canyexiren
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const owner = process.argv[2];
if (!owner || !/^[A-Za-z0-9_.-]+$/.test(owner)) {
  console.error("usage: node scripts/set-owner.mjs <github-owner>");
  process.exit(1);
}

const root = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const skip = new Set(["node_modules", ".git"]);
let touched = 0;

function walk(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    if (skip.has(e.name)) continue;
    const p = path.join(dir, e.name);
    if (e.isDirectory()) { walk(p); continue; }
    if (!/\.(md|json|yml|mjs|js|sh|html|txt)$/.test(e.name)) continue;
    const s = fs.readFileSync(p, "utf8");
    if (!s.includes("canyexiren")) continue;
    fs.writeFileSync(p, s.split("canyexiren").join(owner), "utf8");
    touched++;
    console.log("patched " + path.relative(root, p));
  }
}

walk(root);
console.log("done, files=" + touched + ", owner=" + owner);
