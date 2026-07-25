# 平台适配审计

本版本只修改 Claude Code 与 Codex 的平台差异，不修改科研 prompt 的具体要求、M1–M7 协议或实验工作流程。

## 文件映射

| Claude Code 原文件 | Codex 文件 | 适配理由 |
|---|---|---|
| `BOOTSTRAP.md` | 插件技能 `skills/research-workflow-automation/SKILL.md` | Codex 插件以技能作为可触发的 Bootstrap 入口 |
| `CLAUDE.md` | 项目 `AGENTS.md` 模板 | Codex 自动加载 `AGENTS.md` |
| `.claude/agents/*.md` | `.codex/research-workflow/agents/*.md` 模板 | Codex 不使用 Claude Code 的 agents 注册目录；角色定义由主会话读取后传给子代理 |
| `README-自动化版.md` | `README-Codex版.md` 模板 | 安装、启动、通信方式改为 Codex 对应机制 |

## 允许且已经实施的改动

1. `Claude Code`、`CLAUDE.md`、`.claude/agents/` 等平台名称与路径替换为 Codex 对应名称与路径。
2. Claude Code 的 agent 注册、派生、`SendMessage` 与后台任务表述，替换为 Codex 的 `collaboration.spawn_agent`、`collaboration.followup_task`、`fork_turns: "none"` 和主会话后台运行表述。
3. Claude 工具名 `Read/Write/Edit/Bash/Grep/Glob` 替换为 Codex 工具名 `functions.exec_command` 与 `functions.apply_patch`。
4. 增加 Codex 插件 manifest、本地 Marketplace 和安装脚本；这些是分发与安装层，不改变科研流程。
5. 增加 ZIP 根目录 `BOOTSTRAP.md` 与 `install.sh <项目根目录>` 自举入口；它们只编排安装，不修改项目模板中的科研 prompt。

## 明确保留不变的内容

- 角色1–5 的职责边界；
- 路线确认、修订、维持、判死与结题规则；
- R2→R3→R5→R4→R2 循环顺序；
- M1–M7 的消息格式与原文转发纪律；
- 边跑边审、审核不通过时终止运行并清空结果；
- 审核打回与运行失败各 3 次上限；
- 每 5 循环例行对照；
- commit 绑定、日志目录、断点续跑与工程债规则；
- 各角色的任务设计、实现、审核、合规判定要求。

## 校验结论

- 四个角色文件删除 YAML frontmatter 中的 `tools:` 单行后，与原 Claude Code 文件逐字节一致。
- 主编排规则的差异只出现在 agents 路径、子代理派生/续接、主会话后台进程和 Codex 非阻塞等待的表述中。
- Bootstrap 与 README 的差异只出现在插件安装方式、平台名称、自动加载文件名、agents 路径和 Codex 工具名称中。
