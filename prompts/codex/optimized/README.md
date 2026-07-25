# 科研多智能体工作流 · 自动化版（Codex 原生）

## 让 Codex 自己安装（推荐）

把本 ZIP 的绝对路径和下面这句话一起交给位于目标项目根目录的 Codex：

```text
请安全解压这个 ZIP 到临时目录，完整阅读解压目录根部的 BOOTSTRAP.md，并按它把科研工作流安装到当前 git 项目；安装后在当前任务中立即按新 AGENTS.md 行事。
```

Codex 会自行安装本地 Marketplace、插件与项目级工作流配置，不需要你手动运行脚本。

## 人工一键安装

- macOS：双击 `install.command`；
- 终端：在本目录运行 `./install.sh`。

安装完成后，在目标项目根目录打开一个新的 Codex 任务，说：

```text
把科研多智能体工作流安装到当前目录，然后按 research-workflow-automation 技能执行。
```

Codex 会检查 git、安装项目级配置与目录骨架、汇报验证结果，然后变身为角色1。

## 文件结构

- `.agents/plugins/marketplace.json`：本地 Codex Marketplace；
- `plugins/research-workflow-automation/`：Codex 插件；
- `BOOTSTRAP.md`：给 Codex 的自安装入口；
- `install.command` / `install.sh`：一键安装入口；
- `ADAPTATION-AUDIT.md`：Claude Code → Codex 平台适配审计。

## 卸载插件

```bash
codex plugin remove research-workflow-automation
```

项目中已由 Bootstrap 创建的科研记录与配置不会被插件卸载命令删除。
