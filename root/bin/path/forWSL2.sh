[[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]] && export isWSL2=1
if [[ $isWSL2 -eq 1 ]]; then
  # Windows実行ファイル
  alias ipconfig.exe="/mnt/c/Windows/System32/ipconfig.exe"
  alias cmd.exe="/mnt/c/Windows/System32/cmd.exe"
  alias clip.exe="/mnt/c/Windows/System32/clip.exe"
  alias explorer.exe="/mnt/c/Windows/explorer.exe"
  alias open="/mnt/c/Windows/explorer.exe"
  # PATH
  alias cd~="cd $WINUSERPATH"
  export PATH=${WINUSERPATH}/go/bin:$PATH
  export PATH=${WINUSERPATH}/apps:$PATH
  export PATH=/mnt/c/Program\ Files/Docker/Docker/resources/bin:$PATH

  # 関数として環境変数DIAPLAYを更新する処理を定義
  function update_display(){
    LOCAL_IP=$(ipconfig.exe | awk 'BEGIN { RS="\r\n" } /^[A-Z]/ { isWslSection=/WSL/; }; { if (!isWslSection && /IPv4 Address/) { printf $NF; exit; }}')
    export DISPLAY=$LOCAL_IP:0
  }
  update_display
fi
