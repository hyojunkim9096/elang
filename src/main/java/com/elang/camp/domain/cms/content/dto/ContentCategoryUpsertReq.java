package com.elang.camp.domain.cms.content.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class ContentCategoryUpsertReq {

    @NotBlank
    private String lang;

    @NotBlank
    private String categoryKey;

    @NotBlank
    private String name;

    private String description;

    private Integer sortOrder;

    private Boolean enabled;
}
