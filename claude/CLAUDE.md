"한글로 설명하되, 기술 용어나 코드 관련 항목은 영어 그대로 유지해줘."


2. 커밋 메세지에 이 내용 포함하지마
      🤖 Generated with [Claude Code](https://claude.ai/code)

      Co-Authored-By: Claude <noreply@anthropic.com>")

항상 요청한 작업범위를 벗어나는 추가적인 작업을 멋대로 진행하지마.

• Flutter 프로젝트에서 수정 작업을 한 이후에는 항상 flutter analyzer를 실행해서 변경사항으로 인해 에러가 발생하고 있진 않은지 확인하고 처리해.

• Flutter 프로젝트에서 print() 사용하지말고 LoggerService에서 적절한 로그 찾아서 활용해.

• 나의 의도나 목적, 또는 실제 정보 등이 확실하지 않은 상황에선 항상 먼저 나에게 질문하여 사실관계를 파악 한 뒤에 작업을 이어나가도록 해.

• 변경작업을 완료한 후에는 항상 ide의 진단 기능을 사용해서 에러가 발생하진 않는지 확인하고 에러가 발생하면 해결해줘.


Claude Code 작업 규칙 - 매우 중요! ⚠️
🚨 절대 규칙: .gitignore 파일 백업 🚨
반드시 백업해야 하는 파일들:
데이터베이스 파일 (*.db, *.sqlite, *.db-journal)
환경 설정 파일 (.env, .env.local, .env.production)
비밀 키/인증 파일 (*.pem, *.key, credentials.json)
로컬 설정 파일 (config.local., settings.local.)
안전한 파일 처리 절차 (필수!):
🚫 위험한 방법 (사용 금지):
rm <중요파일>
rm -rf <디렉토리>
✅ 안전한 방법 (권장):
# 1. 이름 변경으로 "삭제" (실제로는 보존)
mv <파일명> <파일명>.removed_$(date +%Y%m%d_%H%M%S)

# 2. 디렉토리의 경우
mv <디렉토리명> <디렉토리명>_removed_$(date +%Y%m%d_%H%M%S)

# 3. 정리가 필요한 경우 별도 디렉토리로 이동
mkdir -p .removed_files
mv <파일명> .removed_files/<파일명>_$(date +%Y%m%d_%H%M%S)

# 4. 나중에 확실히 불필요하다고 판단되면 수동으로 삭제
# (최소 1주일 이상 보관 후)
💡 장점:
실수해도 즉시 복구 가능
히스토리 추적 가능
디스크 공간이 부족할 때까지는 보관
rm 명령어로 인한 영구 삭제 방지
특히 주의할 상황:
디렉토리 구조 변경 시
프로젝트 리팩토링 시
rm -rf 명령어 사용 시
디렉토리 전체 삭제 시
실수 사례 (2025-05-27):
bruce-finance-app 프로젝트에서 Prisma 제거 중 prisma/dev.db 삭제 → Git에 추적되지 않는 파일이라 복구 불가능 → 모든 거래 데이터 손실

기억하세요:
"삭제는 1초, 복구는 불가능할 수 있습니다!" "mv로 이름 변경 > rm으로 삭제" "디스크 공간 < 데이터 가치"

실제 적용 예시:
# ❌ 하지 말아야 할 것
rm -rf prisma/

# ✅ 대신 이렇게
mv prisma/ prisma_removed_20250527_115500/

# ❌ 하지 말아야 할 것
rm .env

# ✅ 대신 이렇게
mv .env .env.removed_20250527_115500
