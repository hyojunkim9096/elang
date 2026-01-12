-- Admin 접근 설정 테이블
CREATE TABLE admin_config (
    id VARCHAR(10) NOT NULL DEFAULT 'default',
    access_mode VARCHAR(20) NOT NULL DEFAULT 'ALL',
    updated_at DATETIME,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 허용 Admin IP 테이블
CREATE TABLE allowed_admin_ip (
    id BIGINT AUTO_INCREMENT,
    ip_address VARCHAR(45) NOT NULL,
    description VARCHAR(100),
    created_at DATETIME,
    PRIMARY KEY (id),
    UNIQUE KEY uk_ip_address (ip_address)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 기본 설정 삽입
INSERT INTO admin_config (id, access_mode, updated_at) VALUES ('default', 'ALL', NOW());
