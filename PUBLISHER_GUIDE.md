# E-LANG CMS 퍼블리셔 가이드

> 이 문서는 퍼블리셔가 elang-camp 프로젝트에서 작업할 때 필요한 정보를 정리한 문서입니다.

---

## 1. 프로젝트 디렉토리 구조

```
src/main/
├── resources/
│   └── static/
│       ├── assets/
│       │   ├── css/                 ← 주요 CSS 파일
│       │   │   ├── admin.css            # 관리자 페이지
│       │   │   ├── public.css           # 공개 페이지 (메인)
│       │   │   └── board.css            # 게시판 전용
│       │   └── js/
│       │       └── quill-editor.js
│       └── uploads/                 ← 업로드된 이미지/파일
│
└── webapp/
    ├── WEB-INF/jsp/
    │   ├── admin/                   ← 관리자 화면 (수정 불필요)
    │   │   ├── common/                  # header, sidebar, footer
    │   │   ├── dashboard/
    │   │   ├── board-posts/
    │   │   ├── content-pages/
    │   │   ├── banners/
    │   │   ├── menus/
    │   │   └── inquiries/
    │   │
    │   └── public/                  ← 공개 화면 (작업 대상)
    │       ├── common/                  # header.jsp, footer.jsp
    │       ├── board/                   # 게시판 컴포넌트
    │       │   ├── board_card.jsp       # 카드형 레이아웃
    │       │   ├── board_list.jsp       # 리스트형 레이아웃
    │       │   └── board_thumb.jsp      # 썸네일형 레이아웃
    │       ├── home.jsp                 # 메인 홈페이지
    │       ├── userContent.jsp          # 콘텐츠 페이지
    │       ├── board-list.jsp           # 게시판 목록
    │       └── board-detail.jsp         # 게시판 상세
    │
    └── resources/                   ← 공용 라이브러리
        ├── css/
        │   ├── modal.css                # 모달 스타일
        │   └── quill-custom.css
        └── js/
            ├── modal.js                 # 모달 스크립트
            └── quill-config.js
```

---

## 2. CSS 파일 가이드

### 파일별 역할

| 파일 | 경로 | 용도 |
|-----|------|-----|
| `public.css` | `/resources/static/assets/css/` | 공개 사이트 전체 스타일 |
| `board.css` | `/resources/static/assets/css/` | 게시판 전용 스타일 |
| `admin.css` | `/resources/static/assets/css/` | 관리자 페이지 (수정 불필요) |
| `modal.css` | `/webapp/resources/css/` | 모달 다이얼로그 공통 |

### CSS 변수 (public.css 상단)

색상이나 스타일을 일괄 변경할 때 `:root` 변수를 수정하세요.

```css
:root {
  /* 주요 색상 */
  --primary: #2563eb;        /* 주 색상 (버튼, 링크) */
  --secondary: #10b981;      /* 보조 색상 */
  --accent: #f59e0b;         /* 강조 색상 */

  /* 그레이 스케일 */
  --gray-900: #111827;       /* 가장 진한 색 (제목) */
  --gray-700: #374151;
  --gray-500: #6b7280;       /* 본문 */
  --gray-300: #d1d5db;       /* 테두리 */
  --gray-100: #f3f4f6;       /* 배경 */
  --gray-50: #f9fafb;

  /* 폰트 */
  --font-main: 'Noto Sans KR', sans-serif;

  /* 그림자 */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
  --shadow-xl: 0 20px 25px rgba(0,0,0,0.1);

  /* 둥글기 */
  --radius-sm: 6px;
  --radius-md: 10px;
  --radius-lg: 16px;
  --radius-xl: 20px;
  --radius-full: 9999px;

  /* 애니메이션 */
  --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
```

### 반응형 브레이크포인트

```css
@media (max-width: 1024px) { /* 태블릿 */ }
@media (max-width: 768px)  { /* 모바일 */ }
@media (max-width: 480px)  { /* 소형 모바일 */ }
```

---

## 3. 공개 사이트 레이아웃 구조

### 전체 레이아웃

```
┌──────────────────────────────────────────────┐
│ Header (position: fixed)                     │
│ - 로고(.site-logo)                           │
│ - 네비게이션(.nav-menu)                      │
│ - 언어전환(.lang-switch)                     │
│ - 모바일 햄버거(.mobile-menu-toggle)         │
├──────────────────────────────────────────────┤
│                                              │
│ Main Content (.main-content)                 │
│ - 각 페이지별 콘텐츠                         │
│                                              │
├──────────────────────────────────────────────┤
│ Footer (.site-footer)                        │
│ - 관리자에서 설정한 커스텀 HTML              │
├──────────────────────────────────────────────┤
│ Floating Buttons (.floating-buttons)         │
│ - 카카오톡, 전화, 상담신청, 맨위로           │
└──────────────────────────────────────────────┘
```

