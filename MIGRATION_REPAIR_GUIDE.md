# Flyway 마이그레이션 복구 가이드

## 문제 상황
```
Validate failed: Migrations have failed validation
Detected failed migration to version 12 (add banner category).
```

V12 마이그레이션이 실패하여 애플리케이션이 시작되지 않음.

## 복구 절차

### 1단계: 애플리케이션 중지
Spring Boot 애플리케이션을 완전히 종료합니다.

### 2단계: DB 현재 상태 확인
```bash
mysql -u root -p elang_camp < check_db_status.sql
```

또는 MySQL 클라이언트에서:
```sql
USE elang_camp;
SELECT * FROM flyway_schema_history WHERE success = 0;
```

### 3단계: 복구 스크립트 실행

**방법 A: 파일로 실행 (권장)**
```bash
mysql -u root -p elang_camp < repair_migration_v2.sql
```

**방법 B: 수동 실행**
```sql
USE elang_camp;

-- 1. 실패한 V12 레코드 삭제
DELETE FROM flyway_schema_history WHERE version = '12' AND success = 0;

-- 2. V12가 부분적으로 생성한 객체 정리
-- FK 삭제
ALTER TABLE site_banner DROP FOREIGN KEY IF EXISTS fk_site_banner_category;

-- 인덱스 삭제
DROP INDEX IF EXISTS idx_site_banner_category_id ON site_banner;

-- 컬럼 삭제
ALTER TABLE site_banner DROP COLUMN IF EXISTS category_id;

-- 테이블 삭제
DROP TABLE IF EXISTS banner_category;

-- 3. 확인
SELECT * FROM flyway_schema_history ORDER BY installed_rank DESC LIMIT 5;
SHOW COLUMNS FROM site_banner;
```

### 4단계: V11도 실패했다면 (선택사항)

V11도 실패 상태라면:
```sql
-- V11 실패 레코드 삭제
DELETE FROM flyway_schema_history WHERE version = '11' AND success = 0;

-- V11이 추가한 컬럼들 확인 및 정리 (필요시)
SHOW COLUMNS FROM site_banner;
-- 만약 url, position, width 등이 없다면 V11도 실패한 것
```

### 5단계: 애플리케이션 재시작

복구 완료 후 Spring Boot 애플리케이션을 재시작합니다.

Flyway가 자동으로:
1. V11 (enhance_banner_system) 재실행 (실패했던 경우)
2. V12 (add_banner_category) 재실행

## 수정된 마이그레이션 파일

### V11 수정 내용
- 큰 ALTER TABLE을 여러 개로 분리 → 안정성 향상
- 인덱스 추가를 CREATE INDEX 개별 명령으로 변경
- MODIFY COLUMN을 개별 실행으로 분리

### V12 수정 내용
- BOOLEAN → TINYINT(1) (MariaDB 호환)
- DATETIME → TIMESTAMP (AUTO UPDATE 지원)
- 서브쿼리 → JOIN (Collation 충돌 해결)
- DEFAULT CHARSET=utf8mb4 명시

## 예상되는 결과

복구 성공 후 `flyway_schema_history` 테이블:
```
| version | description             | success |
|---------|-------------------------|---------|
| 1       | init                    | 1       |
| ...     | ...                     | 1       |
| 10      | add favorite order      | 1       |
| 11      | enhance banner system   | 1       |
| 12      | add banner category     | 1       |
```

`site_banner` 테이블에 추가된 컬럼:
- url (VARCHAR)
- position (VARCHAR)
- width, height (INT)
- popup_max_count, popup_duration (INT)
- start_date, end_date (TIMESTAMP)
- **category_id (BIGINT, FK to banner_category)**

새로 생성된 테이블:
- **banner_category** (id, lang, category_key, name, description, ...)

## 트러블슈팅

### Q: "Column already exists" 오류가 발생하면?
A: V11/V12가 부분적으로 실행된 상태입니다. 3단계의 정리 스크립트를 더 철저히 실행하세요.

### Q: V11, V12 모두 실패했으면?
A: 두 버전 모두 DELETE 하고 정리 후 재시작하세요.

### Q: 기존 배너 데이터가 없어졌나요?
A: 아니요. V11은 URL 통합만 하고, V12는 category_id를 추가하며 자동으로 'main' 카테고리에 연결합니다.

## 확인 명령어

```sql
-- 마이그레이션 상태
SELECT * FROM flyway_schema_history ORDER BY installed_rank DESC;

-- 테이블 구조
SHOW COLUMNS FROM site_banner;
SHOW COLUMNS FROM banner_category;

-- 배너 카테고리 데이터
SELECT * FROM banner_category;

-- 배너와 카테고리 연결 상태
SELECT sb.id, sb.title, sb.category_id, bc.name as category_name
FROM site_banner sb
LEFT JOIN banner_category bc ON sb.category_id = bc.id;
```

## 완료!

복구가 완료되면 애플리케이션이 정상적으로 시작되고 배너 카테고리 관리 기능을 사용할 수 있습니다.

- 배너 카테고리 관리: `/admin/banner-categories`
- 배너 관리: `/admin/banners`
