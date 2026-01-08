# 퍼블리셔 작업 가이드

이 문서는 퍼블리셔가 elang-camp 프로젝트에서 작업할 내용을 안내합니다.

## 📌 작업 범위

### 작업 대상
- ✅ **공개 페이지** (사용자가 보는 프론트엔드)
  - 한국어 페이지: `/ko`
  - 영어 페이지: `/en`
  - 컨텐츠 페이지: `/{lang}/page/{pageKey}`
  - 게시판: `/{lang}/board/{categoryKey}`

### 작업 제외
- ❌ **관리자 페이지** (`/admin/**`)
  - 이미 완성되어 있음
  - 수정 불필요

## 🎨 작업 파일 위치

### 1. JSP 템플릿 (HTML 구조)

```
src/main/webapp/WEB-INF/jsp/public/
├── home.jsp              # 메인 홈페이지 (ko/en)
├── userContent.jsp       # 컨텐츠 페이지
├── board-list.jsp        # 게시판 목록
└── board-detail.jsp      # 게시글 상세
```

### 2. CSS 스타일

```
src/main/resources/static/assets/css/
└── public.css           # 공개 페이지 스타일시트
```

### 3. JavaScript

```
src/main/resources/static/assets/js/
└── public.js            # 공개 페이지 스크립트 (필요시 생성)
```

### 4. 이미지 및 리소스

```
src/main/resources/static/assets/
├── images/              # 이미지 파일
├── fonts/               # 웹폰트
└── favicon.ico          # 파비콘
```

## 📋 작업 내용

### Phase 1: 레이아웃 & 디자인

#### 1.1 전체 레이아웃
- [ ] 반응형 레이아웃 구현 (Mobile, Tablet, Desktop)
- [ ] 헤더 (Header) 디자인
- [ ] 푸터 (Footer) 디자인
- [ ] 네비게이션 메뉴 스타일링
- [ ] 언어 전환 버튼 디자인

#### 1.2 타이포그래피
- [ ] 웹폰트 선정 및 적용
- [ ] 제목 (H1~H6) 스타일
- [ ] 본문 텍스트 스타일
- [ ] 링크 스타일

#### 1.3 컬러 시스템
- [ ] Primary Color 정의
- [ ] Secondary Color 정의
- [ ] Background Colors
- [ ] Text Colors
- [ ] Border & Divider Colors

### Phase 2: 컴포넌트 개발

#### 2.1 홈페이지 (`home.jsp`)
- [ ] Hero Section (메인 배너)
  - 이미지 배너 슬라이더
  - YouTube 영상 배너
  - CTA 버튼
- [ ] 섹션 레이아웃
- [ ] 카드 디자인
- [ ] 버튼 스타일

#### 2.2 컨텐츠 페이지 (`userContent.jsp`)
- [ ] 제목 영역
- [ ] 본문 영역 (위지윅 에디터 출력 스타일)
- [ ] 이미지/비디오 삽입 스타일
- [ ] 목차 (TOC) 스타일 (필요시)

#### 2.3 게시판 목록 (`board-list.jsp`)
- [ ] 게시판 헤더 (카테고리명, 설명)
- [ ] 목록 레이아웃
  - List 형식
  - Grid/Card 형식
  - Gallery 형식
- [ ] 썸네일 이미지 처리
- [ ] 페이지네이션 스타일
- [ ] 검색 폼

#### 2.4 게시글 상세 (`board-detail.jsp`)
- [ ] 제목 & 메타 정보 (작성일, 조회수)
- [ ] 본문 영역
- [ ] 이전글/다음글 네비게이션
- [ ] 목록으로 버튼
- [ ] 공유 버튼 (SNS)

### Phase 3: 인터랙션

#### 3.1 애니메이션
- [ ] 페이지 로드 애니메이션
- [ ] 스크롤 애니메이션
- [ ] 호버 효과
- [ ] 트랜지션 효과

#### 3.2 사용성
- [ ] 모바일 메뉴 (햄버거 메뉴)
- [ ] 스크롤 탑 버튼
- [ ] 이미지 라이트박스
- [ ] 로딩 인디케이터

## 🔧 개발 환경

### 로컬 서버 실행

```bash
# Windows
cd C:\workspace\elang-camp
mvn spring-boot:run

# Mac/Linux
cd ~/projects/elang-camp
mvn spring-boot:run
```

### 접속 URL
- 한국어 홈: http://localhost:8081/ko
- 영어 홈: http://localhost:8081/en

### 실시간 수정 확인

#### JSP 파일 수정 시
- 파일 저장 → **브라우저 새로고침 (F5)**
- 서버 재시작 불필요

#### CSS/JS 파일 수정 시
- 파일 저장 → **강제 새로고침 (Ctrl+F5)**
- 캐시 무시하고 새로고침

## 📊 현재 데이터 구조

### 메뉴 (SiteMenu)
```javascript
{
  id: 1,
  lang: "ko",
  label: "프로그램",      // 메뉴명
  href: "#program",       // 링크
  sortOrder: 0,           // 정렬 순서
  enabled: true           // 활성화 여부
}
```

