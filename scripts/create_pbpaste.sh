#!/usr/bin/env bash
# 
# pbpaste を、macOS -> SSH -> Linux で再現する
# 設定方法
#  1. macOS 端末に Linux 端末で ssh 接続可能にする
#  2. このファイルで /usr/local/bin/pbpaste を作る
#  3. ssh接続 で pbpaste を再現する
read -p "port番号は？" 'PORT'
read -p "ユーザー名は？" 'USER_NAME'
read -p "SSHファイル名は？" 'SSH_NAME'
cat | sudo tee /usr/local/bin/pbpaste <<EOF
#!/usr/bin/env bash
MAC_IP=\$(echo \$SSH_CLIENT | cut -d' ' -f1)
ssh -p ${PORT} -i ~/.ssh/${SSH_NAME} ${USER_NAME}@\${MAC_IP} pbpaste
EOF

sudo chmod +x /usr/local/bin/pbpaste
