# 리더 키 테스트 파일

이 파일은 Neovim의 리더 키가 잘 작동하는지 테스트하기 위한 것입니다.

## 테스트 방법

1. 이 파일을 Neovim으로 엽니다:
   ```bash
   nvim /Users/brucechoe/dotfiles/nvim/TEST_LEADER_KEY.md
   ```

2. 다음 리더 키 단축키를 시도해봅니다:
   - `<Space>w` - 저장
   - `<Space>h` - 검색 강조 제거
   - `<Space>ff` - 파일 검색

3. 리더 키 영향을 받는 것으로 확인된 단축키:
   - `<Space>ff` - 파일 검색
   - `<Space>fg` - 텍스트 검색
   - `<Space>fb` - 버퍼 검색
   - `<Space>fh` - 도움말 검색
   - `<Space>w` - 저장
   - `<Space>q` - 종료
   - `<Space>h` - 검색 강조 제거
   - `<Space>/` - 주석 토글
   - `<Space>gg` - LazyGit 열기
   - `<Space>xx` - Trouble 토글
   - `<Space>rn` - 이름 변경
   - `<Space>ca` - 코드 액션
   - `<Space>f` - 코드 포맷팅
   - `<Space>e` - 진단 정보 표시

## 리더 키 문제 해결 방법

리더 키가 제대로 작동하지 않는 경우:

1. `init.lua` 파일에서 리더 키가 파일 맨 위에 설정되었는지 확인합니다:
   ```lua
   vim.g.mapleader = " "      -- 스페이스바를 리더 키로 설정
   vim.g.maplocalleader = " " -- 로컬 리더 키도 스페이스바로 설정
   ```

2. 모든 플러그인과 설정을 reload하기 위해 Neovim을 다시 시작합니다:
   ```
   :q
   nvim
   ```

3. 키 매핑 확인:
   ```
   :map <leader>
   ```

4. 특정 키 매핑 확인 (예: 파일 저장):
   ```
   :map <leader>w
   ```

5. 타임아웃 설정 확인:
   ```
   :set timeout?
   :set timeoutlen?
   ```

6. WhichKey 플러그인 설치 고려:
   ```lua
   { "folke/which-key.nvim", opts = {} }
   ```

## 참고

스페이스바 리더 키가 작동하지 않는 일반적인 원인:
- 리더 키 설정이 다른 설정 후에 로드됨
- 플러그인과 충돌
- 타임아웃 설정이 너무 짧음
- 키 매핑 중복