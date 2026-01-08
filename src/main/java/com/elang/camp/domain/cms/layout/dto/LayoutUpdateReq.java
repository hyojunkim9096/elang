package com.elang.camp.domain.cms.layout.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter // Request 객체는 값을 담아야 하므로 Setter나 생성자가 필요합니다.
@NoArgsConstructor
@AllArgsConstructor
public class LayoutUpdateReq {
    @NotNull(message = "headerHtml은 null일 수 없습니다.")
    private String headerHtml;

    @NotNull(message = "footerHtml은 null일 수 없습니다.")
    private String footerHtml;
}