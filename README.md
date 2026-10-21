<p align="center">
  <img src="docs/banner.svg" alt="dsh-purge" width="720">
</p>

<h1 align="center">⚔️ dsh-purge</h1>

<p align="center"><strong>v1.1.68</strong></p>

<p align="center">
  <em>DeepSeek Harness 破甲：让所有模型都能破甲，不同模型可换不同提示词；默认提示词面向国模「小码酱」。<br>
  Jailbreak for every model — swap prompts per model.<br>
  求 Star 收藏 ⭐ 如要二开，请查看<a href="#attribution">署名要求</a>部分。</em>
</p>

<p align="center">
  <a href="https://github.com/__OWNER__/dsh-purge/stargazers"><img src="https://img.shields.io/github/stars/__OWNER__/dsh-purge?label=Stars" alt="Stars"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-65a30d" alt="MIT"></a>
  <img src="https://img.shields.io/badge/dsh-0.2.0--rc.2-blue" alt="dsh 0.2">
  <img src="https://img.shields.io/badge/Node.js-%3E%3D18-339933" alt="Node.js">
</p>

<p align="center">
  <a href="README.md">中文</a> | <a href="README.en.md">English</a>
</p>

---

## 这是什么

**dsh-purge** 是本机已装官方 [DeepSeek Harness](https://www.deepseek.com/harness/) 的提示词注入 / 本机补丁插件。
它不跟你讲"模型会不会答"，它处理的是**宿主层**：Harness 在运行时重写系统提示词、审批门、沙箱策略、会话迁移。
把这层和"模型拒答"拆开看，你才能在自己的机器上做可控评测，也能一眼看出哪条默认策略收紧过头了。

- 官方 **Web**（`dsh web`）与官方 **桌面 EXE**（0.2.0-rc.2）都支持，分开安装、分开 Apply。
- 目标只有你本机的官方 `@deepseek-ai` 包与本地配置；不改 Harness 源码树。
- 默认提示词面向国模「小码酱」，可整体替换；换模型就换一份提示词，规则集可并存多套。
- 启动自检 + 自动重放：npm 把 `node_modules` 覆盖掉之后，不用手改文件。

## 能力

| 你会看到 | 它做什么 |
|---|---|
| **dsh-purge 面板** | 会话标题旁一个按钮，右侧停靠；两页：Clean 与 Drill |
| **Clean** | 分组补丁状态、Apply / Restore / Uninstall、提示词编辑器、多套规则集 |
| **Drill** | 授权后的资产、技能与本机环境视图（仅限你自己管的宿主 / 离线靶标 / 书面授权演练） |
| **宿主策略** | 默认文案、权限策略、工具上限；官方能力保留，不另造第二身份 |
| **启动时** | 校验并重放补丁，状态落 `$DSH_HOME/dsh-purge/` |

## 支持宿主

| 宿主 | profile | 版本 |
|---|---|---|
| 官方 `dsh web` | `web` | dsh 0.2（0.2.0-rc.2） |
| 官方 Harness 桌面 EXE | `desktop` | 0.2.0-rc.2 |

老版本 dsh（0.1.7 及更早）要配对应旧版插件。补丁不匹配时保持 pending / skipped，不会盲改。

## 安装

先把插件装进 profile，再在界面上 Apply —— **装插件本身不改宿主**。

```sh
# 官方 Web
dsh plugin --profile web add https://github.com/__OWNER__/dsh-purge/archive/refs/heads/main.tar.gz

# 官方桌面 EXE
dsh plugin --profile desktop add https://github.com/__OWNER__/dsh-purge/archive/refs/heads/main.tar.gz

# 已经是本地 clone
dsh plugin --profile web add .
```

装完三步：

1. **完全退出**刚装的那个宿主再打开（`dsh web` 停掉重起；桌面端连托盘一起退）。
2. 在**那个宿主**里点会话标题旁的 **dsh-purge** → **Clean** 页 → **Apply**。
3. Apply 成功会重启一次让补丁加载；没跑完就不会重启。重启后**新开一个会话**，注入才进上下文。

Web 与 Desktop 的 Apply / Restart / Uninstall 互不影响，不要跨宿主 Apply。

## 换提示词

- **改默认提示词**：Clean 页的提示词编辑器直接改；落盘在 `$DSH_HOME/prompt-inject.md`，与插件内密封的默认文本比对后判定"是否用户手改"。
- **换模型就换一份**：编辑器里整体替换，或把不同模型的版本各存一份规则集，用时切。
- **规则集**：写入 `AGENTS.md` / `CLAUDE.md` 目标，不参与 system 注入链（磁盘与 UI/注入保持一致）。
- **插件内置默认提示词**：`lib/default-prompt-inject.md`，构建时由 `scripts/embed-default-prompt.mjs` 密封进 `lib/asset-table.js`（AES-256-GCM + deflate），运行时 `lib/table-read.js#openSlot()` 解封；宿主提示词文件不被读取，身份只来自插件自带那份。

## 工作原理

1. 定位 DSH 家目录：`$DSH_HOME` → dsh 启动器旁的 `.dsh` → `~/.dsh`（不写死盘符）。
2. 对官方 `@deepseek-ai` 包与本机配置打分组补丁，逐条校验命中，不匹配就挂起。
3. 重写提示词装配链：注入进 system，而不是拼在用户消息里。
4. 启动时自检 + 重放；npm 覆盖安装后自动恢复，不用手改。
5. 桌面端 Apply 会解 `app.asar`、给官方入口加 `app/` 回退与 `app/runtime` 链接。

## 恢复原状

- **Restore**：Clean 页还原被改的宿主文件。
- **Uninstall**：移除插件与补丁，重启宿主。
- **只想看状态**：会话里 `/purge status`，会打印 `DSH_HOME` 与补丁清单。

## 目录

```
lib/           核心：core.js 补丁引擎、identity.js 注入链、rules.js 规则集、
               host.js 宿主探测、reapply.js 重放、update.js 升级、redteam/ Drill
bin/           CLI 入口
client.js      构建产物（Web 端 UI，由 scripts/build-client.mjs 生成）
presets/       redteam 预设与锚点门
skills/        随插件分发的技能文档
scripts/       构建 / 嵌提示词 / 导出报告 / 设仓库地址
docs/          banner、预览图、原作者完整 README（docs/original/）
```

## <a id="attribution"></a>署名要求

**借用本项目的名称、思路、代码或提示词，必须署名作者并注明来源仓库。**

- 作者：**昔人**
- 本仓库：`https://github.com/__OWNER__/dsh-purge`

不署名、隐去来源、改头换面当作原创，会被追究。二次开发请保留 `LICENSE` 的版权行与本文件说明。

来源与改动记录见 [NOTICE.md](NOTICE.md)。

## 使用边界

本项目是本地安全评测工具：只作用于**你本机已装的官方 DeepSeek Harness 与本地配置**，不针对任何第三方站点、服务器或账号。
完整合规声明沿用原作者版本，见 [docs/original/README.en.md](docs/original/README.en.md)。
商用、付费转售、以及任何违法或灰产用途一律禁止。

MIT License · Copyright (c) 2026 昔人
