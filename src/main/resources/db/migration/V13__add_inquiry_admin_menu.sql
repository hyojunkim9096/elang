-- V13: '상담/문의' 메뉴를 2뎁스 구조로 재구성합니다.

-- 한글 메뉴 ('상담/문의')
-- 1. '상담/문의' 상위 메뉴가 올바른 1뎁스 메뉴인지 확인하고, 없으면 생성합니다.
INSERT INTO site_menu (lang, menu_type, label, href, sort_order, enabled, parent_id)
SELECT 'ko', 'admin', '상담/문의', '#', 5, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM site_menu WHERE lang='ko' AND menu_type='admin' AND label='상담/문의');
UPDATE site_menu SET href='#', sort_order=5, parent_id=NULL WHERE lang='ko' AND menu_type='admin' AND label='상담/문의';

-- 2. '문의 목록' 하위 메뉴를 추가합니다.
SET @ko_parent_id = (SELECT id FROM site_menu WHERE lang='ko' AND menu_type='admin' AND label='상담/문의' AND parent_id IS NULL LIMIT 1);
INSERT INTO site_menu (lang, menu_type, label, href, sort_order, enabled, parent_id)
SELECT 'ko', 'admin', '문의 목록', '/admin/inquiries', 1, 1, @ko_parent_id
WHERE @ko_parent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM site_menu WHERE parent_id=@ko_parent_id AND label='문의 목록');


-- 영어 메뉴 ('Inquiries')
-- 1. 'Inquiries' 상위 메뉴가 올바른 1뎁스 메뉴인지 확인하고, 없으면 생성합니다.
INSERT INTO site_menu (lang, menu_type, label, href, sort_order, enabled, parent_id)
SELECT 'en', 'admin', 'Inquiries', '#', 5, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM site_menu WHERE lang='en' AND menu_type='admin' AND label='Inquiries');
UPDATE site_menu SET href='#', sort_order=5, parent_id=NULL WHERE lang='en' AND menu_type='admin' AND label='Inquiries';

-- 2. 'Inquiry List' 하위 메뉴를 추가합니다.
SET @en_parent_id = (SELECT id FROM site_menu WHERE lang='en' AND menu_type='admin' AND label='Inquiries' AND parent_id IS NULL LIMIT 1);
INSERT INTO site_menu (lang, menu_type, label, href, sort_order, enabled, parent_id)
SELECT 'en', 'admin', 'Inquiry List', '/admin/inquiries', 1, 1, @en_parent_id
WHERE @en_parent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM site_menu WHERE parent_id=@en_parent_id AND label='Inquiry List');
