package com.elang.camp.domain.cms.menu;

import com.elang.camp.common.exception.BadRequestException;
import com.elang.camp.common.lang.Lang;
import com.elang.camp.domain.cms.menu.dto.MenuRes;
import com.elang.camp.domain.cms.menu.dto.MenuUpsertReq;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SiteMenuService {

    private final SiteMenuRepository repository;

    @Transactional(readOnly = true)
    public List<MenuRes> list(String langRaw, boolean enabledOnly) {
        Lang lang = Lang.from(langRaw);
        List<SiteMenu> list = enabledOnly
                ? repository.findByLangAndEnabledTrueOrderBySortOrderAscIdAsc(lang.code())
                : repository.findByLangOrderBySortOrderAscIdAsc(lang.code());
        return list.stream().map(this::toRes).toList();
    }

    @Transactional(readOnly = true)
    public List<MenuRes> list(String langRaw, String menuType, boolean enabledOnly) {
        Lang lang = Lang.from(langRaw);
        List<SiteMenu> list = enabledOnly
                ? repository.findByLangAndMenuTypeAndEnabledTrueOrderBySortOrderAscIdAsc(lang.code(), menuType)
                : repository.findByLangAndMenuTypeOrderBySortOrderAscIdAsc(lang.code(), menuType);
        return list.stream().map(this::toRes).toList();
    }

    @Transactional
    public MenuRes create(MenuUpsertReq req) {
        if (req == null) throw new BadRequestException("요청 바디가 비어있습니다.");
        Lang lang = Lang.from(req.getLang());

        SiteMenu m = new SiteMenu();
        m.setLang(lang.code());
        m.setMenuType(req.getMenuType());
        m.setParentId(req.getParentId());
        m.setLabel(req.getLabel() == null ? "" : req.getLabel().trim());
        m.setHref(req.getHref() == null ? "" : req.getHref().trim());

        // sortOrder가 null이면 마지막 순서로 자동 설정
        if (req.getSortOrder() == null || req.getSortOrder() == 0) {
            // 같은 레벨(parentId)의 메뉴 중 가장 큰 sortOrder 찾기
            List<SiteMenu> siblings = repository.findByLangAndMenuTypeOrderBySortOrderAscIdAsc(lang.code(), req.getMenuType());
            int maxOrder = siblings.stream()
                .filter(menu -> {
                    if (req.getParentId() == null) {
                        return menu.getParentId() == null || menu.getParentId() == 0;
                    }
                    return req.getParentId().equals(menu.getParentId());
                })
                .mapToInt(menu -> menu.getSortOrder() == null ? 0 : menu.getSortOrder())
                .max()
                .orElse(0);
            m.setSortOrder(maxOrder + 1);
        } else {
            m.setSortOrder(req.getSortOrder());
        }

        m.setEnabled(req.getEnabled());

        return toRes(repository.save(m));
    }

    @Transactional
    public MenuRes update(Long id, MenuUpsertReq req) {
        if (id == null) throw new BadRequestException("id가 필요합니다.");
        if (req == null) throw new BadRequestException("요청 바디가 비어있습니다.");

        SiteMenu m = repository.findById(id)
                .orElseThrow(() -> new BadRequestException("메뉴가 존재하지 않습니다. id=" + id));

        Lang lang = Lang.from(req.getLang());
        m.setLang(lang.code());
        m.setMenuType(req.getMenuType());
        m.setParentId(req.getParentId());
        m.setLabel(req.getLabel() == null ? "" : req.getLabel().trim());
        m.setHref(req.getHref() == null ? "" : req.getHref().trim());
        m.setSortOrder(req.getSortOrder());
        m.setEnabled(req.getEnabled());

        return toRes(m);
    }

    @Transactional
    public void delete(Long id) {
        if (id == null) throw new BadRequestException("id가 필요합니다.");
        repository.deleteById(id);
    }

    @Transactional
    public void reorder(List<Long> menuIds) {
        if (menuIds == null || menuIds.isEmpty()) return;

        // 각 메뉴의 sortOrder를 순서대로 업데이트
        for (int i = 0; i < menuIds.size(); i++) {
            Long menuId = menuIds.get(i);
            SiteMenu menu = repository.findById(menuId)
                .orElseThrow(() -> new BadRequestException("메뉴가 존재하지 않습니다. id=" + menuId));

            menu.setSortOrder(i + 1);
            // Dirty Checking으로 자동 UPDATE
        }
    }

    @Transactional
    public void toggleFavorite(Long id) {
        if (id == null) throw new BadRequestException("id가 필요합니다.");
        SiteMenu menu = repository.findById(id)
            .orElseThrow(() -> new BadRequestException("메뉴가 존재하지 않습니다. id=" + id));

        boolean newFavoriteState = !menu.getIsFavorite();
        menu.setIsFavorite(newFavoriteState);

        // 즐겨찾기 추가 시 favoriteOrder 설정 (기존 최대값 + 1)
        if (newFavoriteState && menu.getFavoriteOrder() == null) {
            List<SiteMenu> favorites = repository.findByMenuTypeAndIsFavoriteTrueOrderBySortOrderAscIdAsc(menu.getMenuType());
            int maxOrder = favorites.stream()
                .filter(m -> m.getFavoriteOrder() != null)
                .mapToInt(SiteMenu::getFavoriteOrder)
                .max()
                .orElse(0);
            menu.setFavoriteOrder(maxOrder + 1);
        }
    }

    @Transactional
    public void reorderFavorites(List<Long> menuIds) {
        if (menuIds == null || menuIds.isEmpty()) return;

        // 각 메뉴의 favoriteOrder를 순서대로 업데이트
        for (int i = 0; i < menuIds.size(); i++) {
            Long menuId = menuIds.get(i);
            SiteMenu menu = repository.findById(menuId)
                .orElseThrow(() -> new BadRequestException("메뉴가 존재하지 않습니다. id=" + menuId));

            menu.setFavoriteOrder(i + 1);
            // Dirty Checking으로 자동 UPDATE
        }
    }

    @Transactional(readOnly = true)
    public List<MenuRes> getFavorites(String menuType) {
        List<SiteMenu> favorites = repository.findByMenuTypeAndIsFavoriteTrueOrderByFavoriteOrderAscIdAsc(menuType);
        return favorites.stream().map(this::toRes).toList();
    }

    @Transactional(readOnly = true)
    public List<MenuRes> getFavorites(String menuType, String lang) {
        Lang langObj = Lang.from(lang);
        List<SiteMenu> favorites = repository.findByMenuTypeAndIsFavoriteTrueOrderByFavoriteOrderAscIdAsc(menuType);
        return favorites.stream()
            .filter(m -> langObj.code().equals(m.getLang()))
            .map(this::toRes)
            .toList();
    }

    private MenuRes toRes(SiteMenu m) {
        return new MenuRes(m.getId(), m.getLang(), m.getMenuType(), m.getParentId(), m.getLabel(), m.getHref(), m.getSortOrder(), m.getEnabled(), m.getIsFavorite());
    }
}
