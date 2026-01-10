package com.elang.camp.domain.cms.inquiry.dto;

import com.elang.camp.domain.cms.inquiry.InquiryStatus;
import lombok.Getter;
import lombok.Setter;

/**
 * 관리자 문의 수정 요청 DTO
 */
@Getter
@Setter
public class InquiryUpdateReq {
    private InquiryStatus status;
    private String adminMemo;
    private Boolean isRead;
}
