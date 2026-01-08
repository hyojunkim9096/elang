package com.elang.camp.domain.cms.board.dto;

import com.elang.camp.domain.cms.board.BoardPost;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@AllArgsConstructor
public class BoardPostRes {
    private Long id;
    private Long categoryId;
    private String lang;
    private String title;
    private String content;
    private String thumbnail;
    private Integer viewCount;
    private Boolean isPinned;
    private Boolean enabled;
    private LocalDateTime publishedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static BoardPostRes from(BoardPost entity) {
        return new BoardPostRes(
            entity.getId(),
            entity.getCategoryId(),
            entity.getLang(),
            entity.getTitle(),
            entity.getContent(),
            entity.getThumbnail(),
            entity.getViewCount(),
            entity.getIsPinned(),
            entity.getEnabled(),
            entity.getPublishedAt(),
            entity.getCreatedAt(),
            entity.getUpdatedAt()
        );
    }
}
