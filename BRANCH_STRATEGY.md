# Git Branch Strategy

이 프로젝트는 Git Flow 기반의 브랜치 전략을 사용합니다.

## 브랜치 구조

```
main (기본 브랜치)
├── develop (개발 브랜치)
└── prod (운영 배포 브랜치)
```

## 브랜치 설명

### 1. `main` 브랜치
- **목적**: 기본 브랜치, 안정적인 코드 유지
- **보호**: 직접 커밋 금지
- **병합**: develop과 prod에서만 병합 가능
- **용도**:
  - 프로젝트의 메인 소스 코드 저장소
  - develop과 prod의 공통 기반

### 2. `develop` 브랜치
- **목적**: 개발 환경용 브랜치
- **배포**: 개발/테스트 서버
- **활동**:
  - 새로운 기능 개발
  - 버그 수정
  - 테스트 및 검증
- **설정 파일**: `application-local.yml` (로컬/개발)
- **병합 방향**: main ← develop

### 3. `prod` 브랜치
- **목적**: 운영 환경용 브랜치
- **배포**: 카페24 운영 서버
- **특징**:
  - 안정화된 코드만 병합
  - 실제 사용자에게 서비스되는 버전
  - 긴급 패치 가능
- **설정 파일**: `application-prod.yml` (운영)
- **병합 방향**: main ← develop → prod (검증 후)

## 워크플로우

### 일반 개발 흐름

```bash
# 1. develop 브랜치에서 작업
git checkout develop
git pull origin develop

# 2. 개발 및 커밋
git add .
git commit -m "feat: 새로운 기능 추가"

# 3. develop에 푸시
git push origin develop

# 4. 테스트 완료 후 main에 병합
git checkout main
git merge develop
git push origin main
```

### 운영 배포 흐름

```bash
# 1. develop에서 충분히 테스트 완료

# 2. main 최신화
git checkout main
git merge develop
git push origin main

# 3. prod 브랜치로 병합
git checkout prod
git merge main
git push origin prod

# 4. 카페24 서버에 배포
# prod 브랜치 기준으로 WAR 파일 빌드 및 배포
```

### 긴급 패치 (Hotfix)

```bash
# 1. prod에서 긴급 수정
git checkout prod
# 수정 작업
git commit -m "hotfix: 긴급 버그 수정"
git push origin prod

# 2. main과 develop에도 반영
git checkout main
git merge prod
git push origin main

git checkout develop
git merge main
git push origin develop
```

## 브랜치별 환경 설정

### develop 브랜치
- **프로필**: `local` 또는 `dev`
- **DB**: 로컬 또는 개발 서버 DB
- **포트**: 8081
- **설정**: `application-local.yml`

```yaml
spring:
  datasource:
    url: jdbc:mariadb://localhost:3306/elang_camp
    username: elang
    password: elang1234
```

### prod 브랜치
- **프로필**: `prod`
- **DB**: 카페24 운영 DB
- **포트**: 카페24 설정에 따름
- **설정**: `application-prod.yml` (별도 생성 필요)

```yaml
spring:
  datasource:
    url: jdbc:mariadb://카페24_DB_호스트:3306/DB명
    username: 운영_DB_사용자
    password: 운영_DB_비밀번호
```

## 주의사항

### ⚠️ 운영 배포 전 체크리스트

- [ ] develop 브랜치에서 충분한 테스트 완료
- [ ] DB 마이그레이션 스크립트 확인
- [ ] 설정 파일(application-prod.yml) 확인
- [ ] 로그 레벨 확인 (운영은 INFO 이상)
- [ ] 불필요한 디버그 코드 제거
- [ ] WAR 파일 빌드 성공 확인
- [ ] 백업 완료

### 🚫 금지 사항

1. **main 브랜치에 직접 커밋 금지**
   - 반드시 develop 또는 prod에서 병합

2. **prod 브랜치에 테스트 코드 푸시 금지**
   - 충분히 검증된 코드만 병합

3. **설정 파일 커밋 주의**
   - `application-prod.yml`은 `.gitignore`에 포함됨
   - 운영 DB 정보 노출 금지

## 배포 순서

```
개발 → 테스트 → 스테이징 → 운영
develop → main → prod → 카페24
```

## 커밋 컨벤션

```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 수정
style: 코드 포맷팅 (기능 변경 없음)
refactor: 코드 리팩토링
test: 테스트 추가/수정
chore: 빌드/패키지 설정
hotfix: 긴급 운영 패치
```

## 참고

- **카페24 배포**: prod 브랜치만 배포
- **개발 협업**: develop 브랜치에서 작업
- **긴급 수정**: prod에서 hotfix 후 다른 브랜치에 병합
