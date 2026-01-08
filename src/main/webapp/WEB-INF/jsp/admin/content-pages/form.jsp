<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">

<!-- Quill Editor CSS -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<link href="/resources/css/quill-custom.css" rel="stylesheet">

<div class="page-header">
  <h1>${isEdit ? '페이지 수정' : '페이지 생성'}</h1>
  <p class="subtitle">컨텐츠 페이지 정보를 입력하세요</p>
</div>

<div class="panel">
  <div class="panel-header">
    <h2>페이지 정보</h2>
    <a href="/admin/content-pages?categoryId=${categoryId}&categoryKey=${categoryKey}" class="btn btn-secondary">← 목록으로</a>
  </div>
  <div class="panel-body">
    <form action="/admin/content-pages/save" method="post" class="form" id="pageForm">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <input type="hidden" name="categoryId" value="${categoryId}"/>
      <input type="hidden" name="categoryKey" value="${categoryKey}"/>
      <c:if test="${isEdit}">
        <input type="hidden" name="id" value="${page.id}"/>
      </c:if>

      <div class="form-group">
        <label>페이지 제목<span class="required">*</span></label>
        <input type="text" name="title" class="form-input" placeholder="페이지 제목을 입력하세요"
               value="${page.title}" required/>
      </div>

      <div class="form-group">
        <label>
          <input type="checkbox" name="enabled" value="1"
                 ${empty page or page.enabled ? 'checked' : ''}/>
          활성화
        </label>
      </div>

      <div class="form-group">
        <label>컨텐츠 (HTML)<span class="required">*</span></label>
        <div id="editor" style="min-height: 400px; background: white;"></div>
        <input type="hidden" name="content" id="hiddenContent" value=""/>
      </div>

      <div class="form-actions">
        <a href="/admin/content-pages?categoryId=${categoryId}&categoryKey=${categoryKey}" class="btn btn-secondary">취소</a>
        <button type="submit" class="btn btn-primary">💾 저장</button>
      </div>
    </form>
  </div>
</div>

<!-- Quill Editor JS -->
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
<!-- Quill ImageResize Module -->
<script src="https://unpkg.com/quill-image-resize-module@3.0.0/image-resize.min.js"></script>
<script src="/resources/js/quill-config.js"></script>
<script>
let quill = null;

document.addEventListener('DOMContentLoaded', function() {
  console.log('=== 페이지 로드 완료 ===');

  // Quill 에디터 초기화
  const initialContent = `${page != null && page.content != null ? page.content : ''}`;
  quill = initQuillEditor('#editor', '내용을 입력하세요...', initialContent);

  // 폼 제출
  document.getElementById('pageForm').addEventListener('submit', function(e) {
    console.log('=== 폼 제출 시작 ===');

    const content = quill.root.innerHTML;
    document.getElementById('hiddenContent').value = content;

    console.log('제출할 데이터:');
    console.log('- 제목:', document.querySelector('input[name="title"]').value);
    console.log('- 카테고리ID:', document.querySelector('input[name="categoryId"]').value);
    console.log('- 본문 길이:', content.length);
    console.log('- 본문 미리보기:', content.substring(0, 100));

    if (!content || content.trim() === '' || content.trim() === '<p><br></p>') {
      e.preventDefault();
      showAlert('컨텐츠를 입력해주세요.', 'warning');
      return false;
    }

    // FormData 확인
    const formData = new FormData(this);
    console.log('FormData 내용:');
    for (let pair of formData.entries()) {
      if (pair[0] === 'content') {
        console.log('  content: (길이=' + pair[1].length + ') ' + pair[1].substring(0, 50) + '...');
      } else {
        console.log('  ' + pair[0] + ': ' + pair[1]);
      }
    }
  });
});
</script>

</main>
<jsp:include page="../common/footer.jsp"/>
