# SSH クリップボードの後続タスク

目的は [ADR 0001](adr/0001-ssh-tmux-clipboard-osc52.md) に記した、接続元から Mac mini への画像貼り付けと、Mac mini から接続元への copy/yank の両立。

## MacBook Pro と SSH

- MacBook Pro に Clipper 3.0.0 を導入し、launchd の `sh.brew.clipper` で起動済み。`~/.clipper.sock` の待受を確認済み。Mac mini 側も Clipper が同じ名前のソケットを待ち受けている。
- `myhouse/setup_ssh.md` の履歴（commit `78cb403`）にあった `RemoteForward /Users/t-akira012/.clipper.sock /Users/t-akira012/.clipper.sock` を SSH 設定に戻し、既存の `RemoteForward 2222 localhost:22` と併用する。Mac mini の `/etc/ssh/sshd_config` には `StreamLocalBindUnlink yes` があるため、SSH は既存のソケットパスを外して転送用に使用できる。Mac mini 側 Clipper の待受との切り替わりを実際に確認する。
- 新しい SSH 接続でソケット転送が成功することを確認し、Mac mini の `~/.clipper.sock` が SSH 転送を指している間に MacBook Pro のクリップボードへコピーできることを確認する。

## 実動作と ADR

- 新しい識別可能な PNG を MacBook Pro でコピーし、Ghostty → SSH → tmux → Codex に貼り付け、古い画像ではなく新しい画像が届くことを確認する。Clipper と macOS クリップボードの状態も記録し、実際の転送経路を特定する。
- tmux の copy、Neovim の Visual `y`・通常の yank、Codex の copy が接続元へ届くことを MacBook Pro と Windows 11 で確認する。
- Windows 11 → Mac mini の画像貼り付け方法を決め、tmux・Neovim・Codex それぞれで検証する。Windows に Mac 用 Clipper を導入できるとは仮定しない。
- 結果を踏まえて ADR 0001 の暫定決定を更新し、採用する最終構成と未対応の組み合わせを明記する。
