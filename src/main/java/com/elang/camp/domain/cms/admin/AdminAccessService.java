package com.elang.camp.domain.cms.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminAccessService {

    private final AdminConfigRepository configRepository;
    private final AllowedAdminIpRepository ipRepository;

    /**
     * Admin 설정 조회
     */
    public AdminConfig getConfig() {
        return configRepository.getConfig();
    }

    /**
     * AccessMode 변경
     */
    @Transactional
    public AdminConfig updateAccessMode(AdminConfig.AccessMode accessMode) {
        AdminConfig config = configRepository.getConfig();
        config.setAccessMode(accessMode);
        return configRepository.save(config);
    }

    /**
     * 허용 IP 목록 조회
     */
    public List<AllowedAdminIp> getAllowedIps() {
        return ipRepository.findAllByOrderByCreatedAtDesc();
    }

    /**
     * IP 허용 추가
     */
    @Transactional
    public AllowedAdminIp addAllowedIp(String ipAddress, String description) {
        if (ipRepository.existsByIpAddress(ipAddress)) {
            throw new IllegalArgumentException("이미 등록된 IP입니다: " + ipAddress);
        }
        return ipRepository.save(new AllowedAdminIp(ipAddress, description));
    }

    /**
     * IP 삭제
     */
    @Transactional
    public void removeAllowedIp(Long id) {
        ipRepository.deleteById(id);
    }

    /**
     * IP가 허용되어 있는지 확인
     */
    public boolean isIpAllowed(String clientIp) {
        AdminConfig config = getConfig();

        // 전체 허용 모드면 true
        if (config.getAccessMode() == AdminConfig.AccessMode.ALL) {
            return true;
        }

        // IP 제한 모드면 등록된 IP인지 확인
        return ipRepository.existsByIpAddress(clientIp);
    }

    /**
     * Admin 접근이 가능한지 확인 (login, admin 페이지용)
     */
    public boolean canAccessAdmin(String clientIp) {
        return isIpAllowed(clientIp);
    }
}
