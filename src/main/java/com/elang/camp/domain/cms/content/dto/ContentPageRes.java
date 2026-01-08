package com.elang.camp.domain.cms.content.dto;

import com.elang.camp.domain.cms.content.ContentPage;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@AllArgsConstructor
public class ContentPageRes {
    private Long id;
    private String lang;
    private String pageKey;
    private String title;
    private String content;
    private Boolean enabled;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static ContentPageRes from(ContentPage entity) {
        return new ContentPageRes(
            entity.getId(),
            entity.getLang(),
            entity.getPageKey(),
            entity.getTitle(),
            entity.getContent(),
            entity.getEnabled(),
            entity.getCreatedAt(),
            entity.getUpdatedAt()
        );
    }
}
