package com.elang.camp.web.publicweb;

import com.elang.camp.common.lang.Lang;
import com.elang.camp.domain.cms.banner.BannerCategoryService;
import com.elang.camp.domain.cms.banner.SiteBannerService;
import com.elang.camp.domain.cms.banner.dto.BannerCategoryRes;
import com.elang.camp.domain.cms.banner.dto.BannerRes;
import com.elang.camp.domain.cms.board.BoardPostService;
import com.elang.camp.domain.cms.board.dto.BoardPostRes; // 빠진 import 구문 추가
import com.elang.camp.domain.cms.inquiry.InquiryService;
import com.elang.camp.domain.cms.inquiry.dto.InquiryCreateReq;
import com.elang.camp.domain.cms.inquiry.dto.InquiryRes;
import com.elang.camp.domain.file.AttachFile;
import com.elang.camp.domain.file.AttachFileService;
import com.elang.camp.common.api.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class PublicController {

    private final SiteBannerService bannerService;
    private final BannerCategoryService bannerCategoryService;
    private final BoardPostService boardPostService;
    private final InquiryService inquiryService;
    private final AttachFileService attachFileService;

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
        
        model.addAttribute("bannerCategories", bannerCategories);
        model.addAttribute("bannersByCategory", bannersByCategory);
        model.addAttribute("switchLangUrl", lang == Lang.KO ? "/en" : "/ko");

        return "public/home";
    }

    // 게시글 상세
    @GetMapping("/{lang}/board/{categoryKey}/{postId}")
    public String boardDetail(@PathVariable String lang,
                             @PathVariable String categoryKey,
                             @PathVariable Long postId,
                             Authentication authentication,
                             Model model) {
        BoardPostRes post = boardPostService.getById(postId);

        // 조회수 증가
        boardPostService.incrementViewCount(postId);

        // 관리자 여부 확인
        boolean isAdmin = authentication != null &&
                authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"));

        // 첨부파일 조회
        List<AttachFile> attachments = attachFileService.listByReference("board_post_attachment", postId);

        model.addAttribute("categoryKey", categoryKey);
        model.addAttribute("post", post);
        model.addAttribute("isAdmin", isAdmin);
        model.addAttribute("attachments", attachments);

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
