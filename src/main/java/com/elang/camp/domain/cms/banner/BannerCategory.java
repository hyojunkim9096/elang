package com.elang.camp.domain.cms.banner;

import com.elang.camp.domain.cms.base.BaseCategory;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.Getter;
import lombok.Setter;

/**
 * 배너 카테고리 Entity
 * Position 기반 카테고리 (상단, 중간, 하단, 팝업, 사이드)
 */
@Entity
@Table(name = "banner_category",
    uniqueConstraints = @UniqueConstraint(columnNames = {"lang", "category_key"})
)
@Getter
@Setter
public class BannerCategory extends BaseCategory {

    /** 팝업 최대 동시 표시 개수 (popup_banner만 사용) */
    @Column(name = "popup_max_count")
    private Integer popupMaxCount;

    /** 팝업 자동 닫힘 시간(초, 0=수동) (popup_banner만 사용) */
    @Column(name = "popup_duration")
    private Integer popupDuration;
}
