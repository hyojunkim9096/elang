package com.elang.camp.domain.file;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 첨부파일 Entity
 * 게시글, 에디터 등에서 업로드된 파일 메타정보 관리
 */
@Entity
@Table(name = "attach_file")
@Getter @Setter
public class AttachFile {

    /** 파일 ID */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** 원본 파일명 */
    @Column(name = "original_name", nullable = false)
    private String originalName;

    /** 저장된 파일명 (UUID) */
    @Column(name = "saved_name", nullable = false)
    private String savedName;

    /** 파일 저장 경로 */
    @Column(name = "file_path", nullable = false, length = 500)
    private String filePath;

    /** 파일 크기 (bytes) */
    @Column(name = "file_size", nullable = false)
    private Long fileSize;

    /** MIME 타입 (image/jpeg, application/pdf 등) */
    @Column(name = "content_type", length = 100)
    private String contentType;

    /** 파일 확장자 (.jpg, .pdf 등) */
    @Column(name = "file_extension", length = 20)
    private String fileExtension;

    /** 업로드 유형 (thumbnail, editor, general, attachment) */
    @Column(name = "upload_type", length = 50)
    private String uploadType;

    /** 참조 엔티티 타입 (board_post_thumbnail, board_post_attachment 등) */
    @Column(name = "reference_type", length = 50)
    private String referenceType;

    /** 참조 엔티티 ID */
    @Column(name = "reference_id")
    private Long referenceId;

    /** 업로드 일시 */
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    /**
     * 웹 접근 URL 반환
     * @return /uploads/{savedName} 형태의 URL
     */
    public String getUrl() {
        return "/uploads/" + savedName;
    }
}
