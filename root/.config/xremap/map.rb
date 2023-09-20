# vim:fenc=utf-8 ff=unix ft=ruby ts=2 sw=2 sts=2
# https://github.com/hachibeeDI/dotfiles/blob/master/.xremap.conf
# C-k, C-u, C-y は gnome tweak に任せる

window class_not: ['urxvt', 'gnome-terminal-server', 'Alacritty'] do
  remap 'C-b', to: 'Left'
  remap 'C-f', to: 'Right'
  remap 'C-p', to: 'Up'
  remap 'C-n', to: 'Down'

  remap 'M-b', to: 'Ctrl-Left'
  remap 'M-f', to: 'Ctrl-Right'

  remap 'C-a', to: 'Home'
  remap 'C-e', to: 'End'

  # remap 'C-k', to: ['Shift-End', 'BackSpace']
  # remap 'C-u', to: ['Shift-Home', 'BackSpace']
  remap 'C-y', to: 'Shift-Insert'

  remap 'C-h', to: 'BackSpace'
  # remap 'C-d', to: 'Delete'

  remap 'M-h', to: 'Ctrl-BackSpace'
  remap 'C-w', to: 'Ctrl-BackSpace'
  remap 'M-d', to: 'Ctrl-Delete'

  %w[a c f l n r v p w t x z].each do |key|
    remap "Super-#{key}", to: "C-#{key}"
  end
  %w[n t r z].each do |key|
    remap "Super-Shift-#{key}", to: "C-#{key}"
  end

  # remap "Super-Tab-z", to: "C-Tab-z"
end


window class_only: ['urxvt', 'xfce4-terminal', 'Alacritty', 'gnome-terminal-server'] do
  remap 'Super-c', to: 'Ctrl-Shift-c'
  remap 'Super-v', to: 'Ctrl-Shift-v'
end


window class_only: ['google-chrome', 'vivaldi-stable', 'firefox-aurora'] do
  (0..9).each do |key|
    remap "Super-#{key}", to: "C-#{key}"
  end

  remap 'Super-Enter', to: 'M-Enter'
  remap "C-q", to: "C-w"
  remap "Super-q", to: "Super-w"
end


window class_only: 'slack' do
  remap 'Super-k', to: 'Ctrl-k'

  remap 'Super-k', to: 'Alt-Up'
  remap 'Super-j', to: 'Alt-Down'

  remap 'Super-Shift-k', to: 'Alt-Shift-Up'
  remap 'Super-Shift-j', to: 'Alt-Shift-Down'
end
