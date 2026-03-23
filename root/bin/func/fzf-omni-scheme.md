# fzf-omni-search 列定義

## 列構造

```
col1: 型（短縮名。型対応表で定義）
col2: 表示文字列1
col3: 表示文字列2
col4: 表示文字列3（予約）
col5: 表示文字列4（予約）
col6+: 隠蔽文字列（action用メタデータ）
```

fzf: `--with-nth=1..5 --delimiter=$'\t'`

## 型対応表

| 短縮型 | query関数 | action関数 |
|---|---|---|
| `a` | `__query-apps` | `__action-apps` |
| `s` | `__query-search` | `__action-search` |
| `c` | `__query-today-calendar` | `__action-today-calendar` |
| `gt` | `__query-today-tasks` | `__action-today-tasks` |
| `p` | `__query-projects` | `__action-projects` |
| `b` | `__query-bookmarks` | `__action-bookmarks` |
| `t` | `__query-todo` | `__action-todo` |

## 各ソースの列割り当て

| 短縮型 | col2 | col3 | col4 | col5 | col6+ (隠蔽) |
|---|---|---|---|---|---|
| `a` | AppName | | | | |
| `s` | url | title | | | |
| `c` | 表示文字列 | | | | url |
| `gt` | 表示文字列 | | | | url |
| `p` | 行番号:見出し | | | | |
| `b` | url | title | | | |
| `t` | 行番号:タスク行 | | | | |

## __query-* 命名規則

- データ生成関数は全て `__query-*` を命名規則とする
- 出力はタブ区切り、改行区切りリスト
- col1（型）は `__fzf-omni-search` が型対応表に基づき付与。`__query-*` は col2 以降を出力する
- col2-5 は表示列。隠蔽データは必ず col6+ に配置すること（col2-5 に隠蔽列を置くのはschema違反）
- 隠蔽列がある場合、col2-5 を空タブで埋めて col6+ に配置する

## __action-* 命名規則

- アクション関数は全て `__action-*` を命名規則とする（`__query-*` と同じサフィックス）
- `__omni-action` は型から逆引きし `__action-{suffix}` にディスパッチする
- `__action-*` は `__query-*` 出力（型プレフィックスなし）を受け取る

## アーキテクチャ

```
__query-* → 動的発見 ${(k)functions[(I)__query-*]}
         → 型対応表で短縮型付与（未登録は関数名サフィックス）
         → __omni-format（一元整形、型非依存）
         → fzf
         → __omni-action → 逆引き対応表 → __action-*
```
