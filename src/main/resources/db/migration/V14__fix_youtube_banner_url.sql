-- YouTube 배너 URL을 삽입용(embed) 주소로 표준화합니다.

-- 1. 일반 시청 주소 (youtube.com/watch?v=...) 처리
-- 예: https://www.youtube.com/watch?v=xIDYwLOWzcw&feature=share -> https://www.youtube.com/embed/xIDYwLOWzcw
UPDATE site_banner
SET url = CONCAT('https://www.youtube.com/embed/', SUBSTRING_INDEX(SUBSTRING_INDEX(url, 'v=', -1), '&', 1))
WHERE type = 'YOUTUBE' AND url LIKE '%watch?v=%';

-- 2. 짧은 공유 주소 (youtu.be/...) 처리
-- 예: https://youtu.be/xIDYwLOWzcw?si=a__tR8xraH8GrrZ9 -> https://www.youtube.com/embed/xIDYwLOWzcw
UPDATE site_banner
SET url = CONCAT('https://www.youtube.com/embed/', SUBSTRING_INDEX(SUBSTRING_INDEX(url, 'youtu.be/', -1), '?', 1))
WHERE type = 'YOUTUBE' AND url LIKE '%youtu.be/%';
