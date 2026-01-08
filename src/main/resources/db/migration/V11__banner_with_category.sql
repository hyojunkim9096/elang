-- 배너 카테고리 시스템 구축 (V11+V12 통합)

-- 1. banner_category 테이블 생성
CREATE TABLE IF NOT EXISTS banner_category (
    id            BIGINT NOT NULL AUTO_INCREMENT COMMENT '카테고리 ID',
    lang          VARCHAR(2) NOT NULL COMMENT '언어 (ko, en)',
    category_key  VARCHAR(64) NOT NULL COMMENT '카테고리 식별 키',
    name          VARCHAR(128) NOT NULL COMMENT '카테고리 명',
    description   VARCHAR(255) NULL COMMENT '설명',
    sort_order    INT NOT NULL DEFAULT 0 COMMENT '정렬 순서',
    enabled       TINYINT(1) NOT NULL DEFAULT 1 COMMENT '활성화 여부',
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (id),
    UNIQUE KEY uk_banner_category_lang_key (lang, category_key),
    KEY idx_banner_category_lang (lang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='배너 카테고리';

-- 2. 기본 배너 카테고리 데이터 삽입
INSERT INTO banner_category (lang, category_key, name, description, sort_order, enabled) VALUES
('ko', 'main', '메인 배너', '메인 페이지 기본 배너', 1, 1),
('ko', 'promotion', '프로모션', '할인 및 프로모션 배너', 2, 1),
('ko', 'event', '이벤트', '특별 이벤트 배너', 3, 1),
('en', 'main', 'Main Banner', 'Main page default banners', 1, 1),
('en', 'promotion', 'Promotion', 'Discount and promotion banners', 2, 1),
('en', 'event', 'Event', 'Special event banners', 3, 1);

-- 3. site_banner 테이블 수정
-- 3-1. 새 컬럼 추가
ALTER TABLE site_banner
  ADD COLUMN category_id BIGINT NULL COMMENT '카테고리 ID' AFTER lang,
  ADD COLUMN url VARCHAR(1024) NULL COMMENT '배너 URL' AFTER title,
  ADD COLUMN position VARCHAR(20) NOT NULL DEFAULT 'TOP_BANNER' COMMENT '배너 위치' AFTER type,
  ADD COLUMN width INT NOT NULL DEFAULT 1920 COMMENT '배너 너비(px)' AFTER position,
  ADD COLUMN height INT NOT NULL DEFAULT 200 COMMENT '배너 높이(px)' AFTER width,
  ADD COLUMN popup_max_count INT NULL COMMENT '팝업 최대 개수' AFTER height,
  ADD COLUMN popup_duration INT NULL COMMENT '팝업 표시 시간(초)' AFTER popup_max_count,
  ADD COLUMN start_date TIMESTAMP NULL COMMENT '노출 시작일시' AFTER enabled,
  ADD COLUMN end_date TIMESTAMP NULL COMMENT '노출 종료일시' AFTER start_date;

-- 3-2. 기존 데이터 마이그레이션
UPDATE site_banner SET url = COALESCE(image_url, youtube_url, link_url) WHERE url IS NULL;

-- 3-3. 기존 배너를 'main' 카테고리에 연결
UPDATE site_banner sb
JOIN banner_category bc ON bc.lang = sb.lang AND bc.category_key = 'main'
SET sb.category_id = bc.id
WHERE sb.category_id IS NULL;

-- 3-4. 기존 URL 컬럼 삭제
ALTER TABLE site_banner
  DROP COLUMN image_url,
  DROP COLUMN youtube_url,
  DROP COLUMN link_url;

-- 4. 인덱스 및 외래키 추가
CREATE INDEX idx_site_banner_category_id ON site_banner(category_id);
CREATE INDEX idx_banner_position_enabled ON site_banner(position, enabled, sort_order);
CREATE INDEX idx_banner_dates ON site_banner(start_date, end_date);

ALTER TABLE site_banner
ADD CONSTRAINT fk_site_banner_category
FOREIGN KEY (category_id) REFERENCES banner_category(id) ON DELETE SET NULL;
