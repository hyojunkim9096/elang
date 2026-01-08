package com.elang.camp.common.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class YoutubeUtil {

    // ✅ 자바 문자열에서는 역슬래시를 \\ 로 써야 합니다.
    private static final Pattern ID_PATTERN = Pattern.compile(
            "(?:youtu\\.be/|youtube\\.com/(?:watch\\?v=|embed/|shorts/))([A-Za-z0-9_-]{6,})"
    );

    private YoutubeUtil() {}

    public static String toEmbedUrl(String raw) {
        if (raw == null) return null;
        String s = raw.trim();
        if (s.isEmpty()) return null;

        if (s.contains("youtube.com/embed/")) return s;

        Matcher m = ID_PATTERN.matcher(s);
        if (m.find()) {
            String id = m.group(1);
            return "https://www.youtube.com/embed/" + id;
        }
        return s;
    }
}
