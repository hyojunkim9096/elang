<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="langParam" value="${not empty adminLang ? adminLang : 'ko'}"/>
<!-- Sidebar Toggle Button -->
<button class="sidebar-toggle" id="sidebarToggle" title="사이드바 접기/펼치기">
  <span id="toggleIcon">◀</span>
</button>
<!-- Sidebar -->
<aside class="admin-sidebar" id="adminSidebar">
  <nav class="sidebar-nav">
    <c:if test="${empty adminMenus}">
      <!-- 기본 메뉴 (DB에 메뉴가 없을 경우) -->
      <div class="nav-section">
        <div class="nav-title">CMS 관리</div>
        <a href="/admin?lang=${langParam}" class="nav-item ${active == 'dashboard' ? 'active' : ''}">
          <span class="nav-icon">🏠</span>
          <span class="nav-text">대시보드</span>
        </a>
        <a href="/admin/layout?lang=${langParam}" class="nav-item ${active == 'layout' ? 'active' : ''}">
          <span class="nav-icon">🎨</span>
          <span class="nav-text">레이아웃 관리</span>
        </a>
        <a href="/admin/menus?lang=${langParam}" class="nav-item ${active == 'menus' ? 'active' : ''}">
          <span class="nav-icon">📋</span>
          <span class="nav-text">메뉴 관리</span>
        </a>
        <a href="/admin/banners?lang=${langParam}" class="nav-item ${active == 'banners' ? 'active' : ''}">
          <span class="nav-icon">🖼️</span>
          <span class="nav-text">배너 관리</span>
        </a>
      </div>

      <div class="nav-section">
        <div class="nav-title">컨텐츠</div>
        <a href="/admin/content-categories?lang=${langParam}" class="nav-item ${active == 'content-categories' ? 'active' : ''}">
          <span class="nav-icon">📁</span>
          <span class="nav-text">카테고리</span>
        </a>
        <a href="/admin/content-pages?lang=${langParam}" class="nav-item ${active == 'content-pages' ? 'active' : ''}">
          <span class="nav-icon">📄</span>
          <span class="nav-text">컨텐츠 페이지</span>
        </a>
      </div>

      <div class="nav-section">
        <div class="nav-title">게시판</div>
        <a href="/admin/board-categories?lang=${langParam}" class="nav-item ${active == 'board-categories' ? 'active' : ''}">
          <span class="nav-icon">📁</span>
          <span class="nav-text">카테고리</span>
        </a>
        <a href="/admin/board-posts?lang=${langParam}" class="nav-item ${active == 'board-posts' ? 'active' : ''}">
          <span class="nav-icon">📝</span>
          <span class="nav-text">게시글</span>
        </a>
      </div>

      <div class="nav-section">
        <div class="nav-title">고객관리</div>
        <a href="/admin/inquiries?lang=${langParam}" class="nav-item ${active == 'inquiries' ? 'active' : ''}">
          <span class="nav-icon">💬</span>
          <span class="nav-text">문의 관리</span>
        </a>
      </div>

      <div class="nav-section">
        <div class="nav-title">설정</div>
        <a href="/admin/users?lang=${langParam}" class="nav-item ${active == '/admin/users' ? 'active' : ''}">
          <span class="nav-icon">👤</span>
          <span class="nav-text">관리자 계정</span>
        </a>
        <a href="/admin/access?lang=${langParam}" class="nav-item ${active == '/admin/access' ? 'active' : ''}">
          <span class="nav-icon">🔐</span>
          <span class="nav-text">접근 설정</span>
        </a>
      </div>
    </c:if>

    <c:if test="${not empty adminMenus}">
      <!-- 동적 메뉴 (DB에서 로드) -->
      <c:forEach var="rootMenu" items="${adminMenus}">
        <c:if test="${rootMenu.parentId == null || rootMenu.parentId == 0}">
          <div class="nav-section">
            <div class="nav-title">${rootMenu.label}</div>

            <!-- 1뎁스 메뉴의 자식들 표시 -->
            <c:forEach var="menu" items="${adminMenus}">
              <c:if test="${menu.parentId != null && menu.parentId == rootMenu.id}">
                <div class="nav-item-wrapper">
                  <a href="${menu.href}?lang=${langParam}" class="nav-item ${active == menu.href ? 'active' : ''}">
                    <span class="nav-icon">📄</span>
                    <span class="nav-text">${menu.label}</span>
                  </a>
                  <button class="favorite-btn ${menu.isFavorite ? 'is-favorite' : ''}"
                          onclick="toggleFavorite(${menu.id}, this)"
                          title="${menu.isFavorite ? '즐겨찾기 해제' : '즐겨찾기 추가'}">
                    ⭐
                  </button>
                </div>

                <!-- 2뎁스 메뉴의 자식들 표시 (들여쓰기) -->
                <c:forEach var="subMenu" items="${adminMenus}">
                  <c:if test="${subMenu.parentId != null && subMenu.parentId == menu.id}">
                    <a href="${subMenu.href}?lang=${langParam}" class="nav-item nav-item-sub ${active == subMenu.href ? 'active' : ''}">
                      <span class="nav-icon">└</span>
                      <span class="nav-text">${subMenu.label}</span>
                    </a>
                  </c:if>
                </c:forEach>
              </c:if>
            </c:forEach>
          </div>
        </c:if>
      </c:forEach>
    </c:if>
  </nav>
