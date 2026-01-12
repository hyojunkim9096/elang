package com.elang.camp.config;

import com.elang.camp.domain.cms.admin.AdminUserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import java.io.IOException;

@Configuration
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationSuccessHandler loginSuccessHandler(AdminUserService adminUserService) {
        return new AuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                                Authentication authentication) throws IOException {
                // 마지막 로그인 시간 업데이트
                adminUserService.updateLastLogin(authentication.getName());
                response.sendRedirect("/admin");
            }
        };
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, AuthenticationSuccessHandler loginSuccessHandler) throws Exception {
        // API 엔드포인트만 CSRF 비활성화 (JSON 통신)
        http.csrf(csrf -> csrf
                .ignoringRequestMatchers("/api/**", "/admin/menus/reorder", "/admin/upload-image")
        );

        http.authorizeHttpRequests(auth -> auth
                // 정적 리소스 및 공용 페이지는 모두 허용
                .requestMatchers(
                    new AntPathRequestMatcher("/"),
                    new AntPathRequestMatcher("/login"),
                    new AntPathRequestMatcher("/error"),
                    new AntPathRequestMatcher("/assets/**"),
                    new AntPathRequestMatcher("/uploads/**"),
                    new AntPathRequestMatcher("/favicon.ico"),
                    // 언어 코드가 포함된 모든 공개 경로 허용
                    new AntPathRequestMatcher("/{lang:(?:ko|en)}/**"),
                    // 공개 댓글 API
                    new AntPathRequestMatcher("/api/comments/**")
                ).permitAll()
                // 관리자 페이지는 ADMIN 역할 필요
                .requestMatchers("/admin/**", "/api/admin/**").hasRole("ADMIN")
                // 그 외 모든 요청은 일단 허용 (필요 시 더 세분화 가능)
                .anyRequest().permitAll()
        );

        http.formLogin(form -> form
                .loginPage("/login")
                .successHandler(loginSuccessHandler)
                .permitAll()
        );

        http.logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/ko")
        );

        return http.build();
    }
}
