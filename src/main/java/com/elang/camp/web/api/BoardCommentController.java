package com.elang.camp.web.api;

import com.elang.camp.common.api.ApiResponse;
import com.elang.camp.domain.cms.board.BoardCommentService;
import com.elang.camp.domain.cms.board.dto.BoardCommentReq;
import com.elang.camp.domain.cms.board.dto.BoardCommentRes;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
public class BoardCommentController {

    private final BoardCommentService commentService;

    /**
     * 게시글의 댓글 목록 조회
     */
    @GetMapping("/post/{postId}")
    public ApiResponse<List<BoardCommentRes>> listByPost(@PathVariable Long postId) {
        return ApiResponse.ok(commentService.listByPostId(postId));
    }

    /**
     * 댓글 작성
     */
    @PostMapping
    public ApiResponse<BoardCommentRes> create(@RequestBody BoardCommentReq req) {
        try {
            return ApiResponse.ok(commentService.create(req));
        } catch (IllegalStateException | IllegalArgumentException e) {
            return ApiResponse.fail(e.getMessage());
        }
    }

    /**
     * 댓글 수정
     */
    @PutMapping("/{id}")
    public ApiResponse<BoardCommentRes> update(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        try {
            String content = body.get("content");
            String password = body.get("password");
            return ApiResponse.ok(commentService.update(id, content, password));
        } catch (IllegalArgumentException e) {
            return ApiResponse.fail(e.getMessage());
        }
    }

    /**
     * 댓글 삭제
     */
    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(
            @PathVariable Long id,
            @RequestParam(required = false) String password) {
        try {
            commentService.delete(id, password);
            return ApiResponse.ok(null);
        } catch (IllegalArgumentException e) {
            return ApiResponse.fail(e.getMessage());
        }
    }

    /**
     * 관리자용 댓글 삭제
     */
    @DeleteMapping("/admin/{id}")
    public ApiResponse<Void> deleteByAdmin(@PathVariable Long id) {
        commentService.deleteByAdmin(id);
        return ApiResponse.ok(null);
    }
}
