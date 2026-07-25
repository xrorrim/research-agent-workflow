# BOOTSTRAP · 自安装与变身指令

**本文件写给 Claude Code。** 作者把这个 zip 交给你，是要你完成两件事：把科研多智能体工作流的配置安装进当前仓库，然后变身为该工作流的主会话（角色1）。按顺序执行，不要跳步。

## 第 1 步：确认位置

- 确认当前目录是作者项目仓库的**根目录**；不确定就先问作者一句。
- `git rev-parse --is-inside-work-tree` 检查 git。本工作流用 commit hash 绑定实验结果，**git 是必需的**——若不是 git 仓库，征得作者同意后 `git init`。

## 第 2 步：放置文件

zip 内容如已解压到当前目录则跳过；否则解压。完成后必须满足：

- `CLAUDE.md` → 仓库根目录；
- `.claude/agents/` 下四个文件齐全：`role2-strategist.md`、`role3-implementer.md`、`role4-logbook.md`、`role5-reviewer.md`；
- `.claude/settings.json` → 主会话（角色1）的模型与 effort 配置；
- `README-自动化版.md` → 仓库根目录（给作者的说明书）。

若根目录已存在另一份 CLAUDE.md：**不要覆盖**，把冲突报告给作者，等待处置。
若 `.claude/settings.json` 已存在：**不要覆盖**——把本包的 `"model"` 与 `"effortLevel"` 两个键合并进去，并把改动报告给作者。

## 第 3 步：建目录骨架

```bash
mkdir -p docs/route_archive logbook/messages experiments results tests
touch logbook/index.md logbook/debt.md
```

## 第 4 步：验证

逐项检查并准备一份简短清单（安装报告，第 6 步一并给作者）：6 个配置文件就位？骨架目录齐全？git 可用？

**版本检查**：`claude --version` 必须 ≥ **2.1.219**。低于此版本时如实告诉作者哪一项会失效，不要假装配置生效：

- < 2.1.219：`best` 别名可能无法解析到最新模型；
- < 2.1.211：子代理的 `model:` 覆盖在 SendMessage 续接时会退回主会话模型（对本包影响有限——子代理是无状态的，每次重新派生；但作者若改用持久子代理会踩到）;
- < 2.1.149：agent frontmatter 的 `effort:` 字段完全不生效。

## 第 5 步：变身

读取 `CLAUDE.md` 全文，**从此刻起完全按它行事**：你是主会话——身份A（角色1·调研者，作者唯一的对话对象）+ 身份B（编排器，自动驱动 R2→R3→R5→R4 实验循环）。本次会话由你手动读取生效；之后新开的会话会自动加载 CLAUDE.md 与子代理，行为一致。

## 第 6 步：开场

变身后对作者只说两件事（合计三四行以内）：

1. 安装验证结果（一行清单）；
2. 以角色1 的身份请作者描述课题，随即开始深度调研与路线讨论。

不要向作者解释系统原理——作者就是这套系统的设计者。

## 故障提示

若后续派生子代理时报 `role2-strategist` 等不存在（个别版本仅在会话启动时注册 agents）：告诉作者重启会话即可——文件已就位，新会话会自动加载一切；重启后描述课题或说"继续循环"即可无缝衔接。

---

**给作者**：把本 zip 放进项目目录后，对 Claude Code 说一句：

```
解压 科研工作流-自动化版.zip 到当前目录，然后按 BOOTSTRAP.md 执行。
```
