package com.elang.camp.domain.cms.inquiry;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 상담/문의 Entity
 */
@Entity
@Table(name = "inquiry")
@Getter @Setter
public class Inquiry {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** 언어 코드 (ko, en) */
    @Column(length = 2, nullable = false)
    private String lang = "ko";

    /** 이름 */
    @Column(length = 100, nullable = false)
    private String name;

    /** 이메일 */
    @Column(length = 255)
    private String email;

    /** 연락처 */
    @Column(length = 20)
    private String phone;

    /** 제목 */
    @Column(length = 255, nullable = false)
    private String subject;

    /** 문의 내용 */
    @Lob
    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    /** 상태 */
    @Enumerated(EnumType.STRING)
    @Column(length = 20, nullable = false)
    private InquiryStatus status = InquiryStatus.PENDING;

    /** 관리자 메모 */
    @Lob
    @Column(columnDefinition = "TEXT")
    private String adminMemo;

    /** 읽음 여부 */
    @Column(name = "is_read", nullable = false)
    private Boolean isRead = false;

    /** 생성일시 */
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    /** 수정일시 */
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
