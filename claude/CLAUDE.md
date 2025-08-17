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


# 🎯 Brxce CLI를 활용한 작업 관리 - 필수! ⚠️

## 📋 작업 관리 원칙
Brxce CLI를 적극 활용하여 모든 작업의 진행 상황을 체계적으로 관리합니다.

### 1️⃣ 작업 시작 시

#### 상위 WorkNode 찾기 (필수!)
```bash
# 1. 먼저 프로젝트 구조 확인
brxce worknode tree --show-ids

# 2. 관련 프로젝트/서브프로젝트 찾기
brxce worknode list --type project,subproject

# 3. 적절한 상위 노드 선택 규칙:
# - 기능 개발 → 해당 subproject 하위
# - 버그 수정 → 관련 subproject 또는 project 하위  
# - 문서 작업 → 관련 project 하위
# - 긴급 이슈 → project 직속 또는 독립 task

# 4. 상위 노드 ID를 찾아서 생성
PARENT_ID=$(brxce worknode list --type subproject | grep "CLI" | awk '{print $2}')
brxce worknode create "[작업명]" --type task --parent $PARENT_ID --priority medium --description "[상세 설명]"
```

#### WorkNode 생성 예시
```bash
# CLI 관련 작업인 경우
brxce worknode create "명령어 추가 개발" --type task --parent [CLI_subproject_ID] --priority medium

# Electron 관련 작업인 경우  
brxce worknode create "UI 컴포넌트 수정" --type task --parent [Electron_subproject_ID] --priority low

# 프로젝트 전체 관련 작업
brxce worknode create "전체 테스트 실행" --type task --parent [BRXCE_project_ID] --priority high

# 복잡한 작업은 subtask로 분해
brxce worknode create "[세부 작업]" --type subtask --parent [parent_task_ID]
```

### 2️⃣ 작업 진행 중
```bash
# 작업 시작 시 상태 업데이트
brxce worknode update [ID] --status in_progress --progress 0

# 진행률 업데이트 (25%, 50%, 75% 단위로)
brxce worknode update [ID] --progress 50

# 중요한 마일스톤마다 업데이트
brxce worknode update [ID] --progress 75 --description "테스트 통과, 문서화 진행 중"
```

### 3️⃣ 작업 완료 시
```bash
# 작업 완료 처리
brxce worknode update [ID] --status completed --progress 100

# 전체 현황 확인
brxce worknode tree --show-completed
```

## ⚠️ 주의사항
- **과도한 WorkNode 생성 금지**: 실제로 추적이 필요한 의미 있는 작업만 생성
- **적절한 계층 구조**: project > subproject > task > subtask 순서 준수
- **진행률 정확도**: 실제 진행 상황과 일치하도록 업데이트
- **작업 범위 준수**: 요청받은 작업 범위 내에서만 WorkNode 생성
- **상위 노드 필수 확인**: 새 WorkNode 생성 전 반드시 적절한 부모 찾기

## 🎯 상위 WorkNode 자동 선택 전략

### 범용적 상위 노드 선택 규칙
1. **현재 프로젝트 구조 파악**
   - `brxce worknode tree --show-ids`로 전체 구조 확인
   - 현재 활성화된 프로젝트와 서브프로젝트 목록 확인

2. **작업 유형별 매칭**
   ```bash
   # 작업명과 설명에서 키워드 추출하여 관련 노드 찾기
   TASK_KEYWORDS="작업명과 설명에서 추출한 키워드"
   
   # 1단계: 서브프로젝트에서 매칭 시도
   PARENT=$(brxce worknode list --type subproject | grep -i "$TASK_KEYWORDS" | head -1 | awk '{print $2}')
   
   # 2단계: 못 찾으면 프로젝트에서 매칭
   if [ -z "$PARENT" ]; then
       PARENT=$(brxce worknode list --type project | grep -i "$TASK_KEYWORDS" | head -1 | awk '{print $2}')
   fi
   
   # 3단계: 그래도 못 찾으면 현재 작업 중인 프로젝트 사용
   if [ -z "$PARENT" ]; then
       PARENT=$(brxce worknode list --type project --status in_progress | head -1 | awk '{print $2}')
   fi
   
   # 4단계: 기본값 - 가장 최근 프로젝트
   if [ -z "$PARENT" ]; then
       PARENT=$(brxce worknode list --type project | head -1 | awk '{print $2}')
   fi
   ```

3. **계층 구조 규칙**
   - **긴급 버그**: 프로젝트 직속 task
   - **기능 개발**: 관련 subproject 하위 task
   - **세부 작업**: 부모 task 하위 subtask
   - **문서/테스트**: 관련 프로젝트/서브프로젝트 하위

## 🔄 자동화 규칙
1. 사용자가 새로운 기능/버그 수정 요청 → 즉시 task 생성
2. 복잡한 작업 (3단계 이상) → subtask로 분해
3. 각 단계 완료 시 → 진행률 업데이트
4. 최종 완료 시 → completed 상태로 변경
5. **이슈/에러 발생 시 → 자동으로 버그 task 생성 (priority: urgent)**

## 🐛 이슈/버그 자동 추적
```bash
# 에러나 이슈 발견 시 즉시 생성
brxce worknode create "[이슈: 에러 내용 요약]" \
  --type task \
  --priority urgent \
  --description "에러 상세: [에러 메시지 및 스택 트레이스]"

# 예시: 500 에러, 빌드 실패, 테스트 실패 등
brxce worknode create "이슈: inbox WorkNodes API 500 에러" \
  --type task \
  --priority urgent \
  --description "deleted_at 필드 누락으로 인한 Prisma 쿼리 오류"
```

## 📊 상태 확인 명령어
```bash
# 현재 진행 중인 작업
brxce worknode list --status in_progress

# 오늘 생성된 작업
brxce worknode list --created-after $(date +%Y-%m-%d)

# 전체 프로젝트 구조
brxce worknode tree
```

이 규칙을 따라 모든 작업을 체계적으로 관리하고 사용자에게 진행 상황을 명확하게 전달합니다
