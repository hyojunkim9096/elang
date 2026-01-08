<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">
<div class="page-header">
  <h1>레이아웃 관리</h1>
  <p class="subtitle">헤더/푸터 HTML 편집</p>
</div>

<div class="panel">
  <div class="panel-header">
    <h2>언어 선택</h2>
    <div class="panel-actions">
      <select id="langSelect" class="form-select" onchange="location.href='/admin/layout?lang='+this.value">
        <option value="ko" ${param.lang == null || param.lang == 'ko' ? 'selected' : ''}>한국어 (ko)</option>
        <option value="en" ${param.lang == 'en' ? 'selected' : ''}>영어 (en)</option>
      </select>
      <a href="/admin/layout?lang=${param.lang != null ? param.lang : 'ko'}" class="btn btn-secondary">🔄 새로고침</a>
    </div>
  </div>
  <div class="panel-body">
    <p class="hint">💡 저장하면 즉시 공개 페이지에 반영됩니다.</p>
    <c:if test="${not empty message}">
      <div class="alert alert-success">${message}</div>
    </c:if>
  </div>
</div>

<form action="/admin/layout/save" method="post">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
  <input type="hidden" name="lang" value="${param.lang != null ? param.lang : 'ko'}"/>

  <div class="panel">
    <div class="panel-header">
      <h2>Header HTML</h2>
    </div>
    <div class="panel-body">
      <textarea id="headerHtml" name="headerHtml" class="form-textarea" rows="12" placeholder="헤더 HTML을 입력하세요">${layoutData != null ? layoutData.headerHtml : ''}</textarea>
    </div>
  </div>

  <div class="panel">
    <div class="panel-header">
      <h2>Footer HTML</h2>
    </div>
    <div class="panel-body">
      <textarea id="footerHtml" name="footerHtml" class="form-textarea" rows="12" placeholder="푸터 HTML을 입력하세요">${layoutData != null ? layoutData.footerHtml : ''}</textarea>
    </div>
  </div>

  <div class="form-actions">
    <button type="submit" class="btn btn-primary btn-lg">💾 저장</button>
  </div>
</form>

</main>
<jsp:include page="../common/footer.jsp"/>
