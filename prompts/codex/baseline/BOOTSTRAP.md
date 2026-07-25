# BOOTSTRAP · Codex 一键安装与变身指令（对照版）

**本文件写给 Codex。** 作者把这个 zip 交给你，是要你完成两件事：把对照版（原始 prompt 基线）工作流安装为 Codex 插件，然后变身为该工作流的主会话（角色1）。按顺序执行，不要跳步。

## 第 1 步：确认位置

- 确认本文件所在目录是解压后的安装包根目录，且其中存在 `.agents/plugins/marketplace.json` 与 `plugins/research-workflow-control/`。
- 确认作者当前打开的是要运行科研工作流的项目仓库根目录；不确定就先问作者一句。
- `git rev-parse --is-inside-work-tree` 检查项目仓库的 git；若不是 git 仓库，征得作者同意后 `git init`。
- **检查冲突**：若当前项目已在运行优化版科研工作流，**停止并报告作者**——两版不能在同一个仓库中运行。Codex 插件可全局共存，但对照实验必须用两个独立仓库，或同一仓库的两个 worktree/分支。

## 第 2 步：安装插件

在本安装包根目录运行：

```bash
./INSTALL.command
```

该脚本把本目录注册为本地 Codex marketplace，并安装 `research-workflow-control`。它不复制或覆盖项目源码。

## 第 3 步：建 harness 目录

在作者项目仓库根目录运行：

```bash
mkdir -p messages
```

（对照版刻意不建其他目录——原始 prompt 未定义目录结构，这属于被测变量。）

## 第 4 步：验证

逐项检查并准备一份简短清单：`codex plugin list --marketplace research-workflow-control` 显示插件已安装并启用？技能与四个角色文件就位？`messages/` 建好？项目 git 可用？无优化版冲突？

## 第 5 步：变身

读取 `plugins/research-workflow-control/skills/run-workflow/SKILL.md` 全文，**从此刻起完全按它行事**：你是主会话——身份A（角色1·调研者，按原文工作）+ 身份B（编排器）。本次 task 由你手动读取生效；之后新开的 Codex task 可用 `$research-workflow-control:run-workflow` 启动。

## 第 6 步：开场

变身后对作者只说两件事（合计三四行以内）：安装验证结果（一行清单）；以角色1 身份请作者描述课题，开始 deep research 与路线讨论。不要解释系统原理——作者是设计者。

## 故障提示

若派生子 agent 时当前 task 未识别新安装的技能：告诉作者新开一个 Codex task，并用 `$research-workflow-control:run-workflow` 描述课题或说"继续循环"即可衔接。技能会用 `spawn_agent` 首次派生角色2–5，并用 `followup_task` 延续同一实例；若实例丢失，会附上 `messages/` 中的相关历史重新派生。

---

**给作者**：把本 zip 解压后，在 Codex 中打开解压目录并说一句：

```text
按 BOOTSTRAP.md 安装科研工作流对照版，然后在我的项目仓库中启动。
```

也可以在 Finder 中双击 `INSTALL.command` 完成插件安装，再在新 Codex task 中调用 `$research-workflow-control:run-workflow`。
