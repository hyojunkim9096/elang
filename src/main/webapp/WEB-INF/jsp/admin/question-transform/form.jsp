<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<main class="admin-content">

<div class="page-header">
  <h1>${adminLang == 'en' ? 'Question Transform' : '영어 문제 변형'}</h1>
  <p class="subtitle">${adminLang == 'en' ? 'Transform English questions by difficulty' : '영어 지문/문제를 난이도별로 변형합니다'}</p>
</div>

<c:if test="${not empty error}">
  <div style="padding: 12px 20px; background: #fee2e2; color: #991b1b; border-radius: 8px; margin-bottom: 20px;">
    ${error}
  </div>
</c:if>

<c:if test="${not empty message}">
  <div style="padding: 12px 20px; background: #d1fae5; color: #065f46; border-radius: 8px; margin-bottom: 20px;">
    ${message}
  </div>
</c:if>

<!-- 결과가 없을 때: 2열 레이아웃 -->
<c:if test="${empty result}">
  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
    <!-- 입력 폼 -->
    <div class="panel">
      <div class="panel-header">
        <h2>${adminLang == 'en' ? 'Input' : '입력'}</h2>
      </div>
      <div class="panel-body">
        <form action="/admin/question-transform/transform" method="post" enctype="multipart/form-data">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
          <input type="hidden" name="lang" value="${adminLang}"/>

          <!-- 입력 방식 선택 탭 -->
          <div style="display: flex; gap: 8px; margin-bottom: 16px;">
            <button type="button" class="btn btn-primary input-tab active" data-tab="file" onclick="switchTab('file')">
              📁 파일 업로드
            </button>
            <button type="button" class="btn btn-secondary input-tab" data-tab="text" onclick="switchTab('text')">
              📝 텍스트 입력
            </button>
          </div>

          <!-- 파일 업로드 영역 -->
          <div id="fileInputArea" class="input-area">
            <div class="form-group">
              <label>${adminLang == 'en' ? 'Upload File' : '파일 업로드'}</label>
              <div id="dropZone" style="border: 2px dashed #d1d5db; border-radius: 12px; padding: 40px 20px; text-align: center; cursor: pointer; transition: all 0.2s; background: #f9fafb;">
                <input type="file" name="file" id="fileInput" accept="image/*,.pdf" style="display: none;" onchange="handleFileSelect(this)"/>
                <div id="dropZoneContent">
                  <p style="font-size: 48px; margin: 0;">📄</p>
                  <p style="color: #6b7280; margin: 12px 0 0 0;">${adminLang == 'en' ? 'Click or drag & drop' : '클릭하거나 파일을 드래그하세요'}</p>
                  <p style="color: #9ca3af; font-size: 13px; margin: 8px 0 0 0;">이미지 (JPG, PNG) 또는 PDF</p>
                </div>
                <div id="filePreview" style="display: none;">
                  <img id="imagePreview" src="" alt="미리보기" style="max-width: 100%; max-height: 200px; border-radius: 8px; margin-bottom: 12px; display: none; cursor: zoom-in;" onclick="openImageModal(event)"/>
                  <p id="pdfIcon" style="font-size: 48px; margin: 0; display: none;">📑</p>
                  <p id="fileName" style="color: #059669; font-weight: 500; margin: 8px 0 0 0;"></p>
                  <p id="zoomHint" style="color: #9ca3af; font-size: 12px; margin: 4px 0 0 0; display: none;">클릭하면 크게 볼 수 있습니다</p>
                  <button type="button" class="btn btn-sm btn-secondary" style="margin-top: 12px;" onclick="clearFile(event)">다른 파일 선택</button>
                </div>
              </div>
            </div>
          </div>

          <!-- 텍스트 입력 영역 -->
          <div id="textInputArea" class="input-area" style="display: none;">
            <div class="form-group">
              <label>${adminLang == 'en' ? 'Original Text' : '원본 지문/문제'}</label>
              <textarea name="originalText" id="originalText" class="form-control" rows="12"
                        placeholder="${adminLang == 'en' ? 'Enter English passage or question...' : '영어 지문이나 문제를 입력하세요...'}"
              ><c:out value="${originalText}"/></textarea>
            </div>
          </div>

          <div class="form-group">
            <label>${adminLang == 'en' ? 'Target Difficulty' : '목표 난이도'}<span class="required">*</span></label>
            <select name="difficulty" class="form-control" required>
              <option value="">${adminLang == 'en' ? '-- Select --' : '-- 선택 --'}</option>
              <c:forEach var="diff" items="${difficulties}">
                <option value="${diff}" ${selectedDifficulty == diff ? 'selected' : ''}>
                  ${diff.label} (${diff})
                </option>
              </c:forEach>
            </select>
          </div>

          <!-- 언어 선택 옵션 -->
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
            <div class="form-group">
              <label>${adminLang == 'en' ? 'Question Language' : '문제(질문) 언어'}</label>
              <select name="questionLang" class="form-control">
                <option value="KO" ${selectedQuestionLang == 'KO' || empty selectedQuestionLang ? 'selected' : ''}>한글</option>
                <option value="EN" ${selectedQuestionLang == 'EN' ? 'selected' : ''}>English</option>
              </select>
            </div>
            <div class="form-group">
              <label>${adminLang == 'en' ? 'Choice Language' : '보기(선택지) 언어'}</label>
              <select name="choiceLang" class="form-control">
                <option value="KO" ${selectedChoiceLang == 'KO' || empty selectedChoiceLang ? 'selected' : ''}>한글</option>
                <option value="EN" ${selectedChoiceLang == 'EN' ? 'selected' : ''}>English</option>
              </select>
            </div>
          </div>

          <button type="submit" class="btn btn-primary" style="width: 100%;" id="submitBtn">
            ${adminLang == 'en' ? 'Transform' : '변형 생성'}
          </button>
        </form>
      </div>
    </div>

    <!-- 안내 -->
    <div class="panel">
      <div class="panel-body" style="text-align: center; padding: 60px 20px; color: #9ca3af;">
        <p style="font-size: 48px; margin: 0;">📝</p>
        <p>${adminLang == 'en' ? 'Enter text or upload file and click Transform' : '텍스트를 입력하거나 파일을 업로드하고 변형 생성 버튼을 클릭하세요'}</p>
      </div>
    </div>
  </div>