### 주요 JSP 파일

| 파일 | 경로 | 설명 |
|-----|------|-----|
| `header.jsp` | `/jsp/public/common/` | 헤더 + 네비게이션 |
| `footer.jsp` | `/jsp/public/common/` | 푸터 + 플로팅 버튼 |
| `home.jsp` | `/jsp/public/` | 메인 홈페이지 |
| `userContent.jsp` | `/jsp/public/` | 일반 콘텐츠 페이지 |
| `board-list.jsp` | `/jsp/public/` | 게시판 목록 |
| `board-detail.jsp` | `/jsp/public/` | 게시판 상세 |

---

## 4. 주요 HTML 클래스 구조

### 헤더

```html
<header class="site-header" id="siteHeader">
  <div class="header-inner">
    <!-- 로고 -->
    <a href="/" class="site-logo">
      <span class="brand-text">E-LANG</span>
    </a>

    <!-- 네비게이션 -->
    <nav class="site-nav">
      <!-- 모바일 햄버거 버튼 -->
      <button class="mobile-menu-toggle" id="mobileMenuToggle">
        <span></span><span></span><span></span>
      </button>

      <!-- 메뉴 -->
      <ul class="nav-menu" id="navMenu">
        <li class="nav-item">
          <a href="#">1뎁스 메뉴</a>
          <ul class="sub-menu">
            <li><a href="#">2뎁스 메뉴</a></li>
          </ul>
        </li>
        <li class="nav-item lang-switch-item">
          <a href="#" class="lang-switch">ENG</a>
        </li>
      </ul>
    </nav>
  </div>
</header>
```

**헤더 상태 클래스:**
- `.scrolled` - 스크롤 시 헤더 배경색 변경
- `.nav-menu.active` - 모바일 메뉴 열림
- `.mobile-menu-toggle.active` - 햄버거 → X 아이콘

### 플로팅 버튼

```html
<div class="floating-buttons">
  <a href="#" class="floating-btn kakao">카카오톡</a>
  <a href="tel:000" class="floating-btn phone">전화</a>
  <button class="floating-btn inquiry" id="inquiryModalBtn">상담</button>
  <button class="floating-btn top" id="scrollTopBtn">맨위로</button>
</div>
```

### 섹션 구조

```html
<section class="section fade-in">
  <div class="container">
    <div class="section-header">
      <span class="section-label">라벨</span>
      <h2 class="section-title">섹션 제목</h2>
      <p class="section-desc">섹션 설명</p>
    </div>
    <!-- 콘텐츠 -->
  </div>
</section>
```

---

## 5. 게시판 스타일 (board.css)

### 레이아웃 타입

| 타입 | 파일 | 클래스 |
|-----|------|--------|
| 리스트형 | `board_list.jsp` | `.board-table` |
| 카드형 | `board_card.jsp` | `.card-list`, `.card-item` |
| 썸네일형 | `board_thumb.jsp` | `.thumbnail-list`, `.thumbnail-item` |

### 리스트형 (테이블)

```html
<table class="board-table">
  <thead>
    <tr>
      <th>번호</th>
      <th>제목</th>
      <th>작성일</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1</td>
      <td class="text-left">게시글 제목</td>
      <td>2025-01-10</td>
    </tr>
  </tbody>
</table>
```

### 카드형

```html
<div class="card-list">
  <div class="card-item">
    <a href="#" class="card-link">
      <div class="card-thumbnail">
        <img src="/uploads/image.jpg" alt="">
      </div>
      <div class="card-content">
        <h3 class="card-title">제목</h3>
        <p class="card-text">요약 텍스트</p>
        <span class="card-date">2025-01-10</span>
      </div>
    </a>
  </div>
</div>
```

### 썸네일형

```html
<div class="thumbnail-list">
  <div class="thumbnail-item">
    <a href="#">
      <div class="thumbnail-img">
        <img src="/uploads/image.jpg" alt="">
      </div>
      <div class="thumbnail-content">
        <h4>제목</h4>
        <span>2025-01-10</span>
      </div>
    </a>
  </div>
</div>
```

