package com.elang.camp.web.admin;

import com.elang.camp.common.api.ApiResponse;
import com.elang.camp.domain.cms.admin.AdminAccessService;
import com.elang.camp.domain.cms.admin.AdminConfig;
import com.elang.camp.domain.cms.admin.AllowedAdminIp;
import com.elang.camp.domain.cms.menu.SiteMenuService;
import com.elang.camp.domain.cms.menu.dto.MenuRes;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class AdminAccessController {

    private final AdminAccessService adminAccessService;
    private final SiteMenuService menuService;

    /**
     * Admin 접근 설정 페이지
     */
    @GetMapping("/admin/access")
    public String accessPage(
            @RequestParam(required = false, defaultValue = "ko") String lang,
            Model model,
            HttpServletRequest request) {

        AdminConfig config = adminAccessService.getConfig();
        List<AllowedAdminIp> allowedIps = adminAccessService.getAllowedIps();

        // 현재 접속 IP
        String currentIp = getClientIp(request);

        // 공통 속성
        model.addAttribute("title", lang.equals("en") ? "Access Settings" : "접근 설정");
        model.addAttribute("active", "/admin/access");
        model.addAttribute("adminLang", lang);

        // 관리자 메뉴 로드 (해당 언어에 메뉴가 없으면 한국어로 대체)
        List<MenuRes> adminMenus = menuService.list(lang, "admin", true);
        if (adminMenus.isEmpty() && !"ko".equals(lang)) {
            adminMenus = menuService.list("ko", "admin", true);
        }
        model.addAttribute("adminMenus", adminMenus);

        // 페이지 데이터
        model.addAttribute("config", config);
        model.addAttribute("allowedIps", allowedIps);
        model.addAttribute("currentIp", currentIp);
        model.addAttribute("accessModes", AdminConfig.AccessMode.values());
        model.addAttribute("lang", lang);

        return "admin/access/index";
    }

    /**
     * AccessMode 변경 API
     */
    @PostMapping("/api/admin/access/mode")
    @ResponseBody
    public ApiResponse<AdminConfig> updateAccessMode(@RequestBody Map<String, String> body) {
        String mode = body.get("mode");
        AdminConfig.AccessMode accessMode = AdminConfig.AccessMode.valueOf(mode);
        AdminConfig config = adminAccessService.updateAccessMode(accessMode);
        return ApiResponse.ok(config);
    }

    /**
     * 허용 IP 추가 API
     */
    @PostMapping("/api/admin/access/ip")
    @ResponseBody
    public ApiResponse<AllowedAdminIp> addAllowedIp(@RequestBody Map<String, String> body) {
        String ipAddress = body.get("ipAddress");
        String description = body.get("description");

        if (ipAddress == null || ipAddress.isBlank()) {
            return ApiResponse.fail("IP 주소를 입력해주세요.");
        }

        try {
            AllowedAdminIp ip = adminAccessService.addAllowedIp(ipAddress.trim(), description);
            return ApiResponse.ok(ip);
        } catch (IllegalArgumentException e) {
            return ApiResponse.fail(e.getMessage());
        }
    }

    /**
     * 허용 IP 삭제 API
     */
    @DeleteMapping("/api/admin/access/ip/{id}")
    @ResponseBody
    public ApiResponse<Void> removeAllowedIp(@PathVariable Long id) {
        adminAccessService.removeAllowedIp(id);
        return ApiResponse.ok(null);
    }

    /**
     * 클라이언트 IP 주소 추출
     */
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
}
