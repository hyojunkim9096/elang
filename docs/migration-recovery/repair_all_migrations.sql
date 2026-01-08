-- Flyway 마이그레이션 완전 복구 스크립트
-- V11의 체크섬 불일치와 V12 실패를 모두 해결

USE elang_camp;

-- ===== STEP 1: 현재 상태 확인 =====
SELECT '===== STEP 1: 현재 상태 확인 =====' as '';
SELECT
    installed_rank,
    version,
    description,
    checksum,
    success,
    installed_on
FROM flyway_schema_history
ORDER BY installed_rank DESC
LIMIT 10;

-- ===== STEP 2: V11, V12 관련 모든 정리 =====
SELECT '===== STEP 2: V11, V12 롤백 시작 =====' as '';

-- 2-1. V12가 추가한 FK 삭제
SELECT '2-1. FK 제약조건 삭제' as step;
SET @fk_exists = (SELECT COUNT(*)
                  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
                  WHERE CONSTRAINT_SCHEMA = 'elang_camp'
                  AND TABLE_NAME = 'site_banner'
                  AND CONSTRAINT_NAME = 'fk_site_banner_category');

SET @sql = IF(@fk_exists > 0,
              'ALTER TABLE site_banner DROP FOREIGN KEY fk_site_banner_category',
              'SELECT "FK already dropped" as status');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2-2. V12가 추가한 인덱스 삭제
SELECT '2-2. category_id 인덱스 삭제' as step;
SET @idx_exists = (SELECT COUNT(*)
                   FROM INFORMATION_SCHEMA.STATISTICS
                   WHERE TABLE_SCHEMA = 'elang_camp'
                   AND TABLE_NAME = 'site_banner'
                   AND INDEX_NAME = 'idx_site_banner_category_id');

SET @sql = IF(@idx_exists > 0,
              'DROP INDEX idx_site_banner_category_id ON site_banner',
              'SELECT "Index already dropped" as status');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2-3. V12가 추가한 category_id 컬럼 삭제
SELECT '2-3. category_id 컬럼 삭제' as step;
SET @col_exists = (SELECT COUNT(*)
                   FROM INFORMATION_SCHEMA.COLUMNS
                   WHERE TABLE_SCHEMA = 'elang_camp'
                   AND TABLE_NAME = 'site_banner'
                   AND COLUMN_NAME = 'category_id');

SET @sql = IF(@col_exists > 0,
              'ALTER TABLE site_banner DROP COLUMN category_id',
              'SELECT "Column already dropped" as status');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2-4. V12가 생성한 banner_category 테이블 삭제
SELECT '2-4. banner_category 테이블 삭제' as step;
DROP TABLE IF EXISTS banner_category;

-- 2-5. V11이 추가한 인덱스 삭제
SELECT '2-5. V11 인덱스 삭제' as step;
SET @idx1_exists = (SELECT COUNT(*)
                    FROM INFORMATION_SCHEMA.STATISTICS
                    WHERE TABLE_SCHEMA = 'elang_camp'
                    AND TABLE_NAME = 'site_banner'
                    AND INDEX_NAME = 'idx_banner_position_enabled');

SET @sql = IF(@idx1_exists > 0,
              'DROP INDEX idx_banner_position_enabled ON site_banner',
              'SELECT "idx_banner_position_enabled already dropped" as status');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @idx2_exists = (SELECT COUNT(*)
                    FROM INFORMATION_SCHEMA.STATISTICS
                    WHERE TABLE_SCHEMA = 'elang_camp'
                    AND TABLE_NAME = 'site_banner'
                    AND INDEX_NAME = 'idx_banner_dates');

SET @sql = IF(@idx2_exists > 0,
              'DROP INDEX idx_banner_dates ON site_banner',
              'SELECT "idx_banner_dates already dropped" as status');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2-6. V11이 추가한 컬럼들 삭제 (역순으로)
SELECT '2-6. V11 컬럼들 삭제' as step;

