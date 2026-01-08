-- ============================================================================
-- local-db-init.sql
-- ----------------------------------------------------------------------------
-- 로컬(Homebrew) MariaDB에서 "DB + 앱 계정"을 만드는 부트스트랩 스크립트
--
-- ✅ 중요: 이 파일은 CREATE USER / GRANT 를 포함하므로
--          반드시 "CREATE USER 권한"이 있는 계정으로 실행해야 합니다.
--
-- Homebrew MariaDB를 mariadb-install-db로 초기화하면 보통 아래와 같은 계정이
-- 생성됩니다.
--   - root@localhost (비번 없음) : 시스템 root(sudo)로만 접속 가능(unix_socket)
--   - <mac사용자>@localhost (비번 없음) : 현재 mac 사용자로만 접속 가능(unix_socket)
--
-- 따라서 아래 둘 중 하나로 실행하세요.
--   1) mac 사용자 계정(추천, 보통 비번 없이 접속됨)
--      mariadb -u "$(whoami)" < scripts/local-db-init.sql
--   2) 시스템 root로 접속(sudo 비번은 "Mac 로그인 비번")
--      sudo mariadb < scripts/local-db-init.sql
--
-- 실행 후에는 Spring Boot가 아래 계정으로 접속합니다.
--   - username: elang
--   - password: elang1234
--   - database: elang_camp
-- ============================================================================

-- DB 생성
CREATE DATABASE IF NOT EXISTS elang_camp
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- 계정 생성/보정
-- (localhost / 127.0.0.1 둘 다 만들어 두면 JDBC/CLI 차이로 인한 접속 문제를 줄일 수 있습니다)
CREATE USER IF NOT EXISTS 'elang'@'localhost' IDENTIFIED BY 'elang1234';
CREATE USER IF NOT EXISTS 'elang'@'127.0.0.1' IDENTIFIED BY 'elang1234';

-- 이미 존재하는 경우 비밀번호를 원하는 값으로 "강제" 맞춤
ALTER USER 'elang'@'localhost' IDENTIFIED BY 'elang1234';
ALTER USER 'elang'@'127.0.0.1' IDENTIFIED BY 'elang1234';

-- 권한 부여
GRANT ALL PRIVILEGES ON elang_camp.* TO 'elang'@'localhost';
GRANT ALL PRIVILEGES ON elang_camp.* TO 'elang'@'127.0.0.1';
FLUSH PRIVILEGES;

-- 확인용(실행 결과 확인)
SELECT 'OK' AS result;
