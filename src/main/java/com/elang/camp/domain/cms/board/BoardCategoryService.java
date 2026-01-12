package com.elang.camp.domain.cms.board;

import com.elang.camp.domain.cms.base.AbstractCategoryService;
import com.elang.camp.domain.cms.board.dto.BoardCategoryRes;
import com.elang.camp.domain.cms.board.dto.BoardCategoryUpsertReq;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class BoardCategoryService extends AbstractCategoryService<BoardCategory, BoardCategoryRes, BoardCategoryUpsertReq, BoardCategoryRepository> {

    public BoardCategoryService(BoardCategoryRepository repository) {
        super(repository);
    }

    /**
     * 언어와 카테고리 키로 카테고리 정보를 조회합니다.
     * @param lang 언어 코드 (ko, en)
     * @param categoryKey 카테고리 키
     * @return BoardCategoryRes DTO, 없으면 null
     */
    @Transactional(readOnly = true)
    public BoardCategoryRes getByKey(String lang, String categoryKey) {
        return repository.findByLangAndCategoryKey(lang, categoryKey)
                .map(this::toResponse)
                .orElse(null);
    }

    @Override
    protected String getEntityName() {
        return "BoardCategory";
    }

    @Override
    protected List<BoardCategory> findByLangOrderBySortOrder(String lang) {
        return repository.findByLangOrderBySortOrderAsc(lang);
    }

    @Override
    protected List<BoardCategory> findAllOrderBySortOrder() {
        return repository.findAllByOrderBySortOrderAsc();
    }

    @Override
    protected boolean existsByLangAndCategoryKey(String lang, String categoryKey) {
        return repository.existsByLangAndCategoryKey(lang, categoryKey);
    }

    @Override
    protected BoardCategoryRes toResponse(BoardCategory entity) {
        return BoardCategoryRes.from(entity);
    }

    @Override
    protected BoardCategory createEntity() {
        return new BoardCategory();
    }

    @Override
    protected void setEntityFields(BoardCategory entity, BoardCategoryUpsertReq req, boolean isUpdate) {
        if (!isUpdate) {
            entity.setLang(req.getLang());
            entity.setCategoryKey(req.getCategoryKey());
        }
        entity.setName(req.getName());
        entity.setDescription(req.getDescription());
        entity.setDisplayType(req.getDisplayType());
        entity.setSortOrder(req.getSortOrder());
        entity.setEnabled(req.getEnabled());
    }

    @Override
    protected String getLang(BoardCategoryUpsertReq req) {
        return req.getLang();
    }

    @Override
    protected String getCategoryKey(BoardCategoryUpsertReq req) {
        return req.getCategoryKey();
    }
}
