package com.elang.camp.domain.cms.content;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ContentCategoryRepository extends JpaRepository<ContentCategory, Long> {

    List<ContentCategory> findAllByOrderBySortOrderAsc();

    List<ContentCategory> findByLangOrderBySortOrderAsc(String lang);

    List<ContentCategory> findByLangAndEnabledTrueOrderBySortOrderAsc(String lang);

    boolean existsByLangAndCategoryKey(String lang, String categoryKey);

    Optional<ContentCategory> findByLangAndCategoryKey(String lang, String categoryKey);
}
