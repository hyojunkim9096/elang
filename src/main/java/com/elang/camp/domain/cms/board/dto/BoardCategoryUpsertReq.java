package com.elang.camp.domain.cms.board.dto;

import com.elang.camp.domain.cms.board.DisplayType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class BoardCategoryUpsertReq {

    @NotBlank
    private String lang;

    @NotBlank
    private String categoryKey;

    @NotBlank
    private String name;

    private String description;

    @NotNull
    private DisplayType displayType;

    @NotNull
    private Integer sortOrder;

    @NotNull
    private Boolean enabled;
}
