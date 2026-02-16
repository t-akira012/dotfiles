# exe

## install.bat で一括導入

`install.bat` を実行すると、以下のツールを GitHub Releases から `%USERPROFILE%\exe` にインストールする。

* fzf
* ghq
* fd
* eza
* bat
* ripgrep (rg)
* neovim (`nvim-win64\bin\nvim.exe`)
* git / git-bash (PortableGit → `git-bash\`)

PATH は `cmdrun.bat` で設定済み。

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
