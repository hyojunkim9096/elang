<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
<style>
.menu-tabs {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
  border-bottom: 2px solid #dee2e6;
}
.menu-tab {
  padding: 10px 20px;
  cursor: pointer;
  border: none;
  background: none;
  font-size: 16px;
  font-weight: 500;
  color: #6c757d;
  border-bottom: 3px solid transparent;
  transition: all 0.2s;
}
.menu-tab.active {
  color: #0d6efd;
  border-bottom-color: #0d6efd;
}
.menu-sections { list-style: none; padding-left: 0; }
.menu-section-item { margin-bottom: 20px; }
.menu-tree { list-style: none; padding-left: 0; }
.menu-tree li { margin: 8px 0; }
.menu-item {
  padding: 12px;
  background: #f8f9fa;
  border: 1px solid #dee2e6;
  border-radius: 4px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: move;
  transition: all 0.2s;
}
.menu-item:hover {
  background: #e9ecef;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
.menu-item.sortable-ghost {
  opacity: 0.4;
  background: #dee2e6;
}
.menu-item.sortable-drag {
  opacity: 0.8;
  box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}
.menu-item-info { flex: 1; }
.menu-item-actions button { margin-left: 4px; }
.drag-handle {
  cursor: grab;
  color: #6c757d;
  margin-right: 10px;
  font-size: 18px;
  user-select: none;
}
.drag-handle:active {
  cursor: grabbing;
}
.section-drag-handle {
  cursor: grab !important;
}
.menu-section-item {
  cursor: move;
}
.depth-indicator {
  display: inline-block;
  padding: 2px 8px;
  background: #6c757d;
  color: white;
  border-radius: 3px;
  font-size: 11px;
  margin-right: 8px;
}
.section-title {
  font-size: 18px;
  font-weight: 600;
  color: #1f2937;
  margin-bottom: 10px;
  padding: 8px 12px;
  background: #e5e7eb;
  border-radius: 4px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.section-menus {
  list-style: none;
  padding: 0 0 0 20px;
  margin: 10px 0;
  min-height: 50px;
  border-left: 3px solid #d1d5db;
}
</style>

<div class="page-header">
  <h1>메뉴 관리</h1>
  <p class="subtitle">드래그앤드롭으로 순서 변경 가능 (관리자/사용자 메뉴)</p>
</div>

<div class="menu-tabs">
  <a href="/admin/menus?menuType=admin&lang=${param.lang != null ? param.lang : 'ko'}"
     class="menu-tab ${param.menuType == null || param.menuType == 'admin' ? 'active' : ''}">🔐 관리자 메뉴</a>
  <a href="/admin/menus?menuType=public&lang=${param.lang != null ? param.lang : 'ko'}"
     class="menu-tab ${param.menuType == 'public' ? 'active' : ''}">🌐 사용자 메뉴</a>
</div>

<div class="panel">
  <div class="panel-header">
    <h2>${param.menuType == 'public' ? '사용자 메뉴' : '관리자 메뉴'}</h2>
    <div class="panel-actions">
      <select id="langSelect" class="form-select" onchange="location.href='/admin/menus?menuType=${param.menuType != null ? param.menuType : 'admin'}&lang='+this.value">
        <option value="ko" ${param.lang == null || param.lang == 'ko' ? 'selected' : ''}>한국어 (ko)</option>
        <option value="en" ${param.lang == 'en' ? 'selected' : ''}>영어 (en)</option>
      </select>
      <a href="/admin/menus?menuType=${param.menuType != null ? param.menuType : 'admin'}&lang=${param.lang != null ? param.lang : 'ko'}" class="btn btn-secondary">🔄 새로고침</a>
      <a href="/admin/menus/new?menuType=${param.menuType != null ? param.menuType : 'admin'}&lang=${param.lang != null ? param.lang : 'ko'}" class="btn btn-primary">➕ 1뎁스 추가</a>
    </div>
  </div>
  <div class="panel-body">
    <p class="hint">💡 수정 및 삭제는 각 메뉴 항목의 버튼을 클릭하세요.</p>

    <c:if test="${not empty message}">
      <div class="alert alert-success">${message}</div>
    </c:if>

    <c:choose>
      <c:when test="${empty menus}">
        <p class="hint">등록된 메뉴가 없습니다.</p>
      </c:when>
      <c:otherwise>
        <ul class="menu-sections">
          <c:forEach var="menu" items="${menus}">
            <c:if test="${menu.parentId == null || menu.parentId == 0}">
              <li class="menu-section-item">
                <div class="section-title">
                  <div style="display: flex; align-items: center;">
                    <span class="section-drag-handle drag-handle">☰</span>
                    <strong>${menu.label}</strong>
                    <span style="margin-left: 10px; color: #999;">(${menu.href})</span>
                  </div>
                  <div>
                    <a href="/admin/menus/new?parentId=${menu.id}&menuType=${param.menuType != null ? param.menuType : 'admin'}&lang=${param.lang != null ? param.lang : 'ko'}"
                       class="btn btn-sm btn-success">➕ 2뎁스 추가</a>
                    <a href="/admin/menus/${menu.id}/edit?menuType=${param.menuType != null ? param.menuType : 'admin'}&lang=${param.lang != null ? param.lang : 'ko'}"
                       class="btn btn-sm btn-secondary">수정</a>
                    <form action="/admin/menus/${menu.id}/delete" method="post" style="display: inline;"
                          onsubmit="return confirm('정말 삭제하시겠습니까?');">
                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                      <button type="submit" class="btn btn-sm btn-danger">삭제</button>
                    </form>
                  </div>
                </div>

                <ul class="section-menus">
                  <c:set var="hasChildren" value="false"/>
                  <c:forEach var="child" items="${menus}">
                    <c:if test="${child.parentId == menu.id}">
                      <c:set var="hasChildren" value="true"/>
                      <li>
                        <div class="menu-item">
                          <div class="menu-item-info">
                            <span class="drag-handle">☰</span>
                            <span class="depth-indicator">2뎁스</span>
                            <strong>${child.label}</strong>
                            <span style="color: #666; margin-left: 10px;">${child.href}</span>
                            <c:choose>
                              <c:when test="${child.enabled}">
                                <span style="margin-left: 10px; color: green;">●</span>
                              </c:when>
                              <c:otherwise>
                                <span style="margin-left: 10px; color: red;">●</span>
                              </c:otherwise>
                            </c:choose>
                          </div>
                          <div class="menu-item-actions">
                            <a href="/admin/menus/${child.id}/edit?menuType=${param.menuType != null ? param.menuType : 'admin'}&lang=${param.lang != null ? param.lang : 'ko'}"
                               class="btn btn-sm btn-secondary">수정</a>
                            <form action="/admin/menus/${child.id}/delete" method="post" style="display: inline;"
                                  onsubmit="return confirm('정말 삭제하시겠습니까?');">
                              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                              <button type="submit" class="btn btn-sm btn-danger">삭제</button>
                            </form>
                          </div>
                        </div>
                      </li>
                    </c:if>
                  </c:forEach>
                  <c:if test="${!hasChildren}">
                    <li class="hint" style="padding:10px;">하위 메뉴가 없습니다.</li>
                  </c:if>
                </ul>
              </li>
            </c:if>
          </c:forEach>
        </ul>
      </c:otherwise>
    </c:choose>
  </div>
</div>

</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
  // 1뎁스 (섹션) 드래그앤드롭
  const sectionList = document.querySelector('.menu-sections');
  if (sectionList) {
    Sortable.create(sectionList, {
      animation: 150,
      handle: '.section-drag-handle',
      ghostClass: 'sortable-ghost',
      onEnd: function(evt) {
        // 1뎁스 순서 변경
        const sectionItems = sectionList.querySelectorAll('.menu-section-item');
        const menuIds = [];

        sectionItems.forEach((item, index) => {
          const menuId = item.querySelector('.section-title a[href*="/edit"]').href.match(/\/menus\/(\d+)\/edit/)[1];
          menuIds.push(menuId);
        });

        // 서버에 순서 저장
        saveSortOrder(menuIds, null);
      }
    });
  }

  // 2뎁스 (자식 메뉴) 드래그앤드롭
  const childMenuLists = document.querySelectorAll('.section-menus');
  childMenuLists.forEach(function(childList) {
    Sortable.create(childList, {
      animation: 150,
      handle: '.drag-handle',
      ghostClass: 'sortable-ghost',
      onEnd: function(evt) {
        // 2뎁스 순서 변경
        const menuItems = childList.querySelectorAll('.menu-item');
        const menuIds = [];

        menuItems.forEach((item, index) => {
          const editLink = item.querySelector('a[href*="/edit"]');
          if (editLink) {
            const menuId = editLink.href.match(/\/menus\/(\d+)\/edit/)[1];
            menuIds.push(menuId);
          }
        });

        // 부모 ID 찾기
        const parentSection = childList.closest('.menu-section-item');
        const parentId = parentSection.querySelector('.section-title a[href*="/edit"]').href.match(/\/menus\/(\d+)\/edit/)[1];

        // 서버에 순서 저장
        saveSortOrder(menuIds, parentId);
      }
    });
  });
});

// 순서 변경을 서버에 저장하는 함수
function saveSortOrder(menuIds, parentId) {
  console.log('저장할 메뉴 IDs:', menuIds);
  console.log('부모 ID:', parentId);

  // menuIds를 숫자 배열로 변환
  const numericIds = menuIds.map(id => parseInt(id, 10));
  console.log('변환된 IDs:', numericIds);

  fetch('/admin/menus/reorder', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      menuIds: numericIds,
      parentId: parentId ? parseInt(parentId, 10) : null
    })
  })
  .then(response => {
    console.log('응답 상태:', response.status);
    if (response.ok) {
      return response.text().then(text => {
        console.log('성공:', text);
        alert('순서가 저장되었습니다.');
      });
    } else {
      return response.text().then(text => {
        console.error('실패 응답:', text);
        alert('순서 저장에 실패했습니다: ' + text);
      });
    }
  })
  .catch(error => {
    console.error('네트워크 에러:', error);
    alert('순서 저장 중 오류가 발생했습니다: ' + error.message);
  });
}
</script>

<jsp:include page="../common/footer.jsp"/>
