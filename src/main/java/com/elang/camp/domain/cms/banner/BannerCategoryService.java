package com.elang.camp.domain.cms.banner;

import com.elang.camp.domain.cms.banner.dto.BannerCategoryRes;
import com.elang.camp.domain.cms.banner.dto.BannerCategoryUpsertReq;
import com.elang.camp.domain.cms.base.AbstractCategoryService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BannerCategoryService extends AbstractCategoryService<BannerCategory, BannerCategoryRes, BannerCategoryUpsertReq, BannerCategoryRepository> {

    public BannerCategoryService(BannerCategoryRepository repository) {
        super(repository);
    }

    @Override
    protected String getEntityName() {
        return "BannerCategory";
    }

    @Override
    protected List<BannerCategory> findByLangOrderBySortOrder(String lang) {
        return repository.findByLangOrderBySortOrderAscIdAsc(lang);
    }

    @Override
    protected List<BannerCategory> findAllOrderBySortOrder() {
        return repository.findAllByOrderBySortOrderAscIdAsc();
    }

    @Override
    protected boolean existsByLangAndCategoryKey(String lang, String categoryKey) {
        return repository.existsByLangAndCategoryKey(lang, categoryKey);
    }

    @Override
    protected BannerCategoryRes toResponse(BannerCategory entity) {
        return BannerCategoryRes.from(entity);
    }

    @Override
    protected BannerCategory createEntity() {
        return new BannerCategory();
    }

    @Override
    protected void setEntityFields(BannerCategory entity, BannerCategoryUpsertReq req, boolean isUpdate) {
        if (!isUpdate) {
            // 생성 시에만 lang, categoryKey 설정
            entity.setLang(req.getLang());
            entity.setCategoryKey(req.getCategoryKey());
        }
        // 공통 필드
        entity.setName(req.getName());
        entity.setDescription(req.getDescription());
        entity.setSortOrder(req.getSortOrder() != null ? req.getSortOrder() : 0);
        entity.setEnabled(req.getEnabled() != null ? req.getEnabled() : true);

        // 팝업 설정 (popup_banner 카테고리만 사용)
        entity.setPopupMaxCount(req.getPopupMaxCount());
        entity.setPopupDuration(req.getPopupDuration());
    }

    @Override
    protected String getLang(BannerCategoryUpsertReq req) {
        return req.getLang();
    }

    @Override
    protected String getCategoryKey(BannerCategoryUpsertReq req) {
        return req.getCategoryKey();
    }
}
