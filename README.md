# contracts

byte-v-forge 服务契约真源 + Go module。

## 布局

- `byte/v/forge/contracts/<domain>/v1/*.proto` — 契约源（package `byte.v.forge.contracts.<domain>.v1`，commit）
- `byte/v/forge/contracts/<domain>/v1/*.pb.go` — `buf generate` 产出，gitignore；本机供 IDE/LSP/`go build`，远程构建临时产出后丢弃
- `buf.yaml` — 模块、lint（STANDARD）、breaking（FILE）
- `buf.gen.yaml` — managed mode 注入 `go_package`，proto 源保持语言无关
- `go.mod` — module `github.com/byte-v-forge/contracts`

## 命令

- `scripts/check.sh` — 静态检查：format diff + lint + build，无产出
- `scripts/codegen.sh` — `buf generate` 产出 .pb.go 到 byte/ 子树并 `go mod tidy`，供本机开发

## 消费

服务 `go.mod`：

```
require github.com/byte-v-forge/contracts v0.0.0
replace github.com/byte-v-forge/contracts => ../contracts
```

`import "github.com/byte-v-forge/contracts/byte/v/forge/contracts/common/v1"`。

远程构建 Dockerfile multi-stage 内自行跑 `buf generate`，本地无需传递生成物。
