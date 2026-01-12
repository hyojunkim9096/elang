package com.elang.camp.domain.cms.admin.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminUserReq {
    private String username;
    private String password;
    private String name;
    private String email;
    private String role;
    private Boolean enabled;
}
