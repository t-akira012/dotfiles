# win

cmd.exe をUnix風に使うための最小dotfiles。

## セットアップ

個別ダウンロード

* [Ctrl2Cap - Sysinternals | Microsoft Learn](https://learn.microsoft.com/ja-jp/sysinternals/downloads/ctrl2cap)
    * `ctr2cap /install`

## Install

Windows上のブラウザで `dl.bat` の raw URL を開き、保存して実行する。

```
dl.bat が行うこと:
1. GitHubからdotfiles main zipをDL・展開
2. bin\ を %USERPROFILE%\bin\ に上書きコピー
3. googleime\keybind.txt を %USERPROFILE%\.config\googleime\ にコピー
4. 公式の Keyhac for Windows 1.x リリースを %USERPROFILE%\exe\keyhac\ にDL・展開（既存ならスキップ）
5. このリポジトリの keyhac\config.py を %USERPROFILE%\exe\keyhac\ にコピー
6. install_exefiles.bat を %USERPROFILE%\exe\ に配置・実行
   （fzf, ghq, fd, eza, bat, rg, nvim, git-bash を既存でなければDL）
7. winget\install_apps.bat を %USERPROFILE%\exe\winget\ にコピー
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
│   ├── gg.bat          ghqリポジトリをfzfで選択してジャンプ
│   ├── vz.bat          rgでファイル検索→fzfで選択→nvimで開く
│   ├── gr.bat          gitリポジトリルートへ移動
│   ├── tf.bat          fdでディレクトリ検索→fzfで選択してジャンプ
│   └── rm.bat          ごみ箱に送る削除
├── exe\
│   ├── install_exefiles.bat  外部バイナリ一括DLスクリプト
│   ├── update_nvim.bat       nvim設定をkickstart.nvimから更新
│   ├── fzf.exe
│   ├── ghq.exe
│   ├── fd.exe
│   ├── eza.exe
│   ├── bat.exe
│   ├── rg.exe
│   ├── keyhac\
│   │   ├── keyhac.exe
│   │   └── config.py    このリポジトリのキーバインド設定
│   ├── winget\
│   │   └── install_apps.bat  Visual C++、Firefox、Google 日本語入力を導入
│   ├── git-bash\       bin/, usr/bin/ のUnixコマンドをPATH供給
│   └── nvim-win64\
└── .config\
    └── googleime\
        └── keybind.txt  Google 日本語入力のキー設定
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
| `tf [depth]` | fdでディレクトリを再帰検索→fzfで選択してジャンプ |
| `bd` | 親ディレクトリへ移動 |
| `gg` | ghqリポジトリをfzfで選択してジャンプ |
| `gr` | gitリポジトリルートへ移動 |

### ファイル操作・エディタ

| コマンド | 内容 |
|---|---|
| `rm <file>` | ごみ箱に送る（完全削除ではない） |
| `vi` / `vim` | neovim起動 |
| `vz [query]` | rgでファイル検索→fzfで選択→nvimで開く |

## keyhac

OS全体に適用されるキーバインド設定。
`%USERPROFILE%\exe\keyhac\keyhac.exe` を起動する。設定ファイルは実行ファイルと同じディレクトリに置く。
この設定は Keyhac for Windows 1.x 用なので、公式の旧版リリースを使用する。

| キー | 動作 |
|---|---|
| `C-p/n/f/b` | 上/下/右/左 |
| `C-a/e` | Home/End |
| `C-h/d` | BackSpace/Delete |
| `C-k` | 行末まで削除 |
| `Win+;` | WindowsTerminalを最前面トグル |

対象アプリ: Chrome, Edge WebView2, Notepad, PowerToys Launcher, cmd.exe（Nvim除外）
