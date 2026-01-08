# elang-camp

Spring Boot 3 + JSP 기반의 **영어캠프 홈페이지 + 관리자 CMS** 프로젝트입니다.

## 📋 목차
- [기술 스택](#-기술-스택)
- [사전 준비](#-사전-준비)
- [프로젝트 구조](#-프로젝트-구조)
- [로컬 환경 설정](#-로컬-환경-설정)
  - [Mac 환경](#1-mac-환경)
  - [Windows 환경](#2-windows-환경)
- [IDE 설정](#-ide-설정)
  - [Eclipse 설정](#eclipse-설정)
  - [IntelliJ IDEA 설정](#intellij-idea-설정)
- [실행 방법](#-실행-방법)
- [배포](#-배포)

---

## 🛠 기술 스택

- **Backend**: Spring Boot 3.3.6, Java 17
- **View**: JSP, JSTL
- **Database**: MariaDB
- **Migration**: Flyway
- **Build Tool**: Maven
- **Server**: Embedded Tomcat

---

## 📦 사전 준비

### 공통
- Java 17 이상
- Maven 3.6 이상
- MariaDB 10.5 이상
- Git

### IDE (선택)
- Eclipse IDE for Enterprise Java Developers
- 또는 IntelliJ IDEA Ultimate

---

## 📁 프로젝트 구조

```
elang/
├── src/main/
│   ├── java/com/elang/camp/
│   │   ├── config/          # 설정
│   │   ├── domain/          # 도메인 (엔티티, 리포지토리, 서비스)
│   │   └── web/             # 컨트롤러
│   ├── resources/
│   │   ├── application.yml           # 기본 설정
│   │   ├── application-local.yml     # 로컬 환경
│   │   ├── application-prod.yml      # 운영 환경
│   │   └── db/migration/             # Flyway 마이그레이션
│   └── webapp/
│       ├── assets/          # CSS, JS, 이미지
│       └── WEB-INF/jsp/     # JSP 파일
│           ├── admin/       # 관리자 페이지
│           └── public/      # 사용자 페이지
└── scripts/                 # DB 초기화 스크립트
```

### Admin 페이지 구조
```
admin/
├── common/                  # 공통 레이아웃 (header, sidebar, footer)
├── dashboard/               # 대시보드
├── layout/                  # 레이아웃 관리
├── menus/                   # 메뉴 관리
├── banners/                 # 배너 관리
├── content-pages/           # 컨텐츠 페이지 관리
├── board-categories/        # 게시판 카테고리 관리
└── board-posts/             # 게시글 관리
```

---

## 🚀 로컬 환경 설정

### 1. Mac 환경

#### 1-1. MariaDB 설치
```bash
# Homebrew로 MariaDB 설치
brew install mariadb

# MariaDB 시작
brew services start mariadb
```

#### 1-2. 데이터베이스 초기화
```bash
# 프로젝트 디렉토리로 이동
cd /path/to/elang

# DB 생성 및 사용자 생성 (현재 Mac 사용자 계정으로 실행)
mariadb -u "$(whoami)" < scripts/local-db-init.sql

# 접속 테스트
mariadb -u elang -pelang1234 -e "USE elang_camp; SELECT 1;"
```

> **참고**: Homebrew MariaDB는 현재 Mac 사용자로 비밀번호 없이 접속 가능합니다.

---

### 2. Windows 환경

#### 2-1. MariaDB 설치
1. [MariaDB 다운로드](https://mariadb.org/download/)에서 Windows용 설치 파일 다운로드
2. 설치 중 root 비밀번호 설정 (예: `root1234`)
3. 서비스로 설치 체크

#### 2-2. 데이터베이스 초기화

**방법 1: HeidiSQL 또는 MySQL Workbench 사용**
1. HeidiSQL 실행
2. `scripts/local-db-init.sql` 파일 열기
3. F9 키로 실행

**방법 2: 명령 프롬프트 사용**
```cmd
# 프로젝트 디렉토리로 이동
cd C:\projects\elang

# DB 생성 (root 계정으로)
mysql -u root -p < scripts\local-db-init.sql
```

비밀번호 입력 후 엔터

#### 2-3. 접속 테스트
```cmd
mysql -u elang -pelang1234 -e "USE elang_camp; SELECT 1;"
```

---

## 💻 IDE 설정

### Eclipse 설정

#### 1. 프로젝트 Import
1. Eclipse 실행
2. `File` → `Import` → `Maven` → `Existing Maven Projects`
3. 프로젝트 폴더 선택 후 Import

#### 2. Tomcat 서버 추가 (선택사항)
Spring Boot는 Embedded Tomcat을 사용하므로 별도 설정 불필요합니다.

#### 3. JSP 파일 인코딩 설정
1. `Window` → `Preferences`
2. `General` → `Workspace` → `Text file encoding` → `UTF-8` 선택
3. `Web` → `JSP Files` → `Encoding` → `UTF-8` 선택

#### 4. 실행 설정
1. 프로젝트 우클릭 → `Run As` → `Run Configurations`
2. `Java Application` 생성
3. Main class: `com.elang.camp.ElangCampApplication`
4. Program arguments: `--spring.profiles.active=local`
5. Apply → Run

---

### IntelliJ IDEA 설정

#### 1. 프로젝트 Open
1. IntelliJ IDEA 실행
2. `Open` → 프로젝트 폴더 선택
3. Maven 프로젝트로 인식되어 자동으로 import

#### 2. 실행 설정
1. `Run` → `Edit Configurations`
2. `+` → `Spring Boot` 추가
3. Main class: `com.elang.camp.ElangCampApplication`
4. Active profiles: `local`
5. OK → Run

---

## ▶️ 실행 방법

### Maven으로 실행 (공통)
```bash
# 프로젝트 디렉토리에서
mvn spring-boot:run

# 또는 프로필 지정
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

### 실행 후 접속
- **사용자 페이지** (한글): http://localhost:8081/ko
- **사용자 페이지** (영문): http://localhost:8081/en
- **관리자 페이지**: http://localhost:8081/admin
  - ID: `admin`
  - PW: `admin1234`

---

## 🏗 빌드 및 배포

### WAR 파일 생성
```bash
mvn clean package -DskipTests
```

생성 위치: `target/elang-camp.war`

### 운영 환경 배포
```bash
# 운영 프로필로 실행
java -jar target/elang-camp.war --spring.profiles.active=prod
```

**운영 환경 변수 설정** (application-prod.yml):
```bash
export ELANG_DB_URL=jdbc:mariadb://your-db-host:3306/elang_camp?useUnicode=true&characterEncoding=utf8mb4&serverTimezone=Asia/Seoul&tinyInt1isBit=false
export ELANG_DB_USERNAME=your_username
export ELANG_DB_PASSWORD=your_password
export ELANG_ADMIN_USERNAME=admin
export ELANG_ADMIN_PASSWORD=secure_password
```

---

## 🗃 데이터베이스 관리

### Flyway Migration
- 자동으로 실행됩니다 (`spring.flyway.enabled=true`)
- Migration 파일 위치: `src/main/resources/db/migration/`
- 파일명 규칙: `V{버전}__{설명}.sql` (예: `V1__init.sql`)

**포함되는 것:**
- ✅ 테이블 구조 (자동 생성)
- ✅ 기본 샘플 데이터 (V2__seed_defaults.sql)

**포함되지 않는 것:**
- ❌ 관리자가 추가한 메뉴, 배너, 게시글 등

### 데이터 백업 및 복원

#### 데이터 Export (현재 PC에서)
```bash
# Mac/Linux
./scripts/export-data.sh

# Windows
scripts\export-data.bat
```

생성되는 파일: `data-backup.sql`

#### 데이터 Import (새 PC에서)
```bash
# 1. 프로젝트 clone 후 DB 초기화
git clone https://github.com/your-repo/elang.git
cd elang
mariadb -u elang -pelang1234 < scripts/local-db-init.sql

# 2. 프로젝트 한 번 실행 (Flyway로 테이블 생성)
mvn spring-boot:run
# Ctrl+C로 종료

# 3. 데이터 복원
mariadb -u elang -pelang1234 elang_camp < data-backup.sql
```

**Windows에서:**
```cmd
mysql -u elang -pelang1234 elang_camp < data-backup.sql
```

### DB 초기화 (전체 삭제 후 재생성)
```bash
# Mac
mariadb -u "$(whoami)" < scripts/local-db-reset.sql

# Windows
mysql -u root -p < scripts\local-db-reset.sql
```

---

## 🔧 문제 해결

### 1. DB 접속 오류
- MariaDB 서비스가 실행 중인지 확인
  ```bash
  # Mac
  brew services list

  # Windows
  services.msc 실행 후 "MariaDB" 확인
  ```

### 2. Port 8081이 이미 사용중
- `application-local.yml`에서 포트 변경:
  ```yaml
  server:
    port: 9090  # 원하는 포트로 변경
  ```

### 3. JSP 파일이 렌더링되지 않음
- `pom.xml`의 `tomcat-embed-jasper` 의존성 확인
- `application.yml`의 JSP 설정 확인:
  ```yaml
  spring:
    mvc:
      view:
        prefix: /WEB-INF/jsp/
        suffix: .jsp
  ```

### 4. Boolean 타입 오류 (Cannot convert Boolean to Long)
- JDBC URL에 `tinyInt1isBit=false` 파라미터가 있는지 확인

---

## 📝 주요 기능

### 관리자 기능
- ✅ 레이아웃 관리 (Header/Footer HTML 편집)
- ✅ 메뉴 관리 (다국어, 계층 구조 지원)
- ✅ 배너 관리 (이미지/YouTube 지원)
- ✅ 컨텐츠 페이지 관리
- ✅ 게시판 카테고리 관리
- ✅ 게시글 관리 (CKEditor 에디터)

### 사용자 기능
- ✅ 다국어 지원 (한국어/영어)
- ✅ 반응형 디자인
- ✅ 동적 메뉴
- ✅ 게시판

---

## 📄 라이선스

이 프로젝트는 비공개 프로젝트입니다.

---

## 👤 Contact

문의사항이 있으시면 프로젝트 관리자에게 연락해주세요.
