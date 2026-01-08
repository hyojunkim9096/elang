<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">

<div class="page-header">
  <h1>${isEdit ? '카테고리 수정' : '카테고리 추가'}</h1>
  <p class="subtitle">배너 카테고리 정보를 입력하세요</p>
</div>

<div class="panel">
  <div class="panel-header">
    <h2>카테고리 정보</h2>
    <a href="/admin/banner-categories" class="btn btn-secondary">← 목록으로</a>
  </div>
  <div class="panel-body">
    <form action="/admin/banner-categories/save" method="post" class="form">
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
               placeholder="promotion_2025, event_newyear 등 (영문/숫자/-_ 만)"
               value="${category.categoryKey}"
               ${isEdit ? 'readonly' : ''} required/>
        <small class="hint">배너 그룹 식별키로 사용되므로 영문/숫자/-_ 만 사용 가능합니다.</small>
      </div>

      <div class="form-group">
        <label>카테고리 이름<span class="required">*</span></label>
        <input type="text" name="name" class="form-input"
               placeholder="2025 신년 프로모션"
               value="${category.name}" required/>
      </div>

      <div class="form-group">
        <label>설명</label>
        <input type="text" name="description" class="form-input"
               placeholder="선택사항"
               value="${category.description}"/>
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

      <!-- 팝업 배너 설정 (popup_banner 카테고리만 표시) -->
      <div id="popupSettings" style="display: none; border-top: 1px solid #ddd; margin-top: 20px; padding-top: 20px;">
        <h3 style="margin-bottom: 15px;">팝업 배너 설정</h3>
        <div class="form-group">
          <label>최대 동시 표시 개수</label>
          <input type="number" id="popupMaxCount" name="popupMaxCount" class="form-input"
                 value="${category.popupMaxCount}" min="1" max="10"/>
          <small class="hint">동시에 표시할 수 있는 최대 팝업 개수 (1-10개)</small>
        </div>

        <div class="form-group">
          <label>자동 닫힘 시간 (초)</label>
          <input type="number" id="popupDuration" name="popupDuration" class="form-input"
                 value="${category.popupDuration}" min="0"/>
          <small class="hint">팝업이 자동으로 닫히는 시간 (0 = 수동으로만 닫기)</small>
        </div>
      </div>

      <div class="form-actions">
        <a href="/admin/banner-categories" class="btn btn-secondary">취소</a>
        <button type="submit" class="btn btn-primary">💾 저장</button>
      </div>
    </form>
  </div>
</div>

<script>
// 페이지 로드 시 카테고리 키 확인하여 팝업 설정 표시/숨김
window.addEventListener('DOMContentLoaded', function() {
  const categoryKeyInput = document.querySelector('input[name="categoryKey"]');
  const popupSettings = document.getElementById('popupSettings');

  function togglePopupSettings() {
    const categoryKey = categoryKeyInput.value;
    if (categoryKey === 'popup_banner') {
      popupSettings.style.display = 'block';
    } else {
      popupSettings.style.display = 'none';
    }
  }

  // 초기 상태 설정
  togglePopupSettings();

  // 카테고리 키 변경 시 (신규 생성 시만 가능)
  categoryKeyInput.addEventListener('input', togglePopupSettings);
});
</script>

</main>
<jsp:include page="../common/footer.jsp"/>
