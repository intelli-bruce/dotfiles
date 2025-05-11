# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 저장소 구조 (Repository Structure)

이 저장소는 macOS 환경을 위한 dotfiles를 관리합니다. 주요 구성 파일은 다음과 같습니다:

- `install.sh`: 심볼릭 링크를 생성하여 설정 파일을 적절한 위치에 설치하는 스크립트
- `wezterm/wezterm.lua`: WezTerm 터미널 에뮬레이터 설정
- `nvim/init.lua`: Neovim 텍스트 에디터 설정
- `karabiner/karabiner.json`: Karabiner-Elements 키 매핑 설정
- `rectangle/RectangleConfig.json`: Rectangle 창 관리자 설정

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
- JetBrainsMono Nerd Font와 한글 폰트 지원
- Dracula 색상 테마
- 창 투명도 및 블러 효과 설정
- 한글 입력 개선 설정

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