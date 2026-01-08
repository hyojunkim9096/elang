# 🚨 긴급 복구 가이드

## 문제 상황
```
Migration checksum mismatch for migration version 11
Detected failed migration to version 12
```

**원인:** V11 파일을 수정했기 때문에 이미 적용된 V11과 체크섬이 달라짐

## ⚡ 빠른 해결 방법

### 1. 애플리케이션 중지

### 2. 복구 스크립트 실행
```bash
cd /Users/kimhyojun/projects/elang
mysql -u root -p elang_camp < repair_all_migrations.sql
```

비밀번호 입력 후 대기 (30초~1분 소요)

### 3. 애플리케이션 재시작

끝! V11과 V12가 처음부터 재실행됩니다.

---

## 📋 이 스크립트가 하는 일

1. **V12 정리**
   - banner_category 테이블 삭제
   - category_id 컬럼 삭제
   - FK, 인덱스 삭제

2. **V11 완전 롤백**
   - url, position, width, height 등 컬럼 삭제
   - 기존 image_url, youtube_url, link_url 복구
   - 인덱스 삭제

3. **Flyway 히스토리 정리**
   - V11, V12 레코드 완전 삭제
   - 재실행 가능 상태로 복구

---

## ✅ 성공 확인

```sql
-- 1. Flyway 히스토리 확인
SELECT * FROM flyway_schema_history WHERE version IN ('11', '12');
-- 결과: 빈 결과 (삭제됨)

-- 2. 테이블 구조 확인
SHOW COLUMNS FROM site_banner;
-- url, position, width 등이 없어야 함
-- image_url, youtube_url, link_url이 있어야 함
```

재시작 후:
```sql
SELECT * FROM flyway_schema_history WHERE version IN ('11', '12');
-- 결과: 두 레코드 모두 success = 1

SELECT * FROM banner_category;
-- 결과: 6개 레코드 (ko/en × 3개 카테고리)
```

---

## 🔍 문제가 계속되면?

### A. "Column 'XXX' doesn't exist" 오류
→ V11 롤백이 불완전함. 수동으로:
```sql
ALTER TABLE site_banner ADD COLUMN image_url VARCHAR(1024) NULL;
ALTER TABLE site_banner ADD COLUMN youtube_url VARCHAR(1024) NULL;
ALTER TABLE site_banner ADD COLUMN link_url VARCHAR(1024) NULL;
```

### B. "Column 'XXX' already exists" 오류
→ 정리가 불완전함. 수동으로:
```sql
ALTER TABLE site_banner DROP COLUMN url;
ALTER TABLE site_banner DROP COLUMN position;
-- 등등...
```

### C. Flyway repair 명령어 사용
```sql
-- MySQL에서 직접
UPDATE flyway_schema_history SET checksum = NULL WHERE version = '11';
```

또는
```bash
# Maven으로 (현재 프로젝트는 DB 설정 이슈로 불가능)
mvn flyway:repair
```

---

## 💡 왜 이런 일이?

1. V11 파일을 수정함 → 체크섬 변경
2. Flyway는 이미 적용된 V11의 체크섬과 비교
3. 불일치 발견 → 오류 발생

**해결책:** V11, V12를 완전히 삭제하고 재실행

---

## 🎯 핵심 명령어

```bash
# 원스텝 복구
mysql -u root -p elang_camp < repair_all_migrations.sql

# 확인
mysql -u root -p elang_camp -e "SELECT version, success FROM flyway_schema_history WHERE version > '10'"
```
