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

echo "✅ All config files linked!"

