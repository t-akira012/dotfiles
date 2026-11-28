# exe

## install_exefiles.bat で一括導入

`%USERPROFILE%\exe\install\install_exefiles.bat` を実行すると、以下のツールを GitHub Releases から `%USERPROFILE%\exe` にインストールする。

配置に失敗したツールは後続の導入を続け、`%USERPROFILE%\Downloads\tmp` に ZIP と展開済みファイルを残して手動コピー元・配置先を表示する。

* fzf
* ghq
* fd
* eza
* bat
* ripgrep (rg)
* neovim (`nvim-win64\bin\nvim.exe`)
* git / git-bash (PortableGit → `git-bash\`)

PATH の追加先は `%USERPROFILE%\bin\paths.txt` に集約し、`cmdrun.bat` と Neovim 設定が読み込む。Git 用には `git-bash\cmd` も含む。ユーザー環境変数の PATH は変更しない。

## install_plemoljp_nf.bat でフォントを導入

`%USERPROFILE%\exe\install\install_plemoljp_nf.bat` は公式 GitHub Releases の最新 `PlemolJP_NF_v*.zip` を取得し、含まれる TrueType フォントを現在のユーザーにインストールする。`dl.bat` からも実行される。同じ版の再実行はスキップする。別の版へ更新するときは、既存の PlemolJP NF フォントを削除してから実行する。

フォント導入に失敗した場合、取得済み ZIP と展開済みファイルを `%USERPROFILE%\Downloads\tmp` に残す。

## install_apps.bat でアプリを導入

`%USERPROFILE%\exe\install\install_apps.bat` を実行すると、Microsoft Visual C++ 2015+ 再頒布可能パッケージ（x64 と x86）、Google 日本語入力、Tailscale クライアントを winget からインストールする。`dl.bat` はこの bat を配置する。

## update_nvim.bat で nvim 設定を更新

`%USERPROFILE%\exe\install\update_nvim.bat` を実行すると、`t-akira012/kickstart.nvim` の main ブランチ zip を取得し、既存の `%USERPROFILE%\.config\nvim` を削除してから設定を配置する。削除に失敗した場合は処理を中止する。`dl.bat` からも毎回呼び出す。

設定の配置に失敗した場合、ZIP と展開済み設定を `%USERPROFILE%\Downloads\tmp` に残し、手動コピー元を表示する。

設定配置後、`link_nvim_config.ps1` が `%LOCALAPPDATA%\nvim` から `%USERPROFILE%\.config\nvim` へのジャンクションを作成する。同じ参照先のジャンクションがあれば成功としてスキップする。通常フォルダー・ファイル・別の参照先へのリンクがあれば変更せず、確認対象を表示して終了コード1を返す。必要な設定を退避して競合を解消した後は、この PowerShell スクリプトだけを再実行できる。

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\exe\install\link_nvim_config.ps1"
```

## create_startup.bat で常駐ソフトを登録

`%USERPROFILE%\exe\install\create_startup.bat` は `%USERPROFILE%\Tools\keyhac\Keyhac.exe` と `%USERPROFILE%\Tools\clism\CLISM64.EXE` のショートカットを、現在のユーザーのスタートアップフォルダーに作成する。再実行すると同じショートカットを更新する。`dl.bat` からも毎回呼び出す。

## cargo / go

### cargo install

[rustup-init.exe](https://rustup.rs/) でRustを導入後、以下を実行する。

```
cargo install eza ripgrep fd-find bat
```

### go install

[go.dev](https://go.dev/dl/) でGoを導入後、以下を実行する。

```
go install github.com/junegunn/fzf@latest
go install github.com/x-motemen/ghq@latest
```
