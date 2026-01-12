package com.elang.camp.web.publicweb;

import com.elang.camp.domain.cms.board.BoardCategoryService;
import com.elang.camp.domain.cms.board.BoardPostService;
import com.elang.camp.domain.cms.board.dto.BoardCategoryRes;
import com.elang.camp.domain.cms.board.dto.BoardPostRes;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class PublicBoardController {

    private final BoardPostService boardPostService;
    private final BoardCategoryService boardCategoryService;

    @GetMapping("/{lang}/board/{categoryKey}")
    public String boardPage(@PathVariable String lang,
                            @PathVariable String categoryKey,
                            @RequestParam(required = false) String searchType,
                            @RequestParam(required = false) String keyword,
                            Model model) {

        BoardCategoryRes category = boardCategoryService.getByKey(lang, categoryKey);
        if (category == null) {
            return "error/404";
        }

        List<BoardPostRes> posts = boardPostService.listByCategoryId(category.getId(), true, searchType, keyword);

        model.addAttribute("category", category);
        model.addAttribute("posts", posts);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);

        String viewName = switch (category.getDisplayType()) {
            case CARD -> "public/board/board_card";
            case THUMBNAIL -> "public/board/board_thumb";
            default -> "public/board/board_list";
        };

        return viewName;
    }
}
