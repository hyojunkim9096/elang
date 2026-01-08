-- 컨텐츠 카테고리 테이블 생성
CREATE TABLE IF NOT EXISTS content_category (
    id            BIGINT NOT NULL AUTO_INCREMENT COMMENT '카테고리 ID',
    lang          VARCHAR(2) NOT NULL COMMENT '언어 (ko, en)',
    category_key  VARCHAR(64) NOT NULL COMMENT '카테고리 식별 키 (about, program 등)',
    name          VARCHAR(128) NOT NULL COMMENT '카테고리 명',
    description   VARCHAR(255) NULL COMMENT '설명',
    sort_order    INT NOT NULL DEFAULT 0 COMMENT '정렬 순서',
    enabled       TINYINT(1) NOT NULL DEFAULT 1 COMMENT '활성화 여부',
    updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    PRIMARY KEY (id),
    UNIQUE KEY uk_content_category_lang_key (lang, category_key),
    KEY idx_content_category_lang (lang),
    KEY idx_content_category_enabled (enabled)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='컨텐츠 카테고리';

-- 기존 content_page 테이블 수정
-- 1. page_key 제거 전 기존 데이터 백업을 위한 임시 컬럼
ALTER TABLE content_page ADD COLUMN old_page_key VARCHAR(64) NULL COMMENT '마이그레이션용 임시';
UPDATE content_page SET old_page_key = page_key;

-- 2. page_key unique 제약 조건 제거
ALTER TABLE content_page DROP INDEX uk_page_lang_key;

-- 3. category_id 컬럼 추가
ALTER TABLE content_page ADD COLUMN category_id BIGINT NULL COMMENT '카테고리 ID' AFTER id;

-- 4. page_key를 nullable로 변경 (나중에 제거 예정)
ALTER TABLE content_page MODIFY COLUMN page_key VARCHAR(64) NULL COMMENT '(Deprecated) 카테고리로 대체됨';

-- 기본 컨텐츠 카테고리 데이터 삽입 (한글)
INSERT INTO content_category (lang, category_key, name, description, sort_order, enabled) VALUES
('ko', 'about', '회사소개', 'ELANG CAMP 소개 페이지', 1, 1),
('ko', 'program', '프로그램 안내', '교육 프로그램 상세 안내', 2, 1),
('ko', 'instructor', '강사진', '강사진 소개', 3, 1),
('ko', 'facility', '시설안내', '캠프 시설 안내', 4, 1),
('ko', 'contact', '오시는 길', '위치 및 연락처 정보', 5, 1);

-- 기본 컨텐츠 카테고리 데이터 삽입 (영문)
INSERT INTO content_category (lang, category_key, name, description, sort_order, enabled) VALUES
('en', 'about', 'About Us', 'ELANG CAMP introduction page', 1, 1),
('en', 'program', 'Programs', 'Educational program details', 2, 1),
('en', 'instructor', 'Instructors', 'Instructor profiles', 3, 1),
('en', 'facility', 'Facilities', 'Camp facility information', 4, 1),
('en', 'contact', 'Contact', 'Location and contact information', 5, 1);

-- 기존 content_page 데이터를 새 구조로 마이그레이션
-- (기존에 page_key로 되어있던 데이터를 category_id로 연결)
UPDATE content_page cp
JOIN content_category cc ON cp.lang = cc.lang AND cp.old_page_key = cc.category_key
SET cp.category_id = cc.id
WHERE cp.old_page_key IS NOT NULL;

-- 임시 컬럼 제거
ALTER TABLE content_page DROP COLUMN old_page_key;

-- category_id를 NOT NULL로 변경 (기존 데이터 마이그레이션 후)
-- ALTER TABLE content_page MODIFY COLUMN category_id BIGINT NOT NULL COMMENT '카테고리 ID';

-- Foreign Key 추가
-- ALTER TABLE content_page ADD CONSTRAINT fk_content_page_category
--     FOREIGN KEY (category_id) REFERENCES content_category(id) ON DELETE CASCADE;
