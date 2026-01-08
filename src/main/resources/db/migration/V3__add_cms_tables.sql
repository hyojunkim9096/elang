-- 관리자/사용자 메뉴 구분을 위한 site_menu 테이블 확장
ALTER TABLE site_menu ADD COLUMN menu_type VARCHAR(10) NOT NULL DEFAULT 'public' COMMENT 'public: 사용자메뉴, admin: 관리자메뉴' AFTER lang;
ALTER TABLE site_menu ADD KEY idx_menu_type (menu_type);

-- 컨텐츠 페이지 관리 테이블
CREATE TABLE IF NOT EXISTS content_page (
  id          BIGINT NOT NULL AUTO_INCREMENT,
  lang        VARCHAR(2) NOT NULL COMMENT '언어 (ko, en)',
  page_key    VARCHAR(64) NOT NULL COMMENT '페이지 식별 키 (예: about, program)',
  title       VARCHAR(128) NOT NULL COMMENT '페이지 제목',
  content     LONGTEXT NOT NULL COMMENT 'HTML 컨텐츠',
  enabled     TINYINT(1) NOT NULL DEFAULT 1,
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_page_lang_key (lang, page_key),
  KEY idx_page_lang (lang),
  KEY idx_page_enabled (enabled)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='컨텐츠 페이지 관리';

-- 게시판 카테고리 테이블
CREATE TABLE IF NOT EXISTS board_category (
  id            BIGINT NOT NULL AUTO_INCREMENT,
  lang          VARCHAR(2) NOT NULL COMMENT '언어 (ko, en)',
  category_key  VARCHAR(64) NOT NULL COMMENT '카테고리 식별 키 (예: notice, news)',
  name          VARCHAR(128) NOT NULL COMMENT '카테고리 명',
  description   VARCHAR(255) NULL COMMENT '설명',
  display_type  VARCHAR(16) NOT NULL DEFAULT 'list' COMMENT 'list: 리스트형, card: 카드형, thumbnail: 썸네일형',
  sort_order    INT NOT NULL DEFAULT 0,
  enabled       TINYINT(1) NOT NULL DEFAULT 1,
  updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_category_lang_key (lang, category_key),
  KEY idx_category_lang (lang),
  KEY idx_category_enabled (enabled)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='게시판 카테고리';

-- 게시글 테이블
CREATE TABLE IF NOT EXISTS board_post (
  id           BIGINT NOT NULL AUTO_INCREMENT,
  category_id  BIGINT NOT NULL COMMENT '카테고리 ID',
  lang         VARCHAR(2) NOT NULL COMMENT '언어 (ko, en)',
  title        VARCHAR(255) NOT NULL COMMENT '제목',
  content      LONGTEXT NOT NULL COMMENT '본문 (HTML)',
  thumbnail    VARCHAR(1024) NULL COMMENT '썸네일 이미지 URL',
  view_count   INT NOT NULL DEFAULT 0 COMMENT '조회수',
  is_pinned    TINYINT(1) NOT NULL DEFAULT 0 COMMENT '상단 고정 여부',
  enabled      TINYINT(1) NOT NULL DEFAULT 1,
  published_at TIMESTAMP NULL COMMENT '게시일',
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_post_category (category_id),
  KEY idx_post_lang (lang),
  KEY idx_post_enabled (enabled),
  KEY idx_post_pinned (is_pinned),
  KEY idx_post_published (published_at),
  CONSTRAINT fk_post_category FOREIGN KEY (category_id) REFERENCES board_category(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='게시글';
