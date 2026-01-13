package com.elang.camp.domain.question;

/**
 * 변형 처리 상태
 */
public enum TransformStatus {
    PENDING("대기중"),
    PROCESSING("처리중"),
    COMPLETED("완료"),
    FAILED("실패");

    private final String label;

    TransformStatus(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
