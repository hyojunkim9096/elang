<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">
<jsp:include page="../common/category-table-style.jsp"/>

<div class="page-header">
  <h1>배너 카테고리 관리</h1>
  <p class="subtitle">배너 카테고리를 생성하고 관리합니다. 드래그 앤 드롭으로 순서를 변경할 수 있습니다.</p>
</div>

<c:if test="${not empty message}">
  <div style="padding: 12px 20px; background: #d1fae5; color: #065f46; border-radius: 8px; margin-bottom: 20px;">
    ✅ ${message}
  </div>
</c:if>

<div class="panel">
  <div class="panel-header">
    <h2>카테고리 목록</h2>
    <a href="/admin/banner-categories/new" class="btn btn-primary">➕ 새 카테고리 추가</a>
  </div>
  <div class="panel-body">
    <c:choose>
      <c:when test="${empty categories}">
        <p class="hint">등록된 카테고리가 없습니다.</p>
      </c:when>
      <c:otherwise>
        <table class="category-table data-table">
          <thead>
            <tr>
              <th style="width:40px;"></th>
              <th style="width:60px;">ID</th>
              <th style="width:80px;">언어</th>
              <th>카테고리 키</th>
              <th>이름</th>
              <th>설명</th>
              <th style="width:90px;">정렬순서</th>
              <th style="width:90px;">활성화</th>
              <th style="width:200px;">작업</th>
            </tr>
          </thead>
          <tbody id="banner-categories-tbody">
            <c:forEach var="cat" items="${categories}">
              <tr draggable="true" data-id="${cat.id}">
                <td class="drag-handle">⋮⋮</td>
                <td>${cat.id}</td>
                <td>${cat.lang}</td>
                <td><strong>${cat.categoryKey}</strong></td>
                <td>${cat.name}</td>
                <td>${cat.description}</td>
                <td>${cat.sortOrder}</td>
                <td>
                  <c:choose>
                    <c:when test="${cat.enabled}">
                      <span class="badge badge-success">활성화</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-secondary">비활성화</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <a href="/admin/banner-categories/${cat.id}/edit" class="btn btn-sm btn-secondary">✏️ 수정</a>
                  <a href="/admin/banners?categoryId=${cat.id}&categoryKey=${cat.categoryKey}" class="btn btn-sm btn-success">🎨 배너</a>
                  <form action="/admin/banner-categories/${cat.id}/delete" method="post" style="display:inline;" onsubmit="return confirm('카테고리를 삭제하시겠습니까? (하위 배너도 모두 삭제됩니다)')">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-sm btn-danger">🗑</button>
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

<jsp:include page="../common/category-drag-script.jsp">
  <jsp:param name="tbodyId" value="banner-categories-tbody"/>
  <jsp:param name="reorderUrl" value="/admin/banner-categories/reorder"/>
  <jsp:param name="sortOrderColumnIndex" value="6"/>
</jsp:include>

</main>
<jsp:include page="../common/footer.jsp"/>
