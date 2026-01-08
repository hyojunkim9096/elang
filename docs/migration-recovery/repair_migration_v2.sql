-- Flyway 마이그레이션 복구 스크립트 (개선 버전)
-- 사용법: mysql -u [username] -p elang_camp < repair_migration_v2.sql

USE elang_camp;

-- ===== STEP 1: 현재 상태 확인 =====
SELECT '===== STEP 1: 현재 Flyway 상태 확인 =====' as '';
SELECT
    installed_rank,
    version,
    description,
    success,
    installed_on
FROM flyway_schema_history
ORDER BY installed_rank DESC
LIMIT 10;

-- ===== STEP 2: 실패한 마이그레이션 확인 =====
SELECT '===== STEP 2: 실패한 마이그레이션 (success=0) =====' as '';
SELECT version, description, script FROM flyway_schema_history WHERE success = 0;

-- ===== STEP 3: V12 정리 =====
SELECT '===== STEP 3: V12 마이그레이션 정리 시작 =====' as '';

-- V12가 실패했으면 삭제
DELETE FROM flyway_schema_history WHERE version = '12' AND success = 0;
SELECT 'V12 실패 레코드 삭제 완료' as status;

-- FK 삭제
DROP TABLE IF EXISTS banner_category;
SELECT 'banner_category 테이블 삭제 완료' as status;

-- ===== STEP 4: site_banner 테이블 정리 =====
SELECT '===== STEP 4: site_banner 정리 =====' as '';

-- FK 제약 삭제 (에러 무시)
SET @sql = 'ALTER TABLE site_banner DROP FOREIGN KEY fk_site_banner_category';
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
     WHERE CONSTRAINT_SCHEMA = 'elang_camp'
     AND TABLE_NAME = 'site_banner'
     AND CONSTRAINT_NAME = 'fk_site_banner_category') > 0,
    @sql,
    'SELECT "FK already dropped" as status'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 인덱스 삭제 (에러 무시)
SET @sql = 'DROP INDEX idx_site_banner_category_id ON site_banner';
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
     WHERE TABLE_SCHEMA = 'elang_camp'
     AND TABLE_NAME = 'site_banner'
     AND INDEX_NAME = 'idx_site_banner_category_id') > 0,
    @sql,
    'SELECT "Index already dropped" as status'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- category_id 컬럼 삭제 (에러 무시)
SET @sql = 'ALTER TABLE site_banner DROP COLUMN category_id';
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'elang_camp'
     AND TABLE_NAME = 'site_banner'
     AND COLUMN_NAME = 'category_id') > 0,
    @sql,
    'SELECT "Column already dropped" as status'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ===== STEP 5: 최종 상태 확인 =====
SELECT '===== STEP 5: 정리 완료! =====' as '';

SELECT '현재 Flyway 상태:' as '';
SELECT
    installed_rank,
    version,
    description,
    success
FROM flyway_schema_history
ORDER BY installed_rank DESC
LIMIT 10;

SELECT 'site_banner 테이블 구조:' as '';
SHOW COLUMNS FROM site_banner;

SELECT '
===== 복구 완료! =====
이제 애플리케이션을 재시작하세요.
V12 (add_banner_category) 마이그레이션이 다시 실행됩니다.
' as message;
