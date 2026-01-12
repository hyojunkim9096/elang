package com.elang.camp.domain.cms.board.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardCommentReq {
    private Long postId;
    private Long parentId;
    private String authorName;
    private String authorEmail;
    private String password;
    private String content;
}
