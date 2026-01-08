package com.elang.camp.domain.cms.menu.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MenuRes {
    private Long id;
    private String lang;
    private String menuType;
    private Long parentId;
    private String label;
    private String href;
    private Integer sortOrder;
    private Boolean enabled;
    private Boolean isFavorite;
}