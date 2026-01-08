-- ⚠️ 전체 초기화 (DROP + CREATE)
-- 실행:
--   mariadb -u "$(whoami)" < scripts/local-db-reset.sql

DROP DATABASE IF EXISTS elang_camp;

-- 아래는 init과 동일
CREATE DATABASE IF NOT EXISTS elang_camp
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'elang'@'localhost' IDENTIFIED BY 'elang1234';
CREATE USER IF NOT EXISTS 'elang'@'127.0.0.1' IDENTIFIED BY 'elang1234';

-- 이미 존재하는 경우 비밀번호를 강제로 원하는 값으로 맞춰줍니다.
ALTER USER 'elang'@'localhost' IDENTIFIED BY 'elang1234';
ALTER USER 'elang'@'127.0.0.1' IDENTIFIED BY 'elang1234';

GRANT ALL PRIVILEGES ON elang_camp.* TO 'elang'@'localhost';
GRANT ALL PRIVILEGES ON elang_camp.* TO 'elang'@'127.0.0.1';

FLUSH PRIVILEGES;
