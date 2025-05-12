#!/bin/bash

# SSH 및 GPG 키 설정 스크립트

echo "🔐 SSH 및 GPG 키 설정을 시작합니다..."

###############################################################################
# SSH 키 생성                                                                  #
###############################################################################

echo "🔑 SSH 키 설정 중..."

SSH_DIR="$HOME/.ssh"
SSH_KEY="$SSH_DIR/id_ed25519"
SSH_CONFIG="$SSH_DIR/config"

# .ssh 디렉토리가 없으면 생성
if [ ! -d "$SSH_DIR" ]; then
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
fi

# SSH 키가 없으면 생성
if [ ! -f "$SSH_KEY" ]; then
  echo "🔑 새로운 SSH 키를 생성합니다..."
  read -p "SSH 키에 사용할 이메일 주소를 입력하세요: " email
  
  # 키 생성 (비대화형 모드)
  ssh-keygen -t ed25519 -C "$email" -f "$SSH_KEY" -N ""
  
  # ssh-agent에 키 추가
  eval "$(ssh-agent -s)"
  ssh-add "$SSH_KEY"
  
  echo "🔑 SSH 키가 생성되었습니다: $SSH_KEY"
  echo "🔑 공개 키:"
  cat "${SSH_KEY}.pub"
  
  echo "🌐 GitHub, GitLab 등의 서비스에 이 공개 키를 등록하세요."
else
  echo "🔑 SSH 키가 이미 존재합니다: $SSH_KEY"
fi

# SSH 기본 설정 파일 생성
if [ ! -f "$SSH_CONFIG" ]; then
  echo "📝 SSH 설정 파일을 생성합니다..."
  cat > "$SSH_CONFIG" << EOL
# SSH 기본 설정

# 기본 옵션
Host *
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 10
    
# GitHub 설정
Host github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    
# 예시: 커스텀 서버
# Host example
#     HostName example.com
#     User username
#     Port 22
#     IdentityFile ~/.ssh/id_ed25519
EOL
  
  chmod 600 "$SSH_CONFIG"
  echo "📝 SSH 설정 파일이 생성되었습니다: $SSH_CONFIG"
else
  echo "📝 SSH 설정 파일이 이미 존재합니다: $SSH_CONFIG"
fi

###############################################################################
# GPG 키 설정 (선택 사항)                                                      #
###############################################################################

# GPG가 설치되어 있는지 확인
if command -v gpg &> /dev/null; then
  echo "🔒 GPG 설정 중..."
  
  # GPG 키가 있는지 확인
  if ! gpg --list-secret-keys | grep -q "sec"; then
    echo "🔒 GPG 키 설정은 수동으로 해야 합니다."
    echo "🔒 GPG 키를 생성하려면 다음 명령어를 실행하세요:"
    echo "🔒 gpg --full-generate-key"
    echo "🔒 생성 후, git config --global user.signingkey YOUR_KEY_ID로 설정하세요."
  else
    echo "🔒 GPG 키가 이미 설정되어 있습니다."
  fi
else
  echo "🔒 GPG가 설치되어 있지 않습니다. brew install gnupg로 설치할 수 있습니다."
fi

echo "✅ SSH 및 GPG 키 설정이 완료되었습니다!"
