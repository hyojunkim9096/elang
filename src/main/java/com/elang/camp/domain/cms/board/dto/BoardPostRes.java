package com.elang.camp.domain.cms.board.dto;

import com.elang.camp.domain.cms.board.BoardPost;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

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

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public String getCreatedAtFormatted() {
        return createdAt != null ? createdAt.format(DATE_FORMATTER) : "";
    }

    public String getPublishedAtFormatted() {
        return publishedAt != null ? publishedAt.format(DATE_FORMATTER) : "";
    }

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