### 배너 (SiteBanner)
```javascript
{
  id: 1,
  lang: "ko",
  title: "배너 제목",
  type: "IMAGE",          // IMAGE or YOUTUBE
  imageUrl: "/assets/images/banner1.jpg",
  youtubeUrl: null,
  linkUrl: "/ko/page/about",
  sortOrder: 0,
  enabled: true
}
```

### 레이아웃 (SiteLayout)
```javascript
{
  lang: "ko",
  headerHtml: "<div>헤더 HTML</div>",
  footerHtml: "<div>푸터 HTML</div>"
}
```

## 🎯 JSP 변수 사용법

### home.jsp

```jsp
<!-- 언어 코드 -->
${lang}  <!-- "ko" 또는 "en" -->

<!-- 레이아웃 -->
${layout.headerHtml}
${layout.footerHtml}

<!-- 메뉴 목록 -->
<c:forEach items="${menus}" var="menu">
  <a href="${menu.href}">${menu.label}</a>
</c:forEach>

<!-- 배너 목록 -->
<c:forEach items="${banners}" var="banner">
  <c:if test="${banner.type == 'IMAGE'}">
    <img src="${banner.imageUrl}" alt="${banner.title}">
  </c:if>
  <c:if test="${banner.type == 'YOUTUBE'}">
    <iframe src="${banner.youtubeUrl}"></iframe>
  </c:if>
</c:forEach>

<!-- 언어 전환 링크 -->
<a href="${switchLangUrl}">
  <c:if test="${lang == 'ko'}">ENG</c:if>
  <c:if test="${lang == 'en'}">한국어</c:if>
</a>
```

### board-list.jsp

```jsp
<!-- 카테고리 정보 -->
${categoryName}          <!-- 카테고리명 -->
${categoryDescription}   <!-- 카테고리 설명 -->
${displayType}          <!-- LIST, GRID, GALLERY -->

<!-- 게시글 목록 -->
<c:forEach items="${posts}" var="post">
  <div class="post-item">
    <c:if test="${not empty post.thumbnail}">
      <img src="${post.thumbnail}" alt="${post.title}">
    </c:if>
    <h3>${post.title}</h3>
    <p>조회수: ${post.viewCount}</p>
    <p>${post.publishedAt}</p>
  </div>
</c:forEach>
```

### board-detail.jsp

```jsp
<!-- 게시글 정보 -->
${post.title}            <!-- 제목 -->
${post.content}          <!-- 본문 (HTML) -->
${post.viewCount}        <!-- 조회수 -->
${post.publishedAt}      <!-- 작성일 -->
${post.thumbnail}        <!-- 썸네일 (선택) -->
```

## 📐 반응형 브레이크포인트 (권장)

```css
/* Mobile First */
/* Default: 320px ~ 767px */

/* Tablet */
@media (min-width: 768px) { }

/* Desktop */
@media (min-width: 1024px) { }

/* Large Desktop */
@media (min-width: 1280px) { }
```

## 🌐 브라우저 지원

### 지원 브라우저
- ✅ Chrome (최신 2버전)
- ✅ Firefox (최신 2버전)
- ✅ Safari (최신 2버전)
- ✅ Edge (최신 2버전)
- ⚠️ IE11 (기본 레이아웃만 지원, 애니메이션 제외)

## 📦 외부 라이브러리 사용

### 이미 포함된 라이브러리
- ✅ **jQuery 3.7.1** (전역 사용 가능)

### 추가 가능한 라이브러리 (선택)
- Swiper.js (배너 슬라이더)
- AOS (스크롤 애니메이션)
- Lightbox (이미지 팝업)

### 추가 방법

#### CDN 추가 (JSP에 직접)
```jsp
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
```

#### 로컬 파일 추가
```
src/main/resources/static/assets/
├── css/
│   └── vendor/
│       └── swiper.min.css
└── js/
    └── vendor/
        └── swiper.min.js
```

## 🚀 배포 전 체크리스트

### 퍼포먼스
- [ ] 이미지 최적화 (WebP, 압축)
- [ ] CSS Minify
- [ ] JS Minify
- [ ] 불필요한 리소스 제거

### 크로스 브라우저
- [ ] Chrome 테스트
- [ ] Firefox 테스트
- [ ] Safari 테스트 (Mac)
- [ ] Edge 테스트

### 반응형
- [ ] Mobile (320px~767px) 테스트
- [ ] Tablet (768px~1023px) 테스트
- [ ] Desktop (1024px+) 테스트

### 접근성
- [ ] Alt 텍스트 추가
- [ ] Semantic HTML 사용
- [ ] Keyboard Navigation 지원
- [ ] 색상 대비 확인

## 📞 문의

작업 중 궁금한 사항은:
- 백엔드 개발자에게 슬랙/이메일로 문의
- API 엔드포인트 관련 문의는 `README.md` 참고
