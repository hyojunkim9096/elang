-- site_banner 테이블에 누락된 link_url 컬럼을 추가합니다.
ALTER TABLE site_banner
ADD COLUMN link_url VARCHAR(1024) NULL COMMENT '배너 클릭 시 이동할 URL' AFTER url;
