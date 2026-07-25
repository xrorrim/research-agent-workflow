#!/bin/sh
set -eu

plugin_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
template_root="$plugin_root/assets/project-template"
target_root=${1:-"$PWD"}

if [ ! -d "$target_root" ]; then
  printf '错误：目标目录不存在：%s\n' "$target_root" >&2
  exit 2
fi

target_root=$(CDPATH= cd -- "$target_root" && pwd)

if ! git -C "$target_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  printf '错误：目标目录不是 git 仓库。请先征得作者同意，再执行 git init。\n' >&2
  exit 3
fi

check_conflict() {
  source_file=$1
  target_file=$2
  if [ -e "$target_file" ] && ! cmp -s "$source_file" "$target_file"; then
    printf '冲突：已有不同文件，未覆盖：%s\n' "$target_file" >&2
    return 1
  fi
}

check_conflict "$template_root/AGENTS.md" "$target_root/AGENTS.md"
check_conflict "$template_root/README-Codex版.md" "$target_root/README-Codex版.md"

for role_name in role2-strategist.md role3-implementer.md role4-logbook.md role5-reviewer.md; do
  check_conflict \
    "$template_root/.codex/research-workflow/agents/$role_name" \
    "$target_root/.codex/research-workflow/agents/$role_name"
done

mkdir -p \
  "$target_root/.codex/research-workflow/agents" \
  "$target_root/docs/route_archive" \
  "$target_root/logbook/messages" \
  "$target_root/experiments" \
  "$target_root/results" \
  "$target_root/tests"

cp "$template_root/AGENTS.md" "$target_root/AGENTS.md"
cp "$template_root/README-Codex版.md" "$target_root/README-Codex版.md"

for role_name in role2-strategist.md role3-implementer.md role4-logbook.md role5-reviewer.md; do
  cp \
    "$template_root/.codex/research-workflow/agents/$role_name" \
    "$target_root/.codex/research-workflow/agents/$role_name"
done

touch "$target_root/logbook/index.md" "$target_root/logbook/debt.md"

config_count=0
for required_file in \
  "$target_root/AGENTS.md" \
  "$target_root/.codex/research-workflow/agents/role2-strategist.md" \
  "$target_root/.codex/research-workflow/agents/role3-implementer.md" \
  "$target_root/.codex/research-workflow/agents/role4-logbook.md" \
  "$target_root/.codex/research-workflow/agents/role5-reviewer.md"; do
  if [ -f "$required_file" ]; then
    config_count=$((config_count + 1))
  fi
done

printf '安装验证：配置文件 %s/5；目录骨架齐全；git 可用。\n' "$config_count"
