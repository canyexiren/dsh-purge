<p align="center">
  <img src="docs/banner.svg" alt="dsh-purge" width="720">
</p>

<h1 align="center">⚔️ dsh-purge</h1>

<p align="center"><strong>v1.1.68</strong></p>

<p align="center">
  <em>DeepSeek Harness 破甲：让所有模型都能破甲，不同模型可换不同提示词；默认提示词面向国模「小码酱」。<br>
  Jailbreak for every model — swap prompts per model.<br>
  Please star ⭐ If you build on this, see <a href="#attribution">Attribution required</a>.</em>
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

## What this is

**dsh-purge** is a prompt-injection / local-patch plugin for the official
[DeepSeek Harness](https://www.deepseek.com/harness/) already installed on your machine.
It does not ask "will the model answer" — it works on the **host layer**: Harness rewrites prompts,
approval gates, sandbox policy and session migration at runtime. Separating that layer from a model
refusal is how you run controlled evaluation on your own install.

- Official **Web** (`dsh web`) and the official **desktop EXE** (0.2.0-rc.2) are both supported —
  install and Apply them separately.
- Scope is the local official `@deepseek-ai` packages and local config. It does not patch the
  Harness source tree.
- The default prompt targets the Chinese model 「小码酱」 and can be replaced wholesale; swap prompts
  per model, keep several rule sets side by side.
- Self-check and replay on start: after `npm` overwrites `node_modules` you do not hand-edit files.

## Features

| You get | What it does |
|---|---|
| **dsh-purge dock** | A button beside the session title opens the right dock: Clean and Drill |
| **Clean** | Grouped patch status, Apply / Restore / Uninstall, prompt editor, multiple rule sets |
| **Drill** | Assets, skills and local environment after authorization (own host / offline target / written exercise only) |
| **Host policy** | Default copy, permission policy, tool limits; official capabilities stay |
| **On start** | Verifies and replays patches; state lives in `$DSH_HOME/dsh-purge/` |

## Install

Installing the plugin into a profile does **not** patch the host. Apply on the Clean page does.

```sh
# official web
dsh plugin --profile web add https://github.com/__OWNER__/dsh-purge/archive/refs/heads/main.tar.gz

# official desktop EXE
dsh plugin --profile desktop add https://github.com/__OWNER__/dsh-purge/archive/refs/heads/main.tar.gz
```

Then: (1) fully quit and reopen that host, (2) click **dsh-purge** → **Clean** → **Apply**,
(3) Apply restarts once on success; open a new chat afterwards so the inject enters the session.

## Swapping prompts

- Edit the prompt in the Clean page editor; the committed copy lives at `$DSH_HOME/prompt-inject.md`
  and is hashed to detect a user edit.
- Swap the whole text per model, or save one rule set per model and switch when you switch models.
- Rule sets write to `AGENTS.md` / `CLAUDE.md` targets and stay out of the system inject chain.
- The shipped default prompt is `lib/default-prompt-inject.md`, sealed at build time into
  `lib/asset-table.js` (AES-256-GCM + deflate) and opened by `lib/table-read.js#openSlot()`.
  The host prompt file is never read; identity comes from the plugin's own copy.

## Restore

- **Restore** on the Clean page reverts the patched host files.
- **Uninstall** removes the plugin and the patches, then restart.
- `/purge status` in chat prints `DSH_HOME` and the patch list.

## <a id="attribution"></a>Attribution required

**If you borrow this project's name, ideas, code, or prompts, you must credit the author and name the
source repository.**

- Author: **昔人**
- This repository: `https://github.com/__OWNER__/dsh-purge`

Removing attribution, hiding the source, or passing it off as your own will be pursued.
Keep the `LICENSE` copyright line and [NOTICE.md](NOTICE.md) when you fork.

## Scope

This is a local security-evaluation tool: it only touches the official DeepSeek Harness installed on
your own machine and local config. It is not a scanner and not an attack kit for third-party sites.
Commercial resale and any illegal or gray-market use are forbidden. The full compliance statement is
preserved in [docs/original/README.en.md](docs/original/README.en.md).

MIT License · Copyright (c) 2026 昔人
