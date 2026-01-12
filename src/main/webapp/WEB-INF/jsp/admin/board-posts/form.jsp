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
  <h1>${isEdit ? '게시글 수정' : '게시글 작성'}</h1>
  <p class="subtitle">게시글 정보를 입력하세요</p>
</div>

<div class="panel">
  <div class="panel-header">
    <h2>게시글 정보</h2>
    <a href="/admin/board-posts?categoryId=${categoryId}&categoryKey=${categoryKey}" class="btn btn-secondary">← 목록으로</a>
  </div>
  <div class="panel-body">
    <form action="/admin/board-posts/save" method="post" class="form" id="postForm">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <input type="hidden" name="categoryId" value="${categoryId}"/>
      <input type="hidden" name="categoryKey" value="${categoryKey}"/>
      <c:if test="${isEdit}">
        <input type="hidden" name="id" value="${post.id}"/>
      </c:if>
      <input type="hidden" name="thumbnail" id="thumbnailUrl" value="${post.thumbnail}"/>

      <div class="form-group">
        <label>언어<span class="required">*</span></label>
        <select name="lang" class="form-select" required>
          <option value="ko" ${post.lang == 'ko' ? 'selected' : ''}>한글 (ko)</option>
          <option value="en" ${post.lang == 'en' ? 'selected' : ''}>영문 (en)</option>
        </select>
      </div>

      <div class="form-group">
        <label>제목<span class="required">*</span></label>
        <input type="text" name="title" class="form-input"
               placeholder="제목을 입력하세요"
               value="${post.title}" required/>
      </div>

      <div class="form-group">
        <label>썸네일 이미지</label>
        <div style="margin-bottom: 10px;">
          <input type="file" id="thumbnailFile" accept="image/*" class="form-input" style="display: inline-block; width: auto;"/>
          <span id="uploadStatus" style="margin-left: 10px; color: #666; font-size: 14px;"></span>
        </div>
        <div id="thumbnailPreview" style="margin-top: 10px;">
          <c:if test="${not empty post.thumbnail}">
            <img src="${post.thumbnail}" alt="썸네일" style="max-width: 300px; max-height: 200px; border: 1px solid #ddd; border-radius: 4px;"/>
            <p style="font-size: 12px; color: #666; margin-top: 5px;">${post.thumbnail}</p>
          </c:if>
        </div>
        <small class="hint">선택사항 (jpg, png, gif 등) - 파일 선택 시 자동 업로드됩니다</small>
      </div>

      <div class="form-group">
        <label>첨부파일</label>
        <div style="margin-bottom: 10px;">
          <input type="file" id="attachmentFiles" multiple class="form-input" style="display: inline-block; width: auto;"/>
          <span id="attachmentStatus" style="margin-left: 10px; color: #666; font-size: 14px;"></span>
        </div>
        <div id="attachmentList" style="margin-top: 10px;">
          <!-- 업로드된 파일 목록이 여기에 표시됩니다 -->
        </div>
        <input type="hidden" name="attachmentIds" id="attachmentIds" value=""/>
        <small class="hint">여러 파일 선택 가능 (PDF, TXT, 이미지, ZIP 등) - 파일 선택 시 자동 업로드됩니다</small>
      </div>

      <div class="form-group">
        <label>
          <input type="checkbox" name="isPinned" value="1"
                 ${not empty post.isPinned and post.isPinned ? 'checked' : ''}/>
          상단 고정
        </label>
      </div>

      <div class="form-group">
        <label>
          <input type="checkbox" name="enabled" value="1"
                 ${empty post or post.enabled ? 'checked' : ''}/>
          활성화
        </label>
      </div>

      <div class="form-group">
        <label>
          <input type="checkbox" name="commentsEnabled" value="1"
                 ${empty post or post.commentsEnabled ? 'checked' : ''}/>
          댓글 허용
        </label>
        <small class="hint">체크 해제 시 이 게시글에 댓글을 달 수 없습니다</small>
      </div>

      <div class="form-group">
        <label>본문<span class="required">*</span></label>
        <div id="editor" style="min-height: 400px; background: white;"></div>
        <input type="hidden" name="content" id="hiddenContent" value=""/>
      </div>

      <div class="form-actions">
        <a href="/admin/board-posts?categoryId=${categoryId}&categoryKey=${categoryKey}" class="btn btn-secondary">취소</a>
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
  const initialContent = `${post != null && post.content != null ? post.content : ''}`;
  quill = initQuillEditor('#editor', '내용을 입력하세요...', initialContent);

  // 썸네일 자동 업로드 (파일 선택 시)
  const fileInput = document.getElementById('thumbnailFile');
  const uploadStatus = document.getElementById('uploadStatus');

  fileInput.addEventListener('change', function(e) {
    const file = e.target.files[0];

    if (!file) {
      return;
    }

    console.log('=== 썸네일 파일 선택됨 (자동 업로드) ===');
    console.log('파일:', file.name, file.size, file.type);

    if (!file.type.startsWith('image/')) {
      showAlert('이미지 파일만 업로드 가능합니다.', 'warning');
      fileInput.value = '';
      return;
    }

    const formData = new FormData();
    formData.append('upload', file);

    // 상태 표시
    uploadStatus.textContent = '업로드 중...';
    uploadStatus.style.color = '#007bff';
    fileInput.disabled = true;

    fetch('/admin/upload-image', {
      method: 'POST',
      body: formData
    })
    .then(response => {
      console.log('응답 상태:', response.status);
      return response.json();
    })
    .then(data => {
      console.log('응답 데이터:', data);

      if (data.uploaded === 1) {
        const imageUrl = data.url;

        // hidden input에 URL 저장
        document.getElementById('thumbnailUrl').value = imageUrl;
        console.log('✅ thumbnailUrl 값 설정:', imageUrl);
        console.log('✅ 실제 저장된 값:', document.getElementById('thumbnailUrl').value);

        // 미리보기
        const preview = document.getElementById('thumbnailPreview');
        preview.innerHTML = '<img src="' + imageUrl + '" alt="썸네일" style="max-width: 300px; max-height: 200px; border: 1px solid #ddd; border-radius: 4px;"/><p style="font-size: 12px; color: #666; margin-top: 5px;">' + imageUrl + '</p>';

        // 성공 표시
        uploadStatus.textContent = '✓ 업로드 완료';
        uploadStatus.style.color = '#28a745';
      } else {
        uploadStatus.textContent = '✗ 업로드 실패';
        uploadStatus.style.color = '#dc3545';
        showAlert('업로드 실패: ' + (data.error && data.error.message ? data.error.message : '알 수 없는 오류'), 'error');
      }
    })
    .catch(error => {
      console.error('업로드 에러:', error);
      uploadStatus.textContent = '✗ 업로드 오류';
      uploadStatus.style.color = '#dc3545';
      showAlert('업로드 중 오류 발생: ' + error.message, 'error');
    })
    .finally(() => {
      fileInput.disabled = false;
    });
  });

  // 첨부파일 관리
  const attachmentInput = document.getElementById('attachmentFiles');
  const attachmentStatus = document.getElementById('attachmentStatus');
  const attachmentList = document.getElementById('attachmentList');
  const attachmentIdsInput = document.getElementById('attachmentIds');
  let uploadedAttachments = []; // {fileId, fileName, fileUrl, fileSize}

  // 기존 첨부파일 로드 (수정 모드일 때)
  <c:if test="${isEdit}">
    <c:forEach var="file" items="${attachments}">
      uploadedAttachments.push({
        fileId: ${file.id},
        fileName: '${file.originalName}',
        fileUrl: '${file.url}',
        fileSize: ${file.fileSize}
      });
    </c:forEach>
    console.log('기존 첨부파일 로드됨:', uploadedAttachments.length, '개');
    updateAttachmentList();
    updateAttachmentIds();
  </c:if>

  attachmentInput.addEventListener('change', function(e) {
    const files = Array.from(e.target.files);

    if (files.length === 0) {
      return;
    }

    console.log('=== 첨부파일 선택됨 (자동 업로드) ===');
    console.log('파일 개수:', files.length);

    attachmentStatus.textContent = '업로드 중... (0/' + files.length + ')';
    attachmentStatus.style.color = '#007bff';
    attachmentInput.disabled = true;

    let completed = 0;
    let failed = 0;

    // 각 파일 업로드
    files.forEach((file, index) => {
      const formData = new FormData();
      formData.append('upload', file);

      fetch('/admin/upload-image', {
        method: 'POST',
        body: formData
      })
      .then(response => response.json())
      .then(data => {
        completed++;

        if (data.uploaded === 1) {
          // 업로드 성공
          uploadedAttachments.push({
            fileId: data.fileId,
            fileName: file.name,
            fileUrl: data.url,
            fileSize: file.size
          });
          console.log('✅ 파일 업로드 완료:', file.name, 'fileId:', data.fileId);
        } else {
          failed++;
          console.error('❌ 파일 업로드 실패:', file.name);
        }

        // 진행 상태 업데이트
        attachmentStatus.textContent = '업로드 중... (' + completed + '/' + files.length + ')';

        // 모든 파일 완료
        if (completed === files.length) {
          if (failed > 0) {
            attachmentStatus.textContent = '✓ 업로드 완료 (' + (completed - failed) + '개 성공, ' + failed + '개 실패)';
            attachmentStatus.style.color = '#ffc107';
          } else {
            attachmentStatus.textContent = '✓ 모든 파일 업로드 완료 (' + files.length + '개)';
            attachmentStatus.style.color = '#28a745';
          }
          updateAttachmentList();
          updateAttachmentIds();
          attachmentInput.disabled = false;
          attachmentInput.value = ''; // 초기화하여 같은 파일 다시 선택 가능
        }
      })
      .catch(error => {
        completed++;
        failed++;
        console.error('파일 업로드 에러:', file.name, error);

        if (completed === files.length) {
          attachmentStatus.textContent = '✗ 업로드 오류 발생 (' + failed + '개 실패)';
          attachmentStatus.style.color = '#dc3545';
          updateAttachmentList();
          updateAttachmentIds();
          attachmentInput.disabled = false;
          attachmentInput.value = '';
        }
      });
    });
  });

  // 첨부파일 목록 UI 업데이트
  function updateAttachmentList() {
    if (uploadedAttachments.length === 0) {
      attachmentList.innerHTML = '<p style="color: #999; font-size: 14px;">첨부파일이 없습니다.</p>';
      return;
    }

    let html = '<div style="border: 1px solid #ddd; border-radius: 4px; padding: 10px; background: #f8f9fa;">';
    uploadedAttachments.forEach((file, index) => {
      const fileSizeKB = (file.fileSize / 1024).toFixed(1);
      html += '<div style="display: flex; align-items: center; justify-content: space-between; padding: 8px; border-bottom: 1px solid #e9ecef;">';
      html += '<div style="flex: 1;">';
      html += '<strong>' + file.fileName + '</strong> ';
      html += '<span style="color: #666; font-size: 12px;">(' + fileSizeKB + ' KB)</span>';
      html += '</div>';
      html += '<div>';
      html += '<a href="' + file.fileUrl + '" target="_blank" class="btn btn-sm btn-secondary" style="margin-right: 5px;">다운로드</a>';
      html += '<button type="button" class="btn btn-sm btn-danger" onclick="removeAttachment(' + index + ')">삭제</button>';
      html += '</div>';
      html += '</div>';
    });
    html += '</div>';
    attachmentList.innerHTML = html;
  }

  // 첨부파일 삭제
  window.removeAttachment = function(index) {
    if (confirm('첨부파일을 삭제하시겠습니까?')) {
      console.log('첨부파일 삭제:', uploadedAttachments[index].fileName);
      uploadedAttachments.splice(index, 1);
      updateAttachmentList();
      updateAttachmentIds();
    }
  };

  // attachmentIds hidden input 업데이트
  function updateAttachmentIds() {
    const ids = uploadedAttachments.map(f => f.fileId).join(',');
    attachmentIdsInput.value = ids;
    console.log('첨부파일 IDs:', ids);
  }

  // 폼 제출
  document.getElementById('postForm').addEventListener('submit', function(e) {
    console.log('=== 폼 제출 시작 ===');

    const content = quill.root.innerHTML;
    document.getElementById('hiddenContent').value = content;

    const thumbnailInput = document.getElementById('thumbnailUrl');
    const thumbnailValue = thumbnailInput ? thumbnailInput.value : 'INPUT NOT FOUND';

    console.log('제출할 데이터:');
    console.log('- 제목:', document.querySelector('input[name="title"]').value);
    console.log('- 썸네일 input 존재:', !!thumbnailInput);
    console.log('- 썸네일 input.name:', thumbnailInput ? thumbnailInput.name : 'N/A');
    console.log('- 썸네일 값:', thumbnailValue);
    console.log('- 본문 길이:', content.length);

    if (!content || content.trim() === '' || content.trim() === '<p><br></p>') {
      e.preventDefault();
      showAlert('본문을 입력해주세요.', 'warning');
      return false;
    }

    // 실제 폼 데이터 확인
    const formData = new FormData(this);
    console.log('FormData 내용:');
    let hasThumbnail = false;
    for (let pair of formData.entries()) {
      console.log('  ' + pair[0] + ': ' + (pair[1] || '(빈값)'));
      if (pair[0] === 'thumbnail') {
        hasThumbnail = true;
      }
    }
    console.log('thumbnail 파라미터 존재:', hasThumbnail);

    // 디버깅: thumbnail이 없으면 수동으로 추가
    if (!hasThumbnail && thumbnailValue && thumbnailValue !== 'INPUT NOT FOUND') {
      console.warn('⚠️ thumbnail 파라미터가 FormData에 없어서 수동 추가 시도');
      // 폼에 문제가 있을 수 있으니 일단 진행은 시킴
    }
  });
});
</script>

</main>
<jsp:include page="../common/footer.jsp"/>
