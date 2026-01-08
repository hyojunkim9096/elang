<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">
<div class="page-header">
  <h1>대시보드</h1>
  <p class="subtitle">즐겨찾기한 메뉴를 빠르게 이용하세요. 사이드바에서 ⭐ 클릭으로 추가/제거할 수 있습니다.</p>
</div>

<c:choose>
  <c:when test="${empty favorites}">
    <div class="panel">
      <div class="panel-body">
        <p class="hint">즐겨찾기한 메뉴가 없습니다. 사이드바에서 자주 사용하는 메뉴를 즐겨찾기로 추가해보세요!</p>
      </div>
    </div>
  </c:when>
  <c:otherwise>
    <div style="margin-bottom: 16px; padding: 12px; background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 6px; color: #1e40af; font-size: 14px;">
      💡 <strong>Tip:</strong> 드래그 앤 드롭으로 카드 순서를 변경할 수 있습니다.
    </div>
    <div class="dashboard-grid" id="favorites-grid">
      <c:forEach var="menu" items="${favorites}">
        <div class="dashboard-card" data-menu-id="${menu.id}" draggable="true">
          <div class="drag-handle">⋮⋮</div>
          <div class="card-icon-wrapper">
            <c:choose>
              <c:when test="${menu.href.contains('layout')}">
                <span class="icon-emoji">🎨</span>
                <span class="icon-text">Layout</span>
              </c:when>
              <c:when test="${menu.href.contains('menus')}">
                <span class="icon-emoji">📋</span>
                <span class="icon-text">Menu</span>
              </c:when>
              <c:when test="${menu.href.contains('banners')}">
                <span class="icon-emoji">🖼️</span>
                <span class="icon-text">Banner</span>
              </c:when>
              <c:when test="${menu.href.contains('content-categories')}">
                <span class="icon-emoji">📁</span>
                <span class="icon-text">Category</span>
              </c:when>
              <c:when test="${menu.href.contains('content-pages')}">
                <span class="icon-emoji">📄</span>
                <span class="icon-text">Page</span>
              </c:when>
              <c:when test="${menu.href.contains('board-categories')}">
                <span class="icon-emoji">📁</span>
                <span class="icon-text">Category</span>
              </c:when>
              <c:when test="${menu.href.contains('board-posts')}">
                <span class="icon-emoji">📝</span>
                <span class="icon-text">Post</span>
              </c:when>
              <c:otherwise>
                <span class="icon-emoji">📌</span>
                <span class="icon-text">Menu</span>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="card-content">
            <h3>${menu.label}</h3>
            <a href="${menu.href}" class="btn btn-sm btn-primary">
              <c:choose>
                <c:when test="${adminLang == 'en'}">Manage</c:when>
                <c:otherwise>관리하기</c:otherwise>
              </c:choose>
            </a>
          </div>
        </div>
      </c:forEach>
    </div>

<style>
.dashboard-card {
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  padding: 20px;
  transition: all 0.2s;
  position: relative;
  cursor: grab;
}
.dashboard-card:active {
  cursor: grabbing;
}
.dashboard-card:hover {
  border-color: #3b82f6;
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1);
}
.dashboard-card.dragging {
  opacity: 0.5;
  transform: scale(0.95);
}
.dashboard-card.drag-over {
  border-color: #3b82f6;
  border-width: 2px;
  background: #eff6ff;
}
.drag-handle {
  position: absolute;
  top: 8px;
  right: 8px;
  color: #d1d5db;
  font-size: 16px;
  cursor: grab;
  user-select: none;
}
.drag-handle:active {
  cursor: grabbing;
}
.card-icon-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 16px;
}
.icon-emoji {
  font-size: 48px;
  line-height: 1;
  margin-bottom: 8px;
}
.icon-text {
  font-size: 12px;
  color: #9ca3af;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
.card-content h3 {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 12px;
  color: #1f2937;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const grid = document.getElementById('favorites-grid');
  if (!grid) return;

  const cards = grid.querySelectorAll('.dashboard-card');
  let draggedElement = null;

  cards.forEach(card => {
    // 드래그 시작
    card.addEventListener('dragstart', function(e) {
      draggedElement = this;
      this.classList.add('dragging');
      e.dataTransfer.effectAllowed = 'move';
      e.dataTransfer.setData('text/html', this.innerHTML);
    });

    // 드래그 종료
    card.addEventListener('dragend', function(e) {
      this.classList.remove('dragging');
      cards.forEach(c => c.classList.remove('drag-over'));

      // 순서 저장
      saveFavoriteOrder();
    });

    // 드래그 오버
    card.addEventListener('dragover', function(e) {
      e.preventDefault();
      e.dataTransfer.dropEffect = 'move';

      if (this === draggedElement) return;

      this.classList.add('drag-over');
    });

    // 드래그 떠남
    card.addEventListener('dragleave', function(e) {
      this.classList.remove('drag-over');
    });

    // 드롭
    card.addEventListener('drop', function(e) {
      e.preventDefault();
      e.stopPropagation();

      if (this === draggedElement) return;

      this.classList.remove('drag-over');

      // 위치 변경
      const allCards = [...grid.querySelectorAll('.dashboard-card')];
      const draggedIndex = allCards.indexOf(draggedElement);
      const targetIndex = allCards.indexOf(this);

      if (draggedIndex < targetIndex) {
        this.parentNode.insertBefore(draggedElement, this.nextSibling);
      } else {
        this.parentNode.insertBefore(draggedElement, this);
      }
    });
  });

  // 순서 저장 함수
  function saveFavoriteOrder() {
    const cards = grid.querySelectorAll('.dashboard-card');
    const menuIds = Array.from(cards).map(card => card.dataset.menuId);

    const csrfToken = document.querySelector('meta[name="_csrf"]')?.content || '${_csrf.token}';
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content || '${_csrf.headerName}';

    fetch('/admin/menu/reorder-favorites', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        [csrfHeader]: csrfToken
      },
      body: JSON.stringify(menuIds)
    })
    .then(response => {
      if (response.ok) {
        console.log('즐겨찾기 순서 저장 완료');
      } else {
        console.error('순서 저장 실패:', response.status);
      }
    })
    .catch(error => {
      console.error('순서 저장 에러:', error);
    });
  }
});
</script>
  </c:otherwise>
</c:choose>

<div class="panel mt-4">
  <div class="panel-header">
    <h2>시스템 정보</h2>
  </div>
  <div class="panel-body">
    <table class="info-table">
      <tr>
        <th>Spring Boot 버전</th>
        <td>3.3.6</td>
      </tr>
      <tr>
        <th>Java 버전</th>
        <td>17</td>
      </tr>
      <tr>
        <th>데이터베이스</th>
        <td>MariaDB</td>
      </tr>
      <tr>
        <th>지원 언어</th>
        <td>한국어 (ko), 영어 (en)</td>
      </tr>
    </table>
  </div>
</div>

</main>
<jsp:include page="../common/footer.jsp"/>
