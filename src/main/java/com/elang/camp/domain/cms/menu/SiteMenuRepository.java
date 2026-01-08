package com.elang.camp.domain.cms.menu;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SiteMenuRepository extends JpaRepository<SiteMenu, Long> {

    List<SiteMenu> findByLangOrderBySortOrderAscIdAsc(String lang);

    List<SiteMenu> findByLangAndEnabledTrueOrderBySortOrderAscIdAsc(String lang);

    List<SiteMenu> findByLangAndMenuTypeOrderBySortOrderAscIdAsc(String lang, String menuType);

    List<SiteMenu> findByLangAndMenuTypeAndEnabledTrueOrderBySortOrderAscIdAsc(String lang, String menuType);

    List<SiteMenu> findByMenuTypeAndIsFavoriteTrueOrderBySortOrderAscIdAsc(String menuType);

    List<SiteMenu> findByMenuTypeAndIsFavoriteTrueOrderByFavoriteOrderAscIdAsc(String menuType);
}
