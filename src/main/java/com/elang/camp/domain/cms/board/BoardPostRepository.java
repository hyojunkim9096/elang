package com.elang.camp.domain.cms.board;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface BoardPostRepository extends JpaRepository<BoardPost, Long> {

    List<BoardPost> findByCategoryIdOrderByIsPinnedDescPublishedAtDesc(Long categoryId);

    List<BoardPost> findByCategoryIdAndEnabledOrderByIsPinnedDescPublishedAtDesc(Long categoryId, Boolean enabled);

    Page<BoardPost> findByCategoryIdAndEnabled(Long categoryId, Boolean enabled, Pageable pageable);

    List<BoardPost> findByCategoryIdAndLangAndEnabledOrderByIsPinnedDescPublishedAtDesc(
        Long categoryId, String lang, Boolean enabled
    );

    // 제목으로 검색 (VARCHAR는 IgnoreCase 가능)
    List<BoardPost> findByCategoryIdAndEnabledAndTitleContainingIgnoreCaseOrderByIsPinnedDescPublishedAtDesc(
        Long categoryId, Boolean enabled, String titleKeyword
    );

    // 내용으로 검색 (LONGTEXT는 IgnoreCase가 안되므로 네이티브 쿼리 사용)
    @Query(value = "SELECT * FROM board_post " +
                   "WHERE category_id = :categoryId AND enabled = :enabled AND content LIKE CONCAT('%', :keyword, '%') " +
                   "ORDER BY is_pinned DESC, published_at DESC, id DESC",
           nativeQuery = true)
    List<BoardPost> findByContentContainingWithQuery(
        @Param("categoryId") Long categoryId,
        @Param("enabled") Boolean enabled,
        @Param("keyword") String keyword
    );
}
