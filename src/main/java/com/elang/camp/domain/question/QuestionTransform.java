package com.elang.camp.domain.question;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 문제 변형 Entity
 */
@Entity
@Table(name = "question_transform")
@Getter
@Setter
public class QuestionTransform {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** 원본 지문/문제 */
    @Lob
    @Column(name = "original_text", nullable = false, columnDefinition = "TEXT")
    private String originalText;

    /** 난이도 */
    @Enumerated(EnumType.STRING)
    @Column(length = 10, nullable = false)
    private DifficultyLevel difficulty;

    /** 문제(질문) 언어 */
    @Column(name = "question_lang", length = 2, nullable = false)
    private String questionLang = "KO";

    /** 선택지 언어 */
    @Column(name = "choice_lang", length = 2, nullable = false)
    private String choiceLang = "KO";

    /** 변형된 문제 */
    @Lob
    @Column(name = "transformed_text", columnDefinition = "TEXT")
    private String transformedText;

    /** AI 분석 결과 */
    @Lob
    @Column(columnDefinition = "TEXT")
    private String analysis;

    /** 처리 상태 */
    @Enumerated(EnumType.STRING)
    @Column(length = 20, nullable = false)
    private TransformStatus status = TransformStatus.PENDING;

    /** 에러 메시지 */
    @Lob
    @Column(name = "error_message", columnDefinition = "TEXT")
    private String errorMessage;

    /** 생성일시 */
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    /** 수정일시 */
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
