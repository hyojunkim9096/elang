-- Flyway 마이그레이션 복구 스크립트
-- 사용법: 애플리케이션 중지 후 이 스크립트를 실행

-- 1. 실패한 마이그레이션 상태 확인
SELECT * FROM flyway_schema_history ORDER BY installed_rank DESC LIMIT 5;

-- 2. 실패한 V12 마이그레이션 레코드 삭제 (success = 0인 것만)
DELETE FROM flyway_schema_history
WHERE version = '12' AND success = 0;

-- 3. V12로 추가되었을 수 있는 부분 테이블/컬럼 정리 (있으면 삭제)
-- category_id 컬럼이 이미 있는지 확인
SET @col_exists = (SELECT COUNT(*)
                   FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = DATABASE()
                   AND TABLE_NAME = 'site_banner'
                   AND COLUMN_NAME = 'category_id');

-- category_id 컬럼이 있으면 삭제
SET @drop_col = IF(@col_exists > 0,
                   'ALTER TABLE site_banner DROP COLUMN category_id',
                   'SELECT "category_id not exists"');
PREPARE stmt FROM @drop_col;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 인덱스가 있으면 삭제
SET @idx_exists = (SELECT COUNT(*)
                   FROM INFORMATION_SCHEMA.STATISTICS
                   WHERE TABLE_SCHEMA = DATABASE()
                   AND TABLE_NAME = 'site_banner'
                   AND INDEX_NAME = 'idx_site_banner_category_id');

SET @drop_idx = IF(@idx_exists > 0,
                   'DROP INDEX idx_site_banner_category_id ON site_banner',
                   'SELECT "index not exists"');
PREPARE stmt FROM @drop_idx;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- FK 제약조건이 있으면 삭제
SET @fk_exists = (SELECT COUNT(*)
                  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
                  WHERE TABLE_SCHEMA = DATABASE()
                  AND TABLE_NAME = 'site_banner'
                  AND CONSTRAINT_NAME = 'fk_site_banner_category');

SET @drop_fk = IF(@fk_exists > 0,
                  'ALTER TABLE site_banner DROP FOREIGN KEY fk_site_banner_category',
                  'SELECT "FK not exists"');
PREPARE stmt FROM @drop_fk;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- banner_category 테이블이 있으면 삭제
DROP TABLE IF EXISTS banner_category;

-- 4. 완료 후 상태 재확인
SELECT * FROM flyway_schema_history ORDER BY installed_rank DESC LIMIT 5;

-- 완료!
-- 이제 애플리케이션을 재시작하면 V12가 다시 실행됩니다.
