package com.elang.camp.domain.cms.banner;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BannerCategoryRepository extends JpaRepository<BannerCategory, Long> {

    List<BannerCategory> findByLangOrderBySortOrderAscIdAsc(String lang);

    List<BannerCategory> findByLangAndEnabledTrueOrderBySortOrderAscIdAsc(String lang);

    Optional<BannerCategory> findByLangAndCategoryKey(String lang, String categoryKey);

    boolean existsByLangAndCategoryKey(String lang, String categoryKey);

    List<BannerCategory> findAllByOrderBySortOrderAscIdAsc();
}
