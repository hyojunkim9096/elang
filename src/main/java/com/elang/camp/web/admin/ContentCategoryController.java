package com.elang.camp.web.admin;

import com.elang.camp.domain.cms.content.ContentCategory;
import com.elang.camp.domain.cms.content.ContentCategoryService;
import com.elang.camp.domain.cms.content.dto.ContentCategoryRes;
import com.elang.camp.domain.cms.content.dto.ContentCategoryUpsertReq;
import com.elang.camp.web.admin.base.AbstractCategoryController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/content-categories")
public class ContentCategoryController extends AbstractCategoryController<ContentCategory, ContentCategoryRes, ContentCategoryUpsertReq, ContentCategoryService> {

    public ContentCategoryController(ContentCategoryService categoryService) {
        super(categoryService);
    }

    @Override
    protected String getListPageTitle() {
        return "컨텐츠 카테고리 관리";
    }

    @Override
    protected String getActiveMenu() {
        return "content-categories";
    }

    @Override
    protected String getListViewPath() {
        return "admin/content-categories/list";
    }

    @Override
    protected String getFormViewPath() {
        return "admin/content-categories/form";
    }

    @Override
    protected String getRedirectPath() {
        return "redirect:/admin/content-categories";
    }

    @Override
    protected void setEnabledField(ContentCategoryUpsertReq req, Integer enabled) {
        req.setEnabled(enabled == null || enabled == 1);
    }
}
