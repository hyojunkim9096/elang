/**
 * 공통 모달 유틸리티
 */

// 모달 HTML 생성 함수
function initModal() {
  console.log('initModal 호출됨, body 존재:', !!document.body);

  if (document.getElementById('commonModal')) {
    console.log('모달이 이미 존재합니다');
    return;
  }

  if (!document.body) {
    console.error('document.body가 아직 없습니다. DOMContentLoaded를 기다립니다.');
    return;
  }

  const modalHTML = `
    <div id="commonModal" class="modal-overlay">
      <div class="modal-container">
        <div class="modal-header" id="modalHeader">
          <div class="modal-icon" id="modalIcon"></div>
          <h3 class="modal-title" id="modalTitle"></h3>
        </div>
        <div class="modal-body" id="modalBody"></div>
        <div class="modal-footer" id="modalFooter"></div>
      </div>
    </div>
  `;

  document.body.insertAdjacentHTML('beforeend', modalHTML);
  console.log('Modal HTML 추가 완료, 확인:', !!document.getElementById('commonModal'));
}

// DOM 로드 시 즉시 모달 초기화 (여러 방법으로 시도)
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initModal);
} else if (document.readyState === 'interactive' || document.readyState === 'complete') {
  // 이미 로드되었다면 즉시 실행
  if (document.body) {
    initModal();
  } else {
    // body가 없으면 기다림
    document.addEventListener('DOMContentLoaded', initModal);
  }
}

/**
 * 모달 표시
 * @param {Object} options - 모달 옵션
 * @param {string} options.type - 모달 타입 (info, success, warning, error)
 * @param {string} options.title - 모달 제목
 * @param {string} options.message - 모달 메시지
 * @param {Array} options.buttons - 버튼 배열 [{text, className, onClick}]
 */
function showModal(options) {
  // 모달이 없으면 초기화
  if (!document.getElementById('commonModal')) {
    initModal();
  }

  const modal = document.getElementById('commonModal');
  const header = document.getElementById('modalHeader');
  const icon = document.getElementById('modalIcon');
  const title = document.getElementById('modalTitle');
  const body = document.getElementById('modalBody');
  const footer = document.getElementById('modalFooter');

  if (!modal || !header || !icon || !title || !body || !footer) {
    console.error('Modal elements not found. Falling back to alert.');
    console.log('modal:', modal, 'header:', header, 'icon:', icon, 'title:', title, 'body:', body, 'footer:', footer);
    // HTML 태그 제거 후 alert
    const plainMessage = options.message ? options.message.replace(/<br>/g, '\n').replace(/<[^>]*>/g, '') : '';
    alert(plainMessage);
    return;
  }

  // 타입별 아이콘
  const icons = {
    info: 'ℹ️',
    success: '✓',
    warning: '⚠️',
    error: '✕'
  };

  // 헤더 설정
  header.className = 'modal-header ' + (options.type || 'info');
  icon.textContent = icons[options.type || 'info'];
  title.textContent = options.title || '알림';

  // 바디 설정
  body.innerHTML = options.message || '';

  // 버튼 설정
  footer.innerHTML = '';
  const buttons = options.buttons || [{
    text: '확인',
    className: 'btn btn-primary',
    onClick: () => closeModal()
  }];

  buttons.forEach(btn => {
    const button = document.createElement('button');
    button.textContent = btn.text;
    button.className = btn.className || 'btn btn-secondary';
    button.onclick = () => {
      if (btn.onClick) {
        btn.onClick();
      }
      closeModal();
    };
    footer.appendChild(button);
  });

  // 모달 표시
  modal.classList.add('active');

  // ESC 키로 닫기
  const escapeHandler = (e) => {
    if (e.key === 'Escape') {
      closeModal();
      document.removeEventListener('keydown', escapeHandler);
    }
  };
  document.addEventListener('keydown', escapeHandler);

  // 오버레이 클릭으로 닫기
  modal.onclick = (e) => {
    if (e.target === modal) {
      closeModal();
    }
  };
}

/**
 * 모달 닫기
 */
function closeModal() {
  const modal = document.getElementById('commonModal');
  if (modal) {
    modal.classList.remove('active');
  }
}

/**
 * 간단한 알림 모달
 */
function showAlert(message, type = 'info') {
  showModal({
    type: type,
    title: type === 'error' ? '오류' : type === 'success' ? '성공' : type === 'warning' ? '경고' : '알림',
    message: message
  });
}

/**
 * 확인/취소 모달
 */
function showConfirm(message, onConfirm, options = {}) {
  showModal({
    type: options.type || 'warning',
    title: options.title || '확인',
    message: message,
    buttons: [
      {
        text: '취소',
        className: 'btn btn-secondary',
        onClick: () => {
          if (options.onCancel) options.onCancel();
        }
      },
      {
        text: '확인',
        className: 'btn btn-primary',
        onClick: onConfirm
      }
    ]
  });
}
