# Windows 11 軽量化・高速操作環境構築手順書

**対象:** Intel N100 / RAM 16GB / 日本語版 Windows 11 **26H2** / Win32 GUI・事務処理

**改訂日:** 2026-11-09

**構成:** 同一画面で操作する項目は1節にまとめ、GUIの画面遷移は1回だけ記載します。最終操作箇所と設定値を一覧表にまとめ、CUI・レジストリは該当する画面の節に併記します。PowerShellは各コードブロックにつき物理1行で記載します。

## 1. 前提・バージョン判定

Intel N100・RAM 16GBの日本語版 Windows 11を対象に、設定の変更手順を示します。GUIの記載は Windows 11 26H2（OSビルド26300系）の表示を基準とします。

### 1.1 OSバージョンの確認

**GUI操作**

1.  `Win + R` → `winver` → Enter。表示されたダイアログの「バージョン」「OS ビルド」を読み取ります。
2.  `Win + I` →「システム」→「バージョン情報」→「Windows の仕様」→「バージョン」「OS ビルド」を確認します。

**CUI / PowerShell**

**OSとビルドを表示**

```powershell
Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,BuildNumber; Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' | Select-Object DisplayVersion,CurrentBuild,UBR
```

**確認条件:** 「バージョン」と「OS ビルド」の表示を確認できること。

### 1.2 維持するWindows基盤

**確認条件:** Windows Update、Microsoft Defender、Windows Defender Firewall、USB/ネットワーク/ドライバー基盤、Windows Event Log、Task Scheduler、SysMain、ページファイルを停止・無効化しないこと。

**補足:** この項目は変更禁止リストです。設定操作はありません。

## 2. スタートアップ アプリを無効化

サインイン時に起動するアプリとWindowsサービスは別物です。スタートアップ アプリの状態を一つずつ確認します。

### 2.1 設定アプリでスタートアップをすべてオフ

**GUI操作**

1.  `Win + I` →「アプリ」→「スタートアップ」。
2.  一覧の各アプリ名の右端のスイッチをクリックし、1件ずつ「オフ」にします。最後の行までスクロールして全行を確認します。

**確認条件:** 一覧中の各スイッチが「オフ」。

### 2.2 タスク マネージャーで状態を確認

**GUI操作**

1.  `Ctrl + Shift + Esc` → 左メニュー「スタートアップ アプリ」。
2.  各行を選択し、状態が「有効」の場合は対象を右クリック →「無効にする」。すべての行で「無効」を確認します。

**CUI / PowerShell**

**スタートアップ登録の参考一覧（読み取りのみ）**

```powershell
Get-CimInstance Win32_StartupCommand | Select-Object Name,Command,Location,User
```

**確認条件:** タスクマネージャーの「状態」列がすべて「無効」。

**補足:** Win32_StartupCommandは登録方式を網羅しないため、GUIの最終状態を正本とします。

## 3. 視覚効果・透明効果

視覚効果と透明効果の2画面について操作します。フォント設定は「視覚効果」と同じ画面内で指定します。

### 3.1 視覚効果とスクリーンフォント

**GUI操作**

1.  `Win + R` → `SystemPropertiesPerformance.exe` → Enter。
2.  「パフォーマンス オプション」→「視覚効果」タブを開きます。
3.  「パフォーマンスを優先する」のラジオボタンを選択します。
4.  フォントの表示を滑らかにする場合は、同じ画面の「スクリーン フォントの縁を滑らかにする」のチェックボックスをオンにします。
5.  「適用」→「OK」を押します。

**確認条件:** 「パフォーマンスを優先する」が選択され、フォントのチェックボックスが選択した状態になっていること。

### 3.2 透明効果

**GUI操作**

1.  `Win + I` →「個人用設定」→「色」。
2.  「透明効果」の右側にあるスイッチを「オフ」にします。

**確認条件:** 「透明効果」が「オフ」。

## 4. 電源モード

電源接続時のパフォーマンスモードを設定します。

### 4.1 電源モードを選ぶ

**GUI操作**

1.  `Win + I` →「システム」→「電源」。
2.  「電源モード」の行の右端「∨」をクリックして展開します。
3.  「電源に接続」の右端「∨」をクリックし、「最適なパフォーマンス（CPUのパフォーマンスを優先）」を選択します。

**確認条件:** 「電源モード」→「電源に接続」で「最適なパフォーマンス」が選択されていること。

**補足:** 電源モードが選べない場合は `Win + R` → `powercfg.cpl` →「電源オプション」でカスタムプラン選択の有無を調べます。

## 5. Windows 検索・インデックスの停止

インデックス対象を設定します。サービスの起動設定は第8章に集約します。

### 5.1 検索対象とインデックスの場所

