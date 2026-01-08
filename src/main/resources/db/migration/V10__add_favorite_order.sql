-- site_menu 테이블에 favorite_order 컬럼 추가
ALTER TABLE site_menu
ADD COLUMN favorite_order INT NULL COMMENT '즐겨찾기 정렬 순서 (즐겨찾기 전용)' AFTER is_favorite;

-- 기존 즐겨찾기 메뉴들에 순서 부여 (sort_order 기반)
UPDATE site_menu
SET favorite_order = sort_order
WHERE is_favorite = 1;
