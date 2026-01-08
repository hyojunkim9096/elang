package com.elang.camp.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Spring MVC 설정
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${file.upload.path:src/main/resources/static/uploads}")
    private String uploadPath;

    /**
     * 정적 리소스 핸들러 설정
     * /uploads/** URL을 실제 파일 경로에 매핑
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // uploads 폴더 매핑
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadPath + "/");
    }
}
