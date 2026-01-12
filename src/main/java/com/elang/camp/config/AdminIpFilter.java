package com.elang.camp.config;

import com.elang.camp.domain.cms.admin.AdminAccessService;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * Admin 페이지 IP 필터
 * /login, /admin 경로에 대해 IP 제한 적용
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
@RequiredArgsConstructor
@Slf4j
public class AdminIpFilter implements Filter {

    private final AdminAccessService adminAccessService;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestUri = httpRequest.getRequestURI();

        // /login 또는 /admin 경로인지 확인
        if (requestUri.equals("/login") || requestUri.startsWith("/admin")) {
            String clientIp = getClientIp(httpRequest);

            if (!adminAccessService.canAccessAdmin(clientIp)) {
                log.warn("Admin access denied for IP: {} on path: {}", clientIp, requestUri);
                // 접근 불가 시 메인 페이지로 리다이렉트
                httpResponse.sendRedirect("/ko");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    /**
     * 클라이언트 IP 주소 추출
     * 프록시/로드밸런서를 통해 오는 경우 X-Forwarded-For 헤더 확인
     */
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }

        // 여러 IP가 있는 경우 첫 번째 IP 반환
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }

        return ip;
    }
}
