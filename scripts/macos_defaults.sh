#!/bin/bash

# macOS 기본 설정 스크립트
# 사용자 환경을 일관되게 설정합니다

echo "🖥️  macOS 시스템 설정을 구성합니다..."

###############################################################################
# Dock                                                                        #
###############################################################################

echo "🚢 Dock 설정 중..."

# Dock 자동 숨김 활성화
defaults write com.apple.dock autohide -bool true

# Dock 아이콘 크기 설정
defaults write com.apple.dock tilesize -int 48

# 최근 사용 앱 표시 비활성화
defaults write com.apple.dock show-recents -bool false

# 애니메이션 속도 빠르게 설정
defaults write com.apple.dock expose-animation-duration -float 0.15

###############################################################################
# 키보드 & 마우스                                                              #
###############################################################################

echo "⌨️  키보드 및 마우스 설정 중..."

# 키 반복 속도 증가
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# 마우스 속도 설정
defaults write NSGlobalDomain com.apple.mouse.scaling -float 2.5

# 모든 확장 키보드 기능 활성화
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

###############################################################################
# Finder                                                                      #
###############################################################################

echo "🔍 Finder 설정 중..."

# 모든 파일 확장자 표시
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# 숨김 파일 표시
defaults write com.apple.finder AppleShowAllFiles -bool true

# 상태 표시줄 표시
defaults write com.apple.finder ShowStatusBar -bool true

# 경로 표시줄 표시
defaults write com.apple.finder ShowPathbar -bool true

# 검색 시 현재 폴더 기본값으로 설정
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# .DS_Store 파일 생성 방지 (네트워크 볼륨)
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

###############################################################################
# 스크린샷                                                                    #
###############################################################################

echo "📸 스크린샷 설정 중..."

# 스크린샷 저장 위치 변경 (기본: 바탕화면)
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

# 스크린샷 미리보기 그림자 제거
defaults write com.apple.screencapture disable-shadow -bool true

# 스크린샷 파일 형식 변경 (PNG)
defaults write com.apple.screencapture type -string "png"

###############################################################################
# 변경사항 적용                                                                #
###############################################################################

echo "🔄 변경사항 적용 중..."

# 설정 변경한 앱 재시작
for app in "Dock" "Finder" "SystemUIServer"; do
  killall "${app}" &> /dev/null
done

echo "✅ macOS 시스템 설정 완료!"
echo "참고: 일부 설정은 로그아웃하거나 재부팅 후에 적용될 수 있습니다."