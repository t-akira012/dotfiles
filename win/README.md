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
2. %USERPROFILE%\Tools\ と %USERPROFILE%\.dir_history がなければ作成
3. bin\ を %USERPROFILE%\bin\ に上書きコピー
4. googleime\keybind.txt を %USERPROFILE%\.config\googleime\ にコピー
5. 公式の Keyhac 2 Windows x64 最新リリースを %USERPROFILE%\Tools\keyhac\ にDL・展開（配置先は毎回置換）
6. このリポジトリの keyhac\config.py を %USERPROFILE%\Tools\keyhac\ にコピー
7. CLISM excellent の最新版を %USERPROFILE%\Tools\clism\ にDL・展開（配置先は毎回置換）
8. install_exefiles.bat と update_nvim.bat を %USERPROFILE%\exe\ に配置・実行
   （fzf, ghq, fd, eza, bat, rg, nvim, git-bash を既存でなければDL）
   （Neovim 設定は既存の %USERPROFILE%\.config\nvim\ を削除して kickstart.nvim に置き換え）
9. winget\install_apps.bat を %USERPROFILE%\exe\winget\ にコピー
10. create_startup.bat を %USERPROFILE%\exe\ に配置・実行し、Keyhac と CLISM excellent をスタートアップに登録
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
│   ├── create_startup.bat    常駐ソフトのスタートアップ登録
│   ├── fzf.exe
│   ├── ghq.exe
│   ├── fd.exe
│   ├── eza.exe
│   ├── bat.exe
│   ├── rg.exe
│   ├── winget\
│   │   └── install_apps.bat  Visual C++、Google 日本語入力を導入
│   ├── git-bash\       bin/, usr/bin/ のUnixコマンドをPATH供給
│   └── nvim-win64\
├── Tools\
│   ├── keyhac\
│   │   ├── Keyhac.exe
│   │   └── config.py    このリポジトリのキーバインド設定
│   └── clism\
│       ├── CLISM64.EXE
│       ├── CLISM64.DLL
│       ├── CLISM.EXE
│       └── CLISM.DLL
├── .dir_history       ディレクトリ移動履歴
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
`%USERPROFILE%\Tools\keyhac\Keyhac.exe` を起動する。Keyhac 2 の Windows ポータブルモードを使い、設定ファイルを実行ファイルと同じディレクトリに置く。

| キー | 動作 |
|---|---|
| `C-p/n/f/b` | 上/下/右/左 |
| `C-a/e` | Home/End |
| `C-h/d` | BackSpace/Delete |
| `C-k` | 行末まで削除 |
| `Win+;` | WindowsTerminalを最前面トグル |
| `Win+Tab` | 無効化 |
| `Win+V` | 無効化 |

対象アプリ: Chrome, Edge WebView2, Notepad, PowerToys Launcher, cmd.exe（Nvim除外）

`Win+L` は Keyhac 2 に割り当てを記述しているが、Windows がキーボードフックより先に処理するため、Keyhac では無効化できない。

## CLISM excellent

[公式配布ページ](https://toroidj.github.io/slwin4.html#clismex) から最新版を取得する。Windows x64 版の `CLISM64.EXE` を起動し、同じディレクトリにある x86 版も併用できるよう zip の内容をまとめて配置する。

`%USERPROFILE%\exe\create_startup.bat` を実行すると、Keyhac と CLISM excellent のショートカットを現在のユーザーのスタートアップフォルダーに作成する。`dl.bat` からも実行される。

## Google 日本語入力

`dl.bat` は `keybind.txt` を `%USERPROFILE%\.config\googleime\` に配置する。Google 日本語入力へ反映するには、インストール後に「プロパティ」→「一般」→「キー設定の選択」→「編集」→「インポート」からそのファイルを選び、キー設定を「カスタム」にする。ファイルの配置だけでは反映されない。
