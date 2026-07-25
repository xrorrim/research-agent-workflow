#!/bin/sh
set -eu

bundle_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
marketplace_name=research-workflow-local
plugin_name=research-workflow-automation
project_root=${1:-}

if ! command -v codex >/dev/null 2>&1; then
  printf '错误：未找到 codex 命令。请先安装或更新 Codex。\n' >&2
  exit 1
fi

if [ -n "$project_root" ]; then
  if [ ! -d "$project_root" ]; then
    printf '错误：目标项目目录不存在：%s\n' "$project_root" >&2
    exit 2
  fi
  project_root=$(CDPATH= cd -- "$project_root" && pwd)
  if ! git -C "$project_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    printf '错误：目标目录不是 git 仓库。请先征得作者同意，再执行 git init。\n' >&2
    exit 3
  fi
fi

if ! codex plugin marketplace add "$bundle_root"; then
  printf '提示：Marketplace 可能已经添加；继续安装/更新插件。\n' >&2
fi

codex plugin add "$plugin_name@$marketplace_name"

if [ -n "$project_root" ]; then
  "$bundle_root/plugins/research-workflow-automation/scripts/bootstrap-project.sh" "$project_root"
  printf '\n插件与项目工作流均已安装。当前 Codex 任务请继续读取项目 AGENTS.md 并按其行事。\n'
else
  printf '\n插件安装完成。请在目标项目根目录打开一个新的 Codex 任务，然后说：\n'
  printf '把科研多智能体工作流安装到当前目录，然后按 research-workflow-automation 技能执行。\n'
fi
