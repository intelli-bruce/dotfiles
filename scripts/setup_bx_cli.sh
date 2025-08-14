#!/bin/bash

# bx-cli 설치 스크립트
# 이 스크립트는 bx-cli를 빌드하고 전역으로 설치합니다

echo "🚀 bx-cli 설치 시작..."

# 색상 코드
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. 올바른 디렉토리로 이동
BX_CLI_DIR="$HOME/Projects/bx/bx-cli"

if [ ! -d "$BX_CLI_DIR" ]; then
    echo -e "${RED}❌ 에러: bx-cli 디렉토리를 찾을 수 없습니다: $BX_CLI_DIR${NC}"
    echo -e "${YELLOW}📝 bx-cli 프로젝트가 다음 위치에 있는지 확인해주세요:${NC}"
    echo "   $BX_CLI_DIR"
    exit 1
fi

echo -e "${GREEN}✅ bx-cli 디렉토리 발견${NC}"
cd "$BX_CLI_DIR"

# 2. 현재 위치 확인
echo -e "${YELLOW}📁 현재 디렉토리:${NC} $(pwd)"

# 3. package.json 확인
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ 에러: package.json을 찾을 수 없습니다${NC}"
    echo "현재 디렉토리가 올바른지 확인해주세요"
    exit 1
fi

# 4. 의존성 설치
echo -e "${YELLOW}📦 의존성 설치 중...${NC}"
if ! npm install; then
    echo -e "${RED}❌ npm install 실패${NC}"
    exit 1
fi

# 5. 빌드 실행
echo -e "${YELLOW}🔨 프로젝트 빌드 중...${NC}"
if ! npm run build; then
    echo -e "${RED}❌ npm run build 실패${NC}"
    exit 1
fi

# 6. 전역 설치 (npm link)
echo -e "${YELLOW}🔗 전역 설치 중...${NC}"
if ! npm link; then
    echo -e "${RED}❌ npm link 실패${NC}"
    echo "sudo가 필요할 수 있습니다: sudo npm link"
    exit 1
fi

# 7. 설치 확인
echo -e "${GREEN}✅ 설치 완료!${NC}"
echo ""
echo -e "${YELLOW}📋 설치 확인:${NC}"

# bx 명령어 확인
if command -v bx &> /dev/null; then
    echo -e "${GREEN}✅ bx 명령어가 설치되었습니다${NC}"
    echo -e "   버전: $(bx --version 2>/dev/null || echo 'version 명령 없음')"
else
    echo -e "${RED}❌ bx 명령어를 찾을 수 없습니다${NC}"
    echo "PATH에 npm 전역 bin 디렉토리가 포함되어 있는지 확인해주세요"
    echo "npm bin -g 경로: $(npm bin -g)"
fi

# 8. alias 적용 안내
echo ""
echo -e "${YELLOW}💡 추가 설정:${NC}"
echo "bxdev alias가 추가되었습니다. 터미널을 재시작하거나 다음 명령을 실행하세요:"
echo -e "${GREEN}source ~/.zshrc${NC}"
echo ""
echo "이제 다음 명령을 사용할 수 있습니다:"
echo "  bxdev    # bx-cli 프로젝트 디렉토리로 이동"
echo "  bx a     # 새 메모 추가"
echo "  bx l     # 메모 목록 보기"
echo "  bx s     # 메모 검색"

# 9. 테스트 제안
echo ""
echo -e "${YELLOW}🧪 테스트:${NC}"
echo "bx a \"첫 번째 메모 테스트!\""
echo "bx l"