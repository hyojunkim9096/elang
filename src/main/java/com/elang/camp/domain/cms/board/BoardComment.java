package com.elang.camp.domain.cms.board;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 게시글 댓글 Entity
 */
@Entity
@Table(name = "board_comment")
@Getter @Setter
public class BoardComment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** 게시글 ID */
    @Column(name = "post_id", nullable = false)
    private Long postId;

    /** 부모 댓글 ID (대댓글인 경우) */
    @Column(name = "parent_id")
    private Long parentId;

    /** 작성자 이름 */
    @Column(name = "author_name", length = 50, nullable = false)
    private String authorName;

    /** 작성자 이메일 */
    @Column(name = "author_email", length = 100)
    private String authorEmail;

    /** 비밀번호 (비회원 댓글 수정/삭제용) */
    @Column(length = 255)
    private String password;

    /** 댓글 내용 */
    @Column(columnDefinition = "TEXT", nullable = false)
    private String content;

    /** 삭제 여부 */
    @Column(name = "is_deleted", nullable = false)
    private Boolean isDeleted = false;

    /** 생성일시 */
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    /** 수정일시 */
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
