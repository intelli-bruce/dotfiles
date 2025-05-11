# Neovim 설정 가이드

이 문서는 Neovim 설정 파일(`init.lua`)에 대한 상세한 설명과 사용법을 제공합니다. Neovim을 처음 사용하는 분들도 쉽게 이해하고 활용할 수 있도록 작성되었습니다.

## 목차

1. [설치 및 준비](#설치-및-준비)
2. [주요 기능](#주요-기능)
3. [단축키 안내](#단축키-안내)
4. [LSP (Language Server Protocol)](#lsp-language-server-protocol)
5. [자동 완성](#자동-완성)
6. [플러그인 설명](#플러그인-설명)
7. [자주 묻는 질문](#자주-묻는-질문)

## 설치 및 준비

### 필수 요구 사항

- Neovim 0.8.0 이상
- Git
- Node.js (LSP 서버를 위해 필요)
- 터미널에서 잘 보이는 Nerd Font ([JetBrains Mono Nerd Font](https://www.nerdfonts.com) 권장)

### 설치 방법

1. 이 저장소를 클론합니다:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git
   ```

2. `install.sh` 스크립트를 실행하여 설정 파일을 적절한 위치에 설치합니다:
   ```bash
   cd dotfiles
   ./install.sh
   ```

3. Neovim을 처음 실행하면 자동으로 lazy.nvim이 설치되고 모든, 플러그인이 다운로드됩니다:
   ```bash
   nvim
   ```

## 주요 기능

이 Neovim 설정은 다음과 같은 주요 기능을 제공합니다:

- **모던한 UI**: 아름다운 Catppuccin 색상 테마와 상태바
- **파일 탐색기**: NvimTree를 사용한 직관적인 파일 탐색
- **강력한 검색**: Telescope를 통한 파일 및 텍스트 검색
- **구문 강조**: Treesitter를 통한 정확한 구문 강조
- **LSP 지원**: 코드 자동완성, 정의 이동, 에러 표시 등
- **Git 통합**: 변경 내역 표시 및 Git 명령어 사용
- **터미널 통합**: 편집기 내에서 터미널 사용

## 단축키 안내

> 💡 **참고**: `<leader>` 키는 스페이스바로 설정되어 있습니다.

### 기본 편집

| 단축키 | 기능 |
|--------|------|
| `<leader>w` | 파일 저장 |
| `<leader>q` | Neovim 종료 |
| `<leader>h` | 검색 강조 제거 |
| `<leader>/` | 현재 줄 주석 토글 |

### 파일 탐색

| 단축키 | 기능 |
|--------|------|
| `<C-n>` | 파일 탐색기 토글 |
| `<C-p>` | 파일 검색 |
| `<leader>ff` | 파일 검색 |
| `<leader>fg` | 텍스트 검색 (라이브 그렙) |
| `<leader>fb` | 열린 버퍼 검색 |
| `<leader>fh` | 도움말 검색 |

### 창 관리

| 단축키 | 기능 |
|--------|------|
| `<C-h>` | 왼쪽 창으로 이동 |
| `<C-j>` | 아래 창으로 이동 |
| `<C-k>` | 위 창으로 이동 |
| `<C-l>` | 오른쪽 창으로 이동 |
| `<A-h>` | 창 너비 줄이기 |
| `<A-j>` | 창 높이 늘리기 |
| `<A-k>` | 창 높이 줄이기 |
| `<A-l>` | 창 너비 늘리기 |

### 버퍼 관리

| 단축키 | 기능 |
|--------|------|
| `<S-h>` | 이전 버퍼로 이동 |
| `<S-l>` | 다음 버퍼로 이동 |
| `<leader>bd` | 현재 버퍼 닫기 |

### 터미널

| 단축키 | 기능 |
|--------|------|
| `<C-\>` | 터미널 토글 |
| `<leader>tf` | 플로팅 터미널 열기 |
| `<leader>th` | 가로 분할 터미널 열기 |
| `<leader>tv` | 세로 분할 터미널 열기 |
| `<leader>t+` | 터미널 크기 증가 |
| `<leader>t-` | 터미널 크기 감소 |
| `<Esc>` | 터미널 모드 종료 (일반 모드로 전환) |

### 코드 편집

| 단축키 | 설명 |
|--------|------|
| `<` / `>` | 비주얼 모드에서 선택 유지하며 들여쓰기 조정 |
| `J` / `K` | 비주얼 모드에서 선택한 블록 위/아래로 이동 |

## LSP (Language Server Protocol)

LSP는 코드 자동 완성, 정의 이동, 참조 검색 등 다양한 언어 기능을 제공합니다.

### 자동 설치된 LSP 서버

다음 LSP 서버가 자동으로 설치됩니다:

- `lua_ls`: Lua
- `pyright`: Python
- `rust_analyzer`: Rust
- `clangd`: C/C++
- `marksman`: Markdown

**참고**:
- TypeScript/JavaScript 개발을 위해서는 Node.js가 설치되어 있어야 합니다. LSP 설정은 구성되어 있으며, `npm install -g typescript typescript-language-server` 명령으로 서버를 수동 설치할 수 있습니다.
- Dart/Flutter 개발이 필요한 경우, Flutter SDK를 설치하고 설정 파일의 Dart 관련 설정을 활성화하세요.

### LSP 단축키

| 단축키 | 기능 |
|--------|------|
| `gd` | 정의로 이동 |
| `gr` | 참조 찾기 |
| `K` | 정보 표시 |
| `<leader>rn` | 이름 변경 |
| `<leader>ca` | 코드 액션 |
| `<leader>f` | 코드 포맷팅 |
| `<leader>e` | 진단 정보 표시 |
| `[d` | 이전 진단으로 이동 |
| `]d` | 다음 진단으로 이동 |

### 진단 도구 (Trouble)

| 단축키 | 기능 |
|--------|------|
| `<leader>xx` | 진단 문제 목록 토글 |
| `<leader>xd` | 현재 문서 진단 문제 |
| `<leader>xw` | 작업 공간 진단 문제 |
| `<leader>xl` | 위치 목록 |
| `<leader>xq` | 퀵픽스 목록 |

## 자동 완성

자동 완성 기능은 nvim-cmp를 통해 제공됩니다.

### 자동 완성 사용법

| 단축키 | 기능 |
|--------|------|
| `<C-Space>` | 자동 완성 메뉴 표시 |
| `<C-e>` | 자동 완성 취소 |
| `<C-b>` / `<C-f>` | 문서 스크롤 (위/아래) |
| `<Tab>` | 다음 항목 선택/스니펫 확장 |
| `<S-Tab>` | 이전 항목 선택 |
| `<CR>` | 선택한 항목 확정 |

자동 완성은 다음 소스에서 제공됩니다:
- LSP (언어 서버)
- 스니펫
- 버퍼 (현재 열린 파일의 내용)
- 파일 경로

## 플러그인 설명

이 설정에 포함된 주요 플러그인과 그 기능을 설명합니다:

### UI 관련

- **catppuccin/nvim**: 아름다운 색상 테마
- **nvim-tree/nvim-tree.lua**: 파일 탐색기
- **nvim-lualine/lualine.nvim**: 상태 표시줄
- **lukas-reineke/indent-blankline.nvim**: 들여쓰기 가이드

### 편집 도구

- **nvim-telescope/telescope.nvim**: 파일 및 텍스트 검색
- **nvim-treesitter/nvim-treesitter**: 향상된 구문 강조
- **windwp/nvim-autopairs**: 괄호 자동 완성
- **numToStr/Comment.nvim**: 주석 단축키

### 개발 지원

- **neovim/nvim-lspconfig**: LSP 설정
- **williamboman/mason.nvim**: LSP 서버 및 도구 관리자
- **hrsh7th/nvim-cmp**: 자동 완성 엔진
- **L3MON4D3/LuaSnip**: 스니펫 엔진
- **folke/trouble.nvim**: 진단 문제 표시
- **RRethy/vim-illuminate**: 동일한 단어 강조

### Git 관련

- **tpope/vim-fugitive**: Git 명령어 지원
- **lewis6991/gitsigns.nvim**: Git 변경 사항 표시
- **kdheepak/lazygit.nvim**: LazyGit 통합

### 터미널 및 기타

- **akinsho/toggleterm.nvim**: 내장 터미널 관리
- **j-hui/fidget.nvim**: LSP 진행 상황 표시

## 자주 묻는 질문

### Q: 새로운 플러그인을 어떻게 추가하나요?
A: `init.lua` 파일에서 lazy.nvim 설정 부분(`require("lazy").setup({...})`)에 플러그인을 추가하고 Neovim을 다시 시작하세요. lazy.nvim이 자동으로 새 플러그인을 설치합니다.

### Q: 특정 언어의 LSP 서버를 어떻게 추가하나요?
A: `:Mason` 명령어를 실행하여 Mason 인터페이스를 열고 필요한 LSP 서버를 설치하세요. 그다음 `init.lua`의 LSP 설정 부분에 해당 서버 설정을 추가하세요.

### Q: 색상 테마를 어떻게 변경하나요?
A: `init.lua`에서 `vim.cmd.colorscheme "catppuccin-mocha"` 부분을 원하는 테마로 변경하세요. 새 테마를 사용하려면 먼저 해당 플러그인을 추가해야 합니다.

### Q: 파일 탐색기를 열 수 없어요. 어떻게 해야 하나요?
A: `<C-n>` 키를 눌러보세요. 작동하지 않는다면 `:NvimTreeToggle` 명령어를 실행하거나 nvim-tree 플러그인이 올바르게 설치되었는지 확인하세요.

### Q: 자동 완성이 작동하지 않아요.
A: LSP 서버가 현재 파일 유형에 대해 설치되어 있는지 확인하세요. `:LspInfo` 명령어로 LSP 상태를 확인할 수 있습니다. 필요한 경우 `:Mason`을 실행하여 추가 LSP 서버를 설치하세요.

### Q: 단축키를 어떻게 사용자 정의하나요?
A: `init.lua` 파일에서 `vim.keymap.set` 함수를 사용하여 새 단축키를 추가하거나 기존 단축키를 수정할 수 있습니다. 예를 들면:
```lua
vim.keymap.set("n", "<leader>x", ":YourCommand<CR>", { desc = "설명" })
```

---

이 설정 파일과 관련된 질문이나 문제가 있으면 이슈를 생성하거나 PR을 보내주세요.
