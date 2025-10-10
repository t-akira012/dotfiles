# CLAUDE.md

- 常に日本語で会話します
- コード実装は t-wada TDD を常時厳守

## 実行環境

### 重要
- Claudeはコンテナの内部で実行されてます。
- Claudeはコンテナの中にいるので、CLIによる環境の調査を禁止します。AWSやGCPには接続できません。
### 許可事項
- `/workspace/` 以下に限り、アプリケーションコードに関する調査を許可します
- `/workspace/.claude-code` はCLAUDE CODEの実行コードディレクトリです。編集を禁止します。

## MCP利用
- Claudeはserena MCPが使えます。コンテクストを節約するために、必ずserena mcpを使ってください。
