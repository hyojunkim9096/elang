package com.elang.camp.domain.cms.layout;

import com.elang.camp.common.exception.BadRequestException;
import com.elang.camp.common.lang.Lang;
import com.elang.camp.domain.cms.layout.dto.LayoutRes;
import com.elang.camp.domain.cms.layout.dto.LayoutUpdateReq;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class SiteLayoutService {

    private final SiteLayoutRepository repository;

    @Transactional
    public LayoutRes getOrCreate(String langRaw) {
        Lang lang = safeLang(langRaw);

        SiteLayout layout = repository.findByLang(lang.code())
                .orElseGet(() -> {
                    SiteLayout created = new SiteLayout();
                    created.setLang(lang.code());
                    created.setHeaderHtml(defaultHeader(lang));
                    created.setFooterHtml(defaultFooter(lang));
                    return repository.save(created);
                });

        return new LayoutRes(layout.getLang(), layout.getHeaderHtml(), layout.getFooterHtml());
    }

    @Transactional
    public LayoutRes update(String langRaw, LayoutUpdateReq req) {
        Lang lang = safeLang(langRaw);
        if (req == null) throw new BadRequestException("요청 바디가 비어있습니다.");

        SiteLayout layout = repository.findByLang(lang.code())
                .orElseGet(() -> {
                    SiteLayout created = new SiteLayout();
                    created.setLang(lang.code());
                    created.setHeaderHtml("");
                    created.setFooterHtml("");
                    return created;
                });

        layout.setHeaderHtml(req.getHeaderHtml() == null ? "" : req.getHeaderHtml());
        layout.setFooterHtml(req.getFooterHtml() == null ? "" : req.getFooterHtml());

        SiteLayout saved = repository.save(layout);
        return new LayoutRes(saved.getLang(), saved.getHeaderHtml(), saved.getFooterHtml());
    }

    private Lang safeLang(String raw) {
        try {
            return Lang.from(raw);
        } catch (Exception e) {
            return Lang.KO;
        }
    }

    private String defaultHeader(Lang lang) {
        if (lang == Lang.EN) {
            return "<header class=\"site-header\">"
                    + "<div class=\"container\">"
                    + "<div class=\"brand\">English Camp</div>"
                    + "<a class=\"lang-switch\" href=\"/ko\">KOR</a>"
                    + "</div></header>";
        }
        return "<header class=\"site-header\">"
                + "<div class=\"container\">"
                + "<div class=\"brand\">영어캠프</div>"
                + "<a class=\"lang-switch\" href=\"/en\">ENG</a>"
                + "</div></header>";
    }

    private String defaultFooter(Lang lang) {
        if (lang == Lang.EN) {
            return "<footer class=\"site-footer\"><div class=\"container\">"
                    + "<small>© English Camp. All rights reserved.</small>"
                    + "</div></footer>";
        }
        return "<footer class=\"site-footer\"><div class=\"container\">"
                + "<small>© 영어캠프. All rights reserved.</small>"
                + "</div></footer>";
    }
}
