package com.elang.camp.domain.question;

/**
 * 문제 난이도
 */
public enum DifficultyLevel {
    HIGH("상"),
    MEDIUM("중"),
    LOW("하");

    private final String label;

    DifficultyLevel(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
