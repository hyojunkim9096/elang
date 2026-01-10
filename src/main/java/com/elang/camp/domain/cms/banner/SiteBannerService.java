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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@RequiredArgsConstructor
public class SiteBannerService {

    private final SiteBannerRepository repository;

    // YouTube 동영상 ID를 추출하기 위한 정규식 패턴
    private static final Pattern YOUTUBE_ID_PATTERN = Pattern.compile(
            "(?:https?://)?(?:www\\.)?(?:youtube\\.com/(?:watch\\?v=|embed/|v/)|youtu\\.be/)([\\w-]{11})(?:.*)?");

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
        String url = trimToNull(req.getUrl());

        // 배너 타입이 YOUTUBE인 경우, URL을 삽입용으로 변환
        if (req.getType() == BannerType.YOUTUBE && url != null) {
            url = convertYoutubeUrl(url);
        }

        b.setCategoryId(req.getCategoryId());
        b.setTitle(req.getTitle() == null ? "" : req.getTitle().trim());
        b.setType(req.getType());
        b.setUrl(url);
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

    /**
     * 일반 YouTube URL을 삽입(embed)용 URL로 변환합니다.
     * @param url 변환할 YouTube URL
     * @return 삽입용 URL. 변환할 수 없는 경우 원본 URL을 반환합니다.
     */
    private String convertYoutubeUrl(String url) {
        if (url == null) return null;

        Matcher matcher = YOUTUBE_ID_PATTERN.matcher(url);
        if (matcher.find()) {
            String videoId = matcher.group(1);
            return "https://www.youtube.com/embed/" + videoId;
        }

        // 정규식에 매칭되지 않으면 원본 URL을 그대로 반환
        return url;
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
