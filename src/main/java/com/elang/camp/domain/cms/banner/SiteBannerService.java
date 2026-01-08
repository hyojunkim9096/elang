package com.elang.camp.domain.cms.banner;

import com.elang.camp.common.exception.BadRequestException;
import com.elang.camp.common.lang.Lang;
import com.elang.camp.domain.cms.banner.dto.BannerRes;
import com.elang.camp.domain.cms.banner.dto.BannerUpsertReq;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class SiteBannerService {

    private final SiteBannerRepository repository;

    @Transactional(readOnly = true)
    public List<BannerRes> list(String langRaw, boolean enabledOnly) {
        Lang lang = Lang.from(langRaw);
        List<SiteBanner> list = enabledOnly
                ? repository.findByLangAndEnabledTrueOrderBySortOrderAscIdAsc(lang.code())
                : repository.findByLangOrderBySortOrderAscIdAsc(lang.code());
        return list.stream().map(this::toRes).toList();
    }

    @Transactional(readOnly = true)
    public List<BannerRes> getActiveByCategoryId(String langRaw, Long categoryId) {
        Lang lang = Lang.from(langRaw);
        List<SiteBanner> list = repository.findActiveByCategoryId(
            lang.code(),
            categoryId,
            LocalDateTime.now()
        );

        return list.stream().map(this::toRes).toList();
    }

    @Transactional
    public BannerRes create(BannerUpsertReq req) {
        if (req == null) throw new BadRequestException("요청값이 비어있습니다.");
        Lang lang = Lang.from(req.getLang());

        SiteBanner b = new SiteBanner();
        b.setLang(lang.code());
        apply(b, req);

        return toRes(repository.save(b));
    }

    @Transactional
    public BannerRes update(Long id, BannerUpsertReq req) {
        if (id == null) throw new BadRequestException("id가 필요합니다.");
        if (req == null) throw new BadRequestException("요청값이 비어있습니다.");

        SiteBanner b = repository.findById(id)
                .orElseThrow(() -> new BadRequestException("배너를 찾을 수 없습니다. id=" + id));

        Lang lang = Lang.from(req.getLang());
        b.setLang(lang.code());
        apply(b, req);

        return toRes(b);
    }

    @Transactional
    public void delete(Long id) {
        if (id == null) throw new BadRequestException("id가 필요합니다.");
        repository.deleteById(id);
    }

    @Transactional
    public void reorder(List<Long> bannerIds) {
        if (bannerIds == null || bannerIds.isEmpty()) return;

        for (int i = 0; i < bannerIds.size(); i++) {
            Long bannerId = bannerIds.get(i);
            SiteBanner banner = repository.findById(bannerId).orElse(null);
            if (banner != null) {
                banner.setSortOrder(i);
                repository.save(banner);
            }
        }
    }

    private void apply(SiteBanner b, BannerUpsertReq req) {
        b.setCategoryId(req.getCategoryId());
        b.setTitle(req.getTitle() == null ? "" : req.getTitle().trim());
        b.setType(req.getType());
        b.setUrl(trimToNull(req.getUrl()));
        b.setLinkUrl(trimToNull(req.getLinkUrl()));
        b.setSortOrder(req.getSortOrder());
        b.setEnabled(req.getEnabled());
        b.setStartDate(req.getStartDate());
        b.setEndDate(req.getEndDate());

        // Set dimensions
        if (req.getWidth() != null && req.getHeight() != null) {
            b.setWidth(req.getWidth());
            b.setHeight(req.getHeight());
        }
    }

    private BannerRes toRes(SiteBanner b) {
        return BannerRes.from(b);
    }

    private String trimToNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}
