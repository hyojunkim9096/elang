package com.elang.camp.domain.cms.layout;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 사이트 레이아웃 Entity
 * 헤더/푸터 HTML을 언어별로 관리
 */
@Entity
@Table(name = "site_layout")
@Getter @Setter
public class SiteLayout {

    /** 언어 코드 (ko, en) - PK */
    @Id
    @Column(length = 2, nullable = false)
    private String lang;

    /** 헤더 HTML */
    @Lob
    @Column(name = "header_html", nullable = false, columnDefinition = "LONGTEXT")
    private String headerHtml;

    /** 푸터 HTML */
    @Lob
    @Column(name = "footer_html", nullable = false, columnDefinition = "LONGTEXT")
    private String footerHtml;

    /** 수정일시 */
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
