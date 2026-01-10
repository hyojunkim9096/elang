package com.elang.camp.web.admin;

import com.elang.camp.domain.cms.menu.SiteMenuService;
import com.elang.camp.domain.cms.menu.dto.MenuRes;
import lombok.extern.slf4j.Slf4j;
import com.elang.camp.domain.cms.board.BoardCategoryService;
import com.elang.camp.domain.cms.board.BoardPostService;
import com.elang.camp.domain.cms.board.dto.BoardCategoryRes;
import com.elang.camp.domain.cms.board.dto.BoardPostRes;
import com.elang.camp.domain.cms.board.dto.BoardPostUpsertReq;
import com.elang.camp.domain.cms.content.ContentPageService;
import com.elang.camp.domain.cms.content.ContentCategoryService;
import com.elang.camp.domain.cms.content.dto.ContentPageRes;
import com.elang.camp.domain.cms.content.dto.ContentPageUpsertReq;
import com.elang.camp.domain.cms.content.dto.ContentCategoryRes;
import com.elang.camp.domain.cms.banner.SiteBannerService;
import com.elang.camp.domain.cms.banner.BannerCategoryService;
import com.elang.camp.domain.cms.banner.dto.BannerRes;
import com.elang.camp.domain.cms.banner.dto.BannerUpsertReq;
import com.elang.camp.domain.cms.banner.dto.BannerCategoryRes;
import com.elang.camp.domain.cms.layout.SiteLayoutService;
import com.elang.camp.domain.cms.layout.dto.LayoutRes;
import com.elang.camp.domain.cms.layout.dto.LayoutUpdateReq;
import com.elang.camp.domain.cms.menu.dto.MenuUpsertReq;
import com.elang.camp.domain.cms.inquiry.InquiryService;
import com.elang.camp.domain.cms.inquiry.InquiryStatus;
import com.elang.camp.domain.cms.inquiry.dto.InquiryRes;
import com.elang.camp.domain.cms.inquiry.dto.InquiryUpdateReq;
import com.elang.camp.domain.file.AttachFile;
import com.elang.camp.domain.file.AttachFileService;
import com.elang.camp.domain.cms.banner.BannerType;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminPageController {

    private final SiteMenuService menuService;
    private final BoardCategoryService boardCategoryService;
    private final BoardPostService boardPostService;
    private final ContentPageService contentPageService;
    private final ContentCategoryService contentCategoryService;
    private final SiteBannerService bannerService;
    private final BannerCategoryService bannerCategoryService;
    private final SiteLayoutService layoutService;
    private final AttachFileService attachFileService;
    private final InquiryService inquiryService;

    @Value("${app.upload-dir}")
    private String uploadPath;

    private void addCommonAttributes(Model model, String title, String active, String lang) {
        model.addAttribute("title", title);
        model.addAttribute("active", active);
        model.addAttribute("adminLang", lang);

        // 관리자 메뉴 로드 (지정된 언어, admin 타입, 활성화된 것만)
        List<MenuRes> adminMenus = menuService.list(lang, "admin", true);
        model.addAttribute("adminMenus", adminMenus);
    }

    @GetMapping("/admin")
    public String dashboard(@RequestParam(required = false, defaultValue = "ko") String lang, Model model) {
        addCommonAttributes(model, "대시보드", "dashboard", lang);
        // 즐겨찾기 메뉴만 로드 (해당 언어만)
        List<MenuRes> favorites = menuService.getFavorites("admin", lang);
        model.addAttribute("favorites", favorites);
        return "admin/dashboard/index";
    }

    @PostMapping("/admin/menu/{id}/toggle-favorite")
    @ResponseBody
    public void toggleFavorite(@PathVariable Long id) {
        menuService.toggleFavorite(id);
    }

    @PostMapping("/admin/menu/reorder-favorites")
    @ResponseBody
    public void reorderFavorites(@RequestBody List<Long> menuIds) {
        menuService.reorderFavorites(menuIds);
    }

    @GetMapping("/admin/layout")
    public String layout(@RequestParam(required = false, defaultValue = "ko") String lang, Model model) {
        addCommonAttributes(model, "레이아웃 관리", "layout", lang);
        LayoutRes layoutRes = layoutService.getOrCreate(lang);
        model.addAttribute("layoutData", layoutRes);
        return "admin/layout/manage";
    }

    @PostMapping("/admin/layout/save")
    public String saveLayout(@RequestParam(required = false) String lang,
                            @ModelAttribute LayoutUpdateReq req,
                            RedirectAttributes redirectAttributes) {
        layoutService.update(lang != null ? lang : "ko", req);
        redirectAttributes.addFlashAttribute("message", "레이아웃이 저장되었습니다.");
        return "redirect:/admin/layout?lang=" + (lang != null ? lang : "ko");
    }

    @GetMapping("/admin/menus")
    public String menus(@RequestParam(required = false, defaultValue = "ko") String lang,
                       @RequestParam(required = false, defaultValue = "admin") String menuType,
                       Model model) {
        addCommonAttributes(model, "메뉴 관리", "menus", lang);
        List<MenuRes> menus = menuService.list(lang, menuType, false);
        model.addAttribute("menus", menus);
        return "admin/menus/list";
    }

    @GetMapping("/admin/menus/new")
    public String newMenu(@RequestParam(required = false, defaultValue = "ko") String lang, Model model) {
        addCommonAttributes(model, "메뉴 추가", "menus", lang);
        model.addAttribute("menu", null);
        model.addAttribute("isEdit", false);
        List<MenuRes> allMenus = menuService.list(null, false);
        model.addAttribute("allMenus", allMenus);
        return "admin/menus/form";
    }

    @GetMapping("/admin/menus/{id}/edit")
    public String editMenu(@PathVariable Long id,
                          @RequestParam(required = false, defaultValue = "ko") String lang,
                          Model model) {
        addCommonAttributes(model, "메뉴 수정", "menus", lang);
        MenuRes menu = menuService.list(null, false).stream()
            .filter(m -> m.getId().equals(id))
            .findFirst()
            .orElse(null);
        model.addAttribute("menu", menu);
        model.addAttribute("isEdit", true);
        List<MenuRes> allMenus = menuService.list(null, false);
        model.addAttribute("allMenus", allMenus);
        return "admin/menus/form";
    }

    @PostMapping("/admin/menus/save")
    public String saveMenu(@ModelAttribute MenuUpsertReq req,
                          @RequestParam(required = false) Long id,
                          @RequestParam(required = false) String returnMenuType,
                          @RequestParam(required = false) String returnLang,
                          @RequestParam(required = false, defaultValue = "1") Integer enabled,
                          RedirectAttributes redirectAttributes) {
        // 체크박스 값 설정
        req.setEnabled(enabled == null || enabled == 1);

        if (id != null) {
            menuService.update(id, req);
            redirectAttributes.addFlashAttribute("message", "메뉴가 수정되었습니다.");
        } else {
            menuService.create(req);
            redirectAttributes.addFlashAttribute("message", "메뉴가 추가되었습니다.");
        }
        String menuTypeParam = (returnMenuType != null) ? returnMenuType : "admin";
        String langParam = (returnLang != null) ? returnLang : "ko";
        return "redirect:/admin/menus?menuType=" + menuTypeParam + "&lang=" + langParam;
    }

    @PostMapping("/admin/menus/{id}/delete")
    public String deleteMenu(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        menuService.delete(id);
        redirectAttributes.addFlashAttribute("message", "메뉴가 삭제되었습니다.");
        return "redirect:/admin/menus";
    }

    @PostMapping("/admin/menus/reorder")
    @ResponseBody
    public String reorderMenus(@RequestBody java.util.Map<String, Object> payload) {
        try {
            Object menuIdsObj = payload.get("menuIds");
            log.debug("Received payload: {}", payload);
            log.debug("menuIds type: {}", menuIdsObj != null ? menuIdsObj.getClass() : "null");

            if (menuIdsObj == null) {
                log.warn("menuIds is null in payload");
                return "error: menuIds is null";
            }

            @SuppressWarnings("unchecked")
            java.util.List<Object> menuIdsRaw = (java.util.List<Object>) menuIdsObj;

            // Object를 Long으로 변환 (Integer 또는 String일 수 있음)
            java.util.List<Long> menuIds = menuIdsRaw.stream()
                .map(id -> {
                    if (id instanceof Number) {
                        return ((Number) id).longValue();
                    } else if (id instanceof String) {
                        return Long.parseLong((String) id);
                    }
                    throw new IllegalArgumentException("Invalid ID type: " + id.getClass());
                })
                .toList();

            log.debug("Converted menuIds: {}", menuIds);
            menuService.reorder(menuIds);
            return "ok";
        } catch (Exception e) {
            log.error("Failed to reorder menus", e);
            return "error: " + e.getMessage();
        }
    }

    // ==================== 배너 관리 ====================

    @GetMapping("/admin/banners")
    public String banners(@RequestParam(required = false) Long categoryId,
                         @RequestParam(required = false) String categoryKey,
                         @RequestParam(required = false, defaultValue = "ko") String lang,
                         Model model) {
        addCommonAttributes(model, "배너 관리", "banners", lang);
        model.addAttribute("lang", lang);

        if (categoryId != null) {
            List<BannerRes> banners = bannerService.list(lang, false).stream()
                .filter(b -> b.getCategoryId() != null && b.getCategoryId().equals(categoryId))
                .toList();
            model.addAttribute("banners", banners);
            model.addAttribute("categoryId", categoryId);
            model.addAttribute("categoryKey", categoryKey);
        } else {
            List<BannerCategoryRes> categories = bannerCategoryService.list(lang);
            model.addAttribute("categories", categories);
        }

        return "admin/banners/list";
    }

    @GetMapping("/admin/banners/new")
    public String newBanner(@RequestParam Long categoryId,
                           @RequestParam String categoryKey,
                           @RequestParam(required = false, defaultValue = "ko") String lang,
                           Model model) {
        addCommonAttributes(model, "배너 추가", "banners", lang);
        model.addAttribute("banner", null);
        model.addAttribute("isEdit", false);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("categoryKey", categoryKey);
        model.addAttribute("lang", lang);
        return "admin/banners/form";
    }

    @GetMapping("/admin/banners/{id}/edit")
    public String editBanner(@PathVariable Long id,
                            @RequestParam Long categoryId,
                            @RequestParam String categoryKey,
                            @RequestParam(required = false, defaultValue = "ko") String lang,
                            Model model) {
        addCommonAttributes(model, "배너 수정", "banners", lang);
        BannerRes banner = bannerService.list(lang, false).stream()
            .filter(b -> b.getId().equals(id))
            .findFirst()
            .orElse(null);
        model.addAttribute("banner", banner);
        model.addAttribute("isEdit", true);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("categoryKey", categoryKey);
        model.addAttribute("lang", lang);
        return "admin/banners/form";
    }

    @PostMapping("/admin/banners/save")
    public String saveBanner(@ModelAttribute BannerUpsertReq req,
                            @RequestParam(required = false) Long id,
                            @RequestParam Long categoryId,
                            @RequestParam String categoryKey,
                            @RequestParam(required = false) MultipartFile bannerFile,
                            @RequestParam(required = false) String linkUrl,
                            @RequestParam(required = false) String existingImageUrl,
                            @RequestParam(required = false, defaultValue = "1") Integer enabled,
                            RedirectAttributes redirectAttributes) {
        // 체크박스 값 설정
        req.setEnabled(enabled == null || enabled == 1);

        try {
            // IMAGE 타입일 때 파일 업로드 처리
            if (req.getType() == BannerType.IMAGE) {
                if (bannerFile != null && !bannerFile.isEmpty()) {
                    // 새 파일 업로드
                    String imageUrl = uploadBannerImage(bannerFile, id);
                    req.setUrl(imageUrl);
                } else if (existingImageUrl != null) {
                    // 기존 이미지 유지
                    req.setUrl(existingImageUrl);
                }
            }

            // 링크 URL 설정 (linkUrl 파라미터를 req에 설정)
            req.setLinkUrl(linkUrl);

            if (id != null) {
                bannerService.update(id, req);
                redirectAttributes.addFlashAttribute("message", "배너가 수정되었습니다.");
            } else {
                bannerService.create(req);
                redirectAttributes.addFlashAttribute("message", "배너가 추가되었습니다.");
            }
        } catch (Exception e) {
            log.error("Failed to save banner", e);
            redirectAttributes.addFlashAttribute("error", "배너 저장 실패: " + e.getMessage());
        }

        return "redirect:/admin/banners?categoryId=" + categoryId + "&categoryKey=" + categoryKey;
    }

    /**
     * 배너 이미지 파일 업로드
     */
    private String uploadBannerImage(MultipartFile file, Long bannerId) throws IOException {
        // 파일 정보 추출
        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename != null && originalFilename.contains(".")
            ? originalFilename.substring(originalFilename.lastIndexOf("."))
            : "";
        String savedFilename = UUID.randomUUID() + extension;

        // 업로드 디렉토리 생성
        File uploadDir = new File(this.uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 파일 저장
        Path filePath = Paths.get(this.uploadPath, savedFilename);
        Files.write(filePath, file.getBytes());

        // DB에 파일 정보 저장
        AttachFile attachFile = new AttachFile();
        attachFile.setOriginalName(originalFilename);
        attachFile.setSavedName(savedFilename);
        attachFile.setFilePath(filePath.toString());
        attachFile.setFileSize(file.getSize());
        attachFile.setContentType(file.getContentType());
        attachFile.setFileExtension(extension);
        attachFile.setUploadType("banner");
        attachFile.setReferenceType("banner");
        if (bannerId != null) {
            attachFile.setReferenceId(bannerId);
        }

        attachFileService.save(attachFile);

        return "/uploads/" + savedFilename;
    }

    @PostMapping("/admin/banners/{id}/delete")
    public String deleteBanner(@PathVariable Long id,
                              @RequestParam Long categoryId,
                              @RequestParam String categoryKey,
                              RedirectAttributes redirectAttributes) {
        bannerService.delete(id);
        redirectAttributes.addFlashAttribute("message", "배너가 삭제되었습니다.");
        return "redirect:/admin/banners?categoryId=" + categoryId + "&categoryKey=" + categoryKey;
    }

    @PostMapping("/admin/banners/reorder")
    @ResponseBody
    public void reorderBanners(@RequestBody List<Long> bannerIds) {
        bannerService.reorder(bannerIds);
    }

    // ==================== 컨텐츠 페이지 관리 ====================

    @GetMapping("/admin/content-pages")
    public String contentPages(@RequestParam(required = false) Long categoryId,
                              @RequestParam(required = false) String categoryKey,
                              @RequestParam(required = false, defaultValue = "ko") String lang,
                              Model model) {
        addCommonAttributes(model, "컨텐츠 페이지 관리", "content-pages", lang);

        if (categoryId != null) {
            List<ContentPageRes> pages = contentPageService.listByCategoryId(categoryId);
            model.addAttribute("pages", pages);
            model.addAttribute("categoryId", categoryId);
            model.addAttribute("categoryKey", categoryKey);
        } else {
            List<ContentCategoryRes> categories = contentCategoryService.list(lang);
            model.addAttribute("categories", categories);
        }

        return "admin/content-pages/list";
    }

    @GetMapping("/admin/content-pages/new")
    public String newContentPage(@RequestParam Long categoryId,
                                 @RequestParam String categoryKey,
                                 @RequestParam(required = false, defaultValue = "ko") String lang,
                                 Model model) {
        addCommonAttributes(model, "페이지 생성", "content-pages", lang);
        model.addAttribute("page", null);
        model.addAttribute("isEdit", false);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("categoryKey", categoryKey);
        return "admin/content-pages/form";
    }

    @GetMapping("/admin/content-pages/{id}/edit")
    public String editContentPage(@PathVariable Long id,
                                  @RequestParam Long categoryId,
                                  @RequestParam String categoryKey,
                                  @RequestParam(required = false, defaultValue = "ko") String lang,
                                  Model model) {
        addCommonAttributes(model, "페이지 수정", "content-pages", lang);
        ContentPageRes page = contentPageService.getById(id);
        model.addAttribute("page", page);
        model.addAttribute("isEdit", true);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("categoryKey", categoryKey);
        return "admin/content-pages/form";
    }

    @PostMapping("/admin/content-pages/save")
    public String saveContentPage(@ModelAttribute ContentPageUpsertReq req,
                                  @RequestParam(required = false) Long id,
                                  @RequestParam Long categoryId,
                                  @RequestParam String categoryKey,
                                  @RequestParam(required = false, defaultValue = "1") Integer enabled,
                                  RedirectAttributes redirectAttributes) {
        req.setEnabled(enabled == null || enabled == 1);

        if (id != null) {
            contentPageService.update(id, req);
            redirectAttributes.addFlashAttribute("message", "페이지가 수정되었습니다.");
        } else {
            contentPageService.create(req);
            redirectAttributes.addFlashAttribute("message", "페이지가 추가되었습니다.");
        }
        return "redirect:/admin/content-pages?categoryId=" + categoryId + "&categoryKey=" + categoryKey;
    }

    @PostMapping("/admin/content-pages/{id}/delete")
    public String deleteContentPage(@PathVariable Long id,
                                    @RequestParam Long categoryId,
                                    @RequestParam String categoryKey,
                                    RedirectAttributes redirectAttributes) {
        contentPageService.delete(id);
        redirectAttributes.addFlashAttribute("message", "페이지가 삭제되었습니다.");
        return "redirect:/admin/content-pages?categoryId=" + categoryId + "&categoryKey=" + categoryKey;
    }

    @GetMapping("/admin/board-posts")
    public String boardPosts(@RequestParam(required = false) Long categoryId,
                           @RequestParam(required = false) String categoryKey,
                           @RequestParam(required = false, defaultValue = "ko") String lang,
                           Model model) {
        addCommonAttributes(model, "게시글 관리", "board-posts", lang);

        log.debug("Board posts page accessed - categoryId: {}, categoryKey: {}", categoryId, categoryKey);

        if (categoryId != null) {
            // 게시글 목록을 Model에 담아서 JSP로 전달
            List<BoardPostRes> posts = boardPostService.listByCategoryId(categoryId, false);
            log.debug("Board posts retrieved: {} posts", posts.size());
            if (log.isDebugEnabled()) {
                posts.forEach(post -> log.debug("  - {}: {}", post.getId(), post.getTitle()));
            }
            model.addAttribute("posts", posts);
            model.addAttribute("categoryId", categoryId);
            model.addAttribute("categoryKey", categoryKey);
        } else {
            log.debug("categoryId is null, displaying category selection screen");
            // 카테고리 목록을 불러와서 선택할 수 있게 함
            List<BoardCategoryRes> categories = boardCategoryService.list(null);
            log.debug("Available categories: {}", categories.size());
            model.addAttribute("categories", categories);
        }

        return "admin/board-posts/list";
    }

    @GetMapping("/admin/board-posts/new")
    public String newBoardPost(@RequestParam Long categoryId,
                              @RequestParam String categoryKey,
                              @RequestParam(required = false, defaultValue = "ko") String lang,
                              Model model) {
        addCommonAttributes(model, "게시글 작성", "board-posts", lang);
        model.addAttribute("post", null);
        model.addAttribute("isEdit", false);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("categoryKey", categoryKey);
        return "admin/board-posts/form";
    }

    @GetMapping("/admin/board-posts/{id}/edit")
    public String editBoardPost(@PathVariable Long id,
                               @RequestParam Long categoryId,
                               @RequestParam String categoryKey,
                               @RequestParam(required = false, defaultValue = "ko") String lang,
                               Model model) {
        addCommonAttributes(model, "게시글 수정", "board-posts", lang);
        BoardPostRes post = boardPostService.getById(id);
        model.addAttribute("post", post);
        model.addAttribute("isEdit", true);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("categoryKey", categoryKey);

        // 기존 첨부파일 목록 조회
        List<AttachFile> attachments = attachFileService.listByReference("board_post_attachment", id);
        model.addAttribute("attachments", attachments);

        return "admin/board-posts/form";
    }

    @PostMapping("/admin/board-posts/save")
    public String saveBoardPost(@ModelAttribute BoardPostUpsertReq req,
                               @RequestParam(required = false) Long id,
                               @RequestParam Long categoryId,
                               @RequestParam String categoryKey,
                               @RequestParam(required = false, defaultValue = "0") Integer isPinned,
                               @RequestParam(required = false, defaultValue = "1") Integer enabled,
                               RedirectAttributes redirectAttributes) {
        log.debug("saveBoardPost called - thumbnail: {}, title: {}, categoryId: {}",
                  req.getThumbnail(), req.getTitle(), req.getCategoryId());

        // 체크박스 값 설정
        req.setIsPinned(isPinned != null && isPinned == 1);
        req.setEnabled(enabled == null || enabled == 1);

        if (id != null) {
            boardPostService.update(id, req);
            redirectAttributes.addFlashAttribute("message", "게시글이 수정되었습니다.");
        } else {
            boardPostService.create(req);
            redirectAttributes.addFlashAttribute("message", "게시글이 추가되었습니다.");
        }
        return "redirect:/admin/board-posts?categoryId=" + categoryId + "&categoryKey=" + categoryKey;
    }

    @PostMapping("/admin/board-posts/{id}/delete")
    public String deleteBoardPost(@PathVariable Long id,
                                 @RequestParam Long categoryId,
                                 @RequestParam String categoryKey,
                                 RedirectAttributes redirectAttributes) {
        boardPostService.delete(id);
        redirectAttributes.addFlashAttribute("message", "게시글이 삭제되었습니다.");
        return "redirect:/admin/board-posts?categoryId=" + categoryId + "&categoryKey=" + categoryKey;
    }

    // ==================== 상담/문의 관리 ====================

    @GetMapping("/admin/inquiries")
    public String inquiries(@RequestParam(required = false) String status,
                           @RequestParam(required = false, defaultValue = "ko") String lang,
                           Model model) {
        addCommonAttributes(model, "상담/문의 관리", "inquiries", lang);

        List<InquiryRes> inquiries;
        if (status != null && !status.isEmpty()) {
            inquiries = inquiryService.listByStatus(InquiryStatus.valueOf(status));
            model.addAttribute("statusFilter", status);
        } else {
            inquiries = inquiryService.listAll();
        }

        model.addAttribute("inquiries", inquiries);
        model.addAttribute("pendingCount", inquiryService.countPending());
        model.addAttribute("unreadCount", inquiryService.countUnread());
        model.addAttribute("totalCount", inquiries.size());

        return "admin/inquiries/list";
    }

    @GetMapping("/admin/inquiries/{id}")
    public String inquiryDetail(@PathVariable Long id,
                               @RequestParam(required = false, defaultValue = "ko") String lang,
                               Model model) {
        addCommonAttributes(model, "문의 상세", "inquiries", lang);

        InquiryRes inquiry = inquiryService.getById(id);
        model.addAttribute("inquiry", inquiry);

        // 읽음 처리
        if (!inquiry.getIsRead()) {
            inquiryService.markAsRead(id);
        }

        return "admin/inquiries/detail";
    }

    @PostMapping("/admin/inquiries/{id}/update")
    public String updateInquiry(@PathVariable Long id,
                               @ModelAttribute InquiryUpdateReq req,
                               RedirectAttributes redirectAttributes) {
        inquiryService.update(id, req);
        redirectAttributes.addFlashAttribute("message", "문의가 업데이트되었습니다.");
        return "redirect:/admin/inquiries/" + id;
    }

    @PostMapping("/admin/inquiries/{id}/delete")
    public String deleteInquiry(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        inquiryService.delete(id);
        redirectAttributes.addFlashAttribute("message", "문의가 삭제되었습니다.");
        return "redirect:/admin/inquiries";
    }
}
