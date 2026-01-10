package com.elang.camp.domain.cms.inquiry;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface InquiryRepository extends JpaRepository<Inquiry, Long> {

    List<Inquiry> findAllByOrderByCreatedAtDesc();

    List<Inquiry> findByLangOrderByCreatedAtDesc(String lang);

    List<Inquiry> findByStatusOrderByCreatedAtDesc(InquiryStatus status);

    long countByIsRead(Boolean isRead);

    long countByStatus(InquiryStatus status);
}
