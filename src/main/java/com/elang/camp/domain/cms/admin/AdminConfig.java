package com.elang.camp.domain.cms.admin;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * Admin 설정 Entity (싱글톤)
 */
@Entity
@Table(name = "admin_config")
@Getter @Setter
public class AdminConfig {

    @Id
    @Column(length = 10)
    private String id = "default";

    /**
     * Admin 접근 모드
     * ALL: 모든 IP 허용
     * IP_ONLY: 등록된 IP만 허용
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "access_mode", length = 20, nullable = false)
    private AccessMode accessMode = AccessMode.ALL;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    public enum AccessMode {
        ALL,      // 전체 허용
        IP_ONLY   // IP 제한
    }
}
