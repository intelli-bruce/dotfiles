#!/bin/bash

# macOS 키 반복 설정 최적화 스크립트
# 이 스크립트는 AeroSpace 창 관리자에서 키 반복이 더 잘 작동하도록 시스템 설정을 조정합니다

echo "macOS 키 반복 설정 최적화 중..."

# InitialKeyRepeat: 키를 누르고 있을 때 반복이 시작되기 전 지연 시간 (낮을수록 빨리 시작)
# 기본값은 15 (225ms)
defaults write -g InitialKeyRepeat -int 10

# KeyRepeat: 키 반복 속도 (낮을수록 빠름)
# 기본값은 2 (30ms)
defaults write -g KeyRepeat -int 1

echo "설정이 변경되었습니다. 변경사항을 적용하려면 로그아웃 후 다시 로그인하거나 컴퓨터를 재시작하세요."
echo "원래 설정으로 되돌리려면 다음 명령어를 실행하세요:"
echo "defaults write -g InitialKeyRepeat -int 15 && defaults write -g KeyRepeat -int 2"