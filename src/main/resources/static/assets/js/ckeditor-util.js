/**
 * CKEditor 5 Utility (Superbuild)
 * 전역에서 사용 가능한 CKEditor 헬퍼 함수
 */
const CKEditorUtil = {
    /**
     * CKEditor 인스턴스 생성
     * @param {string} elementId - 에디터를 생성할 textarea ID
     * @param {string} initialContent - 초기 HTML 내용
     * @returns {Promise<Editor>} CKEditor 인스턴스
     */
    async createEditor(elementId, initialContent = '') {
        const element = document.getElementById(elementId);
        if (!element) {
            console.error('Element not found:', elementId);
            return null;
        }

        try {
            const {
                ClassicEditor,
                Essentials,
                Bold,
                Italic,
                Underline,
                Strikethrough,
                Font,
                Paragraph,
                Heading,
                Link,
                List,
                Image,
                ImageCaption,
                ImageStyle,
                ImageToolbar,
                ImageUpload,
                SimpleUploadAdapter,
                Table,
                TableToolbar,
                MediaEmbed,
                BlockQuote,
                Indent,
                IndentBlock,
                Alignment,
                HtmlEmbed,
                SourceEditing,
                GeneralHtmlSupport
            } = CKEDITOR;

            const editor = await ClassicEditor.create(element, {
                plugins: [
                    Essentials,
                    Bold,
                    Italic,
                    Underline,
                    Strikethrough,
                    Font,
                    Paragraph,
                    Heading,
                    Link,
                    List,
                    Image,
                    ImageCaption,
                    ImageStyle,
                    ImageToolbar,
                    ImageUpload,
                    SimpleUploadAdapter,
                    Table,
                    TableToolbar,
                    MediaEmbed,
                    BlockQuote,
                    Indent,
                    IndentBlock,
                    Alignment,
                    HtmlEmbed,
                    SourceEditing,
                    GeneralHtmlSupport
                ],
                toolbar: [
                    'heading',
                    '|',
                    'bold',
                    'italic',
                    'underline',
                    'strikethrough',
                    '|',
                    'fontSize',
                    'fontFamily',
                    'fontColor',
                    'fontBackgroundColor',
                    '|',
                    'alignment',
                    '|',
                    'link',
                    'uploadImage',
                    'blockQuote',
                    'insertTable',
                    'mediaEmbed',
                    '|',
                    'bulletedList',
                    'numberedList',
                    'outdent',
                    'indent',
                    '|',
                    'htmlEmbed',
                    'sourceEditing',
                    '|',
                    'undo',
                    'redo'
                ],
                language: 'ko',
                fontSize: {
                    options: [
                        9,
                        11,
                        13,
                        'default',
                        17,
                        19,
                        21,
                        24,
                        28,
                        32,
                        36
                    ],
                    supportAllValues: true
                },
                fontFamily: {
                    options: [
                        'default',
                        'Arial, Helvetica, sans-serif',
                        'Courier New, Courier, monospace',
                        'Georgia, serif',
                        'Lucida Sans Unicode, Lucida Grande, sans-serif',
                        'Tahoma, Geneva, sans-serif',
                        'Times New Roman, Times, serif',
                        'Trebuchet MS, Helvetica, sans-serif',
                        'Verdana, Geneva, sans-serif',
                        'Malgun Gothic, 맑은 고딕',
                        'Nanum Gothic, 나눔고딕',
                        'Noto Sans KR'
                    ],
                    supportAllValues: true
                },
                fontColor: {
                    columns: 5,
                    documentColors: 10
                },
                fontBackgroundColor: {
                    columns: 5,
                    documentColors: 10
                },
                heading: {
                    options: [
                        { model: 'paragraph', title: '본문', class: 'ck-heading_paragraph' },
                        { model: 'heading1', view: 'h1', title: '제목 1', class: 'ck-heading_heading1' },
                        { model: 'heading2', view: 'h2', title: '제목 2', class: 'ck-heading_heading2' },
                        { model: 'heading3', view: 'h3', title: '제목 3', class: 'ck-heading_heading3' },
                        { model: 'heading4', view: 'h4', title: '제목 4', class: 'ck-heading_heading4' }
                    ]
                },
                image: {
                    toolbar: [
                        'imageTextAlternative',
                        'toggleImageCaption',
                        '|',
                        'imageStyle:inline',
                        'imageStyle:block',
                        'imageStyle:side',
                        '|',
                        'linkImage'
                    ],
                    upload: {
                        types: ['jpeg', 'jpg', 'png', 'gif', 'bmp', 'webp', 'svg+xml']
                    }
                },
                table: {
                    contentToolbar: [
                        'tableColumn',
                        'tableRow',
                        'mergeTableCells',
                        'tableCellProperties',
                        'tableProperties'
                    ]
                },
                link: {
                    decorators: {
                        openInNewTab: {
                            mode: 'manual',
                            label: '새 탭에서 열기',
                            attributes: {
                                target: '_blank',
                                rel: 'noopener noreferrer'
                            }
                        }
                    }
                },
                // 이미지 업로드 설정
                simpleUpload: {
                    uploadUrl: '/admin/upload-image',
                    withCredentials: true
                },
                // HTML 지원
                htmlSupport: {
                    allow: [
                        {
                            name: /.*/,
                            attributes: true,
                            classes: true,
                            styles: true
                        }
                    ]
                }
            });

            // 초기 내용 설정
            if (initialContent) {
                editor.setData(initialContent);
            }

            return editor;
        } catch (error) {
            console.error('CKEditor 초기화 실패:', error);
            return null;
        }
    },

    /**
     * 에디터 내용을 HTML로 가져오기
     * @param {Editor} editor - CKEditor 인스턴스
     * @returns {string} HTML 문자열
     */
    getHTML(editor) {
        if (!editor) return '';
        return editor.getData();
    },

    /**
     * 에디터 내용 설정
     * @param {Editor} editor - CKEditor 인스턴스
     * @param {string} html - 설정할 HTML 문자열
     */
    setHTML(editor, html) {
        if (editor) {
            editor.setData(html || '');
        }
    },

    /**
     * 에디터 제거
     * @param {Editor} editor - CKEditor 인스턴스
     */
    destroy(editor) {
        if (editor) {
            editor.destroy().catch(error => {
                console.error('CKEditor 제거 실패:', error);
            });
        }
    }
};

// 전역 객체로 노출
window.CKEditorUtil = CKEditorUtil;
