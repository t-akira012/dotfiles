# ADR-002: __lazy_query-* 遅延ロードパターン

## 状況

dirs（zoxide）、files（fd）、web-search（DuckDuckGo）は応答が遅く、omni-search の即時ソースに混ぜると全体がブロックされていた。

## 決定

`__lazy_query-*` 命名規則を新設。`__omni-engine-search` が動的発見し、1,2,3,4,5秒のスタガーでバックグラウンド投入する。

```bash
local delay=1
for func in ${(k)functions[(I)__lazy_query-*]}; do
  ( sleep $delay; "$func" "$query" | sed "s/^/${type}\t/" ) &
  delay=$((delay + 1))
done
wait
```

## 理由

- fzf は stdin をストリーミングで読むため、パイプが開いている限り後から追加された行がリストに現れる
- 即時ソース（`__query-*`）は即座に表示され、遅延ソースが段階的に追加される
- 5秒超のソースは実用上読まれないため、最大5スロットで十分
- standalone alias（d, f, s）は `__lazy_query-*` を直接呼び出すため影響なし

## JXA CGWindowList が使えない件

macOS の JXA ObjC ブリッジは C 関数（CGWindowListCopyWindowInfo 等）を呼べない。Swift コンパイル済みバイナリで対応した。AppleScript は遅すぎるため禁止。
