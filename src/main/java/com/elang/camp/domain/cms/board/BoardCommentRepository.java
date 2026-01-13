package com.elang.camp.domain.cms.board;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface BoardCommentRepository extends JpaRepository<BoardComment, Long> {

    /** 게시글의 모든 댓글 조회 (최신순) */
    List<BoardComment> findByPostIdOrderByCreatedAtAsc(Long postId);

    /** 게시글의 루트 댓글만 조회 (parentId가 null인 것) */
    List<BoardComment> findByPostIdAndParentIdIsNullOrderByCreatedAtAsc(Long postId);

    /** 특정 댓글의 대댓글 조회 */
    List<BoardComment> findByParentIdOrderByCreatedAtAsc(Long parentId);

    /** 게시글의 댓글 수 (삭제되지 않은 것만) */
    @Query("SELECT COUNT(c) FROM BoardComment c WHERE c.postId = :postId AND c.isDeleted = false")
    long countByPostId(@Param("postId") Long postId);

    /** 게시글 삭제 시 관련 댓글 모두 삭제 */
    void deleteByPostId(Long postId);

    /** 모든 댓글 조회 (최신순) - 관리자용 */
    List<BoardComment> findAllByOrderByCreatedAtDesc();
}
