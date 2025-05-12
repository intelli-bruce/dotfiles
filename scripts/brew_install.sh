#!/bin/bash

# Homebrew 설치 및 패키지 관리 스크립트

echo "🍺 Homebrew 설치 확인 중..."

# Homebrew가 설치되어 있는지 확인
if ! command -v brew &> /dev/null; then
  echo "🍺 Homebrew가 설치되어 있지 않습니다. 설치를 시작합니다..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Homebrew PATH 설정 (zsh 기준)
  if [[ $(uname -m) == 'arm64' ]]; then
    # M1/M2 Mac
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    # Intel Mac
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  
  echo "🍺 Homebrew 설치 완료!"
else
  echo "🍺 Homebrew가 이미 설치되어 있습니다."
fi

echo "🔄 Homebrew 업데이트 중..."
brew update

echo "📦 Brewfile에서 패키지 설치 중..."
DOTFILES_DIR="$HOME/dotfiles"
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "🧹 Homebrew 정리 중..."
brew cleanup

echo "✅ Homebrew 설정 완료!"