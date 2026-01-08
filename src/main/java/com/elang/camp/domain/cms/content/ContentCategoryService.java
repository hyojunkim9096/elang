package com.elang.camp.domain.cms.content;

import com.elang.camp.domain.cms.base.AbstractCategoryService;
import com.elang.camp.domain.cms.content.dto.ContentCategoryRes;
import com.elang.camp.domain.cms.content.dto.ContentCategoryUpsertReq;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContentCategoryService extends AbstractCategoryService<ContentCategory, ContentCategoryRes, ContentCategoryUpsertReq, ContentCategoryRepository> {

    public ContentCategoryService(ContentCategoryRepository repository) {
        super(repository);
    }

    @Override
    protected String getEntityName() {
        return "ContentCategory";
    }

    @Override
    protected List<ContentCategory> findByLangOrderBySortOrder(String lang) {
        return repository.findByLangOrderBySortOrderAsc(lang);
    }

    @Override
    protected List<ContentCategory> findAllOrderBySortOrder() {
        return repository.findAllByOrderBySortOrderAsc();
    }

    @Override
    protected boolean existsByLangAndCategoryKey(String lang, String categoryKey) {
        return repository.existsByLangAndCategoryKey(lang, categoryKey);
    }

    @Override
    protected ContentCategoryRes toResponse(ContentCategory entity) {
        return ContentCategoryRes.from(entity);
    }

    @Override
    protected ContentCategory createEntity() {
        return new ContentCategory();
    }

    @Override
    protected void setEntityFields(ContentCategory entity, ContentCategoryUpsertReq req, boolean isUpdate) {
        if (!isUpdate) {
            entity.setLang(req.getLang());
            entity.setCategoryKey(req.getCategoryKey());
        }
        entity.setName(req.getName());
        entity.setDescription(req.getDescription());
        entity.setSortOrder(req.getSortOrder() != null ? req.getSortOrder() : 0);
        entity.setEnabled(req.getEnabled() != null ? req.getEnabled() : true);
    }

    @Override
    protected String getLang(ContentCategoryUpsertReq req) {
        return req.getLang();
    }

    @Override
    protected String getCategoryKey(ContentCategoryUpsertReq req) {
        return req.getCategoryKey();
    }
}
