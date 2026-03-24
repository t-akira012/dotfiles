# secure_ope.md — dotfiles リポジトリ secrets 露出防止方針

## 前提

- プロンプトによる防御は信用しない
- git hooks, Claude Code hooks, linter 等の自動化ツールチェーンのみを信頼する
- AI Agent (Claude Code) がdotfilesを日常的に編集する環境である

## 脅威モデル

### AI Agent 固有のリスク

| 脅威 | 根拠 |
|---|---|
| Agent支援コミットの secrets 漏洩率がベースラインの2倍 | GitGuardian 2026: 3.2% vs 1.5% |
| `.claude/settings.json` 経由の RCE | CVE-2025-59536 (CVSS 8.7): 悪意あるhook設定で起動時に任意コマンド実行 |
| `ANTHROPIC_BASE_URL` 経由の APIキー窃取 | CVE-2026-21852 (CVSS 5.3): 環境変数オーバーライドで認証ヘッダー奪取 |
| DNS サブドメイン経由のデータ窃取 | CVE-2025-55284: ファイル内容をDNSクエリにエンコードして送信 |
| MCP サプライチェーン攻撃 | レジストリ登録にコードレビュー不要。ツールポイズニング、ツールシャドウイング |
| Deny ルールの迂回 | `Read(.env)` を deny しても `Bash(cat .env)` は通過する |
| Rules File Backdoor | 不可視Unicode文字で CLAUDE.md / AGENTS.md にプロンプトインジェクション |

### dotfiles 固有のリスク

- 設定ファイルは「メタデータ」と認識され、コードレビュー時のセキュリティ精査を受けにくい
- コミット履歴に一度入った secrets は削除コミットしても残り続ける
- dotfiles リポジトリの 73.6% が潜在的にセンシティブな情報を漏洩（MSR 2023 研究）

## 現状評価

| 防御層 | 2026年ベストプラクティス | 当リポ現状 | 判定 |
|---|---|---|---|
| L1: pre-commit secrets scan | betterleaks (recall 98.6%) or gitleaks | 未導入 | NG |
| L2: Claude Code PreToolUse hook | secrets パターン検出で deny | 未導入 | NG |
| L3: OS サンドボックス | bubblewrap / DevContainer で分離 | 未導入 | NG |
| L4: .gitignore | `*.local`, `*secret*`, `.env*` | 部分的（claude/ のみ `*` で保護） | 要強化 |
| L5: GitHub push protection | パブリックリポはデフォルト有効 | 確認要 | 要確認 |
| L6: 実行時 secrets 注入 | 1Password CLI / Bitwarden CLI | 未導入 | 将来検討 |
| L7: git pre-push | 許可 org 以外への push 拒否 | 導入済み | OK |

## 改善計画

### Phase 1: 即時対応（自動検出の導入）

#### 1-1. betterleaks pre-commit hook

gitleaks の後継。BPE トークナイゼーションにより recall 98.6%（gitleaks の Shannon entropy は 70.4%）。

```bash
# インストール
brew install betterleaks

# .git/hooks/pre-commit (フレームワーク不要の最小構成)
#!/usr/bin/env bash
set -euo pipefail
if ! command -v betterleaks >/dev/null 2>&1; then
  echo "betterleaks is required" >&2
  exit 1
fi
betterleaks protect --staged --redact
```

設定ファイル `.gitleaks.toml`（betterleaks は後方互換）:

```toml
title = "dotfiles repo config"

[extend]
useDefault = true

[[allowlists]]
description = "dotfiles known safe patterns"
paths = [
    '''\.gitignore$''',
    '''README\.md$''',
]
```

#### 1-2. Claude Code PreToolUse hook

