# exe

## install_exefiles.bat で一括導入

`install_exefiles.bat` を実行すると、以下のツールを GitHub Releases から `%USERPROFILE%\exe` にインストールする。

* fzf
* ghq
* fd
* eza
* bat
* ripgrep (rg)
* neovim (`nvim-win64\bin\nvim.exe`)
* git / git-bash (PortableGit → `git-bash\`)

PATH は `cmdrun.bat` で設定済み。

## winget/install_apps.bat でアプリを導入

`%USERPROFILE%\exe\winget\install_apps.bat` を実行すると、Microsoft Visual C++ 2015+ 再頒布可能パッケージ（x64 と x86）と Google 日本語入力を winget からインストールする。`dl.bat` はこの bat を配置する。

## update_nvim.bat で nvim 設定を更新

`update_nvim.bat` を実行すると、`t-akira012/kickstart.nvim` の main ブランチ zip を取得し、既存の `%USERPROFILE%\.config\nvim` を削除してから設定を配置する。削除に失敗した場合は処理を中止する。`dl.bat` からも毎回呼び出す。

## create_startup.bat で常駐ソフトを登録

`create_startup.bat` は `%USERPROFILE%\Tools\keyhac\Keyhac.exe` と `%USERPROFILE%\Tools\clism\CLISM64.EXE` のショートカットを、現在のユーザーのスタートアップフォルダーに作成する。再実行すると同じショートカットを更新する。`dl.bat` からも毎回呼び出す。

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
