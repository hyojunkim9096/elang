package com.elang.camp.web.admin;

import com.elang.camp.domain.cms.admin.AdminUserService;
import com.elang.camp.domain.cms.admin.dto.AdminUserReq;
import com.elang.camp.domain.cms.admin.dto.AdminUserRes;
import com.elang.camp.domain.cms.menu.SiteMenuService;
import com.elang.camp.domain.cms.menu.dto.MenuRes;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class AdminUserController {

    private final AdminUserService adminUserService;
    private final SiteMenuService menuService;

    private void addCommonAttributes(Model model, String title, String active, String lang) {
        model.addAttribute("title", title);
        model.addAttribute("active", active);
        model.addAttribute("adminLang", lang);

        List<MenuRes> adminMenus = menuService.list(lang, "admin", true);
        if (adminMenus.isEmpty() && !"ko".equals(lang)) {
            adminMenus = menuService.list("ko", "admin", true);
        }
        model.addAttribute("adminMenus", adminMenus);
    }

    @GetMapping("/admin/users")
    public String list(@RequestParam(required = false, defaultValue = "ko") String lang, Model model) {
        addCommonAttributes(model, "관리자 계정 관리", "/admin/users", lang);
        model.addAttribute("users", adminUserService.listAll());
        return "admin/users/list";
    }

    @GetMapping("/admin/users/new")
    public String newUser(@RequestParam(required = false, defaultValue = "ko") String lang, Model model) {
        addCommonAttributes(model, "관리자 추가", "/admin/users", lang);
        model.addAttribute("user", null);
        model.addAttribute("isEdit", false);
        return "admin/users/form";
    }

    @GetMapping("/admin/users/{id}/edit")
    public String editUser(@PathVariable Long id,
                          @RequestParam(required = false, defaultValue = "ko") String lang,
                          Model model) {
        addCommonAttributes(model, "관리자 수정", "/admin/users", lang);
        model.addAttribute("user", adminUserService.getById(id));
        model.addAttribute("isEdit", true);
        return "admin/users/form";
    }

    @PostMapping("/admin/users/save")
    public String save(@ModelAttribute AdminUserReq req,
                      @RequestParam(required = false) Long id,
                      @RequestParam(required = false, defaultValue = "1") Integer enabled,
                      @RequestParam(required = false, defaultValue = "ko") String lang,
                      RedirectAttributes redirectAttributes) {
        try {
            req.setEnabled(enabled == 1);

            if (id != null) {
                adminUserService.update(id, req);
                redirectAttributes.addFlashAttribute("message", "관리자 정보가 수정되었습니다.");
            } else {
                adminUserService.create(req);
                redirectAttributes.addFlashAttribute("message", "관리자가 추가되었습니다.");
            }
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/users?lang=" + lang;
    }

    @PostMapping("/admin/users/{id}/delete")
    public String delete(@PathVariable Long id,
                        @RequestParam(required = false, defaultValue = "ko") String lang,
                        RedirectAttributes redirectAttributes) {
        try {
            adminUserService.delete(id);
            redirectAttributes.addFlashAttribute("message", "관리자가 삭제되었습니다.");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/users?lang=" + lang;
    }
}
