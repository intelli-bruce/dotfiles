#!/bin/bash

# dotfiles 프로그램 설치 스크립트
# 필요한 프로그램과 패키지를 설치합니다

# 색상 설정
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# 함수 정의: 단계 표시
step() {
  echo
  echo "${BOLD}${BLUE}▶ $1${RESET}"
  echo
}

# 함수 정의: 완료 메시지
success() {
  echo "${BOLD}${GREEN}✓ $1${RESET}"
}

# 함수 정의: 에러 메시지
error() {
  echo "${BOLD}${RED}✗ $1${RESET}"
}

# 시작 메시지
echo "
${BOLD}${BLUE}◉ dotfiles 프로그램 설치를 시작합니다${RESET}
필요한 프로그램과 패키지를 설치합니다.
"

# 현재 디렉토리 확인
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "dotfiles 위치: $DOTFILES_DIR"

# 1. Homebrew 설치
step "Homebrew 설치 확인 중..."
if ! command -v brew &> /dev/null; then
  echo "Homebrew가 설치되어 있지 않습니다. 설치를 시작합니다..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Homebrew PATH 설정
  if [[ $(uname -m) == 'arm64' ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  success "Homebrew 설치 완료"
else
  success "Homebrew가 이미 설치되어 있습니다"
fi

# 2. Homebrew 패키지 설치
step "Homebrew 패키지 설치 중..."
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
  brew update
  brew bundle --file="$DOTFILES_DIR/Brewfile"
  brew cleanup
  success "Homebrew 패키지 설치 완료"
else
  error "Brewfile을 찾을 수 없습니다"
fi

# 3. Oh My Zsh 설치
step "Oh My Zsh 설치 중..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  success "Oh My Zsh 설치 완료"
else
  success "Oh My Zsh가 이미 설치되어 있습니다"
fi

# 4. Powerlevel10k 테마 설치
step "Powerlevel10k 테마 설치 중..."
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  success "Powerlevel10k 설치 완료"
else
  success "Powerlevel10k가 이미 설치되어 있습니다"
fi

# 5. Zsh 플러그인 설치
step "Zsh 플러그인 설치 중..."

# zsh-autosuggestions
ZSH_AUTOSUGGESTIONS="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$ZSH_AUTOSUGGESTIONS" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGESTIONS"
  success "zsh-autosuggestions 설치 완료"
else
  success "zsh-autosuggestions가 이미 설치되어 있습니다"
fi

# zsh-syntax-highlighting
ZSH_SYNTAX="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ ! -d "$ZSH_SYNTAX" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX"
  success "zsh-syntax-highlighting 설치 완료"
else
  success "zsh-syntax-highlighting이 이미 설치되어 있습니다"
fi

# 6. Yazi 플러그인 설치
step "Yazi 플러그인 설치 중..."
mkdir -p "$HOME/.config/yazi/plugins"

# lazygit.yazi
YAZI_LAZYGIT="$HOME/.config/yazi/plugins/lazygit.yazi"
if [ ! -d "$YAZI_LAZYGIT" ]; then
  git clone https://github.com/Lil-Dank/lazygit.yazi.git "$YAZI_LAZYGIT"
  success "lazygit.yazi 설치 완료"
else
  success "lazygit.yazi가 이미 설치되어 있습니다"
fi

# 완료 메시지
echo "
${BOLD}${GREEN}✓ 모든 프로그램 설치가 완료되었습니다!${RESET}

다음 단계:
1. ${BOLD}./setup.sh${RESET}를 실행하여 설정 파일을 연결하세요
2. 새로운 터미널을 열어 설정을 적용하세요

필요한 추가 스크립트:
- ${BOLD}scripts/macos_defaults.sh${RESET}: macOS 시스템 설정
- ${BOLD}scripts/optimize_key_repeat.sh${RESET}: 키 반복 최적화
"