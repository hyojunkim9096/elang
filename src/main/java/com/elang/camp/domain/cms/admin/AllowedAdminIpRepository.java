package com.elang.camp.domain.cms.admin;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AllowedAdminIpRepository extends JpaRepository<AllowedAdminIp, Long> {

    Optional<AllowedAdminIp> findByIpAddress(String ipAddress);

    boolean existsByIpAddress(String ipAddress);

    List<AllowedAdminIp> findAllByOrderByCreatedAtDesc();
}