</c:if>

<!-- 결과가 있을 때: 3열 레이아웃 -->
<c:if test="${not empty result}">
  <div style="display: grid; grid-template-columns: 1.3fr 1fr 1.5fr; gap: 20px;">

    <!-- 1열: 원본 문제 -->
    <div class="panel">
      <div class="panel-header">
        <h2>원본 문제</h2>
        <span class="badge" style="background:#fef3c7; color:#92400e;">원본</span>
      </div>
      <div class="panel-body" style="max-height: 600px; overflow-y: auto;">
        <c:choose>
          <c:when test="${not empty result.originalText && result.originalText != '[이미지에서 추출]'}">
            <pre style="white-space: pre-wrap; background: #fffbeb; padding: 16px; border-radius: 8px; line-height: 1.6; font-size: 13px; margin: 0;"><c:out value="${result.originalText}"/></pre>
          </c:when>
          <c:otherwise>
            <div style="text-align: center; padding: 40px 20px; color: #9ca3af;">
              <p style="font-size: 32px; margin: 0;">📷</p>
              <p style="margin: 8px 0 0 0;">이미지에서 추출 중...</p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- 2열: 분석/해설 -->
    <div class="panel">
      <div class="panel-header">
        <h2>분석 및 해설</h2>
        <c:choose>
          <c:when test="${result.status == 'COMPLETED'}">
            <span class="badge badge-success">${result.statusLabel}</span>
          </c:when>
          <c:when test="${result.status == 'FAILED'}">
            <span class="badge" style="background:#fee2e2; color:#991b1b;">${result.statusLabel}</span>
          </c:when>
          <c:otherwise>
            <span class="badge">${result.statusLabel}</span>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="panel-body" style="max-height: 600px; overflow-y: auto;">
        <c:if test="${result.status == 'FAILED'}">
          <div style="padding: 12px; background: #fee2e2; color: #991b1b; border-radius: 8px; margin-bottom: 16px;">
            <c:out value="${result.errorMessage}"/>
          </div>
        </c:if>
        <c:if test="${not empty result.analysis}">
          <pre style="white-space: pre-wrap; background: #f9fafb; padding: 16px; border-radius: 8px; line-height: 1.6; font-size: 13px; margin: 0;"><c:out value="${result.analysis}"/></pre>
        </c:if>
      </div>
    </div>

    <!-- 3열: 변형 문제 (탭) -->
    <div class="panel">
      <div class="panel-header" style="flex-wrap: wrap; gap: 8px;">
        <h2>변형된 문제</h2>
        <span class="badge" style="background:#dbeafe; color:#1e40af;">${result.difficultyLabel}</span>
      </div>

      <!-- 탭 버튼 -->
      <div style="display: flex; gap: 4px; padding: 12px 16px 0; border-bottom: 1px solid #e5e7eb; background: #f9fafb;">
        <button type="button" class="variant-tab active" data-variant="1" onclick="switchVariantTab(1)">
          변형 1
        </button>
        <button type="button" class="variant-tab" data-variant="2" onclick="switchVariantTab(2)">
          변형 2
        </button>
        <button type="button" class="variant-tab" data-variant="3" onclick="switchVariantTab(3)">
          변형 3
        </button>
      </div>

      <div class="panel-body" style="max-height: 550px; overflow-y: auto; padding-top: 16px;">
        <c:if test="${not empty result.transformedText}">
          <div id="variantContent">
            <pre id="variantPre" style="white-space: pre-wrap; background: #f0fdf4; padding: 16px; border-radius: 8px; line-height: 1.8; font-size: 13px; margin: 0;"><c:out value="${result.transformedText}"/></pre>
          </div>
        </c:if>
      </div>
    </div>

  </div>

  <!-- 하단 버튼 -->
  <div style="margin-top: 16px; display: flex; gap: 12px;">
    <a href="/admin/question-transform/new?lang=${adminLang}" class="btn btn-primary">
      새로운 변형 생성
    </a>
    <a href="/admin/question-transform?lang=${adminLang}" class="btn btn-secondary">
      히스토리 보기
    </a>
  </div>
