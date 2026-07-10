---
name: terraform-create-aws-logs-tail
description: 指定 repo/dir 配下の *.tf を再帰走査し、aws_cloudwatch_log_group の name を aws logs tail <名前> --follow 形式で メモファイル に用意する。既存があれば追記。/aws-cli-create-logs-tail-from-iac 入力時のみ使用。
---

# CloudWatch log group tail コマンドの生成

*.tf の log group 抽出・既存との重複判定・追記は同梱 sh に委譲する。
Claude は対象ディレクトリの確定と結果報告のみ担う。

## 手順

1. 対象ディレクトリ（repo ルート等）を確定する。ユーザー指定が無ければ問い、勝手に既定しない。
2. `bash "${SKILL_DIR}/create.sh" "<対象ディレクトリ>" "<メモファイルパス>"`。
3. 標準出力の `MEMO_FILE:`（生成先）と `APPENDED:`（追記件数）を報告する。追記件数0なら既に全 log group が揃っている旨を伝える。

## 仕様

- 対象は `<対象ディレクトリ>` 配下を再帰探索した全 `*.tf` の `resource "aws_cloudwatch_log_group"` ブロック。
- 各ブロックの `name = "..."` を抽出し、 メモファイルへ `aws logs tail <名前> --follow` を1行ずつ。
- GIT_IGNORED_SCRATCH.md が既存なら追記。既に同名の `aws logs tail <名前>` がある log group は重複追記しない。
- name が `${var...}` 等で補間される場合は逐語でそのまま出力する（placeholder 扱い、実値は各自が置換）。

## 制約

- 対象ディレクトリが無ければ中止。*.tf 0件や log group 0件も中止し、当て推量で生成しない。
- log group 名の抽出は awk のブロック追跡と厳密一致で行い、LLM 推論に委ねない。
- 属性キーは `name` に厳密一致させ、`name_prefix` や tags 内の `name` は対象外。
