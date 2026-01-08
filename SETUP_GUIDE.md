# 영어캠프 홈페이지 CMS - 설정 가이드

## 구현된 기능

### 1. 관리자 기능
- **컨텐츠 페이지 관리** (`/admin/content-pages`)
  - Quill WYSIWYG 에디터로 HTML 컨텐츠 작성
  - 언어별(ko/en) 페이지 관리
  - pageKey로 페이지 식별 (예: about, program)

- **게시판 카테고리 관리** (`/admin/board-categories`)
  - 3가지 표시 형식: LIST(리스트형), CARD(카드형), THUMBNAIL(썸네일형)
  - 언어별 카테고리 생성
  - 정렬 순서 및 활성화 관리

- **게시글 관리** (`/admin/board-posts`)
  - Quill 에디터로 게시글 작성
  - 썸네일 이미지 URL 지정
  - 상단 고정(pin) 기능
  - 조회수 자동 증가

- **메뉴 관리** (기존 기능에 menuType 추가)
  - menuType: `public`(사용자 메뉴), `admin`(관리자 메뉴)

- **레이아웃/배너 관리** (기존 기능)

### 2. 사용자 페이지
- **컨텐츠 페이지**: `/{lang}/page/{pageKey}`
  - 예: `/ko/page/about`, `/en/page/program`
  - DB에 저장된 HTML 컨텐츠를 그대로 렌더링

- **게시판 목록**: `/{lang}/board/{categoryKey}`
  - 예: `/ko/board/notice`, `/en/board/news`
  - 카테고리의 displayType에 따라 LIST/CARD/THUMBNAIL 형식으로 표시

- **게시글 상세**: `/{lang}/board/{categoryKey}/{postId}`
  - 조회수 자동 증가
  - 목록으로 돌아가기 버튼

## 데이터베이스 마이그레이션

새로운 테이블이 추가되었습니다:
- `content_page`: 컨텐츠 페이지
- `board_category`: 게시판 카테고리
- `board_post`: 게시글
- `site_menu`에 `menu_type` 컬럼 추가

마이그레이션 파일: `V3__add_cms_tables.sql`

## 실행 방법

### 1. DB 초기화 (최초 1회)
```bash
mariadb -u "$(whoami)" < scripts/local-db-init.sql
```

### 2. 애플리케이션 실행
```bash
mvn clean spring-boot:run
```

Flyway가 자동으로 V3 마이그레이션을 적용합니다.

### 3. 접속
- 관리자: http://localhost:8081/admin
  - ID: `admin` / PW: `admin1234`

- 사용자 페이지: http://localhost:8081/ko 또는 http://localhost:8081/en

## 사용 예시

### 1. 컨텐츠 페이지 만들기
1. `/admin/content-pages` 접속
2. "새 페이지 생성" 클릭
3. 정보 입력:
   - 언어: `ko`
   - 페이지 키: `about`
   - 제목: `소개`
   - 컨텐츠: Quill 에디터로 HTML 작성
4. 저장
5. 사용자 페이지에서 확인: `/ko/page/about`

### 2. 게시판 만들기
1. `/admin/board-categories` 접속
2. "새 카테고리 추가" 클릭
3. 정보 입력:
   - 언어: `ko`
   - 카테고리 키: `notice`
   - 이름: `공지사항`
   - 표시형식: `list` (또는 `card`, `thumbnail`)
4. 저장
5. "게시글관리" 버튼 클릭하여 게시글 작성
6. 사용자 페이지에서 확인: `/ko/board/notice`

### 3. 메뉴에 연결하기
1. `/admin` 메뉴 관리 섹션
2. "추가" 버튼
3. 정보 입력:
   - Lang: `ko`
   - MenuType: `public`
   - Label: `공지사항`
   - Href: `/ko/board/notice`
4. 저장

## 카페24 배포

### WAR 파일 생성
```bash
mvn clean package -DskipTests
```

생성된 파일: `target/elang-camp-0.0.1-SNAPSHOT.war`

### 카페24 업로드
1. 카페24 호스팅에 MariaDB 생성
2. DB 연결 정보를 `application-prod.yml`에 설정
3. WAR 파일을 Tomcat webapps에 업로드
4. 자동으로 Flyway 마이그레이션 실행됨

## 기술 스택
- Spring Boot 3.3.6
- Java 17
- MariaDB
- Flyway (DB 마이그레이션)
- JSP + JSTL
- Quill.js (WYSIWYG 에디터)
- jQuery

## 주의사항
1. **Quill 에디터**: CDN 방식으로 로드되므로 인터넷 연결 필요
2. **XSS 주의**: 컨텐츠는 HTML 그대로 렌더링되므로 신뢰할 수 있는 관리자만 접근해야 함
3. **이미지 업로드**: 현재는 이미지 URL을 직접 입력하는 방식 (추후 파일 업로드 기능 추가 가능)
4. **메뉴 타입**: `public`은 사용자 페이지 메뉴, `admin`은 관리자 전용 메뉴
