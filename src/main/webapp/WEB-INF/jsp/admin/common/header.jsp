<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <title>${title != null ? title : 'Admin'} - CMS</title>
  <link rel="stylesheet" href="/assets/css/admin.css"/>
  <link rel="stylesheet" href="/resources/css/modal.css?v=1.0.3"/>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body class="admin-body with-sidebar">

<!-- Header -->
<header class="admin-header">
  <div class="header-content">
    <div class="logo">CMS Admin</div>
    <div class="header-actions">
      <div class="lang-switcher">
        <a href="?lang=ko" class="lang-btn ${adminLang == 'ko' ? 'active' : ''}">한국어</a>
        <a href="?lang=en" class="lang-btn ${adminLang == 'en' ? 'active' : ''}">English</a>
      </div>
      <a class="header-link" href="/ko" target="_blank">🌐 공개(ko)</a>
      <a class="header-link" href="/en" target="_blank">🌐 공개(en)</a>
      <form action="/logout" method="post" style="display:inline;">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <button class="btn-logout" type="submit">로그아웃</button>
      </form>
    </div>
  </div>
</header>

<style>
.lang-switcher {
  display: inline-flex;
  gap: 4px;
  margin-right: 16px;
  background: #f3f4f6;
  border-radius: 6px;
  padding: 4px;
}
.lang-btn {
  padding: 6px 12px;
  text-decoration: none;
  color: #6b7280;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.2s;
}
.lang-btn:hover {
  background: #e5e7eb;
  color: #374151;
}
.lang-btn.active {
  background: #3b82f6;
  color: white;
}
</style>

<div class="admin-container">
