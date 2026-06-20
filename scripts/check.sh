#!/usr/bin/env bash
# 本机静态检查：解析 proto、不产出构建物，符合本机构建边界。
set -Eeuo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
CONTRACTS_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd)

cd "$CONTRACTS_DIR"
buf format --diff --exit-code
buf lint
buf build -o /dev/null
printf 'contracts checks passed\n'
