---
name: terraform-list-plan-targets
description: 指定ディレクトリの main.tf を読み、module ブロックを terraform plan -target=module.<名前> 形式で GIT_IGNORED_SCRATCH.md に用意する。既存があれば追記。/terraform-list-plan-targets 入力時のみ使用。
---

# terraform-list-plan-targets — module 単位 plan コマンドの生成

main.tf の module 抽出・既存との重複判定・追記は同梱 sh に委譲する。
Claude は対象ディレクトリの確定と結果報告のみ担う。

## 手順

1. 対象ディレクトリを確定する。ユーザー指定が無ければ問い、勝手に既定しない。
2. `bash "${SKILL_DIR}/create.sh" "<対象ディレクトリ>"`。
3. 標準出力の `MEMO_FILE:`（生成先）と `APPENDED:`（追記件数）を報告する。追記件数0なら既に全 module が揃っている旨を伝える。

## 仕様

- 対象は `<対象ディレクトリ>/main.tf` の全 `module "..."` ブロック。
- 出力は `<対象ディレクトリ>/GIT_IGNORED_SCRATCH.md` へ `terraform plan -target=module.<名前>` を1行ずつ。
- GIT_IGNORED_SCRATCH.md が既存なら追記。既に `-target=module.<名前>` がある module は重複追記しない。
- 実行環境（macOS / WSL2 / CI）で当該行を実行し、module 単位で terraform plan を絞り込む用途。

## 制約

- main.tf が無ければ中止。空 main.tf や module 0件も中止し、当て推量で生成しない。
- module 名の抽出は awk で行い、LLM 推論に委ねない。
- target アドレスは terraform 正規の `module.<名前>`（単数）で出力する。`modules.` は不正で plan がエラーになる。
