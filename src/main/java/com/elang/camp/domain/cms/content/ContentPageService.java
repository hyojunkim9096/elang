package com.elang.camp.domain.cms.content;

import com.elang.camp.common.exception.BadRequestException;
import com.elang.camp.common.exception.NotFoundException;
import com.elang.camp.domain.cms.content.dto.ContentPageRes;
import com.elang.camp.domain.cms.content.dto.ContentPageUpsertReq;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ContentPageService {

    private final ContentPageRepository contentPageRepository;
    private final ContentCategoryRepository contentCategoryRepository;

    public List<ContentPageRes> list(String lang) {
        if (lang != null && !lang.isEmpty()) {
            return contentPageRepository.findByLangOrderByCreatedAtDesc(lang)
                .stream()
                .map(ContentPageRes::from)
                .collect(Collectors.toList());
        }
        return contentPageRepository.findAllByOrderByCreatedAtDesc()
            .stream()
            .map(ContentPageRes::from)
            .collect(Collectors.toList());
    }

    public List<ContentPageRes> listByCategoryId(Long categoryId) {
        return contentPageRepository.findByCategoryIdOrderByCreatedAtDesc(categoryId)
            .stream()
            .map(ContentPageRes::from)
            .collect(Collectors.toList());
    }

    public ContentPageRes getById(Long id) {
        ContentPage page = contentPageRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("ContentPage not found: " + id));
        return ContentPageRes.from(page);
    }

    public ContentPageRes getByLangAndKey(String lang, String pageKey) {
        ContentPage page = contentPageRepository.findByLangAndPageKey(lang, pageKey)
            .orElseThrow(() -> new NotFoundException("ContentPage not found: " + lang + "/" + pageKey));
        return ContentPageRes.from(page);
    }

    /**
     * 카테고리 키로 활성화된 최신 페이지 조회
     * @param lang 언어 코드
     * @param categoryKey 카테고리 키 (예: about, program)
     * @return 활성화된 최신 컨텐츠 페이지
     */
    public ContentPageRes getLatestByCategoryKey(String lang, String categoryKey) {
        // 1. 카테고리 조회
        ContentCategory category = contentCategoryRepository.findByLangAndCategoryKey(lang, categoryKey)
            .orElseThrow(() -> new NotFoundException("ContentCategory not found: " + lang + "/" + categoryKey));

        // 2. 해당 카테고리에서 활성화된 최신 페이지 조회
        ContentPage page = contentPageRepository
            .findFirstByCategoryIdAndEnabledOrderByCreatedAtDesc(category.getId(), true)
            .orElseThrow(() -> new NotFoundException("No enabled content page found for category: " + categoryKey));

        return ContentPageRes.from(page);
    }

    @Transactional
    public ContentPageRes create(ContentPageUpsertReq req) {
        // 카테고리로부터 lang과 pageKey 가져오기
        ContentCategory category = contentCategoryRepository.findById(req.getCategoryId())
            .orElseThrow(() -> new NotFoundException("ContentCategory not found: " + req.getCategoryId()));

        ContentPage page = new ContentPage();
        page.setCategoryId(req.getCategoryId());
        page.setLang(category.getLang());
        page.setPageKey(category.getCategoryKey());  // 카테고리 키를 페이지 키로 사용
        page.setTitle(req.getTitle());
        page.setContent(req.getContent());
        page.setEnabled(req.getEnabled());

        ContentPage saved = contentPageRepository.save(page);
        return ContentPageRes.from(saved);
    }

    @Transactional
    public ContentPageRes update(Long id, ContentPageUpsertReq req) {
        ContentPage page = contentPageRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("ContentPage not found: " + id));

        // categoryId, lang, pageKey는 수정 불가
        page.setTitle(req.getTitle());
        page.setContent(req.getContent());
        page.setEnabled(req.getEnabled());

        ContentPage saved = contentPageRepository.save(page);
        return ContentPageRes.from(saved);
    }

    @Transactional
    public void delete(Long id) {
        if (!contentPageRepository.existsById(id)) {
            throw new NotFoundException("ContentPage not found: " + id);
        }
        contentPageRepository.deleteById(id);
    }
}
