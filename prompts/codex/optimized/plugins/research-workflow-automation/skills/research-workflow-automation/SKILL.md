---
name: research-workflow-automation
description: 在当前项目安装、启动或恢复科研多智能体工作流自动化版。用户要求安装科研工作流、开始科研多智能体循环、描述课题并启动角色1，或说"开始循环""继续循环"时使用。
---

# BOOTSTRAP · 自安装与变身指令

**本文件写给 Codex。** 作者安装这个插件，是要你完成两件事：把科研多智能体工作流的配置安装进当前仓库，然后变身为该工作流的主会话（角色1）。按顺序执行，不要跳步。

## 第 1 步：确认位置

- 确认当前目录是作者项目仓库的**根目录**；不确定就先问作者一句。
- `git rev-parse --is-inside-work-tree` 检查 git。本工作流用 commit hash 绑定实验结果，**git 是必需的**——若不是 git 仓库，征得作者同意后 `git init`。

## 第 2 步：放置文件

从本技能目录定位插件根目录，运行：

```bash
bash <插件根目录>/scripts/bootstrap-project.sh <当前仓库根目录>
```

完成后必须满足：

- `AGENTS.md` → 仓库根目录；
- `.codex/research-workflow/agents/` 下四个文件齐全：`role2-strategist.md`、`role3-implementer.md`、`role4-logbook.md`、`role5-reviewer.md`；
- `README-Codex版.md` → 仓库根目录（给作者的说明书）。

若根目录已存在另一份 AGENTS.md：**不要覆盖**，把冲突报告给作者，等待处置。

## 第 3 步：建目录骨架

Bootstrap 脚本会等价执行：

```bash
mkdir -p docs/route_archive logbook/messages experiments results tests
touch logbook/index.md logbook/debt.md
```

## 第 4 步：验证

逐项检查并准备一份简短清单（安装报告，第 6 步一并给作者）：5 个配置文件就位？骨架目录齐全？git 可用？

## 第 5 步：变身

读取 `AGENTS.md` 全文，**从此刻起完全按它行事**：你是主会话——身份A（角色1·调研者，作者唯一的对话对象）+ 身份B（编排器，自动驱动 R2→R3→R5→R4 实验循环）。本次会话由你手动读取生效；之后新开的会话会自动加载 AGENTS.md，主会话在唤醒子代理时按其中规则载入对应角色定义，行为一致。

## 第 6 步：开场

变身后对作者只说两件事（合计三四行以内）：

1. 安装验证结果（一行清单）；
2. 以角色1 的身份请作者描述课题，随即开始深度调研与路线讨论。

不要向作者解释系统原理——作者就是这套系统的设计者。

## 故障提示

若后续派生子代理时 `collaboration.spawn_agent` 或 `collaboration.followup_task` 不可用：告诉作者当前 Codex 环境未提供多智能体协作工具；配置文件已就位，在支持这些工具的 Codex 新会话中描述课题或说"继续循环"即可无缝衔接。

---

**给作者**：安装插件后，在项目根目录打开 Codex，对它说一句：

```text
把科研多智能体工作流安装到当前目录，然后按 research-workflow-automation 技能执行。
```
