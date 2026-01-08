<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">

<div class="page-header">
  <h1><c:choose><c:when test="${isEdit}">메뉴 수정</c:when><c:otherwise>메뉴 추가</c:otherwise></c:choose></h1>
  <p class="subtitle">${param.menuType == 'public' ? '사용자' : '관리자'} 메뉴 ${isEdit ? '수정' : '등록'}</p>
</div>

<div class="panel">
  <div class="panel-header">
    <h2>메뉴 정보</h2>
  </div>
  <div class="panel-body">
    <form action="/admin/menus/save" method="post" class="form">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <c:if test="${isEdit}">
        <input type="hidden" name="id" value="${menu.id}"/>
        <input type="hidden" name="sortOrder" value="${menu.sortOrder}"/>
      </c:if>
      <c:if test="${!isEdit && param.parentId != null}">
        <input type="hidden" name="parentId" value="${param.parentId}"/>
      </c:if>
      <input type="hidden" name="menuType" value="${param.menuType != null ? param.menuType : 'admin'}"/>
      <input type="hidden" name="returnMenuType" value="${param.menuType != null ? param.menuType : 'admin'}"/>
      <input type="hidden" name="returnLang" value="${param.lang != null ? param.lang : 'ko'}"/>

      <div class="form-group">
        <label for="lang">언어<span class="required">*</span></label>
        <select id="lang" name="lang" class="form-select" required>
          <option value="ko" ${menu == null || menu.lang == 'ko' ? 'selected' : ''}>한국어 (ko)</option>
          <option value="en" ${menu != null && menu.lang == 'en' ? 'selected' : ''}>영어 (en)</option>
        </select>
      </div>

      <div class="form-group">
        <label for="label">메뉴명<span class="required">*</span></label>
        <input type="text" id="label" name="label" class="form-input" value="${menu != null ? menu.label : ''}" required>
        <small style="color: #666;">예: 대시보드, 게시판 관리</small>
      </div>

      <div class="form-group">
        <label for="href">링크 (Href)<span class="required">*</span></label>
        <input type="text" id="href" name="href" class="form-input" value="${menu != null ? menu.href : ''}" required>
        <small style="color: #666;">
          예: ${param.menuType == 'public' ? '/about, /contact' : '/admin/dashboard, /admin/board-categories'}
        </small>
      </div>

      <c:if test="${isEdit && menu.parentId != null && menu.parentId > 0}">
        <div class="form-group">
          <label for="parentId">상위 메뉴 ID</label>
          <input type="number" id="parentId" name="parentId" class="form-input" value="${menu.parentId}" readonly>
        </div>
      </c:if>

      <div class="form-group">
        <label>
          <input type="checkbox" name="enabled" value="1" ${empty menu or menu.enabled ? 'checked' : ''}> 활성화
        </label>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn btn-primary">💾 저장</button>
        <a href="/admin/menus?menuType=${param.menuType != null ? param.menuType : 'admin'}&lang=${param.lang != null ? param.lang : 'ko'}" class="btn btn-secondary">취소</a>
      </div>
    </form>
  </div>
</div>

</main>
<jsp:include page="../common/footer.jsp"/>
