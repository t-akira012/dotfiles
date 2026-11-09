# ADR 0001: SSH 中のクリップボード転送に tmux と OSC 52 を使う

- 日付: 2026-11-09
- 状態: 採用

## 背景

Windows 11 の PowerShell から SSH で Mac mini に入り、tmux 内の Neovim を使う。tmux のコピーモードで取得した文字列は Windows 側に届く一方、Neovim の yank は届かなかった。従来の `pbcopy` ラッパーは Mac mini 上の Clipper ソケットを優先していたが、Windows 側に Clipper を導入する運用は想定していない。

tmux は `set-clipboard external` で、接続元端末に対して OSC 52 を送れる。現在の tmux 3.8 では `Ms` 機能も確認できた。OSC 52 は端末へクリップボード書き込みを伝える制御シーケンスで、SSH を通過できる。Windows Terminal と macOS の Ghostty は OSC 52 の書き込みに対応する。

## 決定

SSH 接続中かつ tmux 内では、コピーを `tmux load-buffer -w -` に渡す。tmux が OSC 52 を接続元端末へ送り、その端末のクリップボードを更新する。Windows 側に Clipper や追加のクリップボード常駐ソフトは入れない。

`root/bin/pbcopy` はこの条件で tmux を使い、それ以外の macOS では `/usr/bin/pbcopy` を使う。tmux のコピーモードは従来どおり tmux 自身の OSC 52 転送を使う。Clipper の分岐と導入スクリプトを削除する。

別リポジトリの `kickstart.nvim` では、SSH 接続中かつ tmux 内のとき `vim.g.clipboard = 'tmux'` を指定する。これにより通常の yank は Neovim の tmux clipboard provider を使う。Visual モードの `y` にある独自マッピングも同じ条件で `tmux load-buffer -w -` を呼ぶ。Mac 上で直接使う Neovim は従来の `pbcopy` を使う。

## 条件と影響

- `tmux load-buffer -w` を利用できる tmux 3.2 以上、tmux の `set-clipboard` が `on` または `external`、接続元端末の OSC 52 書き込み対応が必要。
- OSC 52 はクリップボードへの書き込み経路。Windows 側クリップボードからの読み取りは保証しない。Windows から Neovim への貼り付けは端末の貼り付け操作を使える。
- tmux に複数の接続元端末がある場合、どの端末のクリップボードが更新されるかは tmux のクライアント選択に依存する。
- Windows 11 での実機コピーは未確認。Neovim の provider 選択、Visual `y`、`pbcopy` の tmux 呼び出しはローカルで確認した。

## 参照

- [tmux Clipboard Wiki](https://github.com/tmux/tmux/wiki/Clipboard)
- [tmux マニュアル](https://man.openbsd.org/tmux.1)
- [Neovim clipboard provider](https://neovim.io/doc/user/provider/)
- [Ghostty OSC 52](https://ghostty.org/docs/vt/osc/52)
- [Windows Terminal の OSC 52 対応](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-clipboard)
