package com.elang.camp.domain.cms.banner;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 사이트 배너 Entity
 * 이미지, 유튜브 영상 등 메인 배너 관리
 */
@Entity
@Table(name = "site_banner")
@Getter @Setter
public class SiteBanner {

    /** 배너 ID */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** 언어 코드 (ko, en) */
    @Column(length = 2, nullable = false)
    private String lang;

    /** 카테고리 ID */
    @Column(name = "category_id")
    private Long categoryId;

    /** 배너 제목 */
    @Column(length = 128, nullable = false)
    private String title;

    /** 배너 타입 (IMAGE, VIDEO, YOUTUBE) */
    @Enumerated(EnumType.STRING)
    @Column(length = 16, nullable = false)
    private BannerType type;

    /** 배너 URL (이미지 URL 또는 유튜브 URL) */
    @Column(length = 1024)
    private String url;

    /** 배너 클릭 시 이동할 링크 URL */
    @Column(name = "link_url", length = 1024)
    private String linkUrl;

    /** 배너 너비(px) */
    @Column(nullable = false)
    private Integer width = 1920;

    /** 배너 높이(px) */
    @Column(nullable = false)
    private Integer height = 200;

    /** 정렬 순서 */
    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder = 0;

    /** 활성화 여부 */
    @Column(nullable = false)
    private Boolean enabled = true;

    /** 노출 시작일시 */
    @Column(name = "start_date")
    private LocalDateTime startDate;

    /** 노출 종료일시 */
    @Column(name = "end_date")
    private LocalDateTime endDate;

    /** 생성일시 */
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    /** 수정일시 */
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
