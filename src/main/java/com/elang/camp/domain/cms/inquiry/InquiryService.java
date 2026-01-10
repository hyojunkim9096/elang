package com.elang.camp.domain.cms.inquiry;

import com.elang.camp.common.exception.NotFoundException;
import com.elang.camp.domain.cms.inquiry.dto.InquiryCreateReq;
import com.elang.camp.domain.cms.inquiry.dto.InquiryRes;
import com.elang.camp.domain.cms.inquiry.dto.InquiryUpdateReq;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class InquiryService {

    private final InquiryRepository inquiryRepository;

    /**
     * 전체 문의 목록 조회
     */
    public List<InquiryRes> listAll() {
        return inquiryRepository.findAllByOrderByCreatedAtDesc()
            .stream()
            .map(InquiryRes::from)
            .toList();
    }

    /**
     * 언어별 문의 목록 조회
     */
    public List<InquiryRes> listByLang(String lang) {
        return inquiryRepository.findByLangOrderByCreatedAtDesc(lang)
            .stream()
            .map(InquiryRes::from)
            .toList();
    }

    /**
     * 상태별 문의 목록 조회
     */
    public List<InquiryRes> listByStatus(InquiryStatus status) {
        return inquiryRepository.findByStatusOrderByCreatedAtDesc(status)
            .stream()
            .map(InquiryRes::from)
            .toList();
    }

    /**
     * 문의 상세 조회
     */
    public InquiryRes getById(Long id) {
        Inquiry inquiry = inquiryRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("Inquiry not found: " + id));
        return InquiryRes.from(inquiry);
    }

    /**
     * 문의 등록 (사용자)
     */
    @Transactional
    public InquiryRes create(InquiryCreateReq req) {
        Inquiry inquiry = new Inquiry();
        inquiry.setLang(req.getLang() != null ? req.getLang() : "ko");
        inquiry.setName(req.getName());
        inquiry.setEmail(req.getEmail());
        inquiry.setPhone(req.getPhone());
        inquiry.setSubject(req.getSubject());
        inquiry.setContent(req.getContent());
        inquiry.setStatus(InquiryStatus.PENDING);
        inquiry.setIsRead(false);

        Inquiry saved = inquiryRepository.save(inquiry);
        log.info("New inquiry created: id={}, name={}, subject={}", saved.getId(), saved.getName(), saved.getSubject());

        return InquiryRes.from(saved);
    }

    /**
     * 문의 수정 (관리자)
     */
    @Transactional
    public InquiryRes update(Long id, InquiryUpdateReq req) {
        Inquiry inquiry = inquiryRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("Inquiry not found: " + id));

        if (req.getStatus() != null) {
            inquiry.setStatus(req.getStatus());
        }
        if (req.getAdminMemo() != null) {
            inquiry.setAdminMemo(req.getAdminMemo());
        }
        if (req.getIsRead() != null) {
            inquiry.setIsRead(req.getIsRead());
        }

        Inquiry saved = inquiryRepository.save(inquiry);
        return InquiryRes.from(saved);
    }

    /**
     * 문의 읽음 처리
     */
    @Transactional
    public void markAsRead(Long id) {
        Inquiry inquiry = inquiryRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("Inquiry not found: " + id));
        inquiry.setIsRead(true);
        inquiryRepository.save(inquiry);
    }

    /**
     * 문의 삭제
     */
    @Transactional
    public void delete(Long id) {
        if (!inquiryRepository.existsById(id)) {
            throw new NotFoundException("Inquiry not found: " + id);
        }
        inquiryRepository.deleteById(id);
        log.info("Inquiry deleted: id={}", id);
    }

    /**
     * 읽지 않은 문의 수
     */
    public long countUnread() {
        return inquiryRepository.countByIsRead(false);
    }

    /**
     * 대기 중인 문의 수
     */
    public long countPending() {
        return inquiryRepository.countByStatus(InquiryStatus.PENDING);
    }
}
