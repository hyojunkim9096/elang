package com.elang.camp.domain.question.dto;

import com.elang.camp.domain.question.DifficultyLevel;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

/**
 * 문제 변형 요청 DTO
 */
@Getter
@Setter
public class QuestionTransformReq {

    // 텍스트 직접 입력 (파일 업로드 시에는 비어있을 수 있음)
    private String originalText;

    @NotNull(message = "난이도를 선택해주세요")
    private DifficultyLevel difficulty;

    // 이미지 Base64 (Vision API용)
    private String imageBase64;

    // 입력 타입 (TEXT, IMAGE, PDF)
    private String inputType = "TEXT";

    // 문제(질문) 언어: KO(한글), EN(영어)
    private String questionLang = "KO";

    // 보기(선택지) 언어: KO(한글), EN(영어)
    private String choiceLang = "KO";
}
