package com.elang.camp.web.publicweb;

import com.elang.camp.common.exception.NotFoundException;
import com.elang.camp.common.lang.Lang;
import com.elang.camp.domain.cms.banner.BannerCategoryService;
import com.elang.camp.domain.cms.banner.SiteBannerService;
import com.elang.camp.domain.cms.board.BoardCategoryService;
import com.elang.camp.domain.cms.board.BoardPostService;
import com.elang.camp.domain.cms.content.ContentPageService;
import com.elang.camp.domain.cms.layout.SiteLayoutService;
import com.elang.camp.domain.cms.menu.SiteMenuService;
import com.elang.camp.domain.cms.banner.dto.BannerCategoryRes;
import com.elang.camp.domain.cms.banner.dto.BannerRes;
import com.elang.camp.domain.cms.board.dto.BoardCategoryRes;
import com.elang.camp.domain.cms.board.dto.BoardPostRes;
import com.elang.camp.domain.cms.content.dto.ContentPageRes;
import com.elang.camp.domain.cms.layout.dto.LayoutRes;
import com.elang.camp.domain.cms.menu.dto.MenuRes;
import com.elang.camp.domain.cms.inquiry.InquiryService;
import com.elang.camp.domain.cms.inquiry.dto.InquiryCreateReq;
import com.elang.camp.domain.cms.inquiry.dto.InquiryRes;
import com.elang.camp.common.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class PublicController {

    private final SiteLayoutService layoutService;
    private final SiteMenuService menuService;
    private final SiteBannerService bannerService;
    private final BannerCategoryService bannerCategoryService;
    private final ContentPageService contentPageService;
    private final BoardCategoryService boardCategoryService;
    private final BoardPostService boardPostService;
    private final InquiryService inquiryService;

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
        List<MenuRes> menus = menuService.list(lang.code(), "public", true);

        // 배너 카테고리 목록 조회
        List<BannerCategoryRes> bannerCategories = bannerCategoryService.list(lang.code());

        // 카테고리별 배너 맵 생성 (categoryKey -> banners)
        Map<String, List<BannerRes>> bannersByCategory = new LinkedHashMap<>();
        for (BannerCategoryRes category : bannerCategories) {
            if (category.getEnabled()) {
                List<BannerRes> categoryBanners = bannerService.getActiveByCategoryId(lang.code(), category.getId());
                if (!categoryBanners.isEmpty()) {
                    bannersByCategory.put(category.getCategoryKey(), categoryBanners);
                }
            }
        }

        model.addAttribute("lang", lang.code());
        model.addAttribute("layout", layout);
        model.addAttribute("menus", menus);
        model.addAttribute("bannerCategories", bannerCategories);
        model.addAttribute("bannersByCategory", bannersByCategory);
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

    // 문의 등록 API
    @PostMapping("/api/inquiry")
    @ResponseBody
    public ApiResponse<InquiryRes> submitInquiry(@RequestBody InquiryCreateReq req) {
        InquiryRes result = inquiryService.create(req);
        return ApiResponse.ok(result);
    }
}
