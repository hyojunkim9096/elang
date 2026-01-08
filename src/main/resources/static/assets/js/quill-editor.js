/**
 * Quill Editor 공통 유틸리티
 * - Quill.js를 사용한 WYSIWYG HTML 에디터
 */

class QuillEditorUtil {
  /**
   * Quill 에디터 초기화
   * @param {string} containerId - 에디터가 렌더링될 DOM 요소 ID
   * @param {string} initialContent - 초기 HTML 컨텐츠
   * @returns {Quill} Quill 인스턴스
   */
  static createEditor(containerId, initialContent = '') {
    const quill = new Quill(`#${containerId}`, {
      theme: 'snow',
      modules: {
        toolbar: [
          [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
          [{ 'font': [] }],
          [{ 'size': ['small', false, 'large', 'huge'] }],
          ['bold', 'italic', 'underline', 'strike'],
          [{ 'color': [] }, { 'background': [] }],
          [{ 'script': 'sub'}, { 'script': 'super' }],
          [{ 'list': 'ordered'}, { 'list': 'bullet' }],
          [{ 'indent': '-1'}, { 'indent': '+1' }],
          [{ 'align': [] }],
          ['blockquote', 'code-block'],
          ['link', 'image', 'video'],
          ['clean']
        ]
      },
      placeholder: '내용을 입력하세요...'
    });

    if (initialContent) {
      quill.root.innerHTML = initialContent;
    }

    // 이미지 업로드 핸들러 등록
    const toolbar = quill.getModule('toolbar');
    toolbar.addHandler('image', function() {
      QuillEditorUtil.imageHandler(quill);
    });

    return quill;
  }

  /**
   * 이미지 업로드 핸들러
   * @param {Quill} quill - Quill 인스턴스
   */
  static imageHandler(quill) {
    const input = document.createElement('input');
    input.setAttribute('type', 'file');
    input.setAttribute('accept', 'image/*');
    input.click();

    input.onchange = async () => {
      const file = input.files[0];
      if (!file) return;

      // 파일 크기 체크 (5MB)
      if (file.size > 5 * 1024 * 1024) {
        alert('이미지 크기는 5MB 이하만 가능합니다.');
        return;
      }

      // FormData 생성
      const formData = new FormData();
      formData.append('file', file);

      try {
        // 서버에 업로드
        const response = await fetch('/admin/upload-image', {
          method: 'POST',
          body: formData,
          headers: {
            'X-CSRF-TOKEN': document.querySelector('input[name="_csrf"]')?.value || ''
          }
        });

        const result = await response.json();

        if (result.error) {
          alert('이미지 업로드 실패: ' + result.error);
          return;
        }

        // 에디터에 이미지 삽입
        const range = quill.getSelection();
        quill.insertEmbed(range.index, 'image', result.url);
        quill.setSelection(range.index + 1);

      } catch (error) {
        console.error('이미지 업로드 오류:', error);
        alert('이미지 업로드 중 오류가 발생했습니다.');
      }
    };
  }

  /**
   * Quill 에디터에서 HTML 컨텐츠 가져오기
   * @param {Quill} quill - Quill 인스턴스
   * @returns {string} HTML 문자열
   */
  static getHTML(quill) {
    return quill.root.innerHTML;
  }

  /**
   * Quill 에디터에 HTML 컨텐츠 설정
   * @param {Quill} quill - Quill 인스턴스
   * @param {string} html - 설정할 HTML 문자열
   */
  static setHTML(quill, html) {
    quill.root.innerHTML = html || '';
  }

  /**
   * Quill CDN 리소스 로드 확인
   * @returns {boolean} Quill이 로드되었는지 여부
   */
  static isLoaded() {
    return typeof Quill !== 'undefined';
  }
}