</c:if>

<c:if test="${empty result}">
  <div style="margin-top: 16px;">
    <a href="/admin/question-transform?lang=${adminLang}" class="btn btn-secondary">
      ${adminLang == 'en' ? 'View History' : '히스토리 보기'}
    </a>
  </div>
</c:if>

<!-- 이미지 확대 모달 -->
<div id="imageModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.9); z-index: 9999; cursor: zoom-out;" onclick="closeImageModal()">
  <span style="position: absolute; top: 20px; right: 30px; color: #fff; font-size: 36px; cursor: pointer;">&times;</span>
  <img id="modalImage" src="" alt="확대 이미지" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); max-width: 95%; max-height: 95%; border-radius: 8px;"/>
</div>

<style>
.variant-tab {
  padding: 8px 16px;
  border: none;
  background: transparent;
  color: #6b7280;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  margin-bottom: -1px;
  transition: all 0.2s;
}
.variant-tab:hover {
  color: #374151;
}
.variant-tab.active {
  color: #059669;
  border-bottom-color: #059669;
  font-weight: 500;
}
</style>

<script>
// 변형된 문제 전체 텍스트 저장
var fullTransformedText = '';
<c:if test="${not empty result.transformedText}">
fullTransformedText = document.getElementById('variantPre') ? document.getElementById('variantPre').textContent : '';
</c:if>

// 변형 문제를 파싱해서 각 탭별로 분리
var variantTexts = {};
function parseVariants() {
  if (!fullTransformedText) return;

  var text = fullTransformedText;

  // [변형 문제 1], [변형 문제 2], [변형 문제 3] 으로 분리
  var matches = text.split(/\[변형 문제 (\d)\]/);

  if (matches.length > 1) {
    for (var i = 1; i < matches.length; i += 2) {
      var num = matches[i];
      var content = matches[i + 1] || '';
      // 다음 섹션 전까지만 가져오기
      var nextSection = content.indexOf('[변형 포인트]');
      if (nextSection > 0) {
        content = content.substring(0, nextSection);
      }
      variantTexts[num] = '[변형 문제 ' + num + ']' + content.trim();
    }
  }

  // 변형 포인트 섹션
  var notesIdx = text.indexOf('[변형 포인트]');
  if (notesIdx >= 0) {
    variantTexts['notes'] = text.substring(notesIdx).trim();
  }
}

function switchVariantTab(num) {
  // 탭 스타일 변경
  document.querySelectorAll('.variant-tab').forEach(function(tab) {
    if (parseInt(tab.dataset.variant) === num) {
      tab.classList.add('active');
    } else {
      tab.classList.remove('active');
    }
  });

  // 내용 변경
  var pre = document.getElementById('variantPre');
  if (pre && variantTexts[num]) {
    var content = variantTexts[num];
    // 변형 포인트도 해당 문제의 것만 추가
    if (variantTexts['notes']) {
      var notes = variantTexts['notes'];
      var lines = notes.split('\n');
      var relevantNote = '';
      lines.forEach(function(line) {
        if (line.includes('변형 문제 ' + num + ':') || line.includes('[변형 포인트]')) {
          relevantNote += line + '\n';
        }
      });
      if (relevantNote) {
        content += '\n\n' + relevantNote.trim();
      }
    }
    pre.textContent = content;
  } else if (pre) {
    pre.textContent = '변형 문제 ' + num + '이 없습니다.';
  }
}

