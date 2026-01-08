package com.elang.camp.domain.cms.menu.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter // 데이터를 담기 위해 Setter가 필요합니다.
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MenuUpsertReq {

    @NotBlank(message = "lang은 필수입니다. (ko|en)")
    private String lang;

    @NotBlank(message = "menuType은 필수입니다. (public|admin)")
    private String menuType;

    private Long parentId;

    @NotBlank(message = "label은 필수입니다.")
    @Size(max = 64, message = "label은 64자 이하여야 합니다.")
    private String label;

    @NotBlank(message = "href은 필수입니다.")
    @Size(max = 255, message = "href은 255자 이하여야 합니다.")
    private String href;

    @NotNull(message = "sortOrder는 필수입니다.")
    private Integer sortOrder;

    @NotNull(message = "enabled는 필수입니다.")
    private Boolean enabled;
}