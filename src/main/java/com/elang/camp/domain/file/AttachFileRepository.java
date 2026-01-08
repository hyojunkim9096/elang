package com.elang.camp.domain.file;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * 첨부파일 Repository
 */
public interface AttachFileRepository extends JpaRepository<AttachFile, Long> {

    /**
     * 참조 타입과 ID로 첨부파일 조회
     */
    List<AttachFile> findByReferenceTypeAndReferenceId(String referenceType, Long referenceId);

    /**
     * 업로드 타입으로 조회
     */
    List<AttachFile> findByUploadType(String uploadType);

    /**
     * 저장된 파일명으로 조회
     */
    AttachFile findBySavedName(String savedName);
}