### 검색폼

```html
<div class="search-form-container">
  <form>
    <select name="searchType">
      <option value="title">제목</option>
      <option value="content">내용</option>
    </select>
    <input type="text" name="keyword" placeholder="검색어">
    <button type="submit">검색</button>
  </form>
</div>
```

### 페이지 헤더

```html
<div class="page-header">
  <h1>게시판 제목</h1>
  <p>게시판 설명</p>
</div>
```

---

## 6. 모달/팝업 스타일

### 상담 모달 (inquiry-modal)

```html
<div class="inquiry-modal" id="inquiryModal">
  <div class="inquiry-modal-overlay"></div>
  <div class="inquiry-modal-content">
    <button class="inquiry-modal-close">&times;</button>
    <h3>빠른 상담 신청</h3>
    <p>설명 텍스트</p>
    <form id="modalInquiryForm">
      <div class="form-group">
        <label>이름 *</label>
        <input type="text" name="name" class="form-control" required>
      </div>
      <button type="submit" class="btn btn-primary btn-submit">신청하기</button>
    </form>
  </div>
</div>
```

**모달 상태 클래스:**
- `.inquiry-modal.active` - 모달 열림

### 결과 모달 (result-modal)

```html
<div class="result-modal" id="resultModal">
  <div class="result-modal-overlay"></div>
  <div class="result-modal-content">
    <div class="result-icon success"><!-- SVG 아이콘 --></div>
    <h3>신청 완료</h3>
    <p>메시지 텍스트</p>
    <button class="btn btn-primary">확인</button>
  </div>
</div>
```

**결과 아이콘 클래스:**
- `.result-icon.success` - 성공 (초록색 체크)
- `.result-icon.error` - 실패 (빨간색 X)

### 팝업 배너 (popup-banner)

팝업 배너는 JavaScript로 동적 생성됩니다. CSS에서 `.popup-banner` 클래스로 스타일링 가능.

```css
/* 팝업 배너 모바일 스타일 예시 */
@media (max-width: 768px) {
  .popup-banner {
    max-width: 90vw !important;
  }
}
```

---

## 7. 자주 사용하는 클래스

### 버튼

```html
<button class="btn btn-primary">기본 버튼</button>
<button class="btn btn-secondary">보조 버튼</button>
<button class="btn btn-outline">아웃라인 버튼</button>
<button class="btn btn-danger">삭제 버튼</button>
<button class="btn btn-submit">폼 제출 버튼</button>
```

### 폼 요소

```html
<div class="form-group">
  <label>라벨</label>
  <input type="text" class="form-control" placeholder="입력">
</div>

<textarea class="form-control" rows="4"></textarea>

<select class="form-control">
  <option>옵션 1</option>
</select>
```

### 컨테이너

```html
<!-- 최대 너비 1200px, 가운데 정렬 -->
<div class="container">...</div>

<!-- 섹션 (상하 패딩 적용) -->
<section class="section">...</section>

<!-- 페이드인 애니메이션 -->
<div class="fade-in">...</div>
```

### 그리드

```html
<!-- 프로그램 그리드 (4열) -->
<div class="programs-grid">
  <div class="program-card">...</div>
</div>

<!-- 특징 그리드 (4열) -->
<div class="features-grid">
  <div class="feature-card">...</div>
</div>

<!-- 연락처 그리드 (2열) -->
<div class="contact-grid">
  <div class="contact-info">...</div>
  <div class="inquiry-form-container">...</div>
</div>
```

---

## 8. 다국어 지원

현재 언어는 `${lang}` 변수로 확인합니다. (ko / en)

### JSP에서 사용

```jsp
<%-- 삼항 연산자 (간단한 텍스트) --%>
${lang == 'ko' ? '한국어 텍스트' : 'English Text'}

<%-- 조건문 (긴 텍스트) --%>
<c:choose>
  <c:when test="${lang == 'ko'}">
    한국어 텍스트
  </c:when>
  <c:otherwise>
    English Text
  </c:otherwise>
</c:choose>
```

### URL 구조

```
/{lang}/                    → 홈페이지
/{lang}/page/{pageKey}      → 콘텐츠 페이지
/{lang}/board/{categoryKey} → 게시판 목록
/{lang}/board/{categoryKey}/{id} → 게시판 상세
```

### 언어 전환 링크

```jsp
<a href="${switchLangUrl}" class="lang-switch">
  ${lang == 'ko' ? 'ENG' : 'KOR'}
</a>
```

