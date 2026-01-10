package com.elang.camp.domain.cms.inquiry.dto;

import com.elang.camp.domain.cms.inquiry.Inquiry;
import com.elang.camp.domain.cms.inquiry.InquiryStatus;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class InquiryRes {
    private Long id;
    private String lang;
    private String name;
    private String email;
    private String phone;
    private String subject;
    private String content;
    private InquiryStatus status;
    private String statusLabel;
    private String adminMemo;
    private Boolean isRead;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static InquiryRes from(Inquiry inquiry) {
        return InquiryRes.builder()
            .id(inquiry.getId())
            .lang(inquiry.getLang())
            .name(inquiry.getName())
            .email(inquiry.getEmail())
            .phone(inquiry.getPhone())
            .subject(inquiry.getSubject())
            .content(inquiry.getContent())
            .status(inquiry.getStatus())
            .statusLabel(inquiry.getStatus().getLabel())
            .adminMemo(inquiry.getAdminMemo())
            .isRead(inquiry.getIsRead())
            .createdAt(inquiry.getCreatedAt())
            .updatedAt(inquiry.getUpdatedAt())
            .build();
    }
}
