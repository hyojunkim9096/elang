package com.elang.camp.config;

import com.elang.camp.domain.cms.admin.AdminUserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

/**
 * 애플리케이션 시작 시 기본 관리자 계정 생성
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AdminInitializer implements ApplicationRunner {

    private final AdminUserService adminUserService;
    private final AdminAccountProperties adminAccountProperties;

    @Override
    public void run(ApplicationArguments args) {
        // DB에 관리자가 없으면 기본 관리자 생성 (properties 설정 사용)
        adminUserService.createDefaultAdminIfNotExists(
                adminAccountProperties.username(),
                adminAccountProperties.password()
        );
        log.info("Admin user initialization completed");
    }
}
