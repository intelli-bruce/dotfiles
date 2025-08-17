#!/bin/bash

# dotfiles 부트스트랩 스크립트
# 새로운 macOS 환경을 빠르게 설정합니다

# 색상 설정
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
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
${BOLD}${BLUE}╔════════════════════════════════════════╗${RESET}
${BOLD}${BLUE}║     dotfiles 환경 설정 부트스트랩     ║${RESET}
${BOLD}${BLUE}╚════════════════════════════════════════╝${RESET}

이 스크립트는 새로운 macOS 환경을 자동으로 설정합니다.
"

# 현재 디렉토리 확인
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "dotfiles 위치: $DOTFILES_DIR"

# 옵션 파싱
SKIP_INSTALL=false
SKIP_SETUP=false
SKIP_MACOS=false
SKIP_KEYS=false

show_help() {
  echo "
${BOLD}사용법:${RESET}
  ./bootstrap.sh [옵션]

${BOLD}옵션:${RESET}
  ${GREEN}--skip-install${RESET}    프로그램 설치 건너뛰기
  ${GREEN}--skip-setup${RESET}      설정 파일 연결 건너뛰기
  ${GREEN}--skip-macos${RESET}      macOS 설정 건너뛰기
  ${GREEN}--skip-keys${RESET}       키 반복 설정 건너뛰기
  ${GREEN}--help${RESET}            이 도움말 표시

${BOLD}예시:${RESET}
  ./bootstrap.sh                        # 전체 설정 실행
  ./bootstrap.sh --skip-install         # 프로그램 설치 제외
  ./bootstrap.sh --skip-macos --skip-keys  # 시스템 설정 제외
"
}

# 인자 처리
for arg in "$@"; do
  case $arg in
    --skip-install)
      SKIP_INSTALL=true
      ;;
    --skip-setup)
      SKIP_SETUP=true
      ;;
    --skip-macos)
      SKIP_MACOS=true
      ;;
    --skip-keys)
      SKIP_KEYS=true
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    *)
      error "알 수 없는 옵션: $arg"
      show_help
      exit 1
      ;;
  esac
done

# 실행할 작업 요약
echo "${BOLD}실행할 작업:${RESET}"
[[ "$SKIP_INSTALL" == false ]] && echo "  ✓ 프로그램 및 패키지 설치"
[[ "$SKIP_SETUP" == false ]] && echo "  ✓ 설정 파일 연결"
[[ "$SKIP_MACOS" == false ]] && echo "  ✓ macOS 시스템 설정"
[[ "$SKIP_KEYS" == false ]] && echo "  ✓ 키 반복 최적화"
echo

# 시작 전 확인
read -p "계속하시겠습니까? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "설치를 취소합니다."
  exit 0
fi

# 1. 프로그램 설치
if [[ "$SKIP_INSTALL" == false ]]; then
  step "1/4: 프로그램 및 패키지 설치 중..."
  if [ -f "$DOTFILES_DIR/scripts/install.sh" ]; then
    bash "$DOTFILES_DIR/scripts/install.sh"
    success "프로그램 설치 완료"
  else
    error "install.sh를 찾을 수 없습니다"
  fi
else
  echo "${YELLOW}⚠ 프로그램 설치를 건너뜁니다${RESET}"
fi

# 2. 설정 파일 연결
if [[ "$SKIP_SETUP" == false ]]; then
  step "2/4: 설정 파일 연결 중..."
  if [ -f "$DOTFILES_DIR/scripts/setup.sh" ]; then
    bash "$DOTFILES_DIR/scripts/setup.sh"
    success "설정 파일 연결 완료"
  else
    error "setup.sh를 찾을 수 없습니다"
  fi
else
  echo "${YELLOW}⚠ 설정 파일 연결을 건너뜁니다${RESET}"
fi

# 3. macOS 시스템 설정
if [[ "$SKIP_MACOS" == false ]]; then
  step "3/4: macOS 시스템 설정 중..."
  if [ -f "$DOTFILES_DIR/scripts/macos_defaults.sh" ]; then
    bash "$DOTFILES_DIR/scripts/macos_defaults.sh"
    success "macOS 설정 완료"
  else
    warning "macos_defaults.sh를 찾을 수 없습니다"
  fi
else
  echo "${YELLOW}⚠ macOS 설정을 건너뜁니다${RESET}"
fi

# 4. 키 반복 최적화
if [[ "$SKIP_KEYS" == false ]]; then
  step "4/4: 키 반복 설정 최적화 중..."
  if [ -f "$DOTFILES_DIR/scripts/optimize_key_repeat.sh" ]; then
    bash "$DOTFILES_DIR/scripts/optimize_key_repeat.sh"
    success "키 반복 설정 완료"
  else
    warning "optimize_key_repeat.sh를 찾을 수 없습니다"
  fi
else
  echo "${YELLOW}⚠ 키 반복 설정을 건너뜁니다${RESET}"
fi

# 완료 메시지
echo "
${BOLD}${GREEN}╔════════════════════════════════════════╗${RESET}
${BOLD}${GREEN}║        모든 설정이 완료되었습니다!     ║${RESET}
${BOLD}${GREEN}╚════════════════════════════════════════╝${RESET}

${BOLD}다음 단계:${RESET}
1. 새로운 터미널 창을 열어 설정을 적용하세요
2. 필요한 경우 SSH 키를 설정하세요:
   ${BLUE}bash scripts/ssh_setup.sh${RESET}
3. 설정을 동기화하려면:
   ${BLUE}bash scripts/sync.sh${RESET}

${BOLD}유용한 명령어:${RESET}
• 설정 동기화: ${BLUE}scripts/sync.sh [앱이름]${RESET}
• tmux 플러그인 설치: ${BLUE}Ctrl+e I${RESET} (tmux 내에서)
• Powerlevel10k 설정: ${BLUE}p10k configure${RESET}

${BOLD}문제가 발생하면:${RESET}
각 스크립트를 개별적으로 실행하세요:
• ${BLUE}scripts/install.sh${RESET} - 프로그램 설치
• ${BLUE}scripts/setup.sh${RESET} - 설정 파일 연결
• ${BLUE}scripts/macos_defaults.sh${RESET} - macOS 설정
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