## 入力メソッド

* uskeyboard の cmd key で macoOS の eisuu / hiragana での ime 切り替えを再現

#### input method
* off US
* ON mozc
#### global option
* 入力メソッドを切換 c-space, c-`
* 入力メソッドON Right super
* 入力メソッドOFF LEFT super, Escape


## crontab

* firefox devのauto updateなどに利用

```
sudo crontab -e
0 4 * * * /home/aki/dotfiles/KDE/all_update.sh
0 11 * * * /home/aki/dotfiles/KDE/all_update.sh

sudo crontab -l
```
