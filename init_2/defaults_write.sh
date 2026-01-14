#!/usr/bin/env bash
#
if [ $(uname) != "Darwin" ] ; then
	echo "Not MacOS!"
	exit 0
fi

# .DS_Storeの読み取り無効化 - https://support.apple.com/ja-jp/102064
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool "true"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool "true"
# 日付と時刻のフォーマット
defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm"

# Battery
## バッテリーをパーセント表示にする
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Dock
## Dockからすべてのアプリを消す
defaults write com.apple.dock persistent-apps -array
## Dockのサイズ
defaults write com.apple.dock "tilesize" -int "36"
## 最近起動したアプリを非表示
defaults write com.apple.dock "show-recents" -bool "false"
## アプリをしまうときのアニメーション
defaults write com.apple.dock "mineffect" -string "scale"
## 使用状況に基づいてデスクトップの順番を入れ替え
defaults write com.apple.dock "mru-spaces" -bool "false"

# ScreenCapture
## 画像の影を無効化
defaults write com.apple.screencapture "disable-shadow" -bool "true"
# 保存場所
if [[ ! -d "$HOME/capture" ]]; then
    mkdir -p "$HOME/capture"
fi
defaults write com.apple.screencapture "location" -string "~/capture"
## 撮影時のサムネイル表示
defaults write com.apple.screencapture "show-thumbnail" -bool "true"
## 保存形式
defaults write com.apple.screencapture "type" -string "png"

# Finder
## ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool "true"
## 拡張子まで表示
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
## 隠しファイルを表示
defaults write com.apple.finder AppleShowAllFiles -bool true
## パスバーを表示
defaults write com.apple.finder ShowPathbar -bool "true"
## タイトルをフルパス化
defaults write com.apple.finder _FXShowPosixPathInTitle -boolean "true"
## Finder 警告音を無効化
defaults write com.apple.finder FinderSounds -bool no
## 未確認ファイルを開くときの警告
defaults write com.apple.LaunchServices LSQuarantine -bool "false"
## ゴミ箱を空にするときの警告
defaults write com.apple.finder WarnOnEmptyTrash -bool "true"
## 名前で入れ替えた時、ディレクトリが先頭に来るようにする
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
## クイックルックでテキスト選択可能にする
defaults write com.apple.finder QLEnableTextSelection -bool "true"

# Trackpad
## タップでクリック
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool "true"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool "true"

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
defaults write -g InitialKeyRepeat -int 10
# normal minimum is 2 (30 ms)
defaults write -g KeyRepeat -int 1
# KeyRepeatで連続入力を可能とする
defaults write -g ApplePressAndHoldEnabled -bool false

# 合字非表示
# defaults write -g ApplePressAndHoldEnabled -bool false

# 再起動して設定を反映
echo "Finder,Dock,SystemUIServerを再起動"
killall Finder
killall Dock
killall SystemUIServer
echo "完了"
echo "スクロール方向の変更、IMEの設定は行われてないのでシステム環境設定から行うこと"
echo "完了"
