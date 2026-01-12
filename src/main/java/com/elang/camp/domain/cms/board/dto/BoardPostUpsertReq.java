package com.elang.camp.domain.cms.board.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter @Setter
public class BoardPostUpsertReq {

    @NotNull
    private Long categoryId;

    @NotBlank
    private String lang;

    @NotBlank
    private String title;

    @NotBlank
    private String content;

    private String thumbnail;

    @NotNull
    private Boolean isPinned;

    @NotNull
    private Boolean enabled;

    private Boolean commentsEnabled = true;

    private LocalDateTime publishedAt;

    // 첨부파일 IDs (쉼표로 구분된 문자열)
    private String attachmentIds;
}
