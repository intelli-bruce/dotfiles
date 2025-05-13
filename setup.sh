#!/bin/bash

# dotfiles 마스터 설치 스크립트
# 새로운 macOS 환경을 자동으로 설정합니다

# 색상 설정
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
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

# 시작 메시지
echo "
${BOLD}${BLUE}◉ dotfiles 설치를 시작합니다${RESET}
이 스크립트는 새로운 macOS 환경을 설정합니다.
"

# 시작 전 확인
read -p "계속하시겠습니까? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "설치를 취소합니다."
  exit 1
fi

# 현재 디렉토리 기록
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "dotfiles 위치: $DOTFILES_DIR"

# 스크립트에 실행 권한 부여
step "스크립트에 실행 권한 부여 중..."
find "$DOTFILES_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
success "실행 권한 부여 완료"

# 1. Homebrew와 패키지 설치
step "1/3: Homebrew 및 패키지 설치 중..."
bash "$DOTFILES_DIR/scripts/brew_install.sh"
success "Homebrew 및 패키지 설치 완료"

# 2. dotfiles 설정
step "2/3: dotfiles 연결 중..."
bash "$DOTFILES_DIR/install.sh"
success "dotfiles 연결 완료"

# 3. macOS 기본 설정
step "3/4: macOS 시스템 설정 구성 중..."
bash "$DOTFILES_DIR/scripts/macos_defaults.sh"
success "macOS 시스템 설정 구성 완료"

# 4. 키 반복 최적화 설정
step "4/4: 키 반복 설정 최적화 중..."
bash "$DOTFILES_DIR/scripts/optimize_key_repeat.sh"
success "키 반복 설정 최적화 완료"

# 완료 메시지
echo "
${BOLD}${GREEN}✓ 모든 설치가 완료되었습니다!${RESET}

다음 단계:
1. 새로운 터미널 창을 열어 설정을 적용하세요
2. 필요한 경우 SSH 키를 설정하세요 (scripts/ssh_setup.sh)
3. VSCode 또는 필요한 추가 앱을 설정하세요

${BOLD}${BLUE}문제가 발생하면 각 스크립트를 개별적으로 실행하세요:${RESET}
- brew_install.sh: Homebrew 및 패키지 설치
- install.sh: dotfiles 설정
- macos_defaults.sh: macOS 시스템 설정
"

# 재시작 권장
read -p "변경 사항을 완전히 적용하려면 시스템을 재시작하는 것이 좋습니다. 지금 재시작하시겠습니까? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "시스템을 재시작합니다..."
  sudo shutdown -r now
else
  echo "나중에 시스템을 재시작해주세요."
fi