package com.elang.camp.web.publicweb;

import com.elang.camp.domain.cms.content.ContentPageService;
import com.elang.camp.domain.cms.content.dto.ContentPageRes;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
@RequiredArgsConstructor
public class PublicContentController {

    private final ContentPageService contentPageService;

    @GetMapping("/{lang}/page/{pageKey}")
    public String contentPage(@PathVariable String lang,
                              @PathVariable String pageKey,
                              Model model) {

        ContentPageRes page = contentPageService.getLatestByCategoryKey(lang, pageKey);

        if (page == null) {
            return "error/404";
        }

        model.addAttribute("title", page.getTitle());
        model.addAttribute("content", page.getContent());

        return "public/userContent";
    }
}
