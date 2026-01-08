/**
 * Quill Editor 공통 설정
 */

/**
 * Quill 에디터 초기화
 * @param {string} selector - 에디터를 적용할 CSS 셀렉터 (예: '#editor')
 * @param {string} placeholder - 플레이스홀더 텍스트
 * @param {string} initialContent - 초기 컨텐츠 HTML
 * @returns {Quill} Quill 인스턴스
 */
function initQuillEditor(selector, placeholder = '내용을 입력하세요...', initialContent = '') {
  // 한글 글꼴 등록
  const Font = Quill.import('formats/font');
  Font.whitelist = ['sans-serif', 'serif', 'monospace', 'malgun-gothic', 'nanum-gothic', 'noto-sans'];
  Quill.register(Font, true);

  // 글자 크기 등록 (픽셀 단위)
  const Size = Quill.import('formats/size');
  Size.whitelist = ['10px', '12px', '14px', '16px', '18px', '20px', '24px', '28px', '32px', '36px', '48px', '72px'];
  Quill.register(Size, true);

  // 이미지 리사이즈 모듈 등록 (ImageResize가 있을 경우에만)
  if (typeof ImageResize !== 'undefined') {
    Quill.register('modules/imageResize', ImageResize.default || ImageResize);
  }

  // Toolbar 설정
  const toolbarOptions = [
    [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
    [{ 'size': ['10px', '12px', '14px', '16px', '18px', '20px', '24px', '28px', '32px', '36px', '48px', '72px'] }],
    [{ 'font': ['sans-serif', 'serif', 'monospace', 'malgun-gothic', 'nanum-gothic', 'noto-sans'] }],
    ['bold', 'italic', 'underline', 'strike'],
    [{ 'color': [] }, { 'background': [] }],
    [{ 'align': [] }],
    [{ 'list': 'ordered'}, { 'list': 'bullet' }],
    [{ 'indent': '-1'}, { 'indent': '+1' }],
    ['blockquote', 'code-block'],
    ['link', 'image', 'video'],
    ['clean']
  ];

  // 모듈 설정
  const modules = {
    toolbar: {
      container: toolbarOptions,
      handlers: {}
    }
  };

  // ImageResize 모듈이 있으면 추가
  if (typeof ImageResize !== 'undefined') {
    modules.imageResize = {
      displaySize: true,
      modules: ['Resize', 'DisplaySize', 'Toolbar']
    };
  }

  // Quill 초기화
  const quill = new Quill(selector, {
    theme: 'snow',
    modules: modules,
    placeholder: placeholder
  });

  // 이미지 업로드 핸들러 설정
  const toolbar = quill.getModule('toolbar');
  toolbar.addHandler('image', function() {
    const input = document.createElement('input');
    input.setAttribute('type', 'file');
    input.setAttribute('accept', 'image/*');
    input.click();

    input.onchange = async () => {
      const file = input.files[0];
      if (file) {
        // 파일 크기 체크 (5MB = 5 * 1024 * 1024 bytes)
        const maxSize = 5 * 1024 * 1024;
        if (file.size > maxSize) {
          const sizeMB = (file.size / 1024 / 1024).toFixed(2);
          if (typeof showAlert === 'function') {
            showAlert(`이미지 크기가 너무 큽니다.<br>최대 5MB까지 업로드 가능합니다.<br>(현재 파일: ${sizeMB}MB)`, 'warning');
          } else {
            alert(`이미지 크기가 너무 큽니다.\n최대 5MB까지 업로드 가능합니다.\n(현재 파일: ${sizeMB}MB)`);
          }
          return;
        }

        const formData = new FormData();
        formData.append('upload', file);

        try {
          const response = await fetch('/admin/upload-image', {
            method: 'POST',
            body: formData
          });

          if (!response.ok) {
            throw new Error('서버 응답 오류: ' + response.status);
          }

          const data = await response.json();

          if (data.uploaded === 1) {
            const range = quill.getSelection();
            quill.insertEmbed(range.index, 'image', data.url);
            console.log('이미지 삽입 완료:', data.url);
          } else {
            // 서버에서 반환한 에러 메시지 사용
            const errorMsg = data.error && data.error.message ? data.error.message : '이미지 업로드에 실패했습니다.';
            if (typeof showAlert === 'function') {
              showAlert(errorMsg, 'error');
            } else {
              alert(errorMsg);
            }
          }
        } catch (error) {
          console.error('이미지 업로드 에러:', error);
          if (typeof showAlert === 'function') {
            showAlert('이미지 업로드 중 오류가 발생했습니다.', 'error');
          } else {
            alert('이미지 업로드 중 오류 발생');
          }
        }
      }
    };
  });

  // 초기 컨텐츠 설정
  if (initialContent) {
    quill.root.innerHTML = initialContent;
  }

  console.log('Quill 에디터 초기화 완료');

  return quill;
}
