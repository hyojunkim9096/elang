package com.elang.camp.domain.cms.content;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 컨텐츠 페이지 Entity
 * 고정 페이지(회사소개, 프로그램 소개 등) 관리
 */
@Entity
@Table(name = "content_page")
@Getter @Setter
public class ContentPage {

    /** 페이지 ID */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** 카테고리 ID */
    @Column(name = "category_id")
    private Long categoryId;

    /** 언어 코드 (ko, en) */
    @Column(length = 2, nullable = false)
    private String lang;

    /** 페이지 식별 키 (Deprecated - 카테고리로 대체) */
    @Column(name = "page_key", length = 64)
    private String pageKey;

    /** 페이지 제목 */
    @Column(length = 128, nullable = false)
    private String title;

    /** HTML 컨텐츠 */
    @Lob
    @Column(nullable = false, columnDefinition = "LONGTEXT")
    private String content;

    /** 활성화 여부 */
    @Column(nullable = false)
    private Boolean enabled = true;

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
