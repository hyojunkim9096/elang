-- V20: 문제 변형 테이블 생성

CREATE TABLE IF NOT EXISTS question_transform (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '변형 ID',
    original_text TEXT NOT NULL COMMENT '원본 지문/문제',
    difficulty VARCHAR(10) NOT NULL COMMENT '난이도 (HIGH, MEDIUM, LOW)',
    transformed_text TEXT COMMENT '변형된 문제',
    analysis TEXT COMMENT 'AI 분석 결과',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '처리 상태',
    error_message TEXT COMMENT '에러 메시지',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='문제 변형';

CREATE INDEX idx_question_transform_difficulty ON question_transform(difficulty);
CREATE INDEX idx_question_transform_status ON question_transform(status);
CREATE INDEX idx_question_transform_created_at ON question_transform(created_at DESC);
