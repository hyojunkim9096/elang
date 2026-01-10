package com.elang.camp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * 로컬 실행 + 외부 톰캣 WAR 배포(Cafe24) 둘 다 지원
 */
@SpringBootApplication
public class ElangCampApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(ElangCampApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        // 외부 Tomcat으로 배포될 때 'cafe24' 프로필을 활성화합니다.
        return builder.sources(ElangCampApplication.class).profiles("cafe24");
    }
}
