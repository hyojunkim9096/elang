package com.elang.camp.domain.file;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 첨부파일 Service
 */
@Service
@RequiredArgsConstructor
public class AttachFileService {

    private final AttachFileRepository repository;

    /**
     * 첨부파일 저장
     */
    @Transactional
    public AttachFile save(AttachFile file) {
        return repository.save(file);
    }

    /**
     * ID로 조회
     */
    @Transactional(readOnly = true)
    public AttachFile getById(Long id) {
        return repository.findById(id).orElse(null);
    }

    /**
     * 저장된 파일명으로 조회
     */
    @Transactional(readOnly = true)
    public AttachFile getBySavedName(String savedName) {
        return repository.findBySavedName(savedName);
    }

    /**
     * 참조 엔티티의 첨부파일 목록 조회
     */
    @Transactional(readOnly = true)
    public List<AttachFile> listByReference(String referenceType, Long referenceId) {
        return repository.findByReferenceTypeAndReferenceId(referenceType, referenceId);
    }

    /**
     * 첨부파일 삭제
     */
    @Transactional
    public void delete(Long id) {
        repository.deleteById(id);
    }

    /**
     * 참조 정보 업데이트 (게시글 저장 후 파일과 연결)
     */
    @Transactional
    public void updateReference(Long fileId, String referenceType, Long referenceId) {
        AttachFile file = repository.findById(fileId).orElse(null);
        if (file != null) {
            file.setReferenceType(referenceType);
            file.setReferenceId(referenceId);
            repository.save(file);
        }
    }

    /**
     * URL로 파일 찾기 (썸네일 URL -> attach_file 연결용)
     */
    @Transactional(readOnly = true)
    public AttachFile getByUrl(String url) {
        // URL: /uploads/xxx.jpg -> savedName: xxx.jpg
        if (url != null && url.startsWith("/uploads/")) {
            String savedName = url.substring("/uploads/".length());
            return repository.findBySavedName(savedName);
        }
        return null;
    }
}
