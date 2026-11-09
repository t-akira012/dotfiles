# Windows 11 軽量化・高速操作環境構築手順書

Intel N100 · RAM 16GB · Win32 GUI / 事務処理

2026-11-07

WindowsのGUIとドライバ互換性を維持しながら、不要な常駐処理、視覚効果、検索インデックス、入力補助を削減します。

## 1. 基本方針

対象はIntel N100、RAM 16GB、Windows 11、Win32 APIネイティブGUIと事務処理です。Windows Update、Defender、Firewall、USB・ネットワーク・ドライバ基盤、SysMain、ページファイルを維持し、不要な常駐・装飾・検索インデックス・入力補助を削減します。

## 2. スタートアップをすべてOFF

GUI: Ctrl + Shift + Esc → スタートアップ アプリ → 全項目を「無効」。または 設定 → アプリ → スタートアップ → すべてOFF。サービスの自動起動とは別です。

## 3. 視覚効果と透明効果

GUI: Win + R → SystemPropertiesPerformance.exe → 視覚効果 →「パフォーマンスを優先する」。必要なら「スクリーン フォントの縁を滑らかにする」のみON。設定 → 個人用設定 → 色 → 透明効果をOFF。

## 4. 電源モード

GUI: 設定 → システム → 電源（または電源とバッテリー）→ 電源モードを変更。実際に選択した値は未記録です。最適なパフォーマンスは応答性能優先ですが、発熱・消費電力が増える場合があります。

## 5. 検索インデックスとWindows Search

