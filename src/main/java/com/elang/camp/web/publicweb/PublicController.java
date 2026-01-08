package com.elang.camp.web.publicweb;

import com.elang.camp.common.exception.NotFoundException;
import com.elang.camp.common.lang.Lang;
import com.elang.camp.domain.cms.banner.SiteBannerService;
import com.elang.camp.domain.cms.board.BoardCategoryService;
import com.elang.camp.domain.cms.board.BoardPostService;
import com.elang.camp.domain.cms.content.ContentPageService;
import com.elang.camp.domain.cms.layout.SiteLayoutService;
import com.elang.camp.domain.cms.menu.SiteMenuService;
import com.elang.camp.domain.cms.banner.dto.BannerRes;
import com.elang.camp.domain.cms.board.dto.BoardCategoryRes;
import com.elang.camp.domain.cms.board.dto.BoardPostRes;
import com.elang.camp.domain.cms.content.dto.ContentPageRes;
import com.elang.camp.domain.cms.layout.dto.LayoutRes;
import com.elang.camp.domain.cms.menu.dto.MenuRes;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class PublicController {

    private final SiteLayoutService layoutService;
    private final SiteMenuService menuService;
    private final SiteBannerService bannerService;
    private final ContentPageService contentPageService;
    private final BoardCategoryService boardCategoryService;
    private final BoardPostService boardPostService;

    @GetMapping({"/", ""})
    public String root() {
        return "redirect:/ko";
    }

    @GetMapping("/ko")
    public String ko(Model model) {
        return home(Lang.KO, model);
    }

    @GetMapping("/en")
    public String en(Model model) {
        return home(Lang.EN, model);
    }

    private String home(Lang lang, Model model) {
        LayoutRes layout = layoutService.getOrCreate(lang.code());
        List<MenuRes> menus = menuService.list(lang.code(), true);
        List<BannerRes> banners = bannerService.list(lang.code(), true);

        model.addAttribute("lang", lang.code());
        model.addAttribute("layout", layout);
        model.addAttribute("menus", menus);
        model.addAttribute("banners", banners);
        model.addAttribute("switchLangUrl", lang == Lang.KO ? "/en" : "/ko");

        return "public/home";
    }

    // 컨텐츠 페이지 렌더링
    @GetMapping("/{lang}/page/{pageKey}")
    public String contentPage(@PathVariable String lang, @PathVariable String pageKey, Model model) {
        ContentPageRes page = contentPageService.getByLangAndKey(lang, pageKey);
        LayoutRes layout = layoutService.getOrCreate(lang);

        model.addAttribute("lang", lang);
        model.addAttribute("pageTitle", page.getTitle());
        model.addAttribute("content", page.getContent());
        model.addAttribute("headerHtml", layout.getHeaderHtml());
        model.addAttribute("footerHtml", layout.getFooterHtml());

        return "public/userContent";
    }

    // 게시판 목록
    @GetMapping("/{lang}/board/{categoryKey}")
    public String boardList(@PathVariable String lang, @PathVariable String categoryKey, Model model) {
        BoardCategoryRes category = boardCategoryService.list(lang).stream()
            .filter(c -> c.getCategoryKey().equals(categoryKey))
            .findFirst()
            .orElseThrow(() -> new NotFoundException("Category not found"));

        List<BoardPostRes> posts = boardPostService.listByCategoryIdAndLang(category.getId(), lang);
        LayoutRes layout = layoutService.getOrCreate(lang);

        model.addAttribute("lang", lang);
        model.addAttribute("categoryKey", categoryKey);
        model.addAttribute("categoryName", category.getName());
        model.addAttribute("categoryDescription", category.getDescription());
        model.addAttribute("displayType", category.getDisplayType());
        model.addAttribute("posts", posts);
        model.addAttribute("headerHtml", layout.getHeaderHtml());
        model.addAttribute("footerHtml", layout.getFooterHtml());

        return "public/board-list";
    }

    // 게시글 상세
    @GetMapping("/{lang}/board/{categoryKey}/{postId}")
    public String boardDetail(@PathVariable String lang,
                             @PathVariable String categoryKey,
                             @PathVariable Long postId,
                             Model model) {
        BoardPostRes post = boardPostService.getById(postId);
        LayoutRes layout = layoutService.getOrCreate(lang);

        // 조회수 증가
        boardPostService.incrementViewCount(postId);

        model.addAttribute("lang", lang);
        model.addAttribute("categoryKey", categoryKey);
        model.addAttribute("post", post);
        model.addAttribute("headerHtml", layout.getHeaderHtml());
        model.addAttribute("footerHtml", layout.getFooterHtml());

        return "public/board-detail";
    }
}