</aside>

<style>
.nav-item-wrapper {
  display: flex;
  align-items: center;
  position: relative;
}
.nav-item-wrapper .nav-item {
  flex: 1;
  margin: 0;
}
.favorite-btn {
  background: none;
  border: none;
  font-size: 14px;
  cursor: pointer;
  padding: 8px;
  opacity: 0.3;
  transition: opacity 0.2s, transform 0.2s;
}
.nav-item-wrapper:hover .favorite-btn {
  opacity: 0.6;
}
.favorite-btn:hover {
  opacity: 1 !important;
  transform: scale(1.2);
}
.favorite-btn.is-favorite {
  opacity: 1;
}
</style>

<script>
// 사이드바 접기/펼치기
(function() {
  const sidebar = document.getElementById('adminSidebar');
  const toggleBtn = document.getElementById('sidebarToggle');
  const toggleIcon = document.getElementById('toggleIcon');

  // 로컬 스토리지에서 상태 복원
  const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
  if (isCollapsed) {
    sidebar.classList.add('collapsed');
    toggleBtn.classList.add('collapsed');
    document.body.classList.add('sidebar-collapsed');
    toggleIcon.textContent = '▶';
  }

  toggleBtn.addEventListener('click', function() {
    sidebar.classList.toggle('collapsed');
    toggleBtn.classList.toggle('collapsed');
    document.body.classList.toggle('sidebar-collapsed');

    const nowCollapsed = sidebar.classList.contains('collapsed');
    toggleIcon.textContent = nowCollapsed ? '▶' : '◀';
    localStorage.setItem('sidebarCollapsed', nowCollapsed);
  });
})();

function toggleFavorite(menuId, btn) {
  const csrfToken = document.querySelector('meta[name="_csrf"]')?.content || '${_csrf.token}';
  const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content || '${_csrf.headerName}';

  fetch('/admin/menu/' + menuId + '/toggle-favorite', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      [csrfHeader]: csrfToken
    }
  })
  .then(response => {
    if (response.ok) {
      btn.classList.toggle('is-favorite');
      const isFavorite = btn.classList.contains('is-favorite');
      btn.title = isFavorite ? '즐겨찾기 해제' : '즐겨찾기 추가';

      // 대시보드에서 즐겨찾기 변경 시 페이지 새로고침
      if (window.location.pathname.includes('/admin') && window.location.search.includes('lang=')) {
        window.location.reload();
      } else if (window.location.pathname === '/admin') {
        window.location.reload();
      }
    } else {
      console.error('즐겨찾기 토글 실패:', response.status);
      alert('즐겨찾기 변경에 실패했습니다.');
    }
  })
  .catch(error => {
    console.error('즐겨찾기 토글 에러:', error);
    alert('오류가 발생했습니다.');
  });
}
</script>
