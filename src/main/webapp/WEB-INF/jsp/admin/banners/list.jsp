<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">
<div class="page-header">
  <h1>배너 관리</h1>
  <p class="subtitle">카테고리별 배너 편집</p>
</div>

<c:if test="${not empty message}">
  <div style="padding: 12px 20px; background: #d1fae5; color: #065f46; border-radius: 8px; margin-bottom: 20px;">
    ✅ ${message}
  </div>
</c:if>

<c:choose>
  <c:when test="${empty categoryId}">
    <!-- 카테고리 선택 화면 -->
    <div class="panel">
      <div class="panel-header">
        <h2>카테고리를 선택하세요</h2>
        <a href="/admin/banner-categories" class="btn btn-secondary">카테고리 관리</a>
      </div>
      <div class="panel-body">
        <c:choose>
          <c:when test="${empty categories}">
            <p class="hint">등록된 배너 카테고리가 없습니다. 먼저 카테고리를 생성해주세요.</p>
          </c:when>
          <c:otherwise>
            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 16px;">
              <c:forEach var="category" items="${categories}">
                <a href="/admin/banners?categoryId=${category.id}&categoryKey=${category.categoryKey}"
                   class="category-card"
                   style="display: block; padding: 20px; border: 1px solid #e5e7eb; border-radius: 8px; text-decoration: none; transition: all 0.2s;">
                  <div style="font-size: 14px; color: #6b7280; margin-bottom: 4px;">${category.lang}</div>
                  <div style="font-size: 18px; font-weight: 600; color: #111827; margin-bottom: 8px;">${category.name}</div>
                  <div style="font-size: 13px; color: #9ca3af;"><code>${category.categoryKey}</code></div>
                  <c:if test="${not category.enabled}">
                    <div style="margin-top: 8px;"><span class="badge badge-secondary">비활성</span></div>
                  </c:if>
                </a>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </c:when>
  <c:otherwise>
    <!-- 배너 목록 화면 -->
    <div class="panel">
      <div class="panel-header">
        <h2>배너 목록</h2>
        <div class="panel-actions">
          <a href="/admin/banners" class="btn btn-secondary">← 카테고리 선택</a>
          <a href="/admin/banners?categoryId=${categoryId}&categoryKey=${categoryKey}" class="btn btn-secondary">🔄 새로고침</a>
          <a href="/admin/banners/new?categoryId=${categoryId}&categoryKey=${categoryKey}" class="btn btn-primary">➕ 추가</a>
        </div>
      </div>
      <div class="panel-body">
        <c:choose>
          <c:when test="${empty banners}">
            <p class="hint">등록된 배너가 없습니다.</p>
          </c:when>
          <c:otherwise>
        <table class="data-table">
          <thead>
            <tr>
              <th style="width: 50px">🔄</th>
              <th style="width: 60px">ID</th>
              <th style="width: 60px">Lang</th>
              <th style="width: 100px">Type</th>
              <th>Title</th>
              <th>URL</th>
              <th style="width: 100px">Size</th>
              <th style="width: 80px">Status</th>
              <th style="width: 150px">Actions</th>
            </tr>
          </thead>
          <tbody id="bannerList">
            <c:forEach var="banner" items="${banners}">
              <tr data-id="${banner.id}" class="sortable-row" style="cursor: move;">
                <td class="drag-handle" style="cursor: grab;">⋮⋮</td>
                <td>${banner.id}</td>
                <td><span class="badge">${banner.lang}</span></td>
                <td><span class="badge">${banner.type}</span></td>
                <td>${banner.title}</td>
                <td>
                  <c:set var="url" value="${banner.url != null ? banner.url : '-'}"/>
                  <c:choose>
                    <c:when test="${url.length() > 40}">
                      ${url.substring(0, 40)}...
                    </c:when>
                    <c:otherwise>
                      ${url}
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>${banner.width}x${banner.height}</td>
                <td>
                  <c:choose>
                    <c:when test="${banner.enabled}">
                      <span class="badge badge-success">활성</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-secondary">비활성</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <a href="/admin/banners/${banner.id}/edit?categoryId=${categoryId}&categoryKey=${categoryKey}&lang=${lang}"
                     class="btn btn-sm btn-secondary">수정</a>
                  <button type="button" class="btn btn-sm btn-danger" onclick="confirmDelete(${banner.id})">삭제</button>
                  <form id="deleteForm${banner.id}" action="/admin/banners/${banner.id}/delete" method="post" style="display: none;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="categoryId" value="${categoryId}"/>
                    <input type="hidden" name="categoryKey" value="${categoryKey}"/>
                  </form>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </c:otherwise>
</c:choose>

<style>
.category-card:hover {
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  border-color: #3b82f6;
}
</style>

<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
<script>
// 드래그앤드롭으로 순서 변경
document.addEventListener('DOMContentLoaded', function() {
  const bannerList = document.getElementById('bannerList');
  if (bannerList) {
    new Sortable(bannerList, {
      handle: '.drag-handle',
      animation: 150,
      onEnd: function(evt) {
        const rows = bannerList.querySelectorAll('tr');
        const bannerIds = Array.from(rows).map(row => row.dataset.id);

        fetch('/admin/banners/reorder', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]')?.content || '${_csrf.token}'
          },
          body: JSON.stringify(bannerIds)
        }).then(response => {
          if (response.ok) {
            console.log('순서 변경 완료');
          } else {
            console.error('순서 변경 실패');
            location.reload();
          }
        }).catch(error => {
          console.error('순서 변경 오류:', error);
          location.reload();
        });
      }
    });
  }
});

function confirmDelete(bannerId) {
  if (typeof showConfirm === 'function') {
    showConfirm('정말 삭제하시겠습니까?', function() {
      document.getElementById('deleteForm' + bannerId).submit();
    }, { type: 'warning', title: '삭제 확인' });
  } else {
    if (confirm('정말 삭제하시겠습니까?')) {
      document.getElementById('deleteForm' + bannerId).submit();
    }
  }
}
</script>

</main>
<jsp:include page="../common/footer.jsp"/>
