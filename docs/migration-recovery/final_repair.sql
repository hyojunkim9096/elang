-- 최종 복구 스크립트 (간단 버전)
-- V11, V12를 완전히 제거하고 새로운 V11만 실행

USE elang_camp;

-- 1. 상태 확인
SELECT 'Before cleanup:' as '';
SELECT version, description, success FROM flyway_schema_history WHERE version >= '11';

-- 2. V11, V12 관련 모든 객체 제거
DROP TABLE IF EXISTS banner_category;
ALTER TABLE site_banner DROP FOREIGN KEY IF EXISTS fk_site_banner_category;
ALTER TABLE site_banner DROP INDEX IF EXISTS idx_site_banner_category_id;
ALTER TABLE site_banner DROP INDEX IF EXISTS idx_banner_position_enabled;
ALTER TABLE site_banner DROP INDEX IF EXISTS idx_banner_dates;
ALTER TABLE site_banner DROP COLUMN IF EXISTS category_id;
ALTER TABLE site_banner DROP COLUMN IF EXISTS url;
ALTER TABLE site_banner DROP COLUMN IF EXISTS position;
ALTER TABLE site_banner DROP COLUMN IF EXISTS width;
ALTER TABLE site_banner DROP COLUMN IF EXISTS height;
ALTER TABLE site_banner DROP COLUMN IF EXISTS popup_max_count;
ALTER TABLE site_banner DROP COLUMN IF EXISTS popup_duration;
ALTER TABLE site_banner DROP COLUMN IF EXISTS start_date;
ALTER TABLE site_banner DROP COLUMN IF EXISTS end_date;

-- 기존 컬럼 복구 (없으면)
ALTER TABLE site_banner ADD COLUMN IF NOT EXISTS image_url VARCHAR(1024) NULL AFTER type;
ALTER TABLE site_banner ADD COLUMN IF NOT EXISTS youtube_url VARCHAR(1024) NULL AFTER image_url;
ALTER TABLE site_banner ADD COLUMN IF NOT EXISTS link_url VARCHAR(1024) NULL AFTER youtube_url;

-- 3. Flyway 히스토리 삭제
DELETE FROM flyway_schema_history WHERE version IN ('11', '12');

-- 4. 최종 확인
SELECT 'After cleanup:' as '';
SELECT version, description, success FROM flyway_schema_history WHERE version >= '10';
SELECT 'site_banner columns:' as '';
SHOW COLUMNS FROM site_banner;

SELECT '
===== 완료! =====
이제 애플리케이션을 재시작하세요.
새로운 V11 (banner_with_category)이 실행됩니다.
' as message;
