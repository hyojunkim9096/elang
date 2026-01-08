package com.elang.camp.domain.cms.layout;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SiteLayoutRepository extends JpaRepository<SiteLayout, String> {

    Optional<SiteLayout> findByLang(String lang);
}
