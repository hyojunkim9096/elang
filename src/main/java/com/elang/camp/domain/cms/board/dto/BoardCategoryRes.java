package com.elang.camp.domain.cms.board.dto;

import com.elang.camp.domain.cms.board.BoardCategory;
import com.elang.camp.domain.cms.board.DisplayType;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@AllArgsConstructor
public class BoardCategoryRes {
    private Long id;
    private String lang;
    private String categoryKey;
    private String name;
    private String description;
    private DisplayType displayType;
    private Integer sortOrder;
    private Boolean enabled;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static BoardCategoryRes from(BoardCategory entity) {
        return new BoardCategoryRes(
            entity.getId(),
            entity.getLang(),
            entity.getCategoryKey(),
            entity.getName(),
            entity.getDescription(),
            entity.getDisplayType(),
            entity.getSortOrder(),
            entity.getEnabled(),
            entity.getCreatedAt(),
            entity.getUpdatedAt()
        );
    }
}
