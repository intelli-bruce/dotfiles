# Bruce's Dotfiles

내 개발 환경 설정 파일들입니다.

## 🚀 빠른 시작

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## 📦 포함된 도구들

### Shell
- **Zsh** + **Oh My Zsh**
- **Powerlevel10k** 테마
- **zsh-autosuggestions**: 명령어 자동 제안
- **zsh-syntax-highlighting**: 실시간 문법 하이라이팅

### 터미널 도구
- **WezTerm**: GPU 가속 터미널 에뮬레이터
- **tmux**: 터미널 멀티플렉서
- **Neovim**: 확장 가능한 텍스트 에디터
- **Yazi**: 빠른 파일 매니저
- **LazyGit**: Git GUI

### macOS 도구
- **Karabiner-Elements**: 키보드 커스터마이징
- **Rectangle**: 창 관리
- **AeroSpace**: 타일링 윈도우 매니저
- **Hammerspoon**: macOS 자동화

## 🛠 설정 구조

```
dotfiles/
├── zsh/
│   ├── zshrc         # Zsh 설정
│   ├── zprofile      # 환경 변수
│   └── p10k.zsh      # Powerlevel10k 설정
├── wezterm/
│   └── wezterm.lua   # WezTerm 설정
├── tmux/
│   └── tmux.conf     # tmux 설정
├── nvim/
│   └── init.lua      # Neovim 설정
└── install.sh        # 설치 스크립트
```

## ⚙️ Zsh 설정 특징

- **Git 단축키**: `gst` (status), `gco` (checkout), `gcm` (commit)
- **디렉토리 점프**: `z` 명령어로 자주 가는 디렉토리 빠르게 이동
- **자동 완성**: 이전 명령어 자동 제안 (→ 키로 적용)
- **문법 하이라이팅**: 올바른 명령어는 녹색, 오류는 빨간색

## 🔧 수동 설정

### 폰트
Powerlevel10k가 제대로 표시되려면 Nerd Font가 필요합니다:
- macOS: `brew install --cask font-meslo-lg-nerd-font`
- 터미널에서 MesloLGS NF 폰트 선택

### 첫 실행
```bash
# Powerlevel10k 설정 마법사
p10k configure

# tmux 플러그인 설치 (tmux 내에서)
Ctrl+e I
```

## 📝 라이센스

MIT