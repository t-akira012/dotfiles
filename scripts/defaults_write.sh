# for macOS

# .DS_Storeを生成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
# 日付と時刻のフォーマット（24時間表示、秒表示あり、日付・曜日を表示）
defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm:ss"
# バッテリーをパーセント表示にする
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Finder
# 名前で入れ替えた時、ディレクトリが先頭に来るようにする
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# 不可視ファイルの表示
defaults write com.apple.finder AppleShowAllFiles true
# Show Status bar in Finder （ステータスバーを表示）
defaults write com.apple.finder ShowStatusBar -bool true 
# Show Path bar in Finder （パスバーを表示）
defaults write com.apple.finder ShowPathbar -bool true 
# Show Tab bar in Finder （タブバーを表示）
defaults write com.apple.finder ShowTabView -bool true
# 全ての拡張子のファイルを表示する
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# クイックルックでテキスト選択可能にする
defaults write com.apple.finder QLEnableTextSelection -bool true


# Dock
# アイコンサイズの設定
defaults write com.apple.dock tilesize -int 35
# Automatically hide or show the Dock （Dock を自動的に隠す）
defaults write com.apple.dock autohide -bool false
# 最近使ったアプリケーションの表示を無効化
defaults write com.apple.dock show-recents -bool false
# Dock に標準で入っている全てのアプリを消す、Finder とごみ箱は消えない
defaults write com.apple.dock persistent-apps -array

# 各種無効化
# ダウンロードしたファイルを初めて開く際に表示される警告ダイアログを無効
defaults write com.apple.LaunchServices LSQuarantine -bool false
# クラッシュリポーター無効
defaults write com.apple.CrashReporter DialogType none 
# キャプチャに影を付けない
defaults write com.apple.screencapture disable-shadow -boolean true
# Mission Controlを無効にする
# defaults write com.apple.dock mcx-expose-disabled -bool true

# アニメーション高速化
# ツールチップ表示までのタイムラグをなくす
defaults write -g NSInitialToolTipDelay -integer 0
# ダイアログ表示やウィンドウリサイズ速度を高速化する
defaults write -g NSWindowResizeTime 0.1
# フォルダを開くときのアニメーション無効
defaults write com.apple.finder AnimateWindowZoom -bool false 
# ファイルを開くときのアニメーション無効
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false 
# Dockが表示されるまでの待ち時間を無効
defaults write com.apple.dock autohide-delay -float 0 
# Dockを自動で隠すまでの待ち時間無効
defaults write com.apple.dock autohide-time-modifier -float 0


# key repeat 高速化
# normal minimum is 15 (225 ms)
defaults write -g InitialKeyRepeat -int 12
# normal minimum is 2 (30 ms)
defaults write -g KeyRepeat -int 1

# 合字非表示
# defaults write -g ApplePressAndHoldEnabled -bool false

# Finder Title を Full path
defaults write com.apple.finder _FXShowPosixPathInTitle -boolean true

# Finder 警告音を無効化
defaults write com.apple.finder FinderSounds -bool no

# 再起動して設定を反映
echo "Finder,Dock,SystemUIServerを再起動"
killall Finder
killall Dock
killall SystemUIServer
echo "完了"
echo "スクロール方向の変更、IMEの設定は行われてないのでシステム環境設定から行うこと"
echo "完了"
