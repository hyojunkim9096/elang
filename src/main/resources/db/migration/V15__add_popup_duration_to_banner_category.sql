-- 배너 카테고리 테이블에 팝업 관련 컬럼 추가
ALTER TABLE banner_category
ADD COLUMN popup_max_count INT DEFAULT 1 COMMENT '팝업 배너 최대 노출 수',
ADD COLUMN popup_duration INT DEFAULT 24 COMMENT '팝업 "오늘 그만 보기" 쿠키 유지 시간 (시간 단위)';
