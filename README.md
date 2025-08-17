# Bruce's Dotfiles

macOS 개발 환경 자동 설정

## 🚀 빠른 시작

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
make all        # 또는 ./bootstrap.sh
```

## 📂 구조

```
dotfiles/
├── bootstrap.sh         # 메인 진입점
├── scripts/
│   ├── install.sh       # 프로그램 설치
│   ├── setup.sh         # 설정 연결
│   ├── sync.sh          # 설정 동기화
│   └── ...             # 기타 유틸리티
└── [app]/              # 앱별 설정 파일
```

## 🔧 주요 명령어

### Makefile 사용 (권장)
```bash
make help              # 사용 가능한 명령어 보기
make all               # 전체 설정
make install           # 프로그램만 설치
make setup             # 설정만 연결
make sync              # 모든 설정 동기화
make sync-karabiner    # Karabiner만 동기화
make check             # 링크 상태 확인
```

### 스크립트 직접 실행
```bash
./bootstrap.sh                    # 전체 설정
./scripts/install.sh              # 프로그램 설치
./scripts/setup.sh                # 설정 연결
./scripts/sync.sh [앱이름]        # 설정 동기화
```

## 📦 포함된 도구

**Shell**: Zsh, Oh My Zsh, Powerlevel10k  
**터미널**: WezTerm, tmux, Neovim  
**유틸리티**: Yazi, LazyGit, Claude Code  
**macOS**: Karabiner, Rectangle, AeroSpace, Hammerspoon

## ⚙️ 설정 파일 위치

| 앱 | 시스템 위치 | dotfiles 위치 |
|---|---|---|
| WezTerm | `~/.wezterm.lua` | `wezterm/` |
| Neovim | `~/.config/nvim/` | `nvim/` |
| tmux | `~/.tmux.conf` | `tmux/` |
| Karabiner | `~/.config/karabiner/` | `karabiner/` |
| Zsh | `~/.zshrc` | `zsh/` |

## 💡 팁

**폰트 설치**: `brew install --cask font-meslo-lg-nerd-font`  
**tmux 플러그인**: tmux 내에서 `Ctrl+e I`  
**P10k 설정**: `p10k configure`

## 📝 라이센스

MIT