#!/bin/sh
set -eu

bundle_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
"$bundle_root/install.sh"

printf '\n按回车键关闭窗口。'
read answer
