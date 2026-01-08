-- 컨텐츠 섹션의 parent 메뉴 ID 찾기 (한글)
SET @content_parent_id_ko = (SELECT id FROM site_menu WHERE lang='ko' AND menu_type='admin' AND label='컨텐츠' AND parent_id IS NULL LIMIT 1);

-- 컨텐츠 카테고리 메뉴 추가 (한글) - parent_id 아래에 추가
INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled)
SELECT 'ko', 'admin', @content_parent_id_ko, '카테고리', '/admin/content-categories', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM site_menu
    WHERE lang='ko' AND menu_type='admin' AND href='/admin/content-categories'
);

-- 컨텐츠 페이지 메뉴의 sort_order를 2로 변경하여 카테고리 다음에 오도록
UPDATE site_menu
SET sort_order = 2
WHERE lang='ko' AND menu_type='admin' AND href='/admin/content-pages';

-- 영문도 동일하게 처리
SET @content_parent_id_en = (SELECT id FROM site_menu WHERE lang='en' AND menu_type='admin' AND label='Content' AND parent_id IS NULL LIMIT 1);

INSERT INTO site_menu (lang, menu_type, parent_id, label, href, sort_order, enabled)
SELECT 'en', 'admin', @content_parent_id_en, 'Categories', '/admin/content-categories', 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM site_menu
    WHERE lang='en' AND menu_type='admin' AND href='/admin/content-categories'
);

UPDATE site_menu
SET sort_order = 2
WHERE lang='en' AND menu_type='admin' AND href='/admin/content-pages';