`~/.claude/settings.json` に追加（全プロジェクト共通）:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "dotfiles-repo-path/.claude/hooks/block-secrets-write.sh"
          }
        ]
      }
    ]
  }
}
```

`block-secrets-write.sh` の検出対象:

```
AKIA[0-9A-Z]{16}          # AWS Access Key
sk-[a-zA-Z0-9]{20,}       # OpenAI / Anthropic API Key
ghp_[a-zA-Z0-9]{36}       # GitHub PAT
gho_[a-zA-Z0-9]{36}       # GitHub OAuth
glpat-[a-zA-Z0-9\-_]{20,} # GitLab PAT
-----BEGIN.*PRIVATE KEY    # 秘密鍵
password\s*=\s*['"][^'"]+  # ハードコードパスワード
```

判定: exit 0 + `permissionDecision: "deny"` で Claude の書き込みをブロック。

#### 1-3. .gitignore 強化

```gitignore
# secrets
.env
.env.*
*.local
*secret*
*credential*
*token*

# SSH/GPG
id_rsa*
*.pem
*.key
```

### Phase 2: サンドボックス（Agent の爆発半径封じ込め）

#### 2-1. bubblewrap によるファイルシステム分離

Deny ルールは `Bash(cat .env)` を止められない。OS 層で遮断する。

```bash
bwrap \
  --unshare-all \
  --share-net \
  --ro-bind / / \
  --bind "$PROJECT_DIR" "$PROJECT_DIR" \
  --dev-bind /dev/null "$HOME/.ssh/id_rsa" \
  --dev-bind /dev/null "$HOME/.aws/credentials" \
  claude
```

#### 2-2. DevContainer（代替案）

Trail of Bits `claude-code-devcontainer` を利用。ホストの SSH 鍵、クラウド認証情報へのアクセスを完全遮断。

### Phase 3: 供給チェーン防御

#### 3-1. MCP サーバー監査

- `enableAllProjectMcpServers: false` を明示設定（デフォルト）
- `.mcp.json` に記載の全サーバーを手動で監査
- 非公式 MCP サーバーは利用しない

#### 3-2. CLAUDE.md / AGENTS.md の完全性検証

不可視 Unicode（ゼロ幅結合子、双方向テキストマーカー）の検出を pre-commit に追加:

```bash
# .git/hooks/pre-commit に追加
if git diff --cached --diff-filter=ACM -- '*.md' | grep -P '[\x{200B}-\x{200F}\x{2028}-\x{202F}\x{2060}-\x{206F}\x{FEFF}]'; then
  echo "Invisible Unicode characters detected in .md files" >&2
  exit 1
fi
```

### Phase 4: 将来検討

#### 4-1. 実行時 secrets 注入

1Password CLI `op inject` で平文ファイルを排除:

```bash
# secrets.zsh（Git に含めてよい — 参照のみ）
export NOTION_API_KEY="op://private/notion.so/api-token"
```

```bash
# .zshrc
op inject --in-file "${HOME}/.dotfiles/secrets.zsh" | source /dev/stdin
```

#### 4-2. git filter-repo による履歴浄化

万が一の漏洩時:

```bash
git filter-repo --force --replace-text replacements.txt
```

**必須事後手順**: secrets は漏洩済みと見なし即座にローテーション。

## 参考情報

| リソース | URL |
|---|---|
| GitGuardian State of Secrets 2026 | blog.gitguardian.com/the-state-of-secrets-sprawl-2026/ |
| betterleaks | github.com/betterleaks/betterleaks |
| Trail of Bits claude-code-config | github.com/trailofbits/claude-code-config |
| Claude Code Hooks Reference | code.claude.com/docs/en/hooks |
| CVE-2025-59536 (settings.json RCE) | research.checkpoint.com/2026/ |
| CVE-2025-55284 (DNS exfiltration) | embracethered.com/blog/posts/2025/ |
| MCP Security Risks | pillar.security/blog/the-security-risks-of-model-context-protocol-mcp |
| Rules File Backdoor | pillar.security/blog/new-vulnerability-in-github-copilot-and-cursor |
