package com.elang.camp.domain.question;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuestionTransformRepository extends JpaRepository<QuestionTransform, Long> {

    List<QuestionTransform> findAllByOrderByCreatedAtDesc();

    List<QuestionTransform> findByDifficultyOrderByCreatedAtDesc(DifficultyLevel difficulty);

    List<QuestionTransform> findByStatusOrderByCreatedAtDesc(TransformStatus status);

    long countByStatus(TransformStatus status);
}
