# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 저장소 구조 (Repository Structure)

이 저장소는 macOS 환경을 위한 dotfiles를 관리합니다. 주요 구성 파일은 다음과 같습니다:

- `install.sh`: 심볼릭 링크를 생성하여 설정 파일을 적절한 위치에 설치하는 스크립트
- `wezterm/wezterm.lua`: WezTerm 터미널 에뮬레이터 설정
- `tmux/tmux.conf`: tmux 터미널 멀티플렉서 설정
- `nvim/init.lua`: Neovim 텍스트 에디터 설정
- `karabiner/karabiner.json`: Karabiner-Elements 키 매핑 설정
- `rectangle/RectangleConfig.json`: Rectangle 창 관리자 설정
- `aerospace/aerospace.toml`: AeroSpace 윈도우 매니저 설정
- `hammerspoon/init.lua`: Hammerspoon 자동화 도구 설정
- `yazi/`: yazi 파일 매니저 설정
- `lazygit/config.yml`: LazyGit GUI Git 클라이언트 설정
- `claude/`: Claude Code 설정 파일들
  - `CLAUDE.md`: 사용자 지침 파일
  - `settings.json`: Claude Code 메인 설정 파일
  - `statusline-command.sh`: 맞춤형 상태바 스크립트

## 공통 작업 (Common Tasks)

### 설치 방법 (Installation)

dotfiles를 설치하려면 다음 명령어를 실행하세요:

```bash
./install.sh
```

이 스크립트는 각 설정 파일에 대한 심볼릭 링크를 적절한 위치에 생성합니다.

### 설정 업데이트 (Updating Configurations)

1. 저장소 내 파일을 직접 수정합니다.
2. 변경 사항은 심볼릭 링크를 통해 자동으로 적용됩니다.

## 설정 세부 정보 (Configuration Details)

### WezTerm (`wezterm/wezterm.lua`)
- JetBrainsMono Nerd Font와 한글 폰트 지원 (Pretendard 추가)
- Dracula 색상 테마
- 창 투명도 및 블러 효과 설정
- 한글 입력 개선 설정
- 단축키:
  - `Cmd+Shift+h/l`: vim 스타일 윈도우 이동
  - `Cmd+Shift+1/2/3`: 윈도우 번호로 직접 이동
  - `Cmd+t`: tmux 세션 선택 (tms 함수 실행)

### Neovim (`nvim/init.lua`)
- lazy.nvim 플러그인 매니저 사용
- Catppuccin 색상 테마
- nvim-tree, lualine, telescope, treesitter 등 주요 플러그인 설정
- 기본 옵션: 줄 번호, 탭 설정, 클립보드 등

### Karabiner-Elements (`karabiner/karabiner.json`)
- CapsLock 키를 ESC(단일 클릭) 또는 Control(길게 누름)으로 매핑
- Command+Shift+숫자 키를 사용하여 자주 사용하는 앱 실행
- 한글 입력 전환 및 이모지 입력 단축키 설정

### Rectangle (`rectangle/RectangleConfig.json`)
- 창 위치 및 크기 조정을 위한 단축키 설정
- 화면 분할 및 창 정렬 옵션

### tmux (`tmux/tmux.conf`)
- 프리픽스 키: `Ctrl+e`
- vim 스타일 패널 이동 (`Ctrl+e h/j/k/l`)
- 창 분할: `Ctrl+e |` (수직), `Ctrl+e -` (수평)
- 세션 관리: `Ctrl+e s` (세션 목록)
- resurrect와 continuum 플러그인으로 세션 자동 저장/복원

### Claude Code (`claude/`)
- **설정 파일**: `settings.json` - Claude Code 메인 설정 파일
- **상태바 스크립트**: `statusline-command.sh` - 맞춤형 상태바 표시
  - 사용자@호스트명 표시
  - 현재 디렉터리 (프로젝트 루트 기준 상대 경로)
  - Git 브랜치 및 상태 (clean/dirty)  
  - Claude 모델명
  - 세션 메트릭스 (토큰 수, 메시지 수, 세션 시간)
- **알림 설정**: 작업 완료 시 시스템 사운드 재생

### 추가 설정
- **zsh 함수**: `tms` - fzf를 사용한 tmux 세션 선택기 (`.zshrc`에 추가 필요)