---

## 9. JSP 변수 레퍼런스

### home.jsp

```jsp
${lang}                    <%-- "ko" 또는 "en" --%>
${switchLangUrl}           <%-- 언어 전환 URL --%>
${layout.headerHtml}       <%-- 커스텀 헤더 HTML --%>
${layout.footerHtml}       <%-- 커스텀 푸터 HTML --%>

<%-- 메뉴 반복 --%>
<c:forEach items="${menus}" var="m">
  ${m.id}                  <%-- 메뉴 ID --%>
  ${m.label}               <%-- 메뉴 이름 --%>
  ${m.href}                <%-- 메뉴 링크 --%>
  ${m.parentId}            <%-- 부모 메뉴 ID (2뎁스인 경우) --%>
</c:forEach>

<%-- 배너 카테고리별 반복 --%>
<c:forEach items="${bannerCategories}" var="category">
  ${category.categoryKey}  <%-- top_banner, popup_banner 등 --%>
  ${category.name}         <%-- 카테고리 이름 --%>
  ${category.description}  <%-- 카테고리 설명 --%>

  <%-- 해당 카테고리의 배너들 --%>
  <c:set var="banners" value="${bannersByCategory[category.categoryKey]}"/>
  <c:forEach items="${banners}" var="b">
    ${b.title}             <%-- 배너 제목 --%>
    ${b.url}               <%-- 이미지/영상 URL --%>
    ${b.linkUrl}           <%-- 클릭 시 이동 URL --%>
    ${b.type.name()}       <%-- IMAGE, YOUTUBE, VIDEO --%>
  </c:forEach>
</c:forEach>
```

### board-list.jsp

```jsp
${category.name}           <%-- 게시판 이름 --%>
${category.description}    <%-- 게시판 설명 --%>
${category.displayType}    <%-- LIST, CARD, THUMBNAIL --%>

<%-- 게시글 반복 --%>
<c:forEach items="${posts.content}" var="post">
  ${post.id}               <%-- 게시글 ID --%>
  ${post.title}            <%-- 제목 --%>
  ${post.summary}          <%-- 요약 --%>
  ${post.thumbnailUrl}     <%-- 썸네일 URL --%>
  ${post.viewCount}        <%-- 조회수 --%>
  ${post.createdAt}        <%-- 작성일 --%>
</c:forEach>

<%-- 페이지네이션 --%>
${posts.number}            <%-- 현재 페이지 (0부터 시작) --%>
${posts.totalPages}        <%-- 전체 페이지 수 --%>
${posts.totalElements}     <%-- 전체 게시글 수 --%>
```

### board-detail.jsp

```jsp
${post.title}              <%-- 제목 --%>
${post.content}            <%-- 본문 HTML --%>
${post.viewCount}          <%-- 조회수 --%>
${post.createdAt}          <%-- 작성일 --%>
${post.thumbnailUrl}       <%-- 썸네일 (선택) --%>
```

---

## 10. 이미지/파일 경로

### 업로드 파일 참조

```html
<!-- 업로드된 이미지 -->
<img src="/uploads/파일명.jpg" alt="">

<!-- CSS 배경 이미지 -->
<div style="background-image: url('/uploads/파일명.jpg')"></div>
```

### 이미지 Lazy Loading

```html
<img src="/uploads/image.jpg" alt="" loading="lazy">
```

---

## 11. 개발 환경

### 로컬 서버 실행

```bash
cd ~/projects/elang
mvn spring-boot:run
```

### 접속 URL

- 한국어: http://localhost:8081/ko
- 영어: http://localhost:8081/en
- 관리자: http://localhost:8081/admin

### 파일 수정 후 확인

| 파일 유형 | 확인 방법 |
|---------|----------|
| JSP | 브라우저 새로고침 (F5) |
| CSS/JS | 강제 새로고침 (Ctrl+Shift+R) |

---

## 12. 배포 전 체크리스트

### 반응형 테스트

- [ ] 1024px (태블릿)
- [ ] 768px (모바일)
- [ ] 480px (소형 모바일)

### 브라우저 테스트

- [ ] Chrome
- [ ] Safari
- [ ] Firefox
- [ ] Edge

### 기능 테스트

- [ ] 모바일 메뉴 동작
- [ ] 팝업 배너 표시
- [ ] 상담 모달 동작
- [ ] 언어 전환

---

## 문의

작업 중 궁금한 사항은 개발팀에 문의해주세요.
