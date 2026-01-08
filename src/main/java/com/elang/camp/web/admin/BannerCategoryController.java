package com.elang.camp.web.admin;

import com.elang.camp.domain.cms.banner.BannerCategory;
import com.elang.camp.domain.cms.banner.BannerCategoryService;
import com.elang.camp.domain.cms.banner.dto.BannerCategoryRes;
import com.elang.camp.domain.cms.banner.dto.BannerCategoryUpsertReq;
import com.elang.camp.web.admin.base.AbstractCategoryController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/banner-categories")
public class BannerCategoryController extends AbstractCategoryController<BannerCategory, BannerCategoryRes, BannerCategoryUpsertReq, BannerCategoryService> {

    public BannerCategoryController(BannerCategoryService categoryService) {
        super(categoryService);
    }

    @Override
    protected String getListPageTitle() {
        return "배너 카테고리 관리";
    }

    @Override
    protected String getActiveMenu() {
        return "banner-categories";
    }

    @Override
    protected String getListViewPath() {
        return "admin/banner-categories/list";
    }

    @Override
    protected String getFormViewPath() {
        return "admin/banner-categories/form";
    }

    @Override
    protected String getRedirectPath() {
        return "redirect:/admin/banner-categories";
    }

    @Override
    protected void setEnabledField(BannerCategoryUpsertReq req, Integer enabled) {
        req.setEnabled(enabled == null || enabled == 1);
    }
}