GUI: 設定 → プライバシーとセキュリティ → Windowsの検索 →「クラシック」、`C:\` を除外。Win + R → services.msc → Windows Search → 停止・スタートアップの種類「無効」。Windows Search停止によりインデックスに依存する検索は制約を受けます。

## 6. 不要アプリの削除

GUI: 設定 → アプリ → インストールされているアプリ。OneDrive、Xbox関連アプリ、その他不要なプリインストールアプリをアンインストール済み。TeamsやCopilotは不使用なら削除候補ですが、個別削除の実施は未確認です。

## 7. グループポリシー

Win + R → gpedit.msc。コンピューターの構成 → 管理用テンプレート → Windows コンポーネント → ウィジェット →「ウィジェットを許可する」=無効。同 → OneDrive →「OneDriveをファイル記憶域として使用できないようにする」=有効。同 → 配信の最適化 →「ダウンロード モード」=有効、HTTPのみ（0）。Windows 11 Pro等で使用できます。

## 8. 不要サービス

Win + R → services.msc。Fax (Fax)、Downloaded Maps Manager (MapsBroker)、Windows Biometric Service (WbioSrvc)、Geolocation Service (lfsvc)、Windows Search (WSearch) を停止し、スタートアップの種類を「無効」。存在しないサービスは対象外。

## 9. プライバシー

設定 → プライバシーとセキュリティ → アクティビティの履歴、音声認識、デバイスの検索、手書き入力と入力の個人用設定、検索アクセス許可の表示項目をすべてOFF。Windowsのビルドにより表示名は異なります。

## 10. 個人用設定

設定 → 個人用設定 → 背景: 単色。ロック画面: 単色画像、Spotlight・状態表示・ウィジェット・追加コンテンツをOFF。スタート: 追加・おすすめ表示をすべてOFF。タスクバー項目: すべてOFF、システムトレイアイコン: すべてON。

## 11. 通知・ヒント

設定 → システム → 通知 → 通知OFF。追加の設定 → Windowsウェルカムエクスペリエンス、Windows活用提案、ヒント・おすすめをOFF。

## 12. キーボードリピート最高速

GUI: Win + R → control keyboard → 速度 → 表示までの待ち時間「最短」、表示の間隔「最速」。KeyboardDelay=0、KeyboardSpeed=31。長押し時のリピート速度であり単発キーの入力遅延は変更しません。

## 13. アクセシビリティの入力補助

設定 → アクセシビリティ → キーボード → 固定キー、フィルターキー、切り替えキーをOFF。それぞれの有効化ショートカットもOFF。対応するレジストリFlagsは順に506、122、58。

## 14. 入力候補・スペルチェック

設定 → 時刻と言語 → 入力 → 物理キーボードのテキスト候補、多言語候補、自動修正、スペルミスの強調表示をOFF。Microsoft IMEの独立した変換設定は別管理です。

## 15. メニュー表示遅延

MenuShowDelay=0 に設定。反映後、メニュー表示の設定上の待ち時間が0msになります。

## 16. 反映と検証

グループポリシーの反映には gpupdate /force を使えます。レジストリの操作系設定はサインアウト・再サインイン、サービス設定は再起動後に確認します。

## 17. 不採用の設定

マウス加速の無効化は採用しません。マウス加速の既存設定を維持します。

## 18. WinキーとAltキーの恒久的な入れ替え

レジストリの HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout にある Scancode Map を使い、左Win ↔ 左Alt、右Win ↔ 右Altを常時入れ替えます。ログイン画面を含むOS全体に適用され、常駐プログラム・追加のCPU/RAM消費は不要です。内蔵・USBキーボード共通です。

手順: ①管理者としてPowerShellを起動 ②下記コマンド集でScancode Mapの既存設定を確認 ③「Win・Altキーを左右とも入れ替え」を1行のまま実行 ④Windowsを再起動して反映を確認。既存のScancode Mapがある場合は上書きされます。解除時は該当レジストリ値を削除して再起動します。以前から別のキー再配置を使っていた場合、削除ではその設定は復元されません。

## PowerShellコマンド集

各コマンドは1行のまま掲載しています。

### Windows Searchの停止（管理者）

```powershell
Stop-Service -Name WSearch -Force; Set-Service -Name WSearch -StartupType Disabled
```

### Windows Searchの状態確認

```powershell
Get-Service WSearch | Select-Object Name,Status,StartType
```

### サービス5件停止・無効化（管理者）

```powershell
'Fax','MapsBroker','WbioSrvc','lfsvc','WSearch' | ForEach-Object { $s=Get-Service -Name $_ -ErrorAction SilentlyContinue; if($s){ Stop-Service -Name $_ -Force -ErrorAction SilentlyContinue; Set-Service -Name $_ -StartupType Disabled } }
```

### サービス状態確認

```powershell
'Fax','MapsBroker','WbioSrvc','lfsvc','WSearch' | ForEach-Object { Get-Service -Name $_ -ErrorAction SilentlyContinue } | Select-Object Name,Status,StartType
```

### ポリシー反映

```powershell
gpupdate /force
```

### キーボード最高速化

```powershell
Set-ItemProperty 'HKCU:\Control Panel\Keyboard' -Name KeyboardDelay -Value '0'; Set-ItemProperty 'HKCU:\Control Panel\Keyboard' -Name KeyboardSpeed -Value '31'
```

### 固定キー・フィルターキー・切り替えキー無効化

```powershell
Set-ItemProperty 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name Flags -Value '506'; Set-ItemProperty 'HKCU:\Control Panel\Accessibility\Keyboard Response' -Name Flags -Value '122'; Set-ItemProperty 'HKCU:\Control Panel\Accessibility\ToggleKeys' -Name Flags -Value '58'
```

### 入力候補・自動補正無効化

```powershell
$p='HKCU:\Software\Microsoft\Input\Settings'; New-Item -Path $p -Force | Out-Null; Set-ItemProperty -Path $p -Name EnableHwkbTextPrediction -Type DWord -Value 0; Set-ItemProperty -Path $p -Name MultilingualEnabled -Type DWord -Value 0; Set-ItemProperty -Path $p -Name EnableAutocorrection -Type DWord -Value 0; $q='HKCU:\Software\Microsoft\TabletTip\1.7'; New-Item -Path $q -Force | Out-Null; Set-ItemProperty -Path $q -Name EnableAutocorrection -Type DWord -Value 0; Set-ItemProperty -Path $q -Name EnableSpellchecking -Type DWord -Value 0
```

### メニュー表示遅延ゼロ

```powershell
Set-ItemProperty 'HKCU:\Control Panel\Desktop' -Name MenuShowDelay -Value '0'
```

### 操作設定確認

```powershell
Get-ItemProperty 'HKCU:\Control Panel\Keyboard' | Select-Object KeyboardDelay,KeyboardSpeed; Get-ItemProperty 'HKCU:\Control Panel\Desktop' | Select-Object MenuShowDelay; Get-ItemProperty 'HKCU:\Control Panel\Accessibility\StickyKeys' | Select-Object Flags; Get-ItemProperty 'HKCU:\Control Panel\Accessibility\Keyboard Response' | Select-Object Flags; Get-ItemProperty 'HKCU:\Control Panel\Accessibility\ToggleKeys' | Select-Object Flags
```

### プロセス数

```powershell
(Get-Process | Measure-Object).Count
```

### メモリ使用量

```powershell
$os=Get-CimInstance Win32_OperatingSystem; [PSCustomObject]@{Total_GB=[math]::Round($os.TotalVisibleMemorySize/1MB,2);Used_GB=[math]::Round(($os.TotalVisibleMemorySize-$os.FreePhysicalMemory)/1MB,2);Free_GB=[math]::Round($os.FreePhysicalMemory/1MB,2)}
```

### Win・Alt入れ替え前の既存設定確認

```powershell
reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map"
```

### Win・Altキーを左右とも入れ替え（管理者）

```powershell
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d "00000000000000000500000038005BE05BE0380038E05CE05CE038E000000000" /f
```

### Win・Altキーの入れ替え解除（管理者）

```powershell
reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /f
```

## 維持・不採用

Windows Update / Defender / Firewall / Windows Driver Foundation / USB・ネットワーク基盤 / Event Log / Task Scheduler / SysMain / ページファイルを維持します。

**マウス加速OFFは不採用です。**