**GUI操作**

1.  `Win + I` →「プライバシーとセキュリティ」→「検索」。
2.  「ファイルを検索」のラジオボタンで「クラシック」を選択します。
3.  同じ画面の「検索場所のカスタマイズ」をクリックし、「インデックスのオプション」を開きます。
4.  「変更」→「インデックスが作成された場所」で `C:\` 配下のチェックボックスを確認し、除外する場所のチェックを外します。
5.  「OK」→「閉じる」をクリックします。

| 設定項目                     | 設定値                 |
|------------------------------|------------------------|
| ファイルを検索               | クラシック             |
| インデックスが作成された場所 | `C:\` 配下の選択を解除 |

**確認条件:** 「クラシック」が選択され、インデックスの対象一覧に除外した `C:\` の場所が残っていないこと。

**補足:** `WSearch` サービスの停止・無効化は第8章「Windows Search」で行います。

## 6. 不要なプリインストール アプリの削除

同じ「インストールされているアプリ」画面から、対象アプリを検索して削除します。

### 6.1 「インストールされているアプリ」から削除

**GUI操作**

1.  `Win + I` →「アプリ」→「インストールされているアプリ」を開きます。
2.  検索欄に以下の検索語を入力し、対象アプリの名称を確認します。
3.  該当アプリの右端の「…」→「アンインストール」をクリックします。
4.  確認ダイアログの「アンインストール」を押します。削除する各アプリについて手順2～4を繰り返します。

| アプリ名・種類     | 検索語     | 操作                                       |
|--------------------|------------|--------------------------------------------|
| Microsoft OneDrive | `OneDrive` | 対象行の「…」→「アンインストール」         |
| Xbox関連アプリ     | `Xbox`     | 検索結果の各対象行を個別にアンインストール |
| Microsoft Teams    | `Teams`    | 使用しない場合にアンインストール           |
| Microsoft Copilot  | `Copilot`  | 使用しない場合にアンインストール           |

**確認条件:** アンインストールしたアプリが「インストールされているアプリ」の検索結果に表示されないこと。最初から存在しないアプリは操作不要です。

## 7. グループ ポリシー

グループポリシーエディターから3つの設定を変更し、適用・検証します。

### 7.1 ポリシーの変更

**GUI操作**

1.  `Win + R` → `gpedit.msc` → Enter。
2.  左ペイン「コンピューターの構成」→「管理用テンプレート」→「Windows コンポーネント」を展開します。
3.  下表の「フォルダー」を開き、右ペインにある「ポリシー名」をダブルクリックします。
4.  下表の状態に対応するラジオボタンを選択し、必要なオプションを指定して「適用」→「OK」を押します。

| フォルダー | ポリシー名 | 状態 | オプション |
|----|----|----|----|
| ウィジェット | ウィジェットを許可する | 無効 | ― |
| OneDrive | OneDrive をファイル記憶域として使用できないようにする | 有効 | ― |
| 配信の最適化 | ダウンロード モード | 有効 | ダウンロード モード: HTTP のみ (0) |

**確認条件:** 各ポリシーの「状態」列が表の値と一致し、「ダウンロード モード」のオプションが「HTTP のみ (0)」であること。

**補足:** `gpedit.msc` は Windows 11 Pro / Enterprise / Education で使用します。

### 7.2 ポリシー適用と結果の確認

**GUI操作**

1.  変更したポリシー画面を再度開き、選択したラジオボタン・オプションが保存されていることを確認します。

**CUI / PowerShell**

**ポリシー強制更新（管理者）（管理者としてPowerShellを起動）**

```powershell
gpupdate /force
```

**適用ポリシーのHTMLレポート作成・表示（管理者）（管理者としてPowerShellを起動）**

```powershell
gpresult /h "$env:TEMP\windows11-gpresult.html" /f; Start-Process "$env:TEMP\windows11-gpresult.html"
```

**確認条件:** 管理レポートと各ポリシー画面の値が一致すること。

## 8. 停止・無効化する5サービス（各サービス個別操作）

次の5サービスを対象にします。Fax（Fax）、Downloaded Maps Manager（MapsBroker）、Windows Biometric Service（WbioSrvc）、位置情報サービス（lfsvc）、Windows Search（WSearch）。操作するGUIはすべて「サービス」です。

### 8.1 5サービスの停止・起動無効化

**GUI操作**

1.  `Win + R` → `services.msc` → Enter。
2.  下表の「表示名」のサービスを一覧から探してダブルクリックし、「全般」タブを開きます。
3.  「サービス名」が表の値と一致することを確認します。
4.  「サービスの状態」が「実行中」なら「停止」を押します。
5.  「スタートアップの種類」を「無効」に変更し、「適用」→「OK」を押します。これを各サービスについて行います。

| 表示名 | サービス名 | 対象機能 |
|----|----|----|
| Fax | `Fax` | FAX送受信 |
| Downloaded Maps Manager | `MapsBroker` | ダウンロード済みのオフライン地図 |
| Windows Biometric Service | `WbioSrvc` | 指紋・顔などの生体認証 |
| Geolocation Service / 位置情報サービス | `lfsvc` | 位置情報取得 |
| Windows Search | `WSearch` | 検索インデックス |

**CUI / PowerShell**

各サービスは名称を明示した個別コマンドで停止します。

**Fax（Fax）を停止・無効化（管理者）**

```powershell
$s=Get-Service -Name Fax -ErrorAction SilentlyContinue; if($s){if($s.Status -ne 'Stopped'){Stop-Service -Name Fax -Force -ErrorAction Stop}; Set-Service -Name Fax -StartupType Disabled -ErrorAction Stop}else{'Fax: not installed'}
```

**Downloaded Maps Manager（MapsBroker）を停止・無効化（管理者）**

```powershell
$s=Get-Service -Name MapsBroker -ErrorAction SilentlyContinue; if($s){if($s.Status -ne 'Stopped'){Stop-Service -Name MapsBroker -Force -ErrorAction Stop}; Set-Service -Name MapsBroker -StartupType Disabled -ErrorAction Stop}else{'MapsBroker: not installed'}
```

**Windows Biometric Service（WbioSrvc）を停止・無効化（管理者）**

```powershell
$s=Get-Service -Name WbioSrvc -ErrorAction SilentlyContinue; if($s){if($s.Status -ne 'Stopped'){Stop-Service -Name WbioSrvc -Force -ErrorAction Stop}; Set-Service -Name WbioSrvc -StartupType Disabled -ErrorAction Stop}else{'WbioSrvc: not installed'}
```

**位置情報サービス（lfsvc）を停止・無効化（管理者）**

```powershell
$s=Get-Service -Name lfsvc -ErrorAction SilentlyContinue; if($s){if($s.Status -ne 'Stopped'){Stop-Service -Name lfsvc -Force -ErrorAction Stop}; Set-Service -Name lfsvc -StartupType Disabled -ErrorAction Stop}else{'lfsvc: not installed'}
```

**Windows Search（WSearch）を停止・無効化（管理者）**

```powershell
$s=Get-Service -Name WSearch -ErrorAction SilentlyContinue; if($s){if($s.Status -ne 'Stopped'){Stop-Service -Name WSearch -Force -ErrorAction Stop}; Set-Service -Name WSearch -StartupType Disabled -ErrorAction Stop}else{'WSearch: not installed'}
```

**5サービスの状態確認**

**全サービスの表示名・実行状態・起動種別を確認**

```powershell
'Fax','MapsBroker','WbioSrvc','lfsvc','WSearch' | ForEach-Object { $n=$_; $s=Get-Service -Name $n -ErrorAction SilentlyContinue; if($s){[PSCustomObject]@{Name=$n;DisplayName=$s.DisplayName;Status=$s.Status;StartType=$s.StartType}}else{[PSCustomObject]@{Name=$n;DisplayName='未インストール';Status='N/A';StartType='N/A'}} } | Format-Table -AutoSize
```

**確認条件:** 存在する5サービスがそれぞれ `Stopped` / `Disabled` となっていること。インストールされていないサービスは「未インストール」と表示されること。

**補足:** Windows Helloの生体認証を使用している端末では `WbioSrvc` を停止すると利用できなくなります。 `WSearch` 停止によりインデックスベースの検索が制限されます。

## 9. プライバシーと検索の許可

プライバシーの各画面にあるスイッチを設定します。同じ画面内にある検索のアクセス許可のスイッチは、1つの節にまとめています。

### 9.1 オンライン音声認識

**GUI操作**

1.  `Win + I` →「プライバシーとセキュリティ」→「音声認識」。
2.  「オンライン音声認識」スイッチを「オフ」にします。

**確認条件:** 「オンライン音声認識」が「オフ」。

### 9.2 デバイスの検索

**GUI操作**

1.  `Win + I` →「プライバシーとセキュリティ」→「デバイスの検索」。
2.  「デバイスの検索」スイッチを「オフ」にします。

**確認条件:** 「デバイスの検索」が「オフ」。

### 9.3 手描き入力と入力の個人用設定

**GUI操作**

1.  `Win + I` →「プライバシーとセキュリティ」→「手描き入力と入力の個人用設定」。
2.  「カスタム手描き入力と入力辞書」スイッチを「オフ」にします。

**確認条件:** 「カスタム手描き入力と入力辞書」が「オフ」。

### 9.4 検索のアクセス許可：クラウド検索と履歴

**GUI操作**

1.  `Win + I` →「プライバシーとセキュリティ」→「検索のアクセス許可」を開きます。
2.  以下の項目のスイッチを変更します。

| 設定グループ | スイッチ名 | 設定値 |
|----|----|----|
| クラウド コンテンツの検索 | Microsoft アカウント | オフ |
| クラウド コンテンツの検索 | 職場または学校アカウント（表示される場合） | オフ |
| 履歴 | このデバイスの検索履歴 | オフ |

1.  保存済み履歴の消去も行う場合は「履歴」→「デバイスの検索履歴のクリア」をクリックします。

**確認条件:** 表に示したスイッチがすべて「オフ」。検索履歴の消去はスイッチ変更とは別の操作です。

### 9.5 アクティビティ履歴のローカル保存をオフ

**GUI操作**

1.  `Win + I` →「プライバシーとセキュリティ」→「アクティビティの履歴」。
2.  「このデバイスでアクティビティ履歴を保存する」スイッチを「オフ」にします。
3.  既存履歴の消去も実施する場合は、同じ画面の「このアカウントのアクティビティ履歴をクリアする」→「履歴のクリア」をクリックします。既存履歴を消去する操作は、保存停止とは独立です。

**確認条件:** 「このデバイスでアクティビティ履歴を保存する」が「オフ」。

**補足:** Windows 11で廃止された「タイムライン」のUIと、アクティビティ履歴の設定は別です。Microsoft公式の現行手順に従います。

## 10. 個人用設定：背景・ロック画面・スタート・タスクバー

同じ設定画面に属する項目をまとめて操作します。画面単位は「背景」「ロック画面」「スタート」「タスク バー」です。

### 10.1 デスクトップ背景

**GUI操作**

1.  `Win + I` →「個人用設定」→「背景」。
2.  「背景をカスタマイズする」ドロップダウンをクリックし、「単色」を選択。
3.  「背景色の選択」に表示された色のタイルをクリックし、使用する1色を選びます。

**確認条件:** 「背景をカスタマイズする」が「単色」。Windows スポットライトが選択されていないこと。

### 10.2 ロック画面とサインイン画面

**GUI操作**

1.  `Win + I` →「個人用設定」→「ロック画面」を開きます。
2.  「ロック画面のカスタマイズ」ドロップダウンから「画像」を選択します。
3.  「写真の選択」→「写真を参照」から単色の画像ファイルを選択します。
4.  同じ画面で次の項目を設定します。

| 操作対象 | 種類 | 設定値 |
|----|----|----|
| ロック画面のカスタマイズ | ドロップダウン | 画像（Windows スポットライト／スライドショーを使わない） |
| ロック画面で豆知識、ヒント、コツなどを取得する | チェックボックス | オフ |
| ウィジェット | スイッチ | オフ |
| PC を移動したときにロック画面の画像に反応させる（表示される端末のみ） | スイッチ | オフ |
| サインイン画面にロック画面の背景画像を表示する | スイッチ | オフ |

**確認条件:** 画像が選択され、表の各スイッチ・チェックボックスが指定値になっていること。

**補足:** ロック画面の背景には「単色」の直接選択がないため、「画像」を選び単色画像ファイルを指定します。

### 10.3 スタートメニュー

**GUI操作**

1.  `Win + I` →「個人用設定」→「スタート」を開きます。
2.  「レイアウト オプション」→「新着順」をいったん「オン」にし、「∨」から詳細を展開します。
3.  詳細の3チェックボックスを下表のとおりすべて「オフ」にします。
4.  「新着順」の親スイッチを「オフ」に戻します。
5.  同じ「スタート」画面にある残りのスイッチも下表の値に変更します。

| 設定項目 | 種類 | 設定値 |
|----|----|----|
| 最近追加したアプリを表示する | チェックボックス | オフ |
| 最近使ったファイルとおすすめのファイルを表示する | チェックボックス | オフ |
| ヒントとアプリの推奨事項を表示する | チェックボックス | オフ |
| 新着順 | スイッチ（上記設定後） | オフ |
| スタートにモバイル デバイスを表示する | スイッチ | オフ |
| アカウントに関連する通知を表示 | スイッチ | オフ |

**確認条件:** 3つのチェックボックスと3つのスイッチがすべて「オフ」。親スイッチをオフにした結果、スタートメニューに「最近使用」の欄が表示されないこと。

**補足:** 「新着順」を先にオフにすると内訳のチェックボックスが操作できなくなるため、上記の順序で設定します。

### 10.4 タスクバーとシステムトレイ

**GUI操作**

1.  タスクバーの空白を右クリック →「タスク バーの設定」を開きます。
2.  「タスク バー項目」を展開し、下表の項目を設定します。
3.  同じ画面の「システム トレイ アイコン」と「その他のシステム トレイ アイコン」も展開し、各項目を設定します。

| 設定グループ | 設定項目 | 種類 | 設定値 |
|----|----|----|----|
| タスク バー項目 | 検索 | ドロップダウン | 非表示 |
| タスク バー項目 | タスク ビュー | スイッチ | オフ |
| タスク バー項目 | ウィジェット | スイッチ | オフ |
| システム トレイ アイコン | ペン メニュー、タッチ キーボード、仮想タッチパッド（表示される項目） | スイッチ | オン |
| その他のシステム トレイ アイコン | 一覧にある各アプリのアイコン表示 | スイッチ | オン |

**確認条件:** タスクバーの不要な項目が非表示になり、表示可能なトレイアイコンのスイッチが「オン」。

## 11. 通知・ウェルカム画面・ヒント

「設定 → システム → 通知」の1画面で通知と追加のヒント表示をまとめて変更します。

### 11.1 通知・追加の設定

**GUI操作**

1.  `Win + I` →「システム」→「通知」を開きます。
2.  画面上部の「通知」スイッチを「オフ」にします。
3.  ページ下部の「追加の設定」をクリックして展開します。
4.  以下のチェックボックスを「オフ」にします。

| 画面内の位置 | 操作対象 | 種類 | 設定値 |
|----|----|----|----|
| 通知 | 通知 | スイッチ | オフ |
| 追加の設定 | 更新後およびサインイン時に Windows へようこそエクスペリエンスを表示して、新機能や推奨事項を表示する | チェックボックス | オフ |
| 追加の設定 | Windows の使用時にヒントや提案を取得する | チェックボックス | オフ |

**確認条件:** 「通知」が「オフ」、2つのチェックボックスが空欄であること。

## 12. キーボードのリピート最速化

GUIのスライダーとレジストリ値の対応を明示します。

### 12.1 リピート開始遅延0・繰り返し速度31

**GUI操作**

1.  `Win + R` → `control keyboard` → Enter。
2.  「キーボードのプロパティ」→「速度」タブ。
3.  「文字の入力」→「表示までの待ち時間」スライダーを「短く」（最短側）へ動かします。
4.  「表示の間隔」スライダーを「速く」（最速側）へ動かし、「適用」→「OK」。

**CUI / PowerShell**

**KeyboardDelay=0、KeyboardSpeed=31**

```powershell
Set-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name KeyboardDelay -Value '0'; Set-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name KeyboardSpeed -Value '31'
```

**設定値の確認**

```powershell
Get-ItemProperty 'HKCU:\Control Panel\Keyboard' | Select-Object KeyboardDelay,KeyboardSpeed
```

**対応レジストリ**

- パス: `HKCU\Control Panel\Keyboard` ／ 値名: `KeyboardDelay` ／ 型: `REG_SZ` ／ 値: `0`
- パス: `HKCU\Control Panel\Keyboard` ／ 値名: `KeyboardSpeed` ／ 型: `REG_SZ` ／ 値: `31`

**確認条件:** レジストリが `KeyboardDelay=0`、`KeyboardSpeed=31`。

**補足:** リピートを開始するまでの待ち時間とリピート間隔を変更します。単発キー入力遅延は変更しません。

## 13. 固定キー・フィルターキー・切り替えキー

アクセシビリティの「キーボード」画面を起点に、3機能と3ショートカットをまとめて設定します。

### 13.1 入力補助3機能と有効化ショートカット

**GUI操作**

1.  `Win + I` →「アクセシビリティ」→「キーボード」を開きます。
2.  「固定キー機能」「フィルター キー機能」「切り替えキー機能」の3つのスイッチを「オフ」にします。
3.  各機能名をクリックして詳細画面を開き、次の有効化ショートカットも「オフ」にします。詳細の確認後は「キーボード」画面へ戻り、次の機能を操作します。

| 機能 | 機能本体 | 詳細画面でオフにするスイッチ | キー操作 |
|----|----|----|----|
| 固定キー機能 | オフ | 固定キー機能用のキーボード ショートカット | Shift 5回 |
| フィルター キー機能 | オフ | フィルター キー機能のキーボード ショートカット | 右Shift 8秒 |
| 切り替えキー機能 | オフ | 切り替えキー機能用のキーボード ショートカット | NumLock 5秒 |

**CUI / PowerShell**

**固定キーのフラグを506に設定**

```powershell
Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name Flags -Value '506'
```

**フラグ確認**

```powershell
Get-ItemProperty 'HKCU:\Control Panel\Accessibility\StickyKeys' | Select-Object Flags
```

**フィルターキーのフラグを122に設定**

```powershell
Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\Keyboard Response' -Name Flags -Value '122'
```

**フラグ確認**

```powershell
Get-ItemProperty 'HKCU:\Control Panel\Accessibility\Keyboard Response' | Select-Object Flags
```

**切り替えキーのフラグを58に設定**

```powershell
Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\ToggleKeys' -Name Flags -Value '58'
```

**フラグ確認**

```powershell
Get-ItemProperty 'HKCU:\Control Panel\Accessibility\ToggleKeys' | Select-Object Flags
```

**対応レジストリ**

- パス: `HKCU\Control Panel\Accessibility\StickyKeys` ／ 値名: `Flags` ／ 型: `REG_SZ` ／ 値: `506`
- パス: `HKCU\Control Panel\Accessibility\Keyboard Response` ／ 値名: `Flags` ／ 型: `REG_SZ` ／ 値: `122`
- パス: `HKCU\Control Panel\Accessibility\ToggleKeys` ／ 値名: `Flags` ／ 型: `REG_SZ` ／ 値: `58`

**確認条件:** 3つの機能本体と3つの有効化ショートカットがいずれも「オフ」であること。レジストリの `Flags` は上表に対応する `506`・`122`・`58` であること。

## 14. 入力候補・自動修正・スペルチェック

「設定 → 時刻と言語 → 入力」の1画面にある4設定をまとめて操作します。

### 14.1 入力候補とスペルチェック

**GUI操作**

1.  `Win + I` →「時刻と言語」→「入力」を開きます。
2.  同じ画面で下表の4スイッチをすべて「オフ」にします。

| 設定項目                                         | 種類     | 設定値 |
|--------------------------------------------------|----------|--------|
| 物理キーボードでの入力時にテキスト候補を表示する | スイッチ | オフ   |
| 多言語テキスト候補                               | スイッチ | オフ   |
| スペルミスの単語のオートコレクト                 | スイッチ | オフ   |
| スペルミスの単語を強調表示する                   | スイッチ | オフ   |

**CUI / PowerShell**

**物理キーボードのテキスト候補を無効化**

```powershell
$p='HKCU:\Software\Microsoft\Input\Settings'; New-Item -Path $p -Force | Out-Null; New-ItemProperty -Path $p -Name EnableHwkbTextPrediction -PropertyType DWord -Value 0 -Force | Out-Null
```

**多言語テキスト候補を無効化**

```powershell
$p='HKCU:\Software\Microsoft\Input\Settings'; New-Item -Path $p -Force | Out-Null; New-ItemProperty -Path $p -Name MultilingualEnabled -PropertyType DWord -Value 0 -Force | Out-Null
```

**自動修正を無効化（対応するレジストリ）**

```powershell
$p='HKCU:\Software\Microsoft\Input\Settings'; New-Item -Path $p -Force | Out-Null; New-ItemProperty -Path $p -Name EnableAutocorrection -PropertyType DWord -Value 0 -Force | Out-Null; $q='HKCU:\Software\Microsoft\TabletTip\1.7'; New-Item -Path $q -Force | Out-Null; New-ItemProperty -Path $q -Name EnableAutocorrection -PropertyType DWord -Value 0 -Force | Out-Null
```

**スペルチェックのレジストリを無効化**

```powershell
$q='HKCU:\Software\Microsoft\TabletTip\1.7'; New-Item -Path $q -Force | Out-Null; New-ItemProperty -Path $q -Name EnableSpellchecking -PropertyType DWord -Value 0 -Force | Out-Null
```

**対応レジストリ**

- パス: `HKCU\Software\Microsoft\Input\Settings` ／ 値名: `EnableHwkbTextPrediction` ／ 型: `REG_DWORD` ／ 値: `0`
- パス: `HKCU\Software\Microsoft\Input\Settings` ／ 値名: `MultilingualEnabled` ／ 型: `REG_DWORD` ／ 値: `0`
- パス: `HKCU\Software\Microsoft\Input\Settings` ／ 値名: `EnableAutocorrection` ／ 型: `REG_DWORD` ／ 値: `0`
- パス: `HKCU\Software\Microsoft\TabletTip\1.7` ／ 値名: `EnableAutocorrection` ／ 型: `REG_DWORD` ／ 値: `0`
- パス: `HKCU\Software\Microsoft\TabletTip\1.7` ／ 値名: `EnableSpellchecking` ／ 型: `REG_DWORD` ／ 値: `0`

**確認条件:** 同じ「入力」画面の4スイッチがいずれも「オフ」であること。

**補足:** 記載したレジストリはWindowsの入力機構に関連する値です。GUIのスイッチ状態を設定結果の判定に使用します。Microsoft IME独自の変換候補設定は、この4スイッチとは別です。

## 15. メニュー表示遅延を0にする

GUI上にこの値を直接編集できる標準チェックボックスはありません。レジストリ・CUI操作を単独で記載します。

### 15.1 MenuShowDelay=0

**CUI / PowerShell**

**メニュー表示遅延を0へ**

```powershell
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name MenuShowDelay -Value '0'
```

**設定値確認**

```powershell
Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' | Select-Object MenuShowDelay
```

**対応レジストリ**

- パス: `HKCU\Control Panel\Desktop` ／ 値名: `MenuShowDelay` ／ 型: `REG_SZ` ／ 値: `0`

**確認条件:** `MenuShowDelay` が文字列 `0`。

**補足:** サインアウト・再サインインして反映を確認します。

## 16. 反映・全項目検証

操作対象、GUIでの反映、CUIの設定値、再起動要否を分離して確認します。

### 16.1 ポリシーと設定反映

**GUI操作**

1.  キーボード、背景、タスクバー、各チェックボックスについて、記載した画面に再度移動して設定値を確認します。
2.  レジストリ操作設定の適用後はサインアウト・再サインインします。
3.  `Scancode Map` を編集した場合はWindowsの再起動が必要です。

**CUI / PowerShell**

**gpupdate（ポリシー変更時・管理者）（管理者としてPowerShellを起動）**

```powershell
gpupdate /force
```

**確認条件:** 各章の「確認」条件を満たすこと。

### 16.2 サービス5件の起動設定の一覧

**CUI / PowerShell**

**5つの名称・状態・起動種別を一覧表示**

```powershell
'Fax','MapsBroker','WbioSrvc','lfsvc','WSearch' | ForEach-Object { $n=$_; $s=Get-Service -Name $n -ErrorAction SilentlyContinue; if($s){[PSCustomObject]@{Name=$n;DisplayName=$s.DisplayName;Status=$s.Status;StartType=$s.StartType}}else{[PSCustomObject]@{Name=$n;DisplayName='未インストール';Status='N/A';StartType='N/A'}} } | Format-Table -AutoSize
```

**確認条件:** 存在する対象サービスは `Stopped/Disabled`、存在しないものは `未インストール`。

### 16.3 設定値・負荷の計測

**CUI / PowerShell**

**入力操作のレジストリ値**

```powershell
Get-ItemProperty 'HKCU:\Control Panel\Keyboard' | Select-Object KeyboardDelay,KeyboardSpeed; Get-ItemProperty 'HKCU:\Control Panel\Desktop' | Select-Object MenuShowDelay; Get-ItemProperty 'HKCU:\Control Panel\Accessibility\StickyKeys' | Select-Object Flags; Get-ItemProperty 'HKCU:\Control Panel\Accessibility\Keyboard Response' | Select-Object Flags; Get-ItemProperty 'HKCU:\Control Panel\Accessibility\ToggleKeys' | Select-Object Flags
```

**プロセス数**

```powershell
(Get-Process | Measure-Object).Count
```

**物理メモリ使用量**

```powershell
$os=Get-CimInstance Win32_OperatingSystem; [PSCustomObject]@{Total_GB=[math]::Round($os.TotalVisibleMemorySize/1MB,2);Used_GB=[math]::Round(($os.TotalVisibleMemorySize-$os.FreePhysicalMemory)/1MB,2);Free_GB=[math]::Round($os.FreePhysicalMemory/1MB,2)}
```

**確認条件:** GUIの最終状態とCUIの値を照合し、プロセス数とメモリ量は測定結果として記録。

## 17. 不採用の設定

マウス加速は変更対象にしません。

### 17.1 マウス加速を変更しない

**確認条件:** 「ポインターの精度を高める」の値を変更しないこと。

**補足:** マウス加速オフは不採用です。ここには変更手順を設けません。

## 18. WinキーとAltキーの左右入れ替え

常駐ソフトウェアを使わず、左右のWinキーとAltキーを入れ替えます。同じレジストリ画面で確認・設定・解除を行います。

### 18.1 Scancode Mapの確認・設定・解除

Windowsのキーボードスキャンコードをレジストリの `Scancode Map`（`REG_BINARY`）で入れ替えます。変更後は再起動が必要です。

**GUI操作**

1.  `Win + R` → `regedit` → Enter（管理者）。
2.  `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout` に移動します。
3.  右ペインの `Scancode Map` の有無と現在の内容を確認します。
4.  設定する場合は、値がなければ「右クリック → 新規 → バイナリ値」で `Scancode Map` を作成し、既に存在すればダブルクリックで編集します。
5.  「数値のデータ」に `00 00 00 00 00 00 00 00 05 00 00 00 38 00 5B E0 5B E0 38 00 38 E0 5C E0 5C E0 38 E0 00 00 00 00` を入力し、「OK」を押します。
6.  設定を解除する場合は `Scancode Map` を右クリック →「削除」→「はい」を選びます。
7.  設定・解除のどちらも Windows を再起動して反映します。

| 操作           | 対象                         | 結果                     |
|----------------|------------------------------|--------------------------|
| 既存設定の確認 | `Scancode Map`               | 登録の有無・値を確認     |
| 設定           | `Scancode Map`（REG_BINARY） | 左Win↔左Alt、右Win↔右Alt |
| 解除           | `Scancode Map` の削除        | 標準配置へ戻す           |

**CUI / PowerShell**

**既存値を表示**

```powershell
reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map"
```

**Win・Altを左右とも入れ替え（管理者）（管理者としてPowerShellを起動）**

```powershell
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d "00000000000000000500000038005BE05BE0380038E05CE05CE038E000000000" /f
```

**Scancode Map削除（管理者）（管理者としてPowerShellを起動）**

```powershell
reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /f
```

**対応レジストリ**

- パス: `HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout` ／ 値名: `Scancode Map` ／ 型: `REG_BINARY`
- 設定値: `00000000000000000500000038005BE05BE0380038E05CE05CE038E000000000`

**確認条件:** 再起動後、設定時には左右それぞれのWinキーとAltキーが入れ替わること。解除時には標準配置になること。

**補足:** 既に別の `Scancode Map` がある場合は上書きになります。解除すると `Scancode Map` 全体を削除するため、その他のキー再配置も削除されます。

## 参考資料・照合元

Windows 11の公式操作資料と26H2の画面資料を参照します。

- [Windows 11 リリース一覧（26H2）](https://learn.microsoft.com/ja-jp/windows/release-health/windows11-release-information)
- [Windows 11 2026年8月UI変更（KB5120998）](https://support.microsoft.com/ja-jp/servicing/os/windows-11/2026/08/kb5120998-windows-11-24h2-25h2-update)
- [26H2実画面：スタートメニュー（FMV 2026-10-14）](https://www.fmworld.net/cs/azbyclub/qanavi/jsp/qacontents.jsp?PID=1711-3727)
- [26H2実画面：ロック画面（FMV 2026-10-14）](https://www.fmworld.net/cs/azbyclub/qanavi/jsp/qacontents.jsp?PID=8211-3490)
- [Microsoft：スタートアップ設定](https://support.microsoft.com/ja-jp/windows/experience/startup-boot/configure-startup-applications-in-windows)
- [Microsoft：視覚効果](https://support.microsoft.com/ja-jp/windows/experience/performance-optimization/tips-to-improve-pc-performance-in-windows)
- [Microsoft：透明効果](https://support.microsoft.com/ja-jp/accessibility/windows/use-color-and-contrast-for-accessibility-in-microsoft-365)
- [Microsoft：電源モード](https://support.microsoft.com/ja-jp/windows/experience/change-the-power-mode-for-your-windows-pc)
- [FMV：電源モードの設定画面と最適なパフォーマンス（2026年）](https://www.fmworld.net/cs/azbyclub/qanavi/jsp/qacontents.jsp?PID=9311-3578)
- [Microsoft：検索インデックス](https://support.microsoft.com/ja-jp/windows/experience/performance-optimization/search-indexing-in-windows)
- [Microsoft：配信の最適化の動作](https://learn.microsoft.com/ja-jp/windows/deployment/do/waas-delivery-optimization-reference)
- [Microsoft：ロック画面](https://support.microsoft.com/ja-jp/windows/experience/personalization/customize-the-lock-screen-in-windows)
- [Microsoft：タスクバー](https://support.microsoft.com/ja-jp/windows/experience/personalization/customize-the-taskbar-in-windows)
- [Microsoft：通知](https://support.microsoft.com/ja-jp/windows/experience/notifications-and-do-not-disturb-in-windows)
- [Microsoft：音声認識・入力とプライバシー](https://support.microsoft.com/ja-jp/windows/privacy/speech-voice-activation-inking-typing-and-privacy)
- [Microsoft：検索のアクセス許可](https://support.microsoft.com/ja-jp/windows/privacy/windows-search-and-privacy)
- [Microsoft：Windowsのアクティビティ履歴とプライバシー](https://support.microsoft.com/ja-jp/windows/privacy/windows-activity-history-and-your-privacy)
- [Microsoft：入力候補](https://support.microsoft.com/ja-jp/accessibility/windows/enable-text-suggestions-in-windows)
- [Microsoft：キーボードアクセシビリティ](https://support.microsoft.com/ja-jp/accessibility/windows/windows-keyboard-shortcuts-for-accessibility)
