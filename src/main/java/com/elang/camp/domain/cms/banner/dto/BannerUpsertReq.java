package com.elang.camp.domain.cms.banner.dto;

import com.elang.camp.domain.cms.banner.BannerType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BannerUpsertReq {

    @NotBlank(message = "lang은 필수입니다. (ko|en)")
    private String lang;

    /** 카테고리 ID (카테고리가 position 역할) */
    @NotNull(message = "categoryId는 필수입니다.")
    private Long categoryId;

    @NotBlank(message = "title은 필수입니다.")
    @Size(max = 128, message = "title은 128자 이하여야 합니다.")
    private String title;

    @NotNull(message = "type은 필수입니다.")
    private BannerType type;

    /** 배너 URL (이미지 URL 또는 유튜브 URL) */
    private String url;

    /** 배너 클릭 시 이동할 링크 URL */
    private String linkUrl;

    /** 배너 너비(px) */
    private Integer width;

    /** 배너 높이(px) */
    private Integer height;

    @NotNull(message = "sortOrder는 필수입니다.")
    private Integer sortOrder;

    @NotNull(message = "enabled는 필수입니다.")
    private Boolean enabled;

    /** 노출 시작일시 */
    private LocalDateTime startDate;

    /** 노출 종료일시 */
    private LocalDateTime endDate;
}