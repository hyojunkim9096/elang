package com.elang.camp.domain.cms.content;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ContentPageRepository extends JpaRepository<ContentPage, Long> {

    List<ContentPage> findByLangOrderByCreatedAtDesc(String lang);

    List<ContentPage> findAllByOrderByCreatedAtDesc();

    List<ContentPage> findByCategoryIdOrderByCreatedAtDesc(Long categoryId);

    Optional<ContentPage> findByLangAndPageKey(String lang, String pageKey);

    boolean existsByLangAndPageKey(String lang, String pageKey);
}
