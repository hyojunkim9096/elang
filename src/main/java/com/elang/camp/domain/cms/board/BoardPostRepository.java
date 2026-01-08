package com.elang.camp.domain.cms.board;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BoardPostRepository extends JpaRepository<BoardPost, Long> {

    List<BoardPost> findByCategoryIdOrderByIsPinnedDescPublishedAtDesc(Long categoryId);

    List<BoardPost> findByCategoryIdAndEnabledOrderByIsPinnedDescPublishedAtDesc(Long categoryId, Boolean enabled);

    Page<BoardPost> findByCategoryIdAndEnabled(Long categoryId, Boolean enabled, Pageable pageable);

    List<BoardPost> findByCategoryIdAndLangAndEnabledOrderByIsPinnedDescPublishedAtDesc(
        Long categoryId, String lang, Boolean enabled
    );
}
