package com.elang.camp.web.admin.base;

import com.elang.camp.domain.cms.base.AbstractCategoryService;
import com.elang.camp.domain.cms.base.BaseCategory;
import com.elang.camp.domain.cms.menu.SiteMenuService;
import com.elang.camp.domain.cms.menu.dto.MenuRes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * 카테고리 Controller Base Class
 * BoardCategory, ContentCategory, BannerCategory 컨트롤러의 공통 로직 추출
 *
 * @param <T> Category Entity 타입
 * @param <R> Category Response DTO 타입
 * @param <Q> Category Upsert Request DTO 타입
 * @param <S> Category Service 타입
 */
public abstract class AbstractCategoryController<T extends BaseCategory, R, Q, S extends AbstractCategoryService<T, R, Q, ?>> {

    protected final S categoryService;

    @Autowired
    protected SiteMenuService menuService;

    protected AbstractCategoryController(S categoryService) {
        this.categoryService = categoryService;
    }

    /**
     * Model에 공통 속성 추가 (adminMenus 포함)
     */
    protected void addCommonAttributesWithMenus(Model model, String title, String activeMenu, String lang) {
        model.addAttribute("pageTitle", title);
        model.addAttribute("title", title);
        model.addAttribute("active", activeMenu);
        model.addAttribute("activeMenu", activeMenu);
        model.addAttribute("adminLang", lang);
        model.addAttribute("lang", lang);

        // 관리자 메뉴 로드
        List<MenuRes> adminMenus = menuService.list(lang, "admin", true);
        model.addAttribute("adminMenus", adminMenus);
    }

    /**
     * 카테고리 목록 페이지
     */
    @GetMapping
    public String list(@RequestParam(required = false, defaultValue = "ko") String lang, Model model) {
        addCommonAttributesWithMenus(model, getListPageTitle(), getActiveMenu(), lang);
        List<R> categories = categoryService.list(lang);
        model.addAttribute("categories", categories);
        return getListViewPath();
    }

    /**
     * 카테고리 생성 폼 페이지
     */
    @GetMapping("/new")
    public String newForm(@RequestParam(required = false, defaultValue = "ko") String lang, Model model) {
        addCommonAttributesWithMenus(model, "카테고리 추가", getActiveMenu(), lang);
        model.addAttribute("category", null);
        model.addAttribute("isEdit", false);
        return getFormViewPath();
    }

    /**
     * 카테고리 수정 폼 페이지
     */
    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id,
                          @RequestParam(required = false, defaultValue = "ko") String lang,
                          Model model) {
        addCommonAttributesWithMenus(model, "카테고리 수정", getActiveMenu(), lang);
        R category = categoryService.getById(id);
        model.addAttribute("category", category);
        model.addAttribute("isEdit", true);
        return getFormViewPath();
    }

    /**
     * 카테고리 저장 (생성/수정)
     */
    @PostMapping("/save")
    public String save(@ModelAttribute Q req,
                      @RequestParam(required = false) Long id,
                      @RequestParam(required = false, defaultValue = "1") Integer enabled,
                      RedirectAttributes redirectAttributes) {
        setEnabledField(req, enabled);

        if (id != null) {
            categoryService.update(id, req);
            redirectAttributes.addFlashAttribute("message", "카테고리가 수정되었습니다.");
        } else {
            categoryService.create(req);
            redirectAttributes.addFlashAttribute("message", "카테고리가 추가되었습니다.");
        }
        return getRedirectPath();
    }

    /**
     * 카테고리 삭제
     */
    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        categoryService.delete(id);
        redirectAttributes.addFlashAttribute("message", "카테고리가 삭제되었습니다.");
        return getRedirectPath();
    }

    /**
     * 카테고리 순서 재정렬
     */
    @PostMapping("/reorder")
    @ResponseBody
    public void reorder(@RequestBody List<Long> categoryIds) {
        categoryService.reorder(categoryIds);
    }

    // ===== Abstract Methods =====

    /**
     * 목록 페이지 제목
     */
    protected abstract String getListPageTitle();

    /**
     * 활성 메뉴 이름
     */
    protected abstract String getActiveMenu();

    /**
     * 목록 View 경로
     */
    protected abstract String getListViewPath();

    /**
     * 폼 View 경로
     */
    protected abstract String getFormViewPath();

    /**
     * 리다이렉트 경로
     */
    protected abstract String getRedirectPath();

    /**
     * Request DTO에 enabled 필드 설정
     */
    protected abstract void setEnabledField(Q req, Integer enabled);
}
