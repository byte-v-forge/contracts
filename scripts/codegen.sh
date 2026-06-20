#!/usr/bin/env bash
# 本机 buf generate：与 proto 同目录产出 .pb.go (gitignore)，仅供 IDE/LSP/本地编译。
# 远程构建走 Dockerfile multi-stage：拉 proto → buf generate → 编译 → 丢弃产物。
set -Eeuo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
CONTRACTS_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd)

# Go SDK 常装在 ~/sdk/goX.Y.Z/bin/ 等位置不进 PATH，主动探测
if ! command -v go >/dev/null; then
  for cand in "$HOME"/sdk/go*/bin/go /usr/local/go/bin/go /opt/homebrew/bin/go; do
    if [[ -x $cand ]]; then export PATH="$(dirname "$cand"):$PATH"; break; fi
  done
fi

for tool in buf protoc-gen-go protoc-gen-go-grpc go; do
  command -v "$tool" >/dev/null || { printf 'missing tool: %s\n' "$tool" >&2; exit 1; }
done

cd "$CONTRACTS_DIR"
buf format --diff --exit-code
buf lint
find byte -name '*.pb.go' -delete 2>/dev/null || true
buf generate
gofmt -w byte
go mod tidy

printf 'codegen done. .pb.go ready under %s/byte/\n' "$CONTRACTS_DIR"
