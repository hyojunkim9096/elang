package com.elang.camp.domain.cms.base;

import com.elang.camp.common.exception.BadRequestException;
import com.elang.camp.common.exception.NotFoundException;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 카테고리 Service Base Class
 * BoardCategoryService, ContentCategoryService, BannerCategoryService의 공통 로직 추출
 *
 * @param <T> Category Entity 타입 (BoardCategory, ContentCategory, BannerCategory)
 * @param <R> Category Response DTO 타입
 * @param <Q> Category Upsert Request DTO 타입
 * @param <REPO> Category Repository 타입
 */
@Transactional(readOnly = true)
public abstract class AbstractCategoryService<T extends BaseCategory, R, Q, REPO extends JpaRepository<T, Long>> {

    protected final REPO repository;

    protected AbstractCategoryService(REPO repository) {
        this.repository = repository;
    }

    /**
     * 카테고리 목록 조회
     * @param lang 언어 코드 (null이면 전체)
     * @return 카테고리 목록
     */
    public List<R> list(String lang) {
        List<T> categories;
        if (lang != null && !lang.isEmpty()) {
            categories = findByLangOrderBySortOrder(lang);
        } else {
            categories = findAllOrderBySortOrder();
        }
        return categories.stream()
            .map(this::toResponse)
            .collect(Collectors.toList());
    }

    /**
     * 카테고리 단건 조회
     * @param id 카테고리 ID
     * @return 카테고리 응답 DTO
     */
    public R getById(Long id) {
        T category = repository.findById(id)
            .orElseThrow(() -> new NotFoundException(getEntityName() + " not found: " + id));
        return toResponse(category);
    }

    /**
     * 카테고리 생성
     * @param req 생성 요청 DTO
     * @return 생성된 카테고리 응답 DTO
     */
    @Transactional
    public R create(Q req) {
        // 중복 확인
        if (existsByLangAndCategoryKey(getLang(req), getCategoryKey(req))) {
            throw new BadRequestException(getEntityName() + " already exists: " +
                getLang(req) + "/" + getCategoryKey(req));
        }

        T category = createEntity();
        setEntityFields(category, req, false);

        T saved = repository.save(category);
        return toResponse(saved);
    }

    /**
     * 카테고리 수정
     * @param id 카테고리 ID
     * @param req 수정 요청 DTO
     * @return 수정된 카테고리 응답 DTO
     */
    @Transactional
    public R update(Long id, Q req) {
        T category = repository.findById(id)
            .orElseThrow(() -> new NotFoundException(getEntityName() + " not found: " + id));

        setEntityFields(category, req, true);

        T saved = repository.save(category);
        return toResponse(saved);
    }

    /**
     * 카테고리 삭제
     * @param id 카테고리 ID
     */
    @Transactional
    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new NotFoundException(getEntityName() + " not found: " + id);
        }
        repository.deleteById(id);
    }

    /**
     * 카테고리 순서 재정렬
     * @param categoryIds 카테고리 ID 목록
     */
    @Transactional
    public void reorder(List<Long> categoryIds) {
        if (categoryIds == null || categoryIds.isEmpty()) return;

        for (int i = 0; i < categoryIds.size(); i++) {
            Long categoryId = categoryIds.get(i);
            T category = repository.findById(categoryId)
                .orElseThrow(() -> new NotFoundException(getEntityName() + " not found: " + categoryId));
            category.setSortOrder(i + 1);
        }
    }

    // ===== Abstract Methods =====

    /**
     * Entity 이름 반환 (에러 메시지용)
     */
    protected abstract String getEntityName();

    /**
     * 언어별 정렬 조회
     */
    protected abstract List<T> findByLangOrderBySortOrder(String lang);

    /**
     * 전체 정렬 조회
     */
    protected abstract List<T> findAllOrderBySortOrder();

    /**
     * 중복 확인
     */
    protected abstract boolean existsByLangAndCategoryKey(String lang, String categoryKey);

    /**
     * Entity를 Response DTO로 변환
     */
    protected abstract R toResponse(T entity);

    /**
     * 새 Entity 인스턴스 생성
     */
    protected abstract T createEntity();

    /**
     * Request DTO에서 Entity 필드 설정
     * @param entity 대상 Entity
     * @param req 요청 DTO
     * @param isUpdate 수정 여부 (true면 categoryKey 수정 불가)
     */
    protected abstract void setEntityFields(T entity, Q req, boolean isUpdate);

    /**
     * Request DTO에서 lang 추출
     */
    protected abstract String getLang(Q req);

    /**
     * Request DTO에서 categoryKey 추출
     */
    protected abstract String getCategoryKey(Q req);
}
