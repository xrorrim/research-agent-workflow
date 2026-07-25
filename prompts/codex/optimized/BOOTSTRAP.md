# BOOTSTRAP · Codex 自安装指令

**本文件写给 Codex。** 用户把这个 ZIP 交给你，是要你自行完成两层安装：

1. 把 `research-workflow-automation` 安装为 Codex 本地插件；
2. 把科研多智能体工作流配置安装进用户当前的项目仓库，然后在本次任务中变身为主会话（角色1）。

按顺序执行，不要跳步。这里的操作只负责平台安装；不得改写插件内的科研 prompt、M1–M7 协议或实验工作流程。

## 第 1 步：确定两个绝对路径

- **项目根目录**：用户希望运行科研工作流的当前 git 项目。先用 `pwd` 和 `git rev-parse --show-toplevel` 确认；如果当前目录是否为目标项目不明确，先问用户一句。
- **Bundle 根目录**：本文件 `BOOTSTRAP.md` 所在的解压目录。

若用户只给了 ZIP、尚未解压：先查看 ZIP 文件列表，确认没有绝对路径或 `..` 路径穿越项；再用 `mktemp -d` 创建临时目录并解压。不要把 Marketplace 文件散落到项目根目录。解压后读取本文件全文，再继续。

## 第 2 步：检查 git

本工作流用 commit hash 绑定实验结果，**git 是必需的**。

```bash
git -C "<项目根目录>" rev-parse --is-inside-work-tree
```

若不是 git 仓库：征得用户同意后才执行 `git -C "<项目根目录>" init`，然后继续。

## 第 3 步：执行自安装

从 Bundle 根目录运行：

```bash
bash "<Bundle 根目录>/install.sh" "<项目根目录>"
```

这个命令会：

1. 把 Bundle 注册为本地 Codex Marketplace；
2. 安装或更新 `research-workflow-automation` 插件；
3. 安装项目根目录的 `AGENTS.md`、四个角色定义与目录骨架；
4. 遇到已有不同 `AGENTS.md` 或角色文件时停止，**绝不覆盖**。

如果命令因写入 Codex 插件配置需要批准，向用户请求该项批准后继续，不要改走手工复制插件缓存的旁路。

## 第 4 步：验证

逐项确认：

- `codex plugin list --json` 能看到 `research-workflow-automation`；
- 项目根目录有 `AGENTS.md`；
- `.codex/research-workflow/agents/` 下四个角色文件齐全；
- `docs/route_archive`、`logbook/messages`、`experiments`、`results`、`tests` 齐全；
- `logbook/index.md` 与 `logbook/debt.md` 已存在；
- git 可用。

## 第 5 步：在当前任务中变身

完整读取项目根目录的 `AGENTS.md`，**从此刻起完全按它行事**：你是主会话——身份A（角色1·调研者，作者唯一的对话对象）+ 身份B（编排器，自动驱动 R2→R3→R5→R4 实验循环）。

本次任务由你手动读取生效；以后在该项目中新开的 Codex 任务会自动加载 `AGENTS.md`。

## 第 6 步：开场

变身后对作者只说两件事（合计三四行以内）：

1. 安装验证结果（一行清单）；
2. 以角色1 的身份请作者描述课题，随即开始深度调研与路线讨论。

不要向作者解释系统原理——作者就是这套系统的设计者。

## 给用户的一句话

用户以后只需把 ZIP 的绝对路径交给 Codex，并说：

```text
请安全解压这个 ZIP 到临时目录，完整阅读解压目录根部的 BOOTSTRAP.md，并按它把科研工作流安装到当前 git 项目；安装后在当前任务中立即按新 AGENTS.md 行事。
```
