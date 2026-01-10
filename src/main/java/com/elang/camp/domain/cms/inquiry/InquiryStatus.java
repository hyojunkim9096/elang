package com.elang.camp.domain.cms.inquiry;

/**
 * 문의 상태
 */
public enum InquiryStatus {
    PENDING("대기중"),
    IN_PROGRESS("처리중"),
    COMPLETED("완료");

    private final String label;

    InquiryStatus(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
