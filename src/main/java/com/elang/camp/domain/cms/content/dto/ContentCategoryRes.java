package com.elang.camp.domain.cms.content.dto;

import com.elang.camp.domain.cms.content.ContentCategory;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class ContentCategoryRes {
    private Long id;
    private String lang;
    private String categoryKey;
    private String name;
    private String description;
    private Integer sortOrder;
    private Boolean enabled;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static ContentCategoryRes from(ContentCategory category) {
        return ContentCategoryRes.builder()
            .id(category.getId())
            .lang(category.getLang())
            .categoryKey(category.getCategoryKey())
            .name(category.getName())
            .description(category.getDescription())
            .sortOrder(category.getSortOrder())
            .enabled(category.getEnabled())
            .createdAt(category.getCreatedAt())
            .updatedAt(category.getUpdatedAt())
            .build();
    }
}
