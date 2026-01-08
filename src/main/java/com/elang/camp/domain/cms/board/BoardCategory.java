package com.elang.camp.domain.cms.board;

import com.elang.camp.domain.cms.base.BaseCategory;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

/**
 * 게시판 카테고리 Entity
 * 공지사항, 뉴스 등 게시판 카테고리 관리
 */
@Entity
@Table(name = "board_category",
    uniqueConstraints = @UniqueConstraint(columnNames = {"lang", "category_key"})
)
@Getter
@Setter
public class BoardCategory extends BaseCategory {

    /** 표시 타입 (LIST, CARD, THUMBNAIL) */
    @Enumerated(EnumType.STRING)
    @Column(name = "display_type", length = 16, nullable = false)
    private DisplayType displayType = DisplayType.LIST;
}
