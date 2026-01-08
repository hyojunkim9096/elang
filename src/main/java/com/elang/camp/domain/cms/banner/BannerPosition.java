package com.elang.camp.domain.cms.banner;

/**
 * 배너 위치
 */
public enum BannerPosition {
    /** 상단 배너 (1920x200px) */
    TOP_BANNER(1920, 200, "상단 배너"),
    
    /** 중단 배너 (1920x400px) */
    MIDDLE_BANNER(1920, 400, "중단 배너"),
    
    /** 하단 배너 (1920x200px) */
    BOTTOM_BANNER(1920, 200, "하단 배너"),
    
    /** 팝업 배너 (600x800px, 최대 3개) */
    POPUP_BANNER(600, 800, "팝업 배너"),
    
    /** 사이드 배너 (300x600px) */
    SIDE_BANNER(300, 600, "사이드 배너");

    private final int defaultWidth;
    private final int defaultHeight;
    private final String description;

    BannerPosition(int defaultWidth, int defaultHeight, String description) {
        this.defaultWidth = defaultWidth;
        this.defaultHeight = defaultHeight;
        this.description = description;
    }

    public int getDefaultWidth() {
        return defaultWidth;
    }

    public int getDefaultHeight() {
        return defaultHeight;
    }

    public String getDescription() {
        return description;
    }
}
