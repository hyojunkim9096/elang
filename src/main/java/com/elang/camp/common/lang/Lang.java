package com.elang.camp.common.lang;

public enum Lang {
    KO("ko"),
    EN("en");

    private final String code;

    Lang(String code) {
        this.code = code;
    }

    public String code() {
        return code;
    }

    public static Lang from(String raw) {
        if (raw == null || raw.isBlank()) return KO;
        String v = raw.trim().toLowerCase();
        return switch (v) {
            case "ko" -> KO;
            case "en" -> EN;
            default -> throw new IllegalArgumentException("지원하지 않는 lang 입니다: " + raw);
        };
    }
}
