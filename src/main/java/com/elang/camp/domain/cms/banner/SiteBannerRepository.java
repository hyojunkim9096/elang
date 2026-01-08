package com.elang.camp.domain.cms.banner;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface SiteBannerRepository extends JpaRepository<SiteBanner, Long> {

    List<SiteBanner> findByLangOrderBySortOrderAscIdAsc(String lang);

    List<SiteBanner> findByLangAndEnabledTrueOrderBySortOrderAscIdAsc(String lang);

    List<SiteBanner> findByCategoryIdOrderBySortOrderAscIdAsc(Long categoryId);

    @Query("SELECT b FROM SiteBanner b WHERE b.lang = :lang AND b.categoryId = :categoryId AND b.enabled = true " +
           "AND (b.startDate IS NULL OR b.startDate <= :now) " +
           "AND (b.endDate IS NULL OR b.endDate >= :now) " +
           "ORDER BY b.sortOrder ASC, b.id ASC")
    List<SiteBanner> findActiveByCategoryId(@Param("lang") String lang,
                                             @Param("categoryId") Long categoryId,
                                             @Param("now") LocalDateTime now);
}
