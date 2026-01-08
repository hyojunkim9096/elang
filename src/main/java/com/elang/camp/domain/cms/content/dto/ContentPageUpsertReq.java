package com.elang.camp.domain.cms.content.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class ContentPageUpsertReq {

    @NotNull
    private Long categoryId;

    @NotBlank
    private String title;

    @NotBlank
    private String content;

    @NotNull
    private Boolean enabled;
}
