// ============================================================================
// 공통 모달 관리
// ============================================================================

let modalSubmitCallback = null;

/**
 * 모달 열기
 * @param {string} title - 모달 제목
 * @param {string} bodyHtml - 모달 본문 HTML
 * @param {function} onSubmit - 확인 버튼 클릭 시 콜백
 */
function openModal(title, bodyHtml, onSubmit) {
  document.getElementById('modalTitle').textContent = title;
  document.getElementById('modalBody').innerHTML = bodyHtml;
  document.getElementById('commonModal').style.display = 'flex';

  modalSubmitCallback = onSubmit;

  // 확인 버튼 이벤트
  const submitBtn = document.getElementById('modalSubmitBtn');
  submitBtn.onclick = function() {
    if (modalSubmitCallback) {
      modalSubmitCallback();
    }
  };
}

/**
 * 모달 닫기
 */
function closeModal() {
  document.getElementById('commonModal').style.display = 'none';
  document.getElementById('modalBody').innerHTML = '';
  modalSubmitCallback = null;
}

// 모달 배경 클릭시 닫기
document.addEventListener('DOMContentLoaded', function() {
  const modal = document.getElementById('commonModal');
  if (modal) {
    modal.onclick = function(event) {
      if (event.target === modal) {
        closeModal();
      }
    };
  }
});

// ============================================================================
// 공통 유틸리티
// ============================================================================

/**
 * 성공 알림
 */
function showSuccess(message) {
  alert('✅ ' + message);
}

/**
 * 에러 알림
 */
function showError(message) {
  alert('❌ ' + message);
}

/**
 * 확인 다이얼로그
 */
function confirmAction(message, onConfirm) {
  if (confirm(message)) {
    onConfirm();
  }
}

/**
 * AJAX 요청 래퍼
 */
function apiRequest(method, url, data, onSuccess, onError) {
  $.ajax({
    type: method,
    url: url,
    contentType: 'application/json',
    data: data ? JSON.stringify(data) : null,
    success: function(response) {
      if (onSuccess) onSuccess(response);
    },
    error: function(xhr) {
      const errorMsg = xhr.responseJSON?.message || '요청 실패';
      if (onError) {
        onError(errorMsg);
      } else {
        showError(errorMsg);
      }
    }
  });
}

/**
 * 테이블 행 생성 헬퍼
 */
function createTableRow(cells) {
  const tr = document.createElement('tr');
  cells.forEach(cell => {
    const td = document.createElement('td');
    if (typeof cell === 'string') {
      td.innerHTML = cell;
    } else {
      td.appendChild(cell);
    }
    tr.appendChild(td);
  });
  return tr;
}

/**
 * 폼 데이터를 객체로 변환
 */
function formToObject(formId) {
  const form = document.getElementById(formId);
  const formData = new FormData(form);
  const obj = {};
  for (let [key, value] of formData.entries()) {
    obj[key] = value;
  }
  return obj;
}
