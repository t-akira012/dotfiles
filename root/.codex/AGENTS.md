# Global Agent Instructions

## Bash

- 古いBashを含む実行環境で確実に動作することを最優先とする
- `func(){}func(){}main(){}main`型の構造を使用する
- Bash version差による構文障害を防ぐため、可搬性の高い基本構文だけを使用する
- 条件分岐、異常終了、既定値、文字列操作は省略せず明示する
- 処理を短絡演算、command group、変数参照へ隠さない
- 一覧処理には通常のpipelineと`while read`を使用する
- 複雑なshell patternを避け、ファイル検査には基本的な外部コマンドを使用する

次の構文は、古いBashで利用できないか、version間の解釈差や運用時の読解困難を生むため禁止する。

- process substitution、here-string
- 正規表現演算子
- 配列、連想配列
- `mapfile`、`readarray`、`printf -v`
- `eval`、`coproc`
- 複雑な複数行`case` pattern
- 短絡演算とcommand groupの組み合わせ
- 通常の`${variable}`を除く特殊なparameter expansion
- Bash versionに依存する構文

Bashを変更した場合は、全対象へ`bash -n`とShellCheckを実行し、禁止構文が残っていないことを検索で確認する。

## 運用設計

- 一人で運用するホームスタジオ環境では、形式的な原則より継続可能性と運用負荷の低さを優先する
- 具体的な実害を示せない制御や、手動迂回・Admin権限への切り替えを誘発する細分化を行わない
- 制御は増える作業と減らせる危険を比較して決め、利用者・重要データ・外部要件が変わった時だけ再評価する

## 実行可視性

- 長時間処理は対象、現在のファイル、進捗、完了、失敗を端末へ表示し、ログ保存を端末表示の代替にしない
- ユーザーの明示指示なしに`--no-progress`、`--only-show-errors`、stderrのログ限定redirectなど、実行状況を隠す指定を使用しない
