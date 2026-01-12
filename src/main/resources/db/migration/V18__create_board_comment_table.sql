-- 게시글 댓글 테이블
CREATE TABLE board_comment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    post_id BIGINT NOT NULL,
    parent_id BIGINT DEFAULT NULL,
    author_name VARCHAR(50) NOT NULL,
    author_email VARCHAR(100),
    password VARCHAR(255),
    content TEXT NOT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    FOREIGN KEY (post_id) REFERENCES board_post(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES board_comment(id) ON DELETE CASCADE,
    INDEX idx_post_id (post_id),
    INDEX idx_parent_id (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 게시글에 댓글 허용 여부 컬럼 추가
ALTER TABLE board_post ADD COLUMN comments_enabled BOOLEAN NOT NULL DEFAULT TRUE AFTER enabled;
