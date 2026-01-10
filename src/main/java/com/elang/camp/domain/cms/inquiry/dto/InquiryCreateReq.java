package com.elang.camp.domain.cms.inquiry.dto;

import lombok.Getter;
import lombok.Setter;

/**
 * 사용자 문의 등록 요청 DTO
 */
@Getter
@Setter
public class InquiryCreateReq {
    private String lang = "ko";
    private String name;
    private String email;
    private String phone;
    private String subject;
    private String content;
}
