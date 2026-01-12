package com.elang.camp.domain.cms.admin.dto;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class AdminUserRes {
    private Long id;
    private String username;
    private String name;
    private String email;
    private String role;
    private Boolean enabled;
    private LocalDateTime lastLoginAt;
    private LocalDateTime createdAt;
}
