-- 현재 DB 상태 확인 스크립트
-- MySQL/MariaDB 클라이언트에서 실행하세요

USE elang_camp;

-- 1. Flyway 마이그레이션 히스토리 확인 (최근 10개)
SELECT
    installed_rank,
    version,
    description,
    type,
    script,
    checksum,
    installed_on,
    execution_time,
    success
FROM flyway_schema_history
ORDER BY installed_rank DESC
LIMIT 10;

-- 2. site_banner 테이블의 현재 컬럼 구조 확인
SHOW FULL COLUMNS FROM site_banner;

-- 3. banner_category 테이블 존재 여부 확인
SELECT COUNT(*) as banner_category_exists
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'banner_category';

-- 4. site_banner에 category_id 컬럼 존재 여부
SELECT COUNT(*) as category_id_exists
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'site_banner'
AND COLUMN_NAME = 'category_id';

-- 5. site_banner의 인덱스 확인
SHOW INDEX FROM site_banner;

-- 6. site_banner의 외래키 확인
SELECT
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'site_banner'
AND REFERENCED_TABLE_NAME IS NOT NULL;
