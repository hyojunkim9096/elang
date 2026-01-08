-- 기본 관리자 메뉴 데이터 삽입
-- 1뎁스: 섹션 제목 (대시보드는 제외, 섹션만)
-- 2뎁스: 실제 메뉴 아이템

-- 1. CMS 관리 섹션 (1뎁스)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('ko', 'admin', NULL, 'CMS 관리', '#', 0, 1, NOW(), NOW());

SET @cms_section_id = LAST_INSERT_ID();

-- 1-1. 대시보드 (2뎁스)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('ko', 'admin', @cms_section_id, '대시보드', '/admin', 0, 1, NOW(), NOW());

-- 1-2. 레이아웃 관리 (2뎁스)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('ko', 'admin', @cms_section_id, '레이아웃 관리', '/admin/layout', 1, 1, NOW(), NOW());

-- 1-3. 메뉴 관리 (2뎁스)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('ko', 'admin', @cms_section_id, '메뉴 관리', '/admin/menus', 2, 1, NOW(), NOW());

-- 1-4. 배너 관리 (2뎁스)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('ko', 'admin', @cms_section_id, '배너 관리', '/admin/banners', 3, 1, NOW(), NOW());


-- 2. 컨텐츠 섹션 (1뎁스)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('ko', 'admin', NULL, '컨텐츠', '#', 1, 1, NOW(), NOW());

SET @content_section_id = LAST_INSERT_ID();

-- 2-1. 컨텐츠 페이지 (2뎁스)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('ko', 'admin', @content_section_id, '컨텐츠 페이지', '/admin/content-pages', 0, 1, NOW(), NOW());


-- 3. 게시판 섹션 (1뎁스)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('ko', 'admin', NULL, '게시판', '#', 2, 1, NOW(), NOW());

SET @board_section_id = LAST_INSERT_ID();

-- 3-1. 카테고리 (2뎁스)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('ko', 'admin', @board_section_id, '카테고리', '/admin/board-categories', 0, 1, NOW(), NOW());

-- 3-2. 게시글 (2뎁스)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('ko', 'admin', @board_section_id, '게시글', '/admin/board-posts', 1, 1, NOW(), NOW());


-- ============================================================================
-- 영문 메뉴도 동일하게 추가
-- ============================================================================

-- 1. CMS Section (1depth)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('en', 'admin', NULL, 'CMS', '#', 0, 1, NOW(), NOW());

SET @cms_section_id_en = LAST_INSERT_ID();

-- 1-1. Dashboard (2depth)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('en', 'admin', @cms_section_id_en, 'Dashboard', '/admin', 0, 1, NOW(), NOW());

-- 1-2. Layout (2depth)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('en', 'admin', @cms_section_id_en, 'Layout', '/admin/layout', 1, 1, NOW(), NOW());

-- 1-3. Menus (2depth)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('en', 'admin', @cms_section_id_en, 'Menus', '/admin/menus', 2, 1, NOW(), NOW());

-- 1-4. Banners (2depth)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('en', 'admin', @cms_section_id_en, 'Banners', '/admin/banners', 3, 1, NOW(), NOW());


-- 2. Content Section (1depth)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('en', 'admin', NULL, 'Content', '#', 1, 1, NOW(), NOW());

SET @content_section_id_en = LAST_INSERT_ID();

-- 2-1. Content Pages (2depth)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('en', 'admin', @content_section_id_en, 'Content Pages', '/admin/content-pages', 0, 1, NOW(), NOW());


-- 3. Board Section (1depth)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('en', 'admin', NULL, 'Board', '#', 2, 1, NOW(), NOW());

SET @board_section_id_en = LAST_INSERT_ID();

-- 3-1. Categories (2depth)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('en', 'admin', @board_section_id_en, 'Categories', '/admin/board-categories', 0, 1, NOW(), NOW());

-- 3-2. Posts (2depth)
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled, created_at, updated_at)
VALUES ('en', 'admin', @board_section_id_en, 'Posts', '/admin/board-posts', 1, 1, NOW(), NOW());


-- 확인용 쿼리
SELECT m.id, m.lang, m.menu_type, m.parent_id, m.label, m.href, m.sort_order, m.enabled,
       p.label as parent_label
FROM site_menu m
LEFT JOIN site_menu p ON m.parent_id = p.id
WHERE m.menu_type = 'admin'
ORDER BY m.lang, m.sort_order, m.parent_id, m.id;
