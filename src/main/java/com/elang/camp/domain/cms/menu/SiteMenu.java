package com.elang.camp.domain.cms.menu;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 사이트 메뉴 Entity
 * 계층형 구조 지원 (parent_id)
 * 관리자/사용자 메뉴 구분 (menu_type)
 */
@Entity
@Table(name = "site_menu")
@Getter @Setter
public class SiteMenu {

    /** 메뉴 ID */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** 언어 코드 (ko, en) */
    @Column(length = 2, nullable = false)
    private String lang;

    /** 메뉴 타입 (public: 사용자메뉴, admin: 관리자메뉴) */
    @Column(name = "menu_type", length = 10, nullable = false)
    private String menuType = "public";

    /** 상위 메뉴 ID (NULL이면 1뎁스) */
    @Column(name = "parent_id")
    private Long parentId;

    /** 메뉴 라벨 */
    @Column(length = 64, nullable = false)
    private String label;

    /** 링크 URL */
    @Column(length = 255, nullable = false)
    private String href;

    /** 정렬 순서 */
    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder;

    /** 활성화 여부 */
    @Column(nullable = false)
    private Boolean enabled;

    /** 즐겨찾기 여부 (대시보드 표시) */
    @Column(name = "is_favorite", nullable = false)
    private Boolean isFavorite = false;

    /** 즐겨찾기 정렬 순서 (즐겨찾기 전용) */
    @Column(name = "favorite_order")
    private Integer favoriteOrder;

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
