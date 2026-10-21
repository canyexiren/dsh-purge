# NOTICE — 来源、署名与本次改动

## 上游

- 项目名：`dsh-purge`
- 原作者：**小杨**（品牌名「小码酱」）
- 原仓库（已被作者删除）：`https://github.com/YuJunZhiXue/dsh-purge`
- 许可证：MIT（见 `LICENSE`，版权行原样保留）

本仓库是 **dsh-purge@1.1.67 的恢复快照**。上游仓库删除后，本仓库由本机已安装的 npm 包
（`~/.dsh/profiles/<profile>/node_modules/dsh-purge`）反推重建，用于继续分发与二次开发。

## 本次相对发布包做的改动

1. **补回被 npm `files` 排除的默认提示词源文件** `lib/default-prompt-inject.md`：
   原文以 `sealSlot()`（AES-256-GCM + deflate，密钥由 `MASK` 经 `mixKey()` 派生）
   密封在 `lib/asset-table.js` 的 `SLOT/MASK/TAG/IV` 中，本仓库用同仓库内的
   `lib/table-read.js#openSlot()` 解封还原，未改动一个字节。
2. 仓库地址、安装地址由原仓库改为本仓库（`scripts/set-owner.mjs` 统一改写）。
3. 根 README 重写为分发版；作者原文完整保留在 `docs/original/` 下，未删改。
4. 增加 `.gitignore` 与本文件。

代码本身（`lib/`、`client.js`、`bin/`、`presets/`、`skills/`、`scripts/`）与发布包一致，
未做功能性修改。

## 署名

依据上游 README 的 **Attribution required**：

> 如果你借用本项目的名称、思路、代码或提示词，必须署名作者并注明来源仓库。

本仓库已在上方与 README 中署名原作者 **小杨（小码酱）**，并保留 MIT 版权声明。
二次开发请同样保留该署名与来源说明。
