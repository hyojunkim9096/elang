package com.elang.camp.domain.cms.admin;

import com.elang.camp.domain.cms.admin.dto.AdminUserReq;
import com.elang.camp.domain.cms.admin.dto.AdminUserRes;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminUserService {

    private final AdminUserRepository repository;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public List<AdminUserRes> listAll() {
        return repository.findAll().stream()
                .map(this::toRes)
                .toList();
    }

    @Transactional(readOnly = true)
    public AdminUserRes getById(Long id) {
        return repository.findById(id)
                .map(this::toRes)
                .orElse(null);
    }

    @Transactional(readOnly = true)
    public AdminUser findByUsername(String username) {
        return repository.findByUsername(username).orElse(null);
    }

    @Transactional
    public AdminUserRes create(AdminUserReq req) {
        if (repository.existsByUsername(req.getUsername())) {
            throw new IllegalArgumentException("이미 존재하는 아이디입니다.");
        }

        AdminUser user = new AdminUser();
        user.setUsername(req.getUsername());
        user.setPassword(passwordEncoder.encode(req.getPassword()));
        user.setName(req.getName());
        user.setEmail(req.getEmail());
        user.setRole(req.getRole() != null ? req.getRole() : "ADMIN");
        user.setEnabled(req.getEnabled() != null ? req.getEnabled() : true);

        return toRes(repository.save(user));
    }

    @Transactional
    public AdminUserRes update(Long id, AdminUserReq req) {
        AdminUser user = repository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("관리자를 찾을 수 없습니다."));

        // username 변경 시 중복 체크
        if (!user.getUsername().equals(req.getUsername()) && repository.existsByUsername(req.getUsername())) {
            throw new IllegalArgumentException("이미 존재하는 아이디입니다.");
        }

        user.setUsername(req.getUsername());
        user.setName(req.getName());
        user.setEmail(req.getEmail());
        user.setRole(req.getRole() != null ? req.getRole() : "ADMIN");
        user.setEnabled(req.getEnabled() != null ? req.getEnabled() : true);

        // 비밀번호가 입력된 경우에만 변경
        if (req.getPassword() != null && !req.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(req.getPassword()));
        }

        return toRes(repository.save(user));
    }

    @Transactional
    public void delete(Long id) {
        // 마지막 관리자는 삭제 불가
        long count = repository.count();
        if (count <= 1) {
            throw new IllegalStateException("최소 1명의 관리자가 필요합니다.");
        }
        repository.deleteById(id);
    }

    @Transactional
    public void updateLastLogin(String username) {
        repository.findByUsername(username).ifPresent(user -> {
            user.setLastLoginAt(LocalDateTime.now());
            repository.save(user);
        });
    }

    @Transactional
    public void changePassword(Long id, String currentPassword, String newPassword) {
        AdminUser user = repository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("관리자를 찾을 수 없습니다."));

        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("현재 비밀번호가 일치하지 않습니다.");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        repository.save(user);
    }

    /**
     * 초기 관리자 생성 (DB에 관리자가 없을 경우)
     */
    @Transactional
    public void createDefaultAdminIfNotExists(String username, String password) {
        if (repository.count() == 0) {
            AdminUser admin = new AdminUser();
            admin.setUsername(username);
            admin.setPassword(passwordEncoder.encode(password));
            admin.setName("관리자");
            admin.setRole("ADMIN");
            admin.setEnabled(true);
            repository.save(admin);
        }
    }

    private AdminUserRes toRes(AdminUser user) {
        return AdminUserRes.builder()
                .id(user.getId())
                .username(user.getUsername())
                .name(user.getName())
                .email(user.getEmail())
                .role(user.getRole())
                .enabled(user.getEnabled())
                .lastLoginAt(user.getLastLoginAt())
                .createdAt(user.getCreatedAt())
                .build();
    }
}
