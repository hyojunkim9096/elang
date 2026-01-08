package com.elang.camp.domain.cms.layout.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class LayoutRes {
    private String lang;
    private String headerHtml;
    private String footerHtml;
}