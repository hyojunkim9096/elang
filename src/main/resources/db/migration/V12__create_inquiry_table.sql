-- V12: 상담/문의 테이블 생성

CREATE TABLE IF NOT EXISTS inquiry (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '문의 ID',
    lang VARCHAR(2) NOT NULL DEFAULT 'ko' COMMENT '언어 코드 (ko, en)',
    name VARCHAR(100) NOT NULL COMMENT '이름',
    email VARCHAR(255) COMMENT '이메일',
    phone VARCHAR(20) COMMENT '연락처',
    subject VARCHAR(255) NOT NULL COMMENT '제목',
    content TEXT NOT NULL COMMENT '문의 내용',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '상태 (PENDING, IN_PROGRESS, COMPLETED)',
    admin_memo TEXT COMMENT '관리자 메모',
    is_read BOOLEAN NOT NULL DEFAULT FALSE COMMENT '읽음 여부',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일시',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='상담/문의';

-- 인덱스 추가
CREATE INDEX idx_inquiry_lang ON inquiry(lang);
CREATE INDEX idx_inquiry_status ON inquiry(status);
CREATE INDEX idx_inquiry_is_read ON inquiry(is_read);
CREATE INDEX idx_inquiry_created_at ON inquiry(created_at DESC);
