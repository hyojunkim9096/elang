-- site_menu 테이블에 is_favorite 컬럼 추가
ALTER TABLE site_menu
ADD COLUMN is_favorite TINYINT(1) NOT NULL DEFAULT 0 COMMENT '즐겨찾기 여부 (대시보드 표시)' AFTER enabled;

-- 기본 즐겨찾기 설정 (자주 사용하는 메뉴들)
UPDATE site_menu SET is_favorite = 1
WHERE menu_type = 'admin'
  AND href IN (
    '/admin/layout',
    '/admin/menus',
    '/admin/banners',
    '/admin/board-posts',
    '/admin/content-pages'
  );
