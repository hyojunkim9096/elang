package com.elang.camp.domain.cms.base;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 카테고리 Base Entity
 * BoardCategory, ContentCategory, BannerCategory의 공통 필드 추출
 */
@MappedSuperclass
@Getter
@Setter
public abstract class BaseCategory {

    /** 카테고리 ID */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** 언어 코드 (ko, en) */
    @Column(length = 2, nullable = false)
    private String lang;

    /** 카테고리 식별 키 */
    @Column(name = "category_key", length = 64, nullable = false)
    private String categoryKey;

    /** 카테고리 명 */
    @Column(length = 128, nullable = false)
    private String name;

    /** 설명 */
    @Column(length = 255)
    private String description;

    /** 정렬 순서 */
    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder = 0;

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
