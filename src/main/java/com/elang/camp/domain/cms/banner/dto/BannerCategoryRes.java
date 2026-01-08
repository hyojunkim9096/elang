package com.elang.camp.domain.cms.banner.dto;

import com.elang.camp.domain.cms.banner.BannerCategory;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class BannerCategoryRes {
    private Long id;
    private String lang;
    private String categoryKey;
    private String name;
    private String description;
    private Integer sortOrder;
    private Boolean enabled;
    private Integer popupMaxCount;
    private Integer popupDuration;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static BannerCategoryRes from(BannerCategory category) {
        return BannerCategoryRes.builder()
            .id(category.getId())
            .lang(category.getLang())
            .categoryKey(category.getCategoryKey())
            .name(category.getName())
            .description(category.getDescription())
            .sortOrder(category.getSortOrder())
            .enabled(category.getEnabled())
            .popupMaxCount(category.getPopupMaxCount())
            .popupDuration(category.getPopupDuration())
            .createdAt(category.getCreatedAt())
            .updatedAt(category.getUpdatedAt())
            .build();
    }
}
