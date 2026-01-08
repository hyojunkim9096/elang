package com.elang.camp.domain.cms.board;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BoardCategoryRepository extends JpaRepository<BoardCategory, Long> {

    List<BoardCategory> findByLangOrderBySortOrderAsc(String lang);

    List<BoardCategory> findAllByOrderBySortOrderAsc();

    Optional<BoardCategory> findByLangAndCategoryKey(String lang, String categoryKey);

    boolean existsByLangAndCategoryKey(String lang, String categoryKey);
}
