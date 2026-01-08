<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">

<div class="page-header">
  <h1>${isEdit ? '카테고리 수정' : '카테고리 추가'}</h1>
  <p class="subtitle">게시판 카테고리 정보를 입력하세요</p>
</div>

<div class="panel">
  <div class="panel-header">
    <h2>카테고리 정보</h2>
    <a href="/admin/board-categories" class="btn btn-secondary">← 목록으로</a>
  </div>
  <div class="panel-body">
    <form action="/admin/board-categories/save" method="post" class="form">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <c:if test="${isEdit}">
        <input type="hidden" name="id" value="${category.id}"/>
      </c:if>

      <div class="form-group">
        <label>언어<span class="required">*</span></label>
        <select name="lang" class="form-select" required ${isEdit ? 'disabled' : ''}>
          <option value="ko" ${category.lang == 'ko' ? 'selected' : ''}>한글 (ko)</option>
          <option value="en" ${category.lang == 'en' ? 'selected' : ''}>영문 (en)</option>
        </select>
        <c:if test="${isEdit}">
          <input type="hidden" name="lang" value="${category.lang}"/>
        </c:if>
      </div>

      <div class="form-group">
        <label>카테고리 키<span class="required">*</span></label>
        <input type="text" name="categoryKey" class="form-input"
               placeholder="notice, news 등 (영문/숫자/-_ 만)"
               value="${category.categoryKey}"
               ${isEdit ? 'readonly' : ''} required/>
        <small class="hint">URL에 사용되므로 영문/숫자/-_ 만 사용 가능합니다.</small>
      </div>

      <div class="form-group">
        <label>카테고리 이름<span class="required">*</span></label>
        <input type="text" name="name" class="form-input"
               placeholder="공지사항"
               value="${category.name}" required/>
      </div>

      <div class="form-group">
        <label>설명</label>
        <input type="text" name="description" class="form-input"
               placeholder="선택사항"
               value="${category.description}"/>
      </div>

        <div class="form-group">
            <label>표시 형식<span class="required">*</span></label>
            <select name="displayType" class="form-select" required>
                <option value="LIST" ${category != null && category.displayType != null && category.displayType.name() == 'LIST' ? 'selected' : ''}>
                    목록형 (LIST)
                </option>
                <option value="CARD" ${category != null && category.displayType != null && category.displayType.name() == 'CARD' ? 'selected' : ''}>
                    카드형 (CARD)
                </option>
                <option value="THUMBNAIL" ${category != null && category.displayType != null && category.displayType.name() == 'THUMBNAIL' ? 'selected' : ''}>
                    썸네일형 (THUMBNAIL)
                </option>
            </select>
        </div>

      <div class="form-group">
        <label>정렬 순서</label>
        <input type="number" name="sortOrder" class="form-input"
               value="${category.sortOrder != null ? category.sortOrder : 0}"
               min="0"/>
        <small class="hint">작은 숫자가 먼저 표시됩니다.</small>
      </div>

      <div class="form-group">
        <label>
          <input type="checkbox" name="enabled" value="1"
                 ${empty category or category.enabled ? 'checked' : ''}/>
          활성화
        </label>
      </div>

      <div class="form-actions">
        <a href="/admin/board-categories" class="btn btn-secondary">취소</a>
        <button type="submit" class="btn btn-primary">💾 저장</button>
      </div>
    </form>
  </div>
</div>

</main>
<jsp:include page="../common/footer.jsp"/>
