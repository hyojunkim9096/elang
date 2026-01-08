# Windows PC 설치 가이드

이 문서는 Windows PC에서 elang-camp 프로젝트를 설정하고 실행하는 방법을 안내합니다.

## 1. 사전 요구사항

### 1.1 Java 17 설치

1. **다운로드**: https://adoptium.net/temurin/releases/
   - Version: **17 (LTS)**
   - Operating System: **Windows**
   - Architecture: **x64**
   - Package Type: **JDK**
   - Download `.msi` 파일

2. **설치**:
   - 다운로드한 `.msi` 파일 실행
   - **"Set JAVA_HOME variable"** 옵션 체크 ✅
   - **"Add to PATH"** 옵션 체크 ✅
   - 설치 완료

3. **확인**:
   ```cmd
   java -version
   ```
   출력 예시:
   ```
   openjdk version "17.0.x" 2024-xx-xx
   ```

### 1.2 Maven 설치

1. **다운로드**: https://maven.apache.org/download.cgi
   - `apache-maven-3.9.x-bin.zip` 다운로드

2. **설치**:
   - ZIP 파일을 `C:\Program Files\Apache\maven` 에 압축 해제
   - 환경 변수 설정:
     - **시스템 변수**에 `MAVEN_HOME` 추가:
       ```
       C:\Program Files\Apache\maven
       ```
     - **Path** 변수에 추가:
       ```
       %MAVEN_HOME%\bin
       ```

3. **확인**:
   ```cmd
   mvn -version
   ```
   출력 예시:
   ```
   Apache Maven 3.9.x
   ```

### 1.3 MariaDB 설치

1. **다운로드**: https://mariadb.org/download/
   - Version: **10.11** (Stable)
   - OS: **Windows**
   - Download `.msi` 파일

2. **설치**:
   - `.msi` 파일 실행
   - **Root Password** 설정: `root1234` (원하는 비밀번호)
   - **UTF8 지원** 옵션 체크 ✅
   - Port: `3306` (기본값)

3. **설치 확인**:
   - 시작 메뉴에서 "HeidiSQL" 실행
   - 또는 CMD에서:
     ```cmd
     mysql -u root -p
     ```

### 1.4 Git 설치 (선택사항)

1. **다운로드**: https://git-scm.com/download/win
2. **설치**: 기본 옵션으로 설치

## 2. 프로젝트 설정

### 2.1 프로젝트 다운로드

#### 방법 1: Git 사용
```cmd
cd C:\workspace
git clone <repository-url> elang-camp
cd elang-camp
```

#### 방법 2: ZIP 파일
1. 프로젝트 ZIP 파일 다운로드
2. `C:\workspace\elang-camp` 에 압축 해제

### 2.2 데이터베이스 초기화

1. **HeidiSQL 실행** (또는 MySQL Workbench)

2. **Root로 접속**
   - Host: `localhost`
   - User: `root`
   - Password: 설치 시 설정한 비밀번호

3. **SQL 실행**:
   - `scripts/local-db-init.sql` 파일 열기
   - 전체 실행 (F9)

4. **접속 테스트**:
   - User: `elang`
   - Password: `elang1234`
   - Database: `elang_camp`

### 2.3 설정 파일 확인

`src/main/resources/application-local.yml` 확인:
```yaml
server:
  port: 8081

spring:
  datasource:
    url: jdbc:mariadb://localhost:3306/elang_camp?useUnicode=true&characterEncoding=utf8mb4&serverTimezone=Asia/Seoul
    username: elang
    password: elang1234
```

## 3. 실행

### 3.1 로컬 실행

```cmd
cd C:\workspace\elang-camp
mvn clean compile
mvn spring-boot:run
```

서버 시작 완료 메시지:
```
Started ElangCampApplication in X.XXX seconds
Tomcat started on port 8081
```

### 3.2 접속 확인

브라우저에서 아래 URL 접속:

