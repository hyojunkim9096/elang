package com.elang.camp.web.advice;

import com.elang.camp.domain.cms.layout.SiteLayoutService;
import com.elang.camp.domain.cms.layout.dto.LayoutRes;
import com.elang.camp.domain.cms.menu.SiteMenuService;
import com.elang.camp.domain.cms.menu.dto.MenuRes;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@ControllerAdvice(basePackages = "com.elang.camp.web.publicweb")
@RequiredArgsConstructor
public class GlobalControllerAdvice {

    private final SiteMenuService menuService;
    private final SiteLayoutService layoutService;

    private static final Pattern LANG_PATTERN = Pattern.compile("^/(ko|en)");

    @ModelAttribute
    public void addCommonPublicAttributes(Model model, HttpServletRequest request) {
        String uri = request.getRequestURI();
        Matcher matcher = LANG_PATTERN.matcher(uri);

        String lang = "ko"; // 기본값
        if (matcher.find()) {
            lang = matcher.group(1);
        }

        // 모든 모델에 공통으로 추가될 데이터
        List<MenuRes> menus = menuService.list(lang, "public", true);
        LayoutRes layout = layoutService.getOrCreate(lang);

        model.addAttribute("menus", menus);
        model.addAttribute("layout", layout);
        model.addAttribute("lang", lang); // JSP에서 언어 코드 사용을 위해 추가
    }
}
