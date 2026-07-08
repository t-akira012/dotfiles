---
name: git-commit-staged
description: staged 変更のコミットメッセージを検討し、承認後に global user 名義でコミットする。/git-commit-staged 入力時のみ使用。
---

# git-commit-staged — staged 変更のコミット

検査・コミットは同梱 sh に委譲し、Claude は案作成と承認取得のみ担う。

## 手順

1. `bash "${SKILL_DIR}/check.sh"`。標準出力（`GLOBAL_USER:`・staged 一覧・直近ログ・diff）のみを材料とする。
2. 出力から案を作る。直近ログに規約（Conventional Commits 等）があれば踏襲。
3. 案を提示して承認を得る。修正要望は反映して再提示。承認まで先へ進まない。
4. `bash "${SKILL_DIR}/commit.sh" "<承認メッセージ>"`。

## 制約

- global user が無ければ中止。local user や Claude 名義へフォールバックしない。
- staged が無ければ自動 add せず中止。stage 対象の判断はユーザーに委ねる。
- 承認前のコミットを禁止。commit.sh は承認済みメッセージを引数で受けたときのみ実行する。
