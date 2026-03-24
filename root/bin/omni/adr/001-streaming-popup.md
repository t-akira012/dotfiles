# ADR-001: popup.sh ストリーミング対応

## 状況

`__lazy_query-*` 導入により、fzf起動後に遅延データを追加投入する必要が生じた。
旧 popup.sh は `cat > tmpfile` で全量読み取り後に fzf を起動するため、ストリーミング不可だった。

## 決定

named pipe (FIFO) を使い、tmux display-popup をバックグラウンド、cat をフォアグラウンドで実行する。

```bash
mkfifo "$fifo"
tmux display-popup -E ... "fzf < '$fifo' > '$output_file'" &
cat > "$fifo" 2>/dev/null
wait 2>/dev/null
```

## 理由

- `cat &` (バックグラウンド) にすると bash が stdin を /dev/null に差し替えるため、データが流れない
- `tmux display-popup` は tmux サーバとソケット通信するだけで stdin 不要。バックグラウンドで問題なし
- cat がフォアグラウンドなら stdin（パイプ）を保持し、FIFO 経由で fzf にストリーミングできる
- fzf 終了時に FIFO の read end が閉じ、cat が SIGPIPE で自然終了する

## 影響

- 全 `__omni-fzf-*` standalone 関数は変更不要で動作する（非ストリーミングでも FIFO 経由で同じ動作）
- `__omni-engine-search` が `__lazy_query-*` をスタガー投入でき、fzf リストに順次追加される
