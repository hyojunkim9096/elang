package com.elang.camp.domain.cms.board.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Builder
public class BoardCommentRes {
    private Long id;
    private Long postId;
    private Long parentId;
    private String authorName;
    private String content;
    private Boolean isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<BoardCommentRes> replies;  // 대댓글 목록
    private String postTitle;  // 관리자 목록용
}
