package com.elang.camp.domain.cms.admin;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 허용된 Admin IP 목록
 */
@Entity
@Table(name = "allowed_admin_ip")
@Getter @Setter
@NoArgsConstructor
public class AllowedAdminIp {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ip_address", length = 45, nullable = false)
    private String ipAddress;

    @Column(length = 100)
    private String description;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    public AllowedAdminIp(String ipAddress, String description) {
        this.ipAddress = ipAddress;
        this.description = description;
    }
}