// 페이지 로드 시 파싱
document.addEventListener('DOMContentLoaded', function() {
  parseVariants();
  // 첫 번째 탭 활성화
  if (Object.keys(variantTexts).length > 0) {
    switchVariantTab(1);
  }
});

function switchTab(tab) {
  document.querySelectorAll('.input-tab').forEach(function(btn) {
    if (btn.dataset.tab === tab) {
      btn.classList.remove('btn-secondary');
      btn.classList.add('btn-primary', 'active');
    } else {
      btn.classList.remove('btn-primary', 'active');
      btn.classList.add('btn-secondary');
    }
  });

  if (tab === 'file') {
    document.getElementById('fileInputArea').style.display = 'block';
    document.getElementById('textInputArea').style.display = 'none';
    document.getElementById('originalText').value = '';
  } else {
    document.getElementById('fileInputArea').style.display = 'none';
    document.getElementById('textInputArea').style.display = 'block';
    clearFile();
  }
}

// 드래그 앤 드롭
var dropZone = document.getElementById('dropZone');
if (dropZone) {
  dropZone.addEventListener('click', function(e) {
    if (e.target.tagName !== 'BUTTON') {
      document.getElementById('fileInput').click();
    }
  });

  dropZone.addEventListener('dragover', function(e) {
    e.preventDefault();
    dropZone.style.borderColor = '#3b82f6';
    dropZone.style.background = '#eff6ff';
  });

  dropZone.addEventListener('dragleave', function(e) {
    e.preventDefault();
    dropZone.style.borderColor = '#d1d5db';
    dropZone.style.background = '#f9fafb';
  });

  dropZone.addEventListener('drop', function(e) {
    e.preventDefault();
    dropZone.style.borderColor = '#d1d5db';
    dropZone.style.background = '#f9fafb';

    var files = e.dataTransfer.files;
    if (files.length > 0) {
      document.getElementById('fileInput').files = files;
      handleFileSelect(document.getElementById('fileInput'));
    }
  });
}

function handleFileSelect(input) {
  var file = input.files[0];
  if (file) {
    document.getElementById('dropZoneContent').style.display = 'none';
    document.getElementById('filePreview').style.display = 'block';
    document.getElementById('fileName').textContent = file.name + ' (' + formatFileSize(file.size) + ')';

    var imagePreview = document.getElementById('imagePreview');
    var pdfIcon = document.getElementById('pdfIcon');
    var zoomHint = document.getElementById('zoomHint');

    if (file.type.startsWith('image/')) {
      var reader = new FileReader();
      reader.onload = function(e) {
        imagePreview.src = e.target.result;
        imagePreview.style.display = 'block';
        pdfIcon.style.display = 'none';
        zoomHint.style.display = 'block';
      };
      reader.readAsDataURL(file);
    } else {
      imagePreview.style.display = 'none';
      pdfIcon.style.display = 'block';
      zoomHint.style.display = 'none';
    }
  }
}

function clearFile(e) {
  if (e) e.stopPropagation();
  document.getElementById('fileInput').value = '';
  document.getElementById('dropZoneContent').style.display = 'block';
  document.getElementById('filePreview').style.display = 'none';
  document.getElementById('imagePreview').style.display = 'none';
  document.getElementById('imagePreview').src = '';
  document.getElementById('pdfIcon').style.display = 'none';
  document.getElementById('zoomHint').style.display = 'none';
}

function formatFileSize(bytes) {
  if (bytes < 1024) return bytes + ' B';
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
  return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
}

function openImageModal(e) {
  e.stopPropagation();
  var src = document.getElementById('imagePreview').src;
  document.getElementById('modalImage').src = src;
  document.getElementById('imageModal').style.display = 'block';
  document.body.style.overflow = 'hidden';
}

function closeImageModal() {
  document.getElementById('imageModal').style.display = 'none';
  document.body.style.overflow = '';
}

document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape') {
    closeImageModal();
  }
});
</script>

</main>
<jsp:include page="../common/footer.jsp"/>
