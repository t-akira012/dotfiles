# win

cmd.exe をUnix風に使うための最小dotfiles。

## セットアップ

個別ダウンロード

* [Ctrl2Cap - Sysinternals | Microsoft Learn](https://learn.microsoft.com/ja-jp/sysinternals/downloads/ctrl2cap)
    * `ctr2cap /install`

## Install

### 1. 外部ツールの配置

以下を `%USERPROFILE%\exe\` に手動で配置する。

- [fzf](https://github.com/junegunn/fzf/releases) - `fzf.exe`
- [git-bash](https://git-scm.com/install/windows) - `git-bash\` ディレクトリごと
- [neovim](https://github.com/neovim/neovim/releases) - `nvim-win64\` ディレクトリごと

### 2. デプロイ

```bash
cp .env.template .env  # WIN_USERNAME を設定
./copy.sh              # bin/, keyhac/config.py をWindows側にコピー
```

`%USERPROFILE%\bin\cmdrun.bat` を実行して起動する。

## 構成

```
C:\Users\{WIN_USERNAME}\
├── bin\
│   ├── cmdrun.bat      エントリーポイント
│   ├── init.macros     doskey マクロ定義（エイリアス集約）
│   ├── _cd.bat         cd置換（履歴記録付き）
│   ├── l.bat           サブディレクトリをfzfで選択してジャンプ
│   ├── z.bat           過去の移動履歴からfzfでジャンプ
│   └── rm.bat          ごみ箱に送る削除
├── exe\                外部バイナリ（手動配置）
│   ├── fzf.exe
│   ├── git-bash\       bin/, usr/bin/ のUnixコマンドをPATH供給
│   └── nvim-win64\
└── keyhac\config.py    Emacs風キーバインド（OS全体）
```

## コマンド一覧

### エントリーポイント

`cmdrun` を実行すると、UTF-8化・PATH設定・マクロ読込を行った新しいcmd.exeが起動する。

エイリアスは `init.macros` に `doskey /macrofile` 形式で集約されている。

### ディレクトリ移動

`cd` は `_cd.bat` に差し替えられ、全ての移動が `~/.dir_history` に自動記録される。

| コマンド | 内容 |
|---|---|
| `cd <dir>` | ディレクトリ移動 + 履歴記録 |
| `z` | 過去の移動履歴からfzfで選択してジャンプ |
| `l` | 現在地のサブディレクトリをfzfで選択してジャンプ |
| `bd` | 親ディレクトリへ移動 |

### ファイル操作・エディタ

| コマンド | 内容 |
|---|---|
| `rm <file>` | ごみ箱に送る（完全削除ではない） |
| `vi` / `vim` | neovim起動 |

## keyhac

OS全体に適用されるEmacs風キーバインド（Ubuntu.exeは除外）。

| キー | 動作 |
|---|---|
| `C-p/n/f/b` | 上/下/右/左 |
| `C-a/e` | Home/End |
| `C-h/d` | BackSpace/Delete |
| `C-k` | 行末まで削除 |
