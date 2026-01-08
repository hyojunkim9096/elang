package com.elang.camp.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public InMemoryUserDetailsManager userDetailsService(AdminAccountProperties props) {
        UserDetails admin = User.withUsername(props.username())
                .password("{noop}" + props.password())
                .roles("ADMIN")
                .build();
        return new InMemoryUserDetailsManager(admin);
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        // API 엔드포인트만 CSRF 비활성화 (JSON 통신)
        http.csrf(csrf -> csrf
                .ignoringRequestMatchers("/api/**", "/admin/menus/reorder", "/admin/upload-image")
        );

        http.authorizeHttpRequests(auth -> auth
                .requestMatchers("/login", "/error", "/assets/**", "/uploads/**", "/favicon.ico").permitAll()
                .requestMatchers("/admin/**", "/api/admin/**").hasRole("ADMIN")
                .anyRequest().permitAll()
        );

        http.formLogin(form -> form
                .loginPage("/login")
                .defaultSuccessUrl("/admin", true)
                .permitAll()
        );

        http.logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/ko")
        );

        return http.build();
    }
}
