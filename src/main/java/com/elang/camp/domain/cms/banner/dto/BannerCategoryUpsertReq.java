package com.elang.camp.domain.cms.banner.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BannerCategoryUpsertReq {
    @NotBlank
    private String lang;

    @NotBlank
    private String categoryKey;

    @NotBlank
    private String name;

    private String description;

    @NotNull
    private Integer sortOrder = 0;

    @NotNull
    private Boolean enabled = true;

    /** 팝업 최대 동시 표시 개수 (popup_banner만 사용) */
    private Integer popupMaxCount;

    /** 팝업 자동 닫힘 시간(초) (popup_banner만 사용) */
    private Integer popupDuration;
}
