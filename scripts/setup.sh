#!/bin/bash

# dotfiles 설정 연결 스크립트
# 설정 파일들을 심볼릭 링크로 연결하고 환경을 구성합니다

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

# 시작 메시지
echo "
${BOLD}${BLUE}◉ dotfiles 설정 연결을 시작합니다${RESET}
설정 파일들을 심볼릭 링크로 연결합니다.
"

# 현재 디렉토리 확인
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="$(dirname "$SCRIPTS_DIR")"
echo "dotfiles 위치: $DOTFILES_DIR"

# 1. WezTerm 설정
step "WezTerm 설정 연결 중..."
ln -sf "$DOTFILES_DIR/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
success "WezTerm 설정 연결 완료"

# 2. Neovim 설정
step "Neovim 설정 연결 중..."
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/nvim/lua"
ln -sf "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
ln -sf "$DOTFILES_DIR/nvim/lua/dracula-colorful.lua" "$HOME/.config/nvim/lua/dracula-colorful.lua"
success "Neovim 설정 연결 완료"

# 3. Karabiner 설정
step "Karabiner 설정 연결 중..."
# Karabiner가 실행 중이면 종료
killall Karabiner-Elements 2>/dev/null || true
killall karabiner_console_user_server 2>/dev/null || true
sleep 1

mkdir -p "$HOME/.config/karabiner"
mkdir -p "$HOME/.config/karabiner/assets/complex_modifications"

# 기존 파일이 심볼릭 링크가 아니면 삭제
if [ -f "$HOME/.config/karabiner/karabiner.json" ] && [ ! -L "$HOME/.config/karabiner/karabiner.json" ]; then
  rm -f "$HOME/.config/karabiner/karabiner.json"
fi

ln -sf "$DOTFILES_DIR/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
ln -sf "$DOTFILES_DIR/karabiner/korean-ime-fix.json" "$HOME/.config/karabiner/assets/complex_modifications/korean-ime-fix.json"
success "Karabiner 설정 연결 완료"

# 4. Rectangle 설정
step "Rectangle 설정 연결 중..."
mkdir -p "$HOME/Library/Application Support/Rectangle"
ln -sf "$DOTFILES_DIR/rectangle/RectangleConfig.json" "$HOME/Library/Application Support/Rectangle/RectangleConfig.json"
success "Rectangle 설정 연결 완료"

# 5. tmux 설정
step "tmux 설정 연결 중..."
mkdir -p "$HOME/.config/tmux"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
success "tmux 설정 연결 완료"

# 6. Yazi 설정
step "Yazi 설정 연결 중..."
mkdir -p "$HOME/.config/yazi"
ln -sf "$DOTFILES_DIR/yazi/keymap.toml" "$HOME/.config/yazi/keymap.toml"
ln -sf "$DOTFILES_DIR/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
success "Yazi 설정 연결 완료"

# 7. Aerospace 설정
step "Aerospace 설정 연결 중..."
mkdir -p "$HOME/.config/aerospace"
ln -sf "$DOTFILES_DIR/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
success "Aerospace 설정 연결 완료"

# 8. Lazygit 설정
step "Lazygit 설정 연결 중..."
mkdir -p "$HOME/Library/Application Support/lazygit"
ln -sf "$DOTFILES_DIR/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"
success "Lazygit 설정 연결 완료"

# 9. Hammerspoon 설정
step "Hammerspoon 설정 연결 중..."
mkdir -p "$HOME/.hammerspoon"
ln -sf "$DOTFILES_DIR/hammerspoon/init.lua" "$HOME/.hammerspoon/init.lua"
success "Hammerspoon 설정 연결 완료"

# 10. Claude 설정
step "Claude 설정 연결 중..."
mkdir -p "$HOME/.claude"
ln -sf "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
ln -sf "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
ln -sf "$DOTFILES_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
chmod +x "$DOTFILES_DIR/claude/statusline-command.sh"
success "Claude 설정 연결 완료"

# 11. Zsh 설정
step "Zsh 설정 연결 중..."
ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"
if [ -f "$DOTFILES_DIR/zsh/p10k.zsh" ]; then
  ln -sf "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"
fi
success "Zsh 설정 연결 완료"

# 12. LaunchAgent 설정
step "LaunchAgent 설정 중..."
mkdir -p "$HOME/Library/LaunchAgents"
ln -sf "$DOTFILES_DIR/launchd/com.tmux.start.plist" "$HOME/Library/LaunchAgents/com.tmux.start.plist"
launchctl unload "$HOME/Library/LaunchAgents/com.tmux.start.plist" 2>/dev/null || true
launchctl load "$HOME/Library/LaunchAgents/com.tmux.start.plist"
success "LaunchAgent 설정 완료"

# 13. 스크립트 실행 권한 설정
step "스크립트 실행 권한 설정 중..."
find "$SCRIPTS_DIR" -type f -name "*.sh" -exec chmod +x {} \;
chmod +x "$DOTFILES_DIR/install.sh" 2>/dev/null || true
chmod +x "$DOTFILES_DIR/bootstrap.sh" 2>/dev/null || true
success "실행 권한 설정 완료"

# 완료 메시지
echo "
${BOLD}${GREEN}✓ 모든 설정 파일이 연결되었습니다!${RESET}

다음 단계:
1. 새로운 터미널을 열어 설정을 적용하세요
2. 필요한 경우 추가 시스템 설정을 적용하세요:
   - ${BOLD}scripts/macos_defaults.sh${RESET}: macOS 시스템 설정
   - ${BOLD}scripts/optimize_key_repeat.sh${RESET}: 키 반복 최적화

설정 동기화:
- ${BOLD}scripts/sync.sh${RESET}: 시스템 설정을 dotfiles로 동기화

${BOLD}${YELLOW}주의:${RESET}
일부 애플리케이션은 재시작이 필요할 수 있습니다.
"