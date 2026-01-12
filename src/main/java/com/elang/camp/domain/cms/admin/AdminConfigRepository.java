package com.elang.camp.domain.cms.admin;

import org.springframework.data.jpa.repository.JpaRepository;

public interface AdminConfigRepository extends JpaRepository<AdminConfig, String> {

    default AdminConfig getConfig() {
        return findById("default").orElseGet(() -> {
            AdminConfig config = new AdminConfig();
            return save(config);
        });
    }
}
