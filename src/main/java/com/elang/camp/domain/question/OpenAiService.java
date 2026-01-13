package com.elang.camp.domain.question;

import com.elang.camp.domain.question.dto.QuestionTransformReq;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class OpenAiService {

    @Value("${app.openai.api-key:}")
    private String apiKey;

    @Value("${app.openai.model:gpt-4o-mini}")
    private String model;

    private static final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";

    private final RestTemplate restTemplate = new RestTemplate();

    /**
     * 영어 문제 분석 및 변형 생성 (텍스트)
     */
    public Map<String, String> transformQuestion(QuestionTransformReq req) {
        if (apiKey == null || apiKey.isBlank()) {
            throw new IllegalStateException("OpenAI API key is not configured. Set OPENAI_API_KEY environment variable.");
        }

        // 이미지가 있으면 Vision API 사용
        if (req.getImageBase64() != null && !req.getImageBase64().isBlank()) {
            return transformWithVision(req);
        }

        // 텍스트만 있으면 일반 API 사용
        return transformWithText(req);
    }

    /**
     * 텍스트 기반 변형
     */
    private Map<String, String> transformWithText(QuestionTransformReq req) {
        String systemPrompt = buildSystemPrompt(req.getQuestionLang(), req.getChoiceLang());
        String userPrompt = buildUserPrompt(req.getOriginalText(), req.getDifficulty(), req.getQuestionLang(), req.getChoiceLang());

        try {
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("model", model);
            requestBody.put("messages", List.of(
                Map.of("role", "system", "content", systemPrompt),
                Map.of("role", "user", "content", userPrompt)
            ));
            requestBody.put("temperature", 0.7);
            requestBody.put("max_tokens", 2000);

            return callOpenAiApi(requestBody);

        } catch (Exception e) {
            log.error("OpenAI API call failed", e);
            throw new RuntimeException("OpenAI API 호출 실패: " + e.getMessage(), e);
        }
    }

    /**
     * 이미지 기반 변형 (Vision API)
     */
    private Map<String, String> transformWithVision(QuestionTransformReq req) {
        String systemPrompt = buildSystemPrompt(req.getQuestionLang(), req.getChoiceLang());
        String userPrompt = buildVisionUserPrompt(req.getDifficulty(), req.getQuestionLang(), req.getChoiceLang());

        try {
            // Vision API용 메시지 구성
            List<Map<String, Object>> userContent = new ArrayList<>();

            // 텍스트 파트
            userContent.add(Map.of("type", "text", "text", userPrompt));

            // 이미지 파트
            String base64 = req.getImageBase64();
            // data:image/... 형식이면 그대로, 아니면 추가
            String imageUrl;
            if (base64.startsWith("data:")) {
                imageUrl = base64;
            } else {
                imageUrl = "data:image/jpeg;base64," + base64;
            }
            userContent.add(Map.of(
                "type", "image_url",
                "image_url", Map.of("url", imageUrl)
            ));

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("model", model);
            requestBody.put("messages", List.of(
                Map.of("role", "system", "content", systemPrompt),
                Map.of("role", "user", "content", userContent)
            ));
            requestBody.put("max_tokens", 2000);

            return callOpenAiApi(requestBody);

        } catch (Exception e) {
            log.error("OpenAI Vision API call failed", e);
            throw new RuntimeException("OpenAI Vision API 호출 실패: " + e.getMessage(), e);
        }
    }

    /**
     * OpenAI API 호출 공통 메서드
     */
    private Map<String, String> callOpenAiApi(Map<String, Object> requestBody) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        log.info("Calling OpenAI API with model: {}", model);

        ResponseEntity<Map> response = restTemplate.exchange(
            OPENAI_API_URL,
            HttpMethod.POST,
            entity,
            Map.class
        );

        log.info("OpenAI API response status: {}", response.getStatusCode());

        return parseResponse(response.getBody());
    }

    private String buildSystemPrompt(String questionLang, String choiceLang) {
        String questionLangDesc = "KO".equals(questionLang) ? "한글" : "영어(English)";
        String choiceLangDesc = "KO".equals(choiceLang) ? "한글" : "영어(English)";

        return """
            You are an expert in creating Korean 수능 (CSAT) style English test questions.

            IMPORTANT RULES:
            1. 질문(Question)은 반드시 %s로 작성
            2. 선택지(Choices)는 반드시 %s로 작성
            3. 지문은 변형 문제에서 반복하지 마세요 (원본 지문 참조라고만 표시)
            4. 각 변형 문제는 서로 다른 유형이어야 함

            응답 형식:

            [원본 문제]
            (이미지/PDF에서 인식한 원본 문제 전체를 그대로 작성 - 질문, 지문, 선택지 모두 포함)

            [분석]
            - 원본 문제 유형: (제목, 주제, 빈칸, 순서 등)
            - 핵심 내용: (지문의 핵심 주제 1-2문장)
            - 주요 어휘: (고급 어휘 3-5개)
            - 원본 난이도: (상/중/하)

            [변형 문제 1] - (문제 유형 명시: 빈칸추론/문장삽입/순서배열 등)
            (%s 질문)

            ** 중요: 지문 작성 규칙 **
            - 빈칸 추론: 원본 지문 전체를 그대로 사용하고, 핵심 표현만 ________로 빈칸 처리
            - 문장 삽입: 원본 지문 전체에 (A), (B), (C), (D), (E) 위치 표시
            - 순서 배열: 원본 지문을 (A), (B), (C) 문단으로 나누어 제시
            - 주제/요지/제목: 원본 지문 전체 사용

            (위 규칙에 따라 지문 전체 제시)

            ① (%s 선택지)
            ② (%s 선택지)
            ③ (%s 선택지)
            ④ (%s 선택지)
            ⑤ (%s 선택지)
            정답: ②
            해설(한국어): (한국어로 정답 이유 설명)
            解説(English): (영어로 정답 이유 설명)

            [변형 문제 2] - (다른 유형)
            ...

            [변형 문제 3] - (또 다른 유형)
            ...
            """.formatted(questionLangDesc, choiceLangDesc,
                          questionLangDesc, choiceLangDesc, choiceLangDesc, choiceLangDesc, choiceLangDesc, choiceLangDesc);
    }

    private String buildUserPrompt(String originalText, DifficultyLevel difficulty, String questionLang, String choiceLang) {
        String difficultyDesc = getDifficultyDescription(difficulty);
        String questionLangDesc = "KO".equals(questionLang) ? "한글" : "영어";
        String choiceLangDesc = "KO".equals(choiceLang) ? "한글" : "영어";

        return """
            다음 영어 지문/문제를 분석하고, [%s] 난이도로 2~3개의 변형 문제를 만들어주세요.

            형식:
            - 질문은 %s
            - 지문은 영어 유지
            - 선택지는 %s

            원본:
            %s
            """.formatted(difficultyDesc, questionLangDesc, choiceLangDesc, originalText);
    }

    private String buildVisionUserPrompt(DifficultyLevel difficulty, String questionLang, String choiceLang) {
        String difficultyDesc = getDifficultyDescription(difficulty);
        String questionLangDesc = "KO".equals(questionLang) ? "한글" : "영어";
        String choiceLangDesc = "KO".equals(choiceLang) ? "한글" : "영어";

        return """
            이미지에 있는 영어 문제를 분석하고, [%s] 난이도로 변형 문제를 만들어주세요.

            주의사항:
            1. 이미지에 여러 문제가 있으면 각각 분석해주세요
            2. 질문은 %s, 지문은 영어 유지, 선택지는 %s
            3. 각 원본 문제당 2~3개의 변형 문제 생성
            4. 문제 유형(어휘, 주제, 제목, 빈칸 등)을 다양하게 변형
            """.formatted(difficultyDesc, questionLangDesc, choiceLangDesc);
    }

    private String getDifficultyDescription(DifficultyLevel difficulty) {
        return switch (difficulty) {
            case HIGH -> """
                상 (고난이도) - 다음 유형으로 변형:
                - 빈칸 추론: 원본 지문 전체 유지, 핵심 표현/문장만 빈칸으로 (예: ________)
                - 문장 삽입: 원본 지문에 (A)~(E) 위치 표시, 삽입할 문장 제시
                - 글의 순서 배열: 지문을 (A), (B), (C) 문단으로 나누어 제시
                - 함축 의미 추론: 원본 지문의 특정 표현에 밑줄, 의미 추론
                ** 절대로 지문을 요약하거나 짧게 줄이지 마세요! 원본 전체를 사용하세요 **""";
            case MEDIUM -> """
                중 (중간 난이도) - 다음 유형으로 변형:
                - 주제/요지 파악: 원본 지문 전체 사용
                - 제목 선택: 원본 지문 전체 사용
                - 내용 일치/불일치: 원본 지문 전체 사용
                - 글의 목적: 원본 지문 전체 사용
                ** 절대로 지문을 요약하거나 짧게 줄이지 마세요! 원본 전체를 사용하세요 **""";
            case LOW -> """
                하 (기본 난이도) - 다음 유형으로 변형:
                - 글의 목적/분위기: 원본 지문 전체 사용
                - 지칭 대상 파악: 원본 지문에서 특정 표현에 밑줄
                - 직접적인 내용 확인: 원본 지문 전체 사용
                - 단순 어휘 의미: 원본 지문에서 특정 단어에 밑줄
                ** 절대로 지문을 요약하거나 짧게 줄이지 마세요! 원본 전체를 사용하세요 **""";
        };
    }

    @SuppressWarnings("unchecked")
    private Map<String, String> parseResponse(Map<?, ?> responseBody) {
        List<Map<String, Object>> choices = (List<Map<String, Object>>) responseBody.get("choices");
        if (choices == null || choices.isEmpty()) {
            throw new RuntimeException("OpenAI response has no choices");
        }

        Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
        String content = (String) message.get("content");

        Map<String, String> result = new HashMap<>();

        // [원본 문제] 섹션 추출
        int originalStart = content.indexOf("[원본 문제]");
        int analysisStart = content.indexOf("[분석]");
        int variant1Start = content.indexOf("[변형 문제 1]");

        // 영어 형식도 체크 (이전 버전 호환)
        if (variant1Start < 0) {
            variant1Start = content.indexOf("[Variant Question 1]");
        }

        // 원본 문제 추출
        if (originalStart >= 0) {
            int originalEnd = analysisStart > originalStart ? analysisStart :
                             (variant1Start > originalStart ? variant1Start : content.length());
            String original = content.substring(originalStart + "[원본 문제]".length(), originalEnd).trim();
            result.put("extractedOriginal", original);
        }

        // [분석] 섹션 추출
        if (analysisStart >= 0) {
            int analysisEnd = variant1Start > analysisStart ? variant1Start : content.length();
            String analysis = content.substring(analysisStart, analysisEnd).trim();
            result.put("analysis", analysis);
        }

        // [변형 문제 1~3] + [변형 포인트] 추출
        int notesStart = content.indexOf("[변형 포인트]");
        if (notesStart < 0) {
            notesStart = content.indexOf("[Transformation Notes]");
        }

        if (variant1Start >= 0) {
            int end = notesStart > variant1Start ? notesStart : content.length();
            String variants = content.substring(variant1Start, end).trim();

            // 변형 포인트도 포함
            if (notesStart > 0) {
                variants += "\n\n" + content.substring(notesStart).trim();
            }
            result.put("transformedText", variants);
        }

        // 파싱 실패 시 전체 응답 반환
        if (result.isEmpty() || result.get("transformedText") == null) {
            result.put("analysis", "[분석]\n전체 응답을 아래에서 확인하세요.");
            result.put("transformedText", content);
        }

        return result;
    }
}
