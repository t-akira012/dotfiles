if ! type urxvt 2>&1 >/dev/null;then
    sudo apt update
    sudo apt install -y rxvt-unicode
fi


cat <<_EOF_ >>$HOME/.Xresources
! https://github.com/catppuccin/urxvt
! special
URxvt.background: #24273A
URxvt.foreground: #CAD3F5
URxvt.cursorColor: #F4DBD6

! black
URxvt.color0: #494D64
URxvt.color8: #5B6078

! red
URxvt.color1: #ED8796
URxvt.color9: #ED8796

! green
URxvt.color2: #A6DA95
URxvt.color10: #A6DA95

! yellow
URxvt.color3: #EED49F
URxvt.color11: #EED49F

! blue
URxvt.color4: #8AADF4
URxvt.color12: #8AADF4

! magenta
URxvt.color5: #F5BDE6
URxvt.color13: #F5BDE6

! cyan
URxvt.color6: #8BD5CA
URxvt.color14: #8BD5CA

! white
URxvt.color7: #B8C0E0
URxvt.color15: #A5ADCB

!! URxvt Appearance
URxvt.letterSpace: 0
URxvt.lineSpace: 0
URxvt.geometry: 92x24
URxvt.internalBorder: 24
URxvt.cursorBlink: true
URxvt.cursorUnderline: false
URxvt.saveline: 2048
URxvt.scrollBar: false
URxvt.scrollBar_right: false
URxvt.urgentOnBell: true
URxvt.depth: 24
URxvt.iso14755: false

! font
URxvt.font: xft:DejaVu Sans Mono-10, xft:IPAGothic
_EOF_

xrdb -merge $HOME/.Xresources
