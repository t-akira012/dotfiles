---
name: terraform-create-TF_VARS-sh
description: 指定ディレクトリの main.tf を読み、variables を export TF_VAR_<名前>=xxx 形式で TF_VARS.sh に用意する。既存があれば追記。/terraform-create-TF_VARS-sh 入力時のみ使用。
---

# terraform-create-TF_VARS-sh — TF_VAR 環境変数ひな形の生成

main.tf の variable 抽出・既存との重複判定・追記は同梱 sh に委譲する。
Claude は対象ディレクトリの確定と結果報告のみ担う。

## 手順

1. 対象ディレクトリを確定する。ユーザー指定が無ければ問い、勝手に既定しない。
2. `bash "${SKILL_DIR}/create.sh" "<対象ディレクトリ>"`。
3. 標準出力の `VARS_FILE:`（生成先）と `APPENDED:`（追記件数）を報告する。追記件数0なら既に全 variable が揃っている旨を伝える。

## 仕様

- 対象は `<対象ディレクトリ>/main.tf` の全 `variable "..."` ブロック。
- 出力は `<対象ディレクトリ>/TF_VARS.sh` へ `export TF_VAR_<名前>=xxx` を1行ずつ。値は placeholder の `xxx`。
- TF_VARS.sh が既存なら追記。既に `export TF_VAR_<名前>=` がある variable は重複追記しない。
- 実行環境（macOS / WSL2 / CI）で `source TF_VARS.sh` して terraform に読み込ませる用途。xxx は各自が実値へ置換する。

## 制約

- main.tf が無ければ中止。空 main.tf や variable 0件も中止し、当て推量で生成しない。
- variable 名の抽出は awk で行い、LLM 推論に委ねない。
