# Hermes Agent

Hermes Agentの導入処理と、`$HOME/.hermes` private Git repositoryの
allowlistを管理する。

## 初期化

このディレクトリで一度だけ実行する。

```sh
make init
```

このコマンドは以下を順番に行う。

1. `$HOME/.hermes`をlocal Git repositoryとして初期化する。
2. `hermes.gitignore`をrepository-localの`core.excludesFile`へ設定する。
3. `gh repo create`でGitHubに`.hermes` private repositoryを作成し、`origin`へ設定する。
4. Nous Researchの公式インストーラーを非対話モードで取得・実行する。
5. `hermes --version`、`hermes doctor`、Gitの管理対象を表示する。
6. allowlist対象を最初のcommitとしてprivate repositoryへpushする。

`$HOME/.hermes`はHermes Agentの実行領域であり、そのままprivate Git
repositoryでもある。別ディレクトリとの同期、設定ファイルのコピー、
シンボリックリンクは使用しない。

## Git管理

Gitは`$HOME/dotfiles/root/hermes/hermes.gitignore`を直接参照する。
`SOUL.md`、設定、skills、選択したmemoriesなどだけが管理候補になる。
`.env`と`auth.json`を含む認証情報は管理候補にならない。

`$HOME/.hermes`では`git clean -fdx`を実行してはならない。`-x`を指定すると、
Gitから除外した認証情報とHermesの実行時データも削除される。
