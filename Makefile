# Dotfiles Makefile
# macOS 개발 환경 자동 설정

.PHONY: all install setup sync help clean
.DEFAULT_GOAL := help

# 색상 정의
GREEN := \033[0;32m
BLUE := \033[0;34m
YELLOW := \033[0;33m
RED := \033[0;31m
RESET := \033[0m

# 디렉토리 경로
DOTFILES_DIR := $(shell pwd)
SCRIPTS_DIR := $(DOTFILES_DIR)/scripts

## 메인 타겟
all: install setup macos ## 전체 환경 설정 (새 Mac용)
	@echo "$(GREEN)✓ 모든 설정이 완료되었습니다!$(RESET)"
	@echo "새 터미널을 열어 설정을 적용하세요."

## 프로그램 설치
install: ## 필요한 프로그램과 패키지 설치
	@echo "$(BLUE)▶ 프로그램 설치 중...$(RESET)"
	@bash $(SCRIPTS_DIR)/install.sh
	@echo "$(GREEN)✓ 프로그램 설치 완료$(RESET)"

## 설정 연결
setup: ## 설정 파일 심볼릭 링크 생성
	@echo "$(BLUE)▶ 설정 파일 연결 중...$(RESET)"
	@bash $(SCRIPTS_DIR)/setup.sh
	@echo "$(GREEN)✓ 설정 연결 완료$(RESET)"

## macOS 설정
macos: ## macOS 시스템 설정 적용
	@echo "$(BLUE)▶ macOS 설정 중...$(RESET)"
	@if [ -f $(SCRIPTS_DIR)/macos_defaults.sh ]; then \
		bash $(SCRIPTS_DIR)/macos_defaults.sh; \
	fi
	@if [ -f $(SCRIPTS_DIR)/optimize_key_repeat.sh ]; then \
		bash $(SCRIPTS_DIR)/optimize_key_repeat.sh; \
	fi
	@echo "$(GREEN)✓ macOS 설정 완료$(RESET)"

## 설정 동기화
sync: ## 시스템 설정을 dotfiles로 동기화 (기본: 전체)
	@bash $(SCRIPTS_DIR)/sync.sh

sync-karabiner: ## Karabiner 설정만 동기화
	@bash $(SCRIPTS_DIR)/sync.sh karabiner

sync-tmux: ## tmux 설정만 동기화
	@bash $(SCRIPTS_DIR)/sync.sh tmux

sync-neovim: ## Neovim 설정만 동기화
	@bash $(SCRIPTS_DIR)/sync.sh neovim

sync-zsh: ## Zsh 설정만 동기화
	@bash $(SCRIPTS_DIR)/sync.sh zsh

## 개별 설정
brew: ## Homebrew 패키지만 설치
	@echo "$(BLUE)▶ Homebrew 패키지 설치 중...$(RESET)"
	@if [ -f $(SCRIPTS_DIR)/brew_install.sh ]; then \
		bash $(SCRIPTS_DIR)/brew_install.sh; \
	else \
		brew bundle --file=$(DOTFILES_DIR)/Brewfile; \
	fi

zsh-plugins: ## Zsh 플러그인만 설치
	@echo "$(BLUE)▶ Zsh 플러그인 설치 중...$(RESET)"
	@if [ ! -d "$${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then \
		git clone https://github.com/zsh-users/zsh-autosuggestions $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions; \
	fi
	@if [ ! -d "$${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting; \
	fi

tmux-plugins: ## tmux 플러그인만 설치
	@echo "$(BLUE)▶ tmux 플러그인 설치 중...$(RESET)"
	@if [ ! -d "$$HOME/.tmux/plugins/tpm" ]; then \
		git clone https://github.com/tmux-plugins/tpm $$HOME/.tmux/plugins/tpm; \
	fi

ghostty: ## Ghostty 설정만 연결
	@echo "$(BLUE)▶ Ghostty 설정 연결 중...$(RESET)"
	@mkdir -p $$HOME/.config/ghostty
	@ln -sf $(DOTFILES_DIR)/ghostty/config $$HOME/.config/ghostty/config
	@echo "$(GREEN)✓ Ghostty 설정 완료$(RESET)"

## 유틸리티
backup: ## 현재 설정 백업
	@echo "$(BLUE)▶ 설정 백업 중...$(RESET)"
	@mkdir -p $(DOTFILES_DIR)/backups
	@tar -czf $(DOTFILES_DIR)/backups/dotfiles-$$(date +%Y%m%d-%H%M%S).tar.gz \
		--exclude=backups \
		--exclude=.git \
		$(DOTFILES_DIR)
	@echo "$(GREEN)✓ 백업 완료: backups/$(RESET)"

check: ## 설정 파일 링크 상태 확인
	@echo "$(BLUE)▶ 설정 파일 상태 확인$(RESET)"
	@echo "\nWezTerm:"
	@ls -la ~/.wezterm.lua 2>/dev/null || echo "  Not linked"
	@echo "\nNeovim:"
	@ls -la ~/.config/nvim/init.lua 2>/dev/null || echo "  Not linked"
	@echo "\ntmux:"
	@ls -la ~/.tmux.conf 2>/dev/null || echo "  Not linked"
	@echo "\nKarabiner:"
	@ls -la ~/.config/karabiner/karabiner.json 2>/dev/null || echo "  Not linked"

clean: ## 모든 심볼릭 링크 제거 (주의!)
	@echo "$(YELLOW)⚠ 모든 dotfiles 링크를 제거합니다.$(RESET)"
	@read -p "계속하시겠습니까? (y/n) " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		rm -f ~/.wezterm.lua; \
		rm -f ~/.config/nvim/init.lua; \
		rm -f ~/.tmux.conf; \
		rm -f ~/.config/karabiner/karabiner.json; \
		rm -f ~/.zshrc; \
		echo "$(GREEN)✓ 링크 제거 완료$(RESET)"; \
	fi

## 도움말
help: ## 이 도움말 표시
	@echo "$(BLUE)Dotfiles Makefile$(RESET)"
	@echo "사용법: make [타겟]\n"
	@echo "타겟:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(RESET) %s\n", $$1, $$2}'
	@echo "\n예시:"
	@echo "  make all          # 전체 설정"
	@echo "  make setup        # 설정 파일만 연결"
	@echo "  make sync         # 설정 동기화"
	@echo "  make sync-karabiner # Karabiner만 동기화"