- **공개 페이지 (한국어)**: http://localhost:8081/ko
- **공개 페이지 (영어)**: http://localhost:8081/en
- **로그인**: http://localhost:8081/login
  - 아이디: `admin`
  - 비밀번호: `admin1234`
- **관리자**: http://localhost:8081/admin

## 4. WAR 빌드 (배포용)

```cmd
mvn clean package -DskipTests
```

생성 위치: `target/elang-camp-0.0.1-SNAPSHOT.war`

## 5. 트러블슈팅

### 5.1 Port 8081이 이미 사용 중

**증상**:
```
Port 8081 was already in use
```

**해결**:
1. CMD를 **관리자 권한**으로 실행
2. 실행 중인 프로세스 찾기:
   ```cmd
   netstat -ano | findstr :8081
   ```
3. PID 확인 후 종료:
   ```cmd
   taskkill /PID <PID번호> /F
   ```

### 5.2 MariaDB 접속 실패

**증상**:
```
Access denied for user 'elang'@'localhost'
```

**해결**:
1. HeidiSQL에서 Root로 접속
2. 다시 `scripts/local-db-init.sql` 실행
3. 확인:
   ```sql
   SELECT user, host FROM mysql.user WHERE user='elang';
   ```

### 5.3 Java 버전 오류

**증상**:
```
java.lang.UnsupportedClassVersionError
```

**해결**:
1. Java 버전 확인:
   ```cmd
   java -version
   ```
2. Java 17이 아니면 재설치
3. 환경 변수 `JAVA_HOME` 확인

### 5.4 Maven 빌드 실패

**증상**:
```
Failed to execute goal ... compilation failure
```

**해결**:
```cmd
mvn clean install -U
```

## 6. IDE 설정 (IntelliJ IDEA)

### 6.1 프로젝트 열기
1. IntelliJ IDEA 실행
2. **Open** → `C:\workspace\elang-camp` 선택
3. Maven 프로젝트로 자동 인식

### 6.2 JDK 설정
1. **File** → **Project Structure** (Ctrl+Alt+Shift+S)
2. **Project SDK**: Java 17 선택
3. **Project language level**: 17

### 6.3 실행 설정
1. **Run** → **Edit Configurations**
2. **+** → **Spring Boot**
3. Main class: `com.elang.camp.ElangCampApplication`
4. Active profiles: `local`

### 6.4 Lombok 플러그인
1. **File** → **Settings** → **Plugins**
2. "Lombok" 검색 → 설치
3. **File** → **Settings** → **Build** → **Compiler** → **Annotation Processors**
4. **Enable annotation processing** 체크 ✅

## 7. 개발 워크플로우

### 7.1 코드 수정 후 재시작
```cmd
Ctrl+C (서버 종료)
mvn spring-boot:run
```

### 7.2 JSP 수정
- JSP 파일 수정 후 **새로고침**만 하면 바로 반영됨
- 서버 재시작 불필요

### 7.3 CSS/JS 수정
- `src/main/resources/static/assets/` 파일 수정
- **Ctrl+F5** (강제 새로고침)

## 8. 디렉토리 구조

```
elang-camp/
├── src/
│   ├── main/
│   │   ├── java/              # Java 소스 코드
│   │   ├── resources/
│   │   │   ├── application.yml          # 기본 설정
│   │   │   ├── application-local.yml    # 로컬 설정
│   │   │   ├── static/
│   │   │   │   └── assets/              # CSS, JS 파일
│   │   │   └── db/migration/            # DB 마이그레이션
│   │   └── webapp/
│   │       └── WEB-INF/jsp/             # JSP 파일
│   └── test/                  # 테스트 코드
├── scripts/                   # DB 초기화 스크립트
├── pom.xml                    # Maven 설정
└── README.md                  # 프로젝트 설명
```

## 9. 연락처

문제 발생 시:
- 개발자에게 문의
- 에러 로그 전체 복사해서 전달
