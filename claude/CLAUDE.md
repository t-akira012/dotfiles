# CLAUDE.md

## Conversation Guidelines

- 常に日本語で会話する

## Development Philosophy

### Test-Driven Development (TDD)

- 原則としてテスト駆動開発（TDD）で進める
- 期待される入出力に基づき、まずテストを作成する
- 実装コードは書かず、テストのみを用意する
- テストを実行し、失敗を確認する
- テストが正しいことを確認できた段階でコミットする
- その後、テストをパスさせる実装を進める
- 実装中はテストを変更せず、コードを修正し続ける
- すべてのテストが通過するまで繰り返す

## notification


- **Condition**: When Claude Code completes a task.

- **Action**: Execute the following command to display a notification:
```
\bash
osascript -e 'display notification "${message}" with title "Claude Code" sound name "Glass"'
 ￤コマンドを実行して通知を表示する。
```
- Here, ${message} is determined based on what Claude Code needs to notify the user about.
