# 한글 입력 & 단축키 베스트 프랙티스

> Neovim 등 터미널 환경에서 한글 입력과 단축키 문제를 해결하는 완벽한 가이드

## 🔥 문제 상황

한글 입력 상태에서 발생하는 주요 문제들:
1. **단축키 미작동**: `Alt+h`, `Ctrl+w` 등이 한글 입력 상태에서 작동 안 함
2. **모드 전환 번거로움**: Vim Normal mode 진입 시 매번 한/영 전환 필요
3. **커맨드 입력 실패**: `:wq`, `/search` 등 입력 시 한글로 입력됨
4. **반복적인 전환**: 코딩과 주석 작성 사이 빈번한 한/영 전환

## ✅ 해결 방법

### 1. Karabiner-Elements 설정 (강력 추천)

#### 설치
```bash
brew install --cask karabiner-elements
```

#### 핵심 설정 (`karabiner/korean-ime-fix.json`)

이미 생성된 설정 파일을 Karabiner에 추가:

1. Karabiner-Elements 실행
2. Complex Modifications 탭 → Add rule
3. Import more rules from the Internet → Import from file
4. `~/dotfiles/karabiner/korean-ime-fix.json` 선택

#### 제공되는 기능들

**🎯 자동 영문 전환**
- **ESC 키**: Normal mode 진입 시 자동으로 영문 전환
- **Ctrl+[**: ESC 대체 키, 역시 영문으로 전환
- **`: / ?`**: Vim 명령 입력 시 자동 영문 전환

**🔄 스마트 한/영 전환**
- **우측 Command 탭**: 한/영 전환 (탭만 하면 전환, 홀드하면 Command)
- **F18 매핑**: 시스템 한/영 전환 키를 F18로 매핑

**⚡ 단축키 우선 처리**
- **Alt 단축키**: 한글 입력 상태에서도 모든 Alt 단축키 작동
- **Cmd 단축키**: 한글 입력 상태 무관하게 작동

### 2. Neovim 설정

`nvim/init.lua`에 추가된 설정:

```lua
-- 한글 입력 자동 전환 설정 (macOS)
if vim.fn.has('mac') == 1 then
  -- Insert mode 벗어날 때 영문으로 전환
  vim.api.nvim_create_autocmd({"InsertLeave"}, {
    pattern = "*",
    callback = function()
      os.execute("osascript -e 'tell application \"System Events\" to select input source \"ABC\"' &")
    end
  })
end
```

### 3. tmux 사용 팁

#### 이미 설정된 Alt 기반 단축키
```bash
# 한글 입력 상태에서도 작동!
Alt+h/j/k/l      # 패널 이동
Alt+Shift+h/j/k/l # 패널 위치 교체
Alt+Ctrl+h/j/k/l  # 패널 크기 조절
Alt+1~5          # 창 이동
Alt+c            # 새 창 생성
```

### 4. 시스템 레벨 설정

#### macOS 기본 한/영 전환 키 변경
시스템 설정 → 키보드 → 입력 소스 → 편집:
- CapsLock을 한/영 전환으로 설정 (선택사항)
- 또는 우측 Command를 한/영 전환으로 (Karabiner 설정과 연동)

## 🚀 추천 워크플로우

### Vim/Neovim 작업
1. **Insert mode**: 한글/영문 자유롭게 사용
2. **ESC 누름**: 자동으로 영문 전환 + Normal mode
3. **명령 입력**: `:`, `/`, `?` 누르면 자동 영문
4. **다시 Insert**: `i`, `a` 등으로 진입, 필요시 한글 전환

### tmux 작업
1. **모든 Alt 단축키**: 한글 상태 무관하게 작동
2. **패널/창 이동**: 한글 입력 중에도 Alt+hjkl 사용 가능
3. **명령 모드**: `Ctrl+Space :` 후 영문으로 자동 전환

## 🔧 문제 해결

### Karabiner가 작동하지 않을 때
1. 시스템 설정 → 개인정보 보호 및 보안 → 입력 모니터링
2. Karabiner-Elements 권한 허용
3. Karabiner 재시작

### Neovim 자동 전환이 안 될 때
```bash
# 터미널에서 테스트
osascript -e 'tell application "System Events" to select input source "ABC"'
```

### tmux Alt 키가 안 먹을 때
```bash
# tmux 설정 리로드
tmux source-file ~/.tmux.conf
```

## 💡 고급 팁

### 1. 앱별 자동 전환
Karabiner에서 특정 앱에서만 작동하도록 설정:
```json
"conditions": [
    {
        "type": "frontmost_application_if",
        "bundle_identifiers": [
            "^com\\.github\\.wez\\.wezterm$",
            "^com\\.apple\\.Terminal$"
        ]
    }
]
```

### 2. 변수 기반 모드 관리
복잡한 모드 전환이 필요한 경우:
```json
{
    "set_variable": {
        "name": "vim_mode",
        "value": 1
    }
}
```

### 3. 지연 시간 조정
더 빠른 반응을 원한다면:
```json
"parameters": {
    "basic.to_if_held_down_threshold_milliseconds": 50
}
```

## 📚 참고 자료

- [Karabiner-Elements 공식 문서](https://karabiner-elements.pqrs.org/)
- [Vim 한글 입력 문제 해결](https://github.com/johngrib/simple_vim_guide/blob/master/md/with_korean.md)
- [macOS Input Source 관리](https://developer.apple.com/documentation/carbon/1501426-tiselectinputsource)

## 🎯 요약

1. **Karabiner-Elements**로 시스템 레벨 해결 (필수)
2. **Neovim 자동 전환** 설정으로 편의성 증대
3. **Alt 기반 단축키**로 한글 상태 무관하게 사용
4. **우측 Command 탭**으로 빠른 한/영 전환

이제 한글 입력 상태를 신경 쓰지 않고 편하게 작업할 수 있습니다! 🎉