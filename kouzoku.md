# SSH クリップボードの後続タスク

目的は [ADR 0001](adr/0001-ssh-tmux-clipboard-osc52.md) に記した、接続元から Mac mini への画像貼り付けと、Mac mini から接続元への copy/yank の両立。

## MacBook Pro と SSH

- MacBook Pro に Clipper を導入し、launchd で起動する。Mac mini 側は復旧済み。両側の `~/.clipper.sock` がどのプロセスに接続しているか確認する。
- MacBook Pro の `~/.ssh/config` の `Host mini` と `Host vpn` について、旧設定にあった `RemoteForward /Users/t-akira012/.clipper.sock /Users/t-akira012/.clipper.sock` の復旧要否を調べ、必要なら追加する。既存の `RemoteForward 2222 localhost:22` との共存を確認する。
- 接続時にソケット転送が失敗しないことを確認する。Mac mini 側で待受する Clipper と SSH が同じソケットパスを使用する場合は競合を解消する。

## 実動作と ADR

- 新しい識別可能な PNG を MacBook Pro でコピーし、Ghostty → SSH → tmux → Codex に貼り付け、古い画像ではなく新しい画像が届くことを確認する。Clipper と macOS クリップボードの状態も記録し、実際の転送経路を特定する。
- tmux の copy、Neovim の Visual `y`・通常の yank、Codex の copy が接続元へ届くことを MacBook Pro と Windows 11 で確認する。
- Windows 11 → Mac mini の画像貼り付け方法を決め、tmux・Neovim・Codex それぞれで検証する。Windows に Mac 用 Clipper を導入できるとは仮定しない。
- 結果を踏まえて ADR 0001 の暫定決定を更新し、採用する最終構成と未対応の組み合わせを明記する。
