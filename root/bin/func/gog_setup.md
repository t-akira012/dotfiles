# gogcli セットアップ

## インストール

```bash
brew install gogcli
```

## GCP 設定

1. [Cloud Console](https://console.cloud.google.com/) でプロジェクト作成
2. API 有効化: Gmail API, Google Calendar API, Google Drive API, Tasks API
3. OAuth 同意画面 → 外部 → テストユーザーに自分を追加
4. 認証情報 → OAuth クライアント ID → デスクトップアプリ → JSON ダウンロード

## gogcli 認証

```bash
# クライアント登録
gog auth credentials ~/Downloads/client_secret_xxxxx.json

# アカウント追加（readonly + Tasks のみ write）
gog auth add you@gmail.com \
  --services gmail,calendar,drive,tasks \
  --gmail-scope readonly \
  --drive-scope readonly \
  --readonly \
  --extra-scopes "https://www.googleapis.com/auth/tasks"

# ヘッドレスの場合
gog auth add you@gmail.com --manual

# 確認
gog auth status
```

## デフォルトアカウント

```bash
export GOG_ACCOUNT=you@gmail.com
```

## トラブルシューティング

| 症状 | 対処 |
|------|------|
| `invalid_scope` | `--services` を見直して `gog auth add` やり直し |
| ブラウザが開かない | `--manual` を使用 |
| `API has not been enabled` | GCP で該当 API を有効化 |
| テストユーザーエラー | OAuth 同意画面でテストユーザーに自分を追加 |
