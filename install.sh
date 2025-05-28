#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

echo "🔗 Linking WezTerm config..."
ln -sf "$DOTFILES_DIR/wezterm/wezterm.lua" "$HOME/.wezterm.lua"

echo "🔗 Linking Neovim config..."
mkdir -p "$HOME/.config/nvim"
ln -sf "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

echo "🔗 Linking Karabiner config..."
mkdir -p "$HOME/.config/karabiner"
ln -sf "$DOTFILES_DIR/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

echo "🔗 Linking Rectangle config..."
mkdir -p "$HOME/Library/Application Support/Rectangle"
ln -sf "$DOTFILES_DIR/rectangle/RectangleConfig.json" "$HOME/Library/Application Support/Rectangle/RectangleConfig.json"

echo "🔗 Linking tmux config..."
mkdir -p "$HOME/.config/tmux"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

echo "🔗 Linking Yazi config..."
mkdir -p "$HOME/.config/yazi"
ln -sf "$DOTFILES_DIR/yazi/keymap.toml" "$HOME/.config/yazi/keymap.toml"
ln -sf "$DOTFILES_DIR/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"

echo "🔗 Linking Aerospace config..."
mkdir -p "$HOME/.config/aerospace"
ln -sf "$DOTFILES_DIR/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"

echo "🔗 Linking Lazygit config..."
mkdir -p "$HOME/.config/lazygit"
ln -sf "$DOTFILES_DIR/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

echo "🔗 Linking Hammerspoon config..."
mkdir -p "$HOME/.hammerspoon"
ln -sf "$DOTFILES_DIR/hammerspoon/init.lua" "$HOME/.hammerspoon/init.lua"

echo "🔗 Linking Claude config..."
mkdir -p "$HOME/.claude"
ln -sf "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

echo "🔗 Setting up LaunchAgents..."
mkdir -p "$HOME/Library/LaunchAgents"
ln -sf "$DOTFILES_DIR/launchd/com.tmux.start.plist" "$HOME/Library/LaunchAgents/com.tmux.start.plist"
launchctl unload "$HOME/Library/LaunchAgents/com.tmux.start.plist" 2>/dev/null || true
launchctl load "$HOME/Library/LaunchAgents/com.tmux.start.plist"

echo "🔧 Installing tmux plugins..."
# 플러그인 매니저 설치
TMUX_TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TMUX_TPM_DIR" ]; then
  echo "🔗 Installing tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm "$TMUX_TPM_DIR"
fi

# 필수 플러그인 설치
TMUX_RESURRECT_DIR="$HOME/.tmux/plugins/tmux-resurrect"
if [ ! -d "$TMUX_RESURRECT_DIR" ]; then
  echo "🔗 Installing tmux-resurrect plugin..."
  git clone https://github.com/tmux-plugins/tmux-resurrect "$TMUX_RESURRECT_DIR"
fi

TMUX_CONTINUUM_DIR="$HOME/.tmux/plugins/tmux-continuum"
if [ ! -d "$TMUX_CONTINUUM_DIR" ]; then
  echo "🔗 Installing tmux-continuum plugin..."
  git clone https://github.com/tmux-plugins/tmux-continuum "$TMUX_CONTINUUM_DIR"
fi

echo "🔧 Installing Yazi plugins..."
mkdir -p "$HOME/.config/yazi/plugins"
# 이미 설치된 플러그인 확인
if [ ! -d "$HOME/.config/yazi/plugins/lazygit.yazi" ]; then
  echo "🔗 Installing lazygit plugin for Yazi..."
  git clone https://github.com/Lil-Dank/lazygit.yazi.git "$HOME/.config/yazi/plugins/lazygit.yazi"
fi

echo "✅ All config files linked!"

