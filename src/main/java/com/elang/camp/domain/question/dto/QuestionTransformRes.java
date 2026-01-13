package com.elang.camp.domain.question.dto;

import com.elang.camp.domain.question.DifficultyLevel;
import com.elang.camp.domain.question.QuestionTransform;
import com.elang.camp.domain.question.TransformStatus;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Getter
@Builder
public class QuestionTransformRes {

    private Long id;
    private String originalText;
    private DifficultyLevel difficulty;
    private String difficultyLabel;
    private String questionLang;
    private String choiceLang;
    private String transformedText;
    private String analysis;
    private TransformStatus status;
    private String statusLabel;
    private String errorMessage;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static QuestionTransformRes from(QuestionTransform entity) {
        return QuestionTransformRes.builder()
            .id(entity.getId())
            .originalText(entity.getOriginalText())
            .difficulty(entity.getDifficulty())
            .difficultyLabel(entity.getDifficulty().getLabel())
            .questionLang(entity.getQuestionLang())
            .choiceLang(entity.getChoiceLang())
            .transformedText(entity.getTransformedText())
            .analysis(entity.getAnalysis())
            .status(entity.getStatus())
            .statusLabel(entity.getStatus().getLabel())
            .errorMessage(entity.getErrorMessage())
            .createdAt(entity.getCreatedAt())
            .updatedAt(entity.getUpdatedAt())
            .build();
    }

    public String getCreatedAtFormatted() {
        if (createdAt == null) return "";
        return createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }
}
