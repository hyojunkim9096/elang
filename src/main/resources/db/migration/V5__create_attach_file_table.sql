-- 첨부파일 테이블 생성
CREATE TABLE attach_file (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    original_name VARCHAR(255) NOT NULL COMMENT '원본 파일명',
    saved_name VARCHAR(255) NOT NULL COMMENT '저장된 파일명 (UUID)',
    file_path VARCHAR(500) NOT NULL COMMENT '파일 저장 경로',
    file_size BIGINT NOT NULL DEFAULT 0 COMMENT '파일 크기 (bytes)',
    content_type VARCHAR(100) COMMENT '파일 MIME 타입',
    file_extension VARCHAR(20) COMMENT '파일 확장자',
    upload_type VARCHAR(50) DEFAULT 'general' COMMENT '업로드 유형 (thumbnail, editor, general)',
    reference_type VARCHAR(50) COMMENT '참조 엔티티 타입 (board_post, content_page 등)',
    reference_id BIGINT COMMENT '참조 엔티티 ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '업로드 일시',
    INDEX idx_reference (reference_type, reference_id),
    INDEX idx_upload_type (upload_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='첨부파일';