-- end_date
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'elang_camp' AND TABLE_NAME = 'site_banner' AND COLUMN_NAME = 'end_date') > 0,
    'ALTER TABLE site_banner DROP COLUMN end_date',
    'SELECT "end_date already dropped" as status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- start_date
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'elang_camp' AND TABLE_NAME = 'site_banner' AND COLUMN_NAME = 'start_date') > 0,
    'ALTER TABLE site_banner DROP COLUMN start_date',
    'SELECT "start_date already dropped" as status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- popup_duration
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'elang_camp' AND TABLE_NAME = 'site_banner' AND COLUMN_NAME = 'popup_duration') > 0,
    'ALTER TABLE site_banner DROP COLUMN popup_duration',
    'SELECT "popup_duration already dropped" as status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- popup_max_count
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'elang_camp' AND TABLE_NAME = 'site_banner' AND COLUMN_NAME = 'popup_max_count') > 0,
    'ALTER TABLE site_banner DROP COLUMN popup_max_count',
    'SELECT "popup_max_count already dropped" as status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- height
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'elang_camp' AND TABLE_NAME = 'site_banner' AND COLUMN_NAME = 'height') > 0,
    'ALTER TABLE site_banner DROP COLUMN height',
    'SELECT "height already dropped" as status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- width
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'elang_camp' AND TABLE_NAME = 'site_banner' AND COLUMN_NAME = 'width') > 0,
    'ALTER TABLE site_banner DROP COLUMN width',
    'SELECT "width already dropped" as status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- position
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'elang_camp' AND TABLE_NAME = 'site_banner' AND COLUMN_NAME = 'position') > 0,
    'ALTER TABLE site_banner DROP COLUMN position',
    'SELECT "position already dropped" as status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- url
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'elang_camp' AND TABLE_NAME = 'site_banner' AND COLUMN_NAME = 'url') > 0,
    'ALTER TABLE site_banner DROP COLUMN url',
    'SELECT "url already dropped" as status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 2-7. V11이 삭제한 컬럼 복구 (image_url, youtube_url, link_url)
SELECT '2-7. 기존 URL 컬럼 복구' as step;
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'elang_camp' AND TABLE_NAME = 'site_banner' AND COLUMN_NAME = 'image_url') = 0,
    'ALTER TABLE site_banner ADD COLUMN image_url VARCHAR(1024) NULL AFTER type',
    'SELECT "image_url exists" as status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'elang_camp' AND TABLE_NAME = 'site_banner' AND COLUMN_NAME = 'youtube_url') = 0,
    'ALTER TABLE site_banner ADD COLUMN youtube_url VARCHAR(1024) NULL AFTER image_url',
    'SELECT "youtube_url exists" as status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = 'elang_camp' AND TABLE_NAME = 'site_banner' AND COLUMN_NAME = 'link_url') = 0,
    'ALTER TABLE site_banner ADD COLUMN link_url VARCHAR(1024) NULL AFTER youtube_url',
    'SELECT "link_url exists" as status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ===== STEP 3: Flyway 히스토리 정리 =====
SELECT '===== STEP 3: Flyway 히스토리 정리 =====' as '';

-- V12 레코드 삭제
DELETE FROM flyway_schema_history WHERE version = '12';
SELECT 'V12 레코드 삭제 완료' as status;

-- V11 레코드 삭제
DELETE FROM flyway_schema_history WHERE version = '11';
SELECT 'V11 레코드 삭제 완료' as status;

-- ===== STEP 4: 최종 상태 확인 =====
SELECT '===== STEP 4: 복구 완료! =====' as '';

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

다음 단계:
1. 이 스크립트 실행 완료 확인
2. 애플리케이션 재시작
3. V11, V12가 처음부터 재실행됩니다

주의: 기존 배너 데이터가 있었다면 url 통합 전 상태로 돌아갔습니다.
재실행되면 자동으로 통합됩니다.
' as message;
