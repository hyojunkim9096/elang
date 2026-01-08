package com.elang.camp.domain.cms.content;

import com.elang.camp.domain.cms.base.BaseCategory;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.Getter;
import lombok.Setter;

/**
 * 컨텐츠 카테고리 Entity
 * 고정 페이지의 카테고리 (about, program, instructor 등)
 */
@Entity
@Table(name = "content_category",
    uniqueConstraints = @UniqueConstraint(columnNames = {"lang", "category_key"})
)
@Getter
@Setter
public class ContentCategory extends BaseCategory {
    // 모든 필드는 BaseCategory에서 상속
}
