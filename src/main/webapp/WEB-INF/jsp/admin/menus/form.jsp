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

      <c:if test="${param.menuType == 'public'}">
        <div class="form-group">
          <label for="linkType">링크 타입<span class="required">*</span></label>
          <select id="linkType" name="linkType" class="form-select" onchange="onLinkTypeChange()">
            <option value="external" ${empty menu || (menu.href != null && !menu.href.contains('/page/') && !menu.href.contains('/board/')) ? 'selected' : ''}>외부/직접 링크</option>
            <option value="content" ${menu != null && menu.href != null && menu.href.contains('/page/') ? 'selected' : ''}>컨텐츠 페이지</option>
            <option value="board" ${menu != null && menu.href != null && menu.href.contains('/board/') ? 'selected' : ''}>게시판</option>
          </select>
        </div>

        <div class="form-group" id="contentCategoryGroup" style="display: none;">
          <label for="contentCategory">컨텐츠 카테고리<span class="required">*</span></label>
          <select id="contentCategory" class="form-select" onchange="onCategorySelect('content')">
            <option value="">-- 카테고리 선택 --</option>
            <c:forEach var="cat" items="${contentCategories}">
              <option value="${cat.categoryKey}" data-name="${cat.name}">${cat.name} (${cat.categoryKey})</option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group" id="boardCategoryGroup" style="display: none;">
          <label for="boardCategory">게시판 카테고리<span class="required">*</span></label>
          <select id="boardCategory" class="form-select" onchange="onCategorySelect('board')">
            <option value="">-- 카테고리 선택 --</option>
            <c:forEach var="cat" items="${boardCategories}">
              <option value="${cat.categoryKey}" data-name="${cat.name}" data-display="${cat.displayType}">${cat.name} (${cat.categoryKey}) - ${cat.displayType}</option>
            </c:forEach>
          </select>
        </div>
      </c:if>

      <div class="form-group" id="hrefGroup">
        <label for="href">링크 (Href)<span class="required">*</span></label>
        <input type="text" id="href" name="href" class="form-input" value="${menu != null ? menu.href : ''}" required>
        <small style="color: #666;" id="hrefHint">
          예: ${param.menuType == 'public' ? '/page/about, /board/notice (언어는 자동 적용)' : '/admin/dashboard, /admin/board-categories'}
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

<c:if test="${param.menuType == 'public'}">
<script>
  const langSelect = document.getElementById('lang');
  const linkTypeSelect = document.getElementById('linkType');
  const contentCategoryGroup = document.getElementById('contentCategoryGroup');
  const boardCategoryGroup = document.getElementById('boardCategoryGroup');
  const contentCategorySelect = document.getElementById('contentCategory');
  const boardCategorySelect = document.getElementById('boardCategory');
  const hrefInput = document.getElementById('href');
  const labelInput = document.getElementById('label');

  function onLinkTypeChange() {
    const linkType = linkTypeSelect.value;

    contentCategoryGroup.style.display = 'none';
    boardCategoryGroup.style.display = 'none';

    if (linkType === 'content') {
      contentCategoryGroup.style.display = 'block';
    } else if (linkType === 'board') {
      boardCategoryGroup.style.display = 'block';
    }
  }

  function onCategorySelect(type) {
    let categoryKey, categoryName;

    if (type === 'content') {
      const selected = contentCategorySelect.options[contentCategorySelect.selectedIndex];
      categoryKey = selected.value;
      categoryName = selected.dataset.name;
      if (categoryKey) {
        hrefInput.value = '/page/' + categoryKey;
        if (!labelInput.value) {
          labelInput.value = categoryName;
        }
      }
    } else if (type === 'board') {
      const selected = boardCategorySelect.options[boardCategorySelect.selectedIndex];
      categoryKey = selected.value;
      categoryName = selected.dataset.name;
      if (categoryKey) {
        hrefInput.value = '/board/' + categoryKey;
        if (!labelInput.value) {
          labelInput.value = categoryName;
        }
      }
    }
  }

  // 언어는 href에 포함하지 않으므로 이벤트 불필요

  // 페이지 로드 시 초기화
  document.addEventListener('DOMContentLoaded', function() {
    onLinkTypeChange();

    // 기존 href 값으로 카테고리 선택 복원
    const currentHref = hrefInput.value;
    if (currentHref) {
      const pageMatch = currentHref.match(/\/page\/([^\/]+)/);
      const boardMatch = currentHref.match(/\/board\/([^\/]+)/);

      if (pageMatch) {
        linkTypeSelect.value = 'content';
        onLinkTypeChange();
        contentCategorySelect.value = pageMatch[1];
      } else if (boardMatch) {
        linkTypeSelect.value = 'board';
        onLinkTypeChange();
        boardCategorySelect.value = boardMatch[1];
      }
    }
  });
</script>
</c:if>

<jsp:include page="../common/footer.jsp"/>
