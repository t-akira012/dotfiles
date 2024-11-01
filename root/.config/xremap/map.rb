# vim:fenc=utf-8 ff=unix ft=ruby ts=2 sw=2 sts=2
# https://github.com/hachibeeDI/dotfiles/blob/master/.xremap.conf

# 効かないので alacritty.toml 側で制御
# window class_only: 'Alacritty' do
#   remap 'Super-v', to: 'C-Shift-v'
# end

# mac likeにする
#
remap 'CAPSLOCK', to: 'ZENKAKUHANKAKU'
window class_only: ['Alacritty', 'konsole'] do
  remap 'Super-Equal', to: 'Ctrl-Equal'
  remap 'Super-Minus', to: 'Ctrl-Minus'

  remap 'Ctrl-Equal', to: 'Super-Equal'
  remap 'Ctrl-Minus', to: 'Super-Minus'

  remap 'Super-0', to: 'Ctrl-0'
end

window class_only: ['google-chrome', 'firefox', 'firefox-aurora', 'skype', 'slack', 'dolphin'] do
  remap 'C-b', to: 'Left'
  remap 'C-f', to: 'Right'
  remap 'C-p', to: 'Up'
  remap 'C-n', to: 'Down'
  remap 'C-a', to: 'Home'
  remap 'C-e', to: 'End'

  remap 'C-k', to: ['Shift-End', 'Ctrl-C', 'BackSpace']
  remap 'C-u', to: ['Shift-Home', 'BackSpace']
  remap 'C-y', to: 'Shift-Insert'

  remap 'C-h', to: 'BackSpace'
  remap 'C-d', to: 'Delete'
  remap 'C-m', to: 'Enter'

  remap 'C-w', to: 'Ctrl-BackSpace'

  %w[a c f l n r v p w t x z y t h].each do |key|
    remap "Super-#{key}", to: "C-#{key}"
  end
  %w[n t r z].each do |key|
    remap "Super-Shift-#{key}", to: "C-#{key}"
  end

  # 0..9 をタブ移動にする / off
  # (0..9).each do |key|
  #   remap "Super-#{key}", to: "C-#{key}"
  # end

  remap 'Super-Enter', to: 'M-Enter'
  remap 'Super-Ctrl-Enter', to: 'Super-Ctrl-Enter'
  remap 'Super-Equal', to: 'Ctrl-Equal'
  remap 'Super-Minus', to: 'Ctrl-Minus'

  remap 'Super-Shift-t', to: 'Shift-Ctrl-t'
end

window class_only: 'slack' do
  remap 'Super-k', to: 'Ctrl-k'

  remap 'Super-k', to: 'Alt-Up'
  remap 'Super-j', to: 'Alt-Down'

  remap 'Super-Shift-k', to: 'Alt-Shift-Up'
  remap 'Super-Shift-j', to: 'Alt-Shift-Down'
end
