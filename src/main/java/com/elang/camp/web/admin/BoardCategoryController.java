package com.elang.camp.web.admin;

import com.elang.camp.domain.cms.board.BoardCategory;
import com.elang.camp.domain.cms.board.BoardCategoryService;
import com.elang.camp.domain.cms.board.dto.BoardCategoryRes;
import com.elang.camp.domain.cms.board.dto.BoardCategoryUpsertReq;
import com.elang.camp.web.admin.base.AbstractCategoryController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/board-categories")
public class BoardCategoryController extends AbstractCategoryController<BoardCategory, BoardCategoryRes, BoardCategoryUpsertReq, BoardCategoryService> {

    public BoardCategoryController(BoardCategoryService categoryService) {
        super(categoryService);
    }

    @Override
    protected String getListPageTitle() {
        return "게시판 카테고리 관리";
    }

    @Override
    protected String getActiveMenu() {
        return "board-categories";
    }

    @Override
    protected String getListViewPath() {
        return "admin/board-categories/list";
    }

    @Override
    protected String getFormViewPath() {
        return "admin/board-categories/form";
    }

    @Override
    protected String getRedirectPath() {
        return "redirect:/admin/board-categories";
    }

    @Override
    protected void setEnabledField(BoardCategoryUpsertReq req, Integer enabled) {
        req.setEnabled(enabled == null || enabled == 1);
    }
}
