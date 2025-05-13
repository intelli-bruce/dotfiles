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

echo "🔧 Installing Yazi plugins..."
mkdir -p "$HOME/.config/yazi/plugins"
# 이미 설치된 플러그인 확인
if [ ! -d "$HOME/.config/yazi/plugins/lazygit.yazi" ]; then
  echo "🔗 Installing lazygit plugin for Yazi..."
  git clone https://github.com/Lil-Dank/lazygit.yazi.git "$HOME/.config/yazi/plugins/lazygit.yazi"
fi

echo "✅ All config files linked!"

