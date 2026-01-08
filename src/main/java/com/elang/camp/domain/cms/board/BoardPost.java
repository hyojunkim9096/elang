package com.elang.camp.domain.cms.board;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 게시글 Entity
 * 게시판 카테고리별 게시글 관리
 */
@Entity
@Table(name = "board_post")
@Getter @Setter
public class BoardPost {

    /** 게시글 ID */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** 카테고리 ID */
    @Column(name = "category_id", nullable = false)
    private Long categoryId;

    /** 언어 코드 (ko, en) */
    @Column(length = 2, nullable = false)
    private String lang;

    /** 제목 */
    @Column(length = 255, nullable = false)
    private String title;

    /** 본문 (HTML) */
    @Lob
    @Column(nullable = false, columnDefinition = "LONGTEXT")
    private String content;

    /** 썸네일 이미지 URL */
    @Column(length = 1024)
    private String thumbnail;

    /** 조회수 */
    @Column(name = "view_count", nullable = false)
    private Integer viewCount = 0;

    /** 상단 고정 여부 */
    @Column(name = "is_pinned", nullable = false)
    private Boolean isPinned = false;

    /** 활성화 여부 */
    @Column(nullable = false)
    private Boolean enabled = true;

    /** 게시일 */
    @Column(name = "published_at")
    private LocalDateTime publishedAt;

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
