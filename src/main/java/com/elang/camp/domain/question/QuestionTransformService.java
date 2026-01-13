package com.elang.camp.domain.question;

import com.elang.camp.common.exception.NotFoundException;
import com.elang.camp.domain.question.dto.QuestionTransformReq;
import com.elang.camp.domain.question.dto.QuestionTransformRes;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class QuestionTransformService {

    private final QuestionTransformRepository repository;
    private final OpenAiService openAiService;

    /**
     * 전체 목록 조회
     */
    public List<QuestionTransformRes> listAll() {
        return repository.findAllByOrderByCreatedAtDesc()
            .stream()
            .map(QuestionTransformRes::from)
            .toList();
    }

    /**
     * 난이도별 목록 조회
     */
    public List<QuestionTransformRes> listByDifficulty(DifficultyLevel difficulty) {
        return repository.findByDifficultyOrderByCreatedAtDesc(difficulty)
            .stream()
            .map(QuestionTransformRes::from)
            .toList();
    }

    /**
     * 상세 조회
     */
    public QuestionTransformRes getById(Long id) {
        QuestionTransform entity = repository.findById(id)
            .orElseThrow(() -> new NotFoundException("QuestionTransform not found: " + id));
        return QuestionTransformRes.from(entity);
    }

    /**
     * 문제 변형 생성 (동기 처리)
     */
    @Transactional
    public QuestionTransformRes transform(QuestionTransformReq req) {
        // 1. Entity 생성 및 저장
        QuestionTransform entity = new QuestionTransform();
        entity.setOriginalText(req.getOriginalText());
        entity.setDifficulty(req.getDifficulty());
        entity.setQuestionLang(req.getQuestionLang() != null ? req.getQuestionLang() : "KO");
        entity.setChoiceLang(req.getChoiceLang() != null ? req.getChoiceLang() : "KO");
        entity.setStatus(TransformStatus.PROCESSING);
        entity = repository.save(entity);

        try {
            // 2. OpenAI API 호출
            Map<String, String> result = openAiService.transformQuestion(req);

            // 3. 결과 저장
            entity.setTransformedText(result.get("transformedText"));
            entity.setAnalysis(result.get("analysis"));
            entity.setStatus(TransformStatus.COMPLETED);

            // 이미지/PDF에서 추출한 경우 원본 텍스트 업데이트
            String extractedOriginal = result.get("extractedOriginal");
            if (extractedOriginal != null && !extractedOriginal.isBlank()) {
                entity.setOriginalText(extractedOriginal);
            }

            log.info("Question transform completed: id={}", entity.getId());

        } catch (Exception e) {
            // 4. 실패 시 에러 상태로 저장
            entity.setStatus(TransformStatus.FAILED);
            entity.setErrorMessage(e.getMessage());
            log.error("Question transform failed: id={}", entity.getId(), e);
        }

        entity = repository.save(entity);
        return QuestionTransformRes.from(entity);
    }

    /**
     * 삭제
     */
    @Transactional
    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new NotFoundException("QuestionTransform not found: " + id);
        }
        repository.deleteById(id);
        log.info("QuestionTransform deleted: id={}", id);
    }

    /**
     * 완료 건수
     */
    public long countCompleted() {
        return repository.countByStatus(TransformStatus.COMPLETED);
    }

    /**
     * 실패 건수
     */
    public long countFailed() {
        return repository.countByStatus(TransformStatus.FAILED);
    }
}
