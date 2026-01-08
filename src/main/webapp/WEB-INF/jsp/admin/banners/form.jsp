<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">

<div class="page-header">
  <h1><c:choose><c:when test="${isEdit}">배너 수정</c:when><c:otherwise>배너 추가</c:otherwise></c:choose></h1>
  <p class="subtitle">메인 페이지 배너 ${isEdit ? '수정' : '등록'}</p>
</div>

<div class="panel">
  <div class="panel-header">
    <h2>배너 정보</h2>
  </div>
  <div class="panel-body">
    <form action="/admin/banners/save" method="post" class="form" enctype="multipart/form-data">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <c:if test="${isEdit}">
        <input type="hidden" name="id" value="${banner.id}"/>
      </c:if>
      <input type="hidden" name="categoryId" value="${categoryId}"/>
      <input type="hidden" name="categoryKey" value="${categoryKey}"/>

      <div class="form-group">
        <label for="lang">언어<span class="required">*</span></label>
        <select id="lang" name="lang" class="form-select" required>
          <option value="ko" ${banner == null || banner.lang == 'ko' ? 'selected' : ''}>한국어 (ko)</option>
          <option value="en" ${banner != null && banner.lang == 'en' ? 'selected' : ''}>영어 (en)</option>
        </select>
      </div>

      <div class="form-group">
        <label for="title">Title<span class="required">*</span></label>
        <input type="text" id="title" name="title" class="form-input" value="${banner != null ? banner.title : ''}" required>
        <small style="color: #666;">예: 메인 배너 1, 프로모션 배너</small>
      </div>

      <div class="form-group">
        <label for="type">Type<span class="required">*</span></label>
        <select id="type" name="type" class="form-select" required onchange="toggleFileUpload()">
          <option value="IMAGE" ${empty banner || banner.imageType ? 'selected' : ''}>IMAGE</option>
          <option value="YOUTUBE" ${not empty banner && banner.youtubeType ? 'selected' : ''}>YOUTUBE</option>
        </select>
      </div>

      <!-- 이미지 파일 업로드 (IMAGE 타입일 때만) -->
      <div id="fileUploadSection" class="form-group">
        <label for="bannerFile">배너 이미지<span class="required">*</span></label>
        <input type="file" id="bannerFile" name="bannerFile" class="form-input" accept="image/*">
        <small style="color: #666;">JPG, PNG, GIF 등 이미지 파일 (최대 10MB)</small>

        <c:if test="${isEdit && not empty banner && banner.imageType && banner.url != null}">
          <div style="margin-top: 10px;">
            <small style="color: #999;">현재 이미지:</small><br>
            <img src="${banner.url}" alt="현재 배너" style="max-width: 300px; max-height: 200px; border: 1px solid #ddd; margin-top: 5px;">
            <input type="hidden" name="existingImageUrl" value="${banner.url}">
          </div>
        </c:if>
      </div>

      <!-- 유튜브 URL (YOUTUBE 타입일 때만) -->
      <div id="youtubeUrlSection" class="form-group" style="display: none;">
        <label for="youtubeUrl">유튜브 URL<span class="required">*</span></label>
        <input type="text" id="youtubeUrl" name="url" class="form-input" value="${banner != null && banner.url != null ? banner.url : ''}">
        <small style="color: #666;">예: https://www.youtube.com/watch?v=VIDEO_ID</small>
      </div>

      <!-- 링크 URL (IMAGE 타입일 때만) -->
      <div id="linkUrlSection" class="form-group">
        <label for="linkUrl">링크 URL</label>
        <input type="text" id="linkUrl" name="linkUrl" class="form-input" value="${banner != null && banner.linkUrl != null ? banner.linkUrl : ''}">
        <small style="color: #666;">배너 클릭 시 이동할 URL (선택사항)</small>
      </div>

      <div class="form-row">
        <div class="form-group" style="flex: 1;">
          <label for="width">Width (px)</label>
          <input type="number" id="width" name="width" class="form-input" value="${banner != null ? banner.width : 1920}">
        </div>
        <div class="form-group" style="flex: 1;">
          <label for="height">Height (px)</label>
          <input type="number" id="height" name="height" class="form-input" value="${banner != null ? banner.height : 200}">
        </div>
      </div>

      <div class="form-row">
        <div class="form-group" style="flex: 1;">
          <label for="startDate">Start Date</label>
          <input type="datetime-local" id="startDate" name="startDate" class="form-input" value="${banner != null ? banner.formattedStartDate : ''}">
          <small style="color: #666;">시작 날짜/시간 (선택사항)</small>
        </div>
        <div class="form-group" style="flex: 1;">
          <label for="endDate">End Date</label>
          <input type="datetime-local" id="endDate" name="endDate" class="form-input" value="${banner != null ? banner.formattedEndDate : ''}">
          <small style="color: #666;">종료 날짜/시간 (선택사항)</small>
        </div>
      </div>

      <div class="form-group">
        <label for="sortOrder">Sort Order</label>
        <input type="number" id="sortOrder" name="sortOrder" class="form-input" value="${banner != null ? banner.sortOrder : 0}">
        <small style="color: #666;">작은 숫자가 먼저 표시됩니다</small>
      </div>

      <div class="form-group">
        <label>
          <input type="checkbox" name="enabled" value="1" ${empty banner or banner.enabled ? 'checked' : ''}> 활성화
        </label>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn btn-primary">💾 저장</button>
        <a href="/admin/banners?categoryId=${categoryId}&categoryKey=${categoryKey}" class="btn btn-secondary">취소</a>
      </div>
    </form>
  </div>
</div>

<style>
.form-row {
  display: flex;
  gap: 16px;
}
</style>

<script>
// Type 변경 시 파일 업로드/URL 입력 필드 토글
function toggleFileUpload() {
  const type = document.getElementById('type').value;
  const fileUploadSection = document.getElementById('fileUploadSection');
  const youtubeUrlSection = document.getElementById('youtubeUrlSection');
  const linkUrlSection = document.getElementById('linkUrlSection');

  if (type === 'IMAGE') {
    fileUploadSection.style.display = 'block';
    youtubeUrlSection.style.display = 'none';
    linkUrlSection.style.display = 'block';
    document.getElementById('bannerFile').required = ${isEdit ? 'false' : 'true'};
    document.getElementById('youtubeUrl').required = false;
  } else if (type === 'YOUTUBE') {
    fileUploadSection.style.display = 'none';
    youtubeUrlSection.style.display = 'block';
    linkUrlSection.style.display = 'none';
    document.getElementById('bannerFile').required = false;
    document.getElementById('youtubeUrl').required = true;
  }
}

// 페이지 로드 시 초기 상태 설정
window.addEventListener('DOMContentLoaded', function() {
  toggleFileUpload();
});
</script>

</main>
<jsp:include page="../common/footer.jsp"/>
