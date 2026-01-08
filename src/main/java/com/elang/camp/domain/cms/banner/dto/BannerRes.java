package com.elang.camp.domain.cms.banner.dto;

import com.elang.camp.domain.cms.banner.BannerType;
import com.elang.camp.domain.cms.banner.SiteBanner;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BannerRes {
    private Long id;
    private String lang;
    private Long categoryId;
    private String title;
    private BannerType type;
    private String url;
    private String linkUrl;
    private Integer width;
    private Integer height;
    private Integer sortOrder;
    private Boolean enabled;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static BannerRes from(SiteBanner banner) {
        return BannerRes.builder()
            .id(banner.getId())
            .lang(banner.getLang())
            .categoryId(banner.getCategoryId())
            .title(banner.getTitle())
            .type(banner.getType())
            .url(banner.getUrl())
            .linkUrl(banner.getLinkUrl())
            .width(banner.getWidth())
            .height(banner.getHeight())
            .sortOrder(banner.getSortOrder())
            .enabled(banner.getEnabled())
            .startDate(banner.getStartDate())
            .endDate(banner.getEndDate())
            .createdAt(banner.getCreatedAt())
            .updatedAt(banner.getUpdatedAt())
            .build();
    }

    // Helper methods for JSP
    public String getTypeName() {
        return type != null ? type.name() : null;
    }

    public boolean isImageType() {
        return type == BannerType.IMAGE;
    }

    public boolean isYoutubeType() {
        return type == BannerType.YOUTUBE;
    }

    public String getFormattedStartDate() {
        if (startDate == null) return null;
        return startDate.toString().substring(0, 16); // yyyy-MM-ddTHH:mm
    }

    public String getFormattedEndDate() {
        if (endDate == null) return null;
        return endDate.toString().substring(0, 16); // yyyy-MM-ddTHH:mm
    }
}