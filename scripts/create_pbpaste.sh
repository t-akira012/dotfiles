#!/usr/bin/env bash
read -p "port番号は？" 'PORT'
read -p "ユーザー名は？" 'USER_NAME'
read -p "SSHファイル名は？" 'SSH_NAME'
cat | sudo tee /usr/local/bin/pbpaste <<EOF
#!/usr/bin/env bash
MAC_IP=\$(echo \$SSH_CLIENT | cut -d' ' -f1)
ssh -p ${PORT} -i ~/.ssh/${SSH_NAME} ${USER_NAME}@\${MAC_IP} pbpaste
EOF

sudo chmod +x /usr/local/bin/pbpaste
