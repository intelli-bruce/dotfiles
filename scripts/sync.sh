#!/bin/bash

# dotfiles 설정 동기화 스크립트
# 시스템의 설정 파일을 dotfiles 저장소로 복사합니다

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

# 함수 정의: 경고 메시지
warning() {
  echo "${BOLD}${YELLOW}⚠ $1${RESET}"
}

# 함수 정의: 에러 메시지
error() {
  echo "${BOLD}${RED}✗ $1${RESET}"
}

# 함수 정의: 파일 동기화
sync_file() {
  local source="$1"
  local dest="$2"
  local name="$3"
  
  if [ -f "$source" ] || [ -d "$source" ]; then
    if [ -f "$source" ]; then
      cp "$source" "$dest"
    else
      cp -r "$source" "$dest"
    fi
    success "$name 동기화 완료"
  else
    warning "$name 파일이 존재하지 않습니다: $source"
  fi
}

# 현재 디렉토리 확인
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

# 동기화 함수들
sync_karabiner() {
  step "Karabiner 설정 동기화 중..."
  sync_file "$HOME/.config/karabiner/karabiner.json" \
            "$DOTFILES_DIR/karabiner/karabiner.json" \
            "Karabiner 설정"
  
  # Complex modifications 동기화
  if [ -d "$HOME/.config/karabiner/assets/complex_modifications" ]; then
    for file in "$HOME/.config/karabiner/assets/complex_modifications"/*.json; do
      if [ -f "$file" ]; then
        filename=$(basename "$file")
        sync_file "$file" \
                  "$DOTFILES_DIR/karabiner/$filename" \
                  "Karabiner complex modification: $filename"
      fi
    done
  fi
}

sync_rectangle() {
  step "Rectangle 설정 동기화 중..."
  sync_file "$HOME/Library/Application Support/Rectangle/RectangleConfig.json" \
            "$DOTFILES_DIR/rectangle/RectangleConfig.json" \
            "Rectangle 설정"
}

sync_wezterm() {
  step "WezTerm 설정 동기화 중..."
  sync_file "$HOME/.wezterm.lua" \
            "$DOTFILES_DIR/wezterm/wezterm.lua" \
            "WezTerm 설정"
}

sync_neovim() {
  step "Neovim 설정 동기화 중..."
  sync_file "$HOME/.config/nvim/init.lua" \
            "$DOTFILES_DIR/nvim/init.lua" \
            "Neovim init.lua"
  
  if [ -f "$HOME/.config/nvim/lua/dracula-colorful.lua" ]; then
    sync_file "$HOME/.config/nvim/lua/dracula-colorful.lua" \
              "$DOTFILES_DIR/nvim/lua/dracula-colorful.lua" \
              "Neovim Dracula theme"
  fi
}

sync_tmux() {
  step "tmux 설정 동기화 중..."
  sync_file "$HOME/.tmux.conf" \
            "$DOTFILES_DIR/tmux/tmux.conf" \
            "tmux 설정"
}

sync_yazi() {
  step "Yazi 설정 동기화 중..."
  sync_file "$HOME/.config/yazi/keymap.toml" \
            "$DOTFILES_DIR/yazi/keymap.toml" \
            "Yazi keymap"
  
  sync_file "$HOME/.config/yazi/yazi.toml" \
            "$DOTFILES_DIR/yazi/yazi.toml" \
            "Yazi 설정"
}

sync_aerospace() {
  step "Aerospace 설정 동기화 중..."
  sync_file "$HOME/.config/aerospace/aerospace.toml" \
            "$DOTFILES_DIR/aerospace/aerospace.toml" \
            "Aerospace 설정"
}

sync_lazygit() {
  step "Lazygit 설정 동기화 중..."
  sync_file "$HOME/Library/Application Support/lazygit/config.yml" \
            "$DOTFILES_DIR/lazygit/config.yml" \
            "Lazygit 설정"
}

sync_hammerspoon() {
  step "Hammerspoon 설정 동기화 중..."
  sync_file "$HOME/.hammerspoon/init.lua" \
            "$DOTFILES_DIR/hammerspoon/init.lua" \
            "Hammerspoon 설정"
}

sync_claude() {
  step "Claude 설정 동기화 중..."
  sync_file "$HOME/.claude/CLAUDE.md" \
            "$DOTFILES_DIR/claude/CLAUDE.md" \
            "Claude 지침"
  
  sync_file "$HOME/.claude/settings.json" \
            "$DOTFILES_DIR/claude/settings.json" \
            "Claude 설정"
  
  sync_file "$HOME/.claude/statusline-command.sh" \
            "$DOTFILES_DIR/claude/statusline-command.sh" \
            "Claude 상태바 스크립트"
}

sync_zsh() {
  step "Zsh 설정 동기화 중..."
  sync_file "$HOME/.zshrc" \
            "$DOTFILES_DIR/zsh/zshrc" \
            "Zsh 설정"
  
  sync_file "$HOME/.zprofile" \
            "$DOTFILES_DIR/zsh/zprofile" \
            "Zsh profile"
  
  if [ -f "$HOME/.p10k.zsh" ]; then
    sync_file "$HOME/.p10k.zsh" \
              "$DOTFILES_DIR/zsh/p10k.zsh" \
              "Powerlevel10k 설정"
  fi
}

sync_all() {
  sync_karabiner
  sync_rectangle
  sync_wezterm
  sync_neovim
  sync_tmux
  sync_yazi
  sync_aerospace
  sync_lazygit
  sync_hammerspoon
  sync_claude
  sync_zsh
}

show_git_status() {
  step "Git 상태 확인 중..."
  cd "$DOTFILES_DIR"
  if git diff --quiet; then
    success "변경사항이 없습니다"
  else
    echo "${BOLD}${YELLOW}변경된 파일:${RESET}"
    git status --short
    echo
    echo "${BOLD}${BLUE}변경사항을 확인하려면:${RESET}"
    echo "  cd $DOTFILES_DIR"
    echo "  git diff"
    echo
    echo "${BOLD}${BLUE}변경사항을 커밋하려면:${RESET}"
    echo "  git add ."
    echo "  git commit -m \"설정 동기화: $(date +%Y-%m-%d)\""
  fi
}

show_help() {
  echo "
${BOLD}${BLUE}◉ dotfiles 설정 동기화 스크립트${RESET}

${BOLD}사용법:${RESET}
  ./sync.sh [옵션]

${BOLD}옵션:${RESET}
  ${GREEN}all${RESET}           모든 설정 동기화 (기본값)
  ${GREEN}karabiner${RESET}     Karabiner 설정만 동기화
  ${GREEN}rectangle${RESET}     Rectangle 설정만 동기화
  ${GREEN}wezterm${RESET}       WezTerm 설정만 동기화
  ${GREEN}neovim${RESET}        Neovim 설정만 동기화
  ${GREEN}tmux${RESET}          tmux 설정만 동기화
  ${GREEN}yazi${RESET}          Yazi 설정만 동기화
  ${GREEN}aerospace${RESET}     Aerospace 설정만 동기화
  ${GREEN}lazygit${RESET}       Lazygit 설정만 동기화
  ${GREEN}hammerspoon${RESET}   Hammerspoon 설정만 동기화
  ${GREEN}claude${RESET}        Claude 설정만 동기화
  ${GREEN}zsh${RESET}           Zsh 설정만 동기화
  ${GREEN}help${RESET}          이 도움말 표시

${BOLD}예시:${RESET}
  ./sync.sh                 # 모든 설정 동기화
  ./sync.sh karabiner       # Karabiner만 동기화
  ./sync.sh karabiner tmux  # 여러 개 동기화

${BOLD}${YELLOW}주의사항:${RESET}
- 이 스크립트는 시스템 → dotfiles 방향으로만 동기화합니다
- dotfiles → 시스템 동기화는 ${BOLD}setup.sh${RESET}를 사용하세요
"
}

# 메인 로직
if [ $# -eq 0 ] || [ "$1" = "all" ]; then
  # 인자가 없거나 all인 경우 전체 동기화
  echo "
${BOLD}${BLUE}◉ dotfiles 설정 동기화를 시작합니다${RESET}
모든 설정 파일을 dotfiles 저장소로 복사합니다.
"
  echo "dotfiles 위치: $DOTFILES_DIR"
  sync_all
elif [ "$1" = "help" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  show_help
  exit 0
else
  # 특정 항목만 동기화
  echo "
${BOLD}${BLUE}◉ dotfiles 선택적 동기화를 시작합니다${RESET}
선택한 설정 파일만 dotfiles 저장소로 복사합니다.
"
  echo "dotfiles 위치: $DOTFILES_DIR"
  
  for arg in "$@"; do
    case "$arg" in
      karabiner)
        sync_karabiner
        ;;
      rectangle)
        sync_rectangle
        ;;
      wezterm)
        sync_wezterm
        ;;
      neovim|nvim|vim)
        sync_neovim
        ;;
      tmux)
        sync_tmux
        ;;
      yazi)
        sync_yazi
        ;;
      aerospace)
        sync_aerospace
        ;;
      lazygit)
        sync_lazygit
        ;;
      hammerspoon)
        sync_hammerspoon
        ;;
      claude)
        sync_claude
        ;;
      zsh)
        sync_zsh
        ;;
      *)
        error "알 수 없는 옵션: $arg"
        echo "사용 가능한 옵션을 보려면 './sync.sh help'를 실행하세요"
        ;;
    esac
  done
fi

# Git 상태 표시
show_git_status

# 완료 메시지
echo "
${BOLD}${GREEN}✓ 설정 동기화가 완료되었습니다!${RESET}
"