#!/bin/zsh
set -euo pipefail

bundle_dir="$(cd "$(dirname "$0")" && pwd)"
marketplace_name="research-workflow-control"
plugin_name="research-workflow-control"

existing_root="$(
  codex plugin marketplace list |
    awk -v name="$marketplace_name" '
      $1 == name {
        $1 = ""
        sub(/^[[:space:]]+/, "")
        print
        exit
      }
    '
)"

if [[ -n "$existing_root" ]]; then
  existing_root="$(cd "$existing_root" 2>/dev/null && pwd || true)"
  if [[ "$existing_root" != "$bundle_dir" ]]; then
    print -u2 "安装失败：Codex 中已有同名 marketplace，位置为：$existing_root"
    print -u2 "请先确认并移除该同名 marketplace，再重新运行本安装器。"
    exit 1
  fi
else
  codex plugin marketplace add "$bundle_dir"
fi

codex plugin add "$plugin_name@$marketplace_name"

print
print "安装完成：$plugin_name@$marketplace_name"
print '请新开一个 Codex task，调用 $research-workflow-control:run-workflow。'
