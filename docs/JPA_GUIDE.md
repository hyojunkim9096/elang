# JPA Repository 패턴 가이드

> Spring Data JPA를 사용한 데이터베이스 CRUD 작업 완벽 가이드

## 목차
1. [기본 개념](#기본-개념)
2. [조회 (SELECT)](#조회-select)
3. [삽입 (INSERT)](#삽입-insert)
4. [수정 (UPDATE)](#수정-update)
5. [삭제 (DELETE)](#삭제-delete)
6. [실전 예시](#실전-예시)
7. [주의사항](#주의사항)

---

## 기본 개념

### JPA Repository란?
- Spring Data JPA가 제공하는 인터페이스
- **메서드 이름만으로 SQL 쿼리 자동 생성**
- XML 설정 없이 Java 코드만으로 데이터베이스 작업 가능

### Repository 생성 방법
```java
// 1. JpaRepository 인터페이스 상속
// 2. <Entity 클래스, ID 타입> 제네릭 지정
public interface SiteMenuRepository extends JpaRepository<SiteMenu, Long> {
    // 메서드만 선언하면 구현은 Spring이 자동으로!
}
```

### 기본 제공 메서드 (상속받으면 자동 사용 가능)
```java
// 조회
Optional<Entity> findById(Long id);
List<Entity> findAll();
boolean existsById(Long id);
long count();

// 저장/수정
Entity save(Entity entity);
List<Entity> saveAll(Iterable<Entity> entities);

// 삭제
void deleteById(Long id);
void delete(Entity entity);
void deleteAll();
```

---

## 조회 (SELECT)

### 1. 단순 조회

```java
// ✅ 단일 필드로 조회
List<SiteMenu> findByLang(String lang);
// 생성 쿼리: SELECT * FROM site_menu WHERE lang = ?

// ✅ 여러 필드로 조회 (AND 조건)
List<SiteMenu> findByLangAndMenuType(String lang, String menuType);
// 생성 쿼리: SELECT * FROM site_menu WHERE lang = ? AND menu_type = ?

// ✅ OR 조건
List<SiteMenu> findByLangOrMenuType(String lang, String menuType);
// 생성 쿼리: SELECT * FROM site_menu WHERE lang = ? OR menu_type = ?

// ✅ 단건 조회 (Optional 사용 권장)
Optional<SiteMenu> findByIdAndLang(Long id, String lang);
// 생성 쿼리: SELECT * FROM site_menu WHERE id = ? AND lang = ?
```

### 2. Boolean 필드 조회

```java
// ✅ Boolean 값 직접 비교
List<SiteMenu> findByEnabledTrue();
// 생성 쿼리: SELECT * FROM site_menu WHERE enabled = true

List<SiteMenu> findByEnabledFalse();
// 생성 쿼리: SELECT * FROM site_menu WHERE enabled = false

// ✅ 다른 조건과 함께 사용
List<SiteMenu> findByLangAndEnabledTrue(String lang);
// 생성 쿼리: SELECT * FROM site_menu WHERE lang = ? AND enabled = true
```

### 3. 정렬

```java
// ✅ 오름차순 (Asc)
List<SiteMenu> findByLangOrderBySortOrderAsc(String lang);
// 생성 쿼리: SELECT * FROM site_menu WHERE lang = ? ORDER BY sort_order ASC

// ✅ 내림차순 (Desc)
List<SiteMenu> findByLangOrderBySortOrderDesc(String lang);
// 생성 쿼리: SELECT * FROM site_menu WHERE lang = ? ORDER BY sort_order DESC

// ✅ 여러 필드로 정렬
List<SiteMenu> findByLangOrderBySortOrderAscIdAsc(String lang);
// 생성 쿼리: SELECT * FROM site_menu WHERE lang = ? ORDER BY sort_order ASC, id ASC

// ✅ 조건 없이 정렬만
List<SiteMenu> findAllByOrderBySortOrderAsc();
// 생성 쿼리: SELECT * FROM site_menu ORDER BY sort_order ASC
```

### 4. 비교 연산

```java
// ✅ 크다 (Greater Than)
List<BoardPost> findByViewCountGreaterThan(Integer count);
// 생성 쿼리: SELECT * FROM board_post WHERE view_count > ?

// ✅ 크거나 같다 (Greater Than Equal)
List<BoardPost> findByViewCountGreaterThanEqual(Integer count);
// 생성 쿼리: SELECT * FROM board_post WHERE view_count >= ?

// ✅ 작다 (Less Than)
List<BoardPost> findByViewCountLessThan(Integer count);
// 생성 쿼리: SELECT * FROM board_post WHERE view_count < ?

// ✅ 작거나 같다 (Less Than Equal)
List<BoardPost> findByViewCountLessThanEqual(Integer count);
// 생성 쿼리: SELECT * FROM board_post WHERE view_count <= ?

// ✅ 범위 (Between)
List<BoardPost> findByViewCountBetween(Integer min, Integer max);
// 생성 쿼리: SELECT * FROM board_post WHERE view_count BETWEEN ? AND ?
```

### 5. 문자열 검색 (LIKE)

```java
// ✅ 포함 (LIKE '%keyword%')
List<BoardPost> findByTitleContaining(String keyword);
// 생성 쿼리: SELECT * FROM board_post WHERE title LIKE '%keyword%'

// ✅ 시작 (LIKE 'keyword%')
List<BoardPost> findByTitleStartingWith(String prefix);
// 생성 쿼리: SELECT * FROM board_post WHERE title LIKE 'keyword%'

// ✅ 끝 (LIKE '%keyword')
List<BoardPost> findByTitleEndingWith(String suffix);
// 생성 쿼리: SELECT * FROM board_post WHERE title LIKE '%keyword'

// ✅ 대소문자 무시
List<BoardPost> findByTitleContainingIgnoreCase(String keyword);
// 생성 쿼리: SELECT * FROM board_post WHERE LOWER(title) LIKE LOWER('%keyword%')
```

### 6. IN 절 / NULL 체크

```java
// ✅ IN 절 (여러 값 중 하나)
List<SiteMenu> findByLangIn(List<String> langs);
// 생성 쿼리: SELECT * FROM site_menu WHERE lang IN ('ko', 'en')
// 사용: repository.findByLangIn(Arrays.asList("ko", "en"));

List<SiteMenu> findByIdIn(List<Long> ids);
// 생성 쿼리: SELECT * FROM site_menu WHERE id IN (1, 2, 3)

// ✅ NULL 체크
List<SiteMenu> findByParentIdIsNull();
// 생성 쿼리: SELECT * FROM site_menu WHERE parent_id IS NULL

List<SiteMenu> findByParentIdIsNotNull();
// 생성 쿼리: SELECT * FROM site_menu WHERE parent_id IS NOT NULL
```

### 7. 날짜/시간 비교

```java
// ✅ 이전 (Before)
List<BoardPost> findByPublishedAtBefore(LocalDateTime date);
// 생성 쿼리: SELECT * FROM board_post WHERE published_at < ?

// ✅ 이후 (After)
List<BoardPost> findByPublishedAtAfter(LocalDateTime date);
// 생성 쿼리: SELECT * FROM board_post WHERE published_at > ?

// ✅ 범위 (Between)
List<BoardPost> findByPublishedAtBetween(LocalDateTime start, LocalDateTime end);
// 생성 쿼리: SELECT * FROM board_post WHERE published_at BETWEEN ? AND ?
```

### 8. 개수 제한 / 페이징

```java
// ✅ 상위 N개 (Top, First)
List<SiteMenu> findTop10ByLang(String lang);
List<SiteMenu> findFirst5ByLang(String lang);
// 생성 쿼리: SELECT * FROM site_menu WHERE lang = ? LIMIT 10

// ✅ 정렬과 함께
List<BoardPost> findTop10ByEnabledTrueOrderByViewCountDesc();
// 생성 쿼리: SELECT * FROM board_post WHERE enabled = true ORDER BY view_count DESC LIMIT 10

// ✅ 페이징 (Pageable 사용)
Page<SiteMenu> findByLang(String lang, Pageable pageable);
// 사용 예시:
// Pageable pageable = PageRequest.of(0, 10, Sort.by("id").descending());
// Page<SiteMenu> page = repository.findByLang("ko", pageable);
// page.getTotalPages(); // 전체 페이지 수
// page.getContent();    // 현재 페이지 데이터
```

### 9. 존재 여부 / 개수

```java
// ✅ 존재 여부 확인 (boolean 반환)
boolean existsById(Long id);
boolean existsByLang(String lang);
boolean existsByLangAndMenuType(String lang, String menuType);
// 생성 쿼리: SELECT COUNT(*) > 0 FROM site_menu WHERE lang = ?

// ✅ 개수 세기 (long 반환)
long count();
long countByLang(String lang);
long countByLangAndEnabledTrue(String lang);
// 생성 쿼리: SELECT COUNT(*) FROM site_menu WHERE lang = ?
```

### 10. 복잡한 쿼리 - @Query 사용

```java
// ✅ JPQL 사용 (Entity 클래스 기준)
@Query("SELECT m FROM SiteMenu m WHERE m.lang = :lang AND m.menuType = :type")
List<SiteMenu> findMenus(@Param("lang") String lang, @Param("type") String type);
// 주의: SiteMenu는 Entity 클래스명, m.lang은 Entity 필드명

// ✅ Native SQL 사용 (테이블 기준)
@Query(value = "SELECT * FROM site_menu WHERE lang = ?1 AND menu_type = ?2", nativeQuery = true)
List<SiteMenu> findMenusNative(String lang, String type);
// 주의: site_menu는 테이블명, lang은 컬럼명

// ✅ JOIN 쿼리
@Query("SELECT b FROM BoardPost b JOIN BoardCategory c ON b.categoryId = c.id WHERE c.categoryKey = :key")
List<BoardPost> findByCategoryKey(@Param("key") String key);

// ✅ 집계 함수
@Query("SELECT COUNT(m) FROM SiteMenu m WHERE m.lang = :lang")
long countByLangCustom(@Param("lang") String lang);

@Query("SELECT SUM(b.viewCount) FROM BoardPost b WHERE b.categoryId = :categoryId")
Long sumViewCountByCategory(@Param("categoryId") Long categoryId);

// ✅ 동적 쿼리 (여러 줄)
@Query("""
    SELECT m FROM SiteMenu m
    WHERE m.lang = :lang
      AND m.enabled = true
      AND m.menuType = :type
    ORDER BY m.sortOrder ASC
    """)
List<SiteMenu> findComplexQuery(@Param("lang") String lang, @Param("type") String type);
```

---

## 삽입 (INSERT)

### 기본 삽입

```java
/**
 * 메뉴 생성 (INSERT)
 *
 * @Transactional 필수: DB 트랜잭션 관리
 * save() 메서드: ID가 없으면 INSERT, 있으면 UPDATE
 */
@Transactional
public MenuRes create(MenuUpsertReq req) {
    // 1. 새로운 Entity 객체 생성
    SiteMenu menu = new SiteMenu();

    // 2. 값 설정 (ID는 설정하지 않음, 자동 생성됨)
    menu.setLang(req.getLang());
    menu.setMenuType(req.getMenuType());
    menu.setLabel(req.getLabel());
    menu.setHref(req.getHref());
    menu.setSortOrder(req.getSortOrder());
    menu.setEnabled(req.getEnabled());

    // 3. save() 호출 - INSERT 실행
    SiteMenu saved = repository.save(menu);
    // 실행 쿼리: INSERT INTO site_menu (lang, menu_type, ...) VALUES (?, ?, ...)

    // 4. saved 객체에는 자동 생성된 ID가 포함됨
    return toRes(saved);
}
```

### 여러 건 삽입 (Batch Insert)

```java
/**
 * 여러 메뉴 한번에 생성 (BATCH INSERT)
 *
 * saveAll(): 리스트로 여러 Entity를 한번에 저장
 */
@Transactional
public List<MenuRes> createBatch(List<MenuUpsertReq> requests) {
    // 1. Entity 리스트 생성
    List<SiteMenu> menus = requests.stream()
        .map(req -> {
            SiteMenu m = new SiteMenu();
            m.setLang(req.getLang());
            m.setMenuType(req.getMenuType());
            m.setLabel(req.getLabel());
            m.setHref(req.getHref());
            return m;
        })
        .toList();

    // 2. saveAll() 호출 - BATCH INSERT 실행
    List<SiteMenu> savedMenus = repository.saveAll(menus);
    // 실행 쿼리: INSERT INTO site_menu ... (여러 번 또는 BATCH)

    return savedMenus.stream().map(this::toRes).toList();
}
```

### Builder 패턴 사용 (Lombok)

```java
/**
 * Builder 패턴으로 깔끔하게 생성
 *
 * Entity 클래스에 @Builder 애노테이션 필요
 */
@Transactional
public MenuRes createWithBuilder(MenuUpsertReq req) {
    // Builder 패턴 사용
    SiteMenu menu = SiteMenu.builder()
        .lang(req.getLang())
        .menuType(req.getMenuType())
        .label(req.getLabel())
        .href(req.getHref())
        .sortOrder(req.getSortOrder())
        .enabled(req.getEnabled())
        .build();

    return toRes(repository.save(menu));
}
```

---

## 수정 (UPDATE)

### 방법 1: save() 메서드 사용

```java
/**
 * 메뉴 수정 (UPDATE) - save() 사용
 *
 * save()는 ID가 있으면 UPDATE 실행
 */
@Transactional
public MenuRes update(Long id, MenuUpsertReq req) {
    // 1. 기존 데이터 조회 (없으면 예외)
    SiteMenu menu = repository.findById(id)
        .orElseThrow(() -> new BadRequestException("메뉴가 존재하지 않습니다. id=" + id));

    // 2. 값 변경
    menu.setLang(req.getLang());
    menu.setMenuType(req.getMenuType());
    menu.setLabel(req.getLabel());
    menu.setHref(req.getHref());
    menu.setEnabled(req.getEnabled());

    // 3. save() 호출 - UPDATE 실행
    SiteMenu updated = repository.save(menu);
    // 실행 쿼리: UPDATE site_menu SET lang=?, menu_type=?, ... WHERE id=?

    return toRes(updated);
}
```

### 방법 2: Dirty Checking (자동 UPDATE) ⭐ 권장

```java
/**
 * 메뉴 수정 (UPDATE) - Dirty Checking 사용
 *
 * @Transactional 안에서 Entity를 조회하고 setter로 변경하면
 * 트랜잭션 종료 시 자동으로 UPDATE 쿼리 실행!
 * save() 호출 불필요!
 */
@Transactional
public MenuRes updateWithDirtyChecking(Long id, MenuUpsertReq req) {
    // 1. 기존 데이터 조회
    SiteMenu menu = repository.findById(id)
        .orElseThrow(() -> new BadRequestException("메뉴가 없습니다."));

    // 2. setter로 값만 변경
    menu.setLang(req.getLang());
    menu.setMenuType(req.getMenuType());
    menu.setLabel(req.getLabel());

    // 3. save() 호출 안해도 됨!
    // @Transactional 종료될 때 자동으로 UPDATE 쿼리 실행
    // 실행 쿼리: UPDATE site_menu SET lang=?, menu_type=?, ... WHERE id=?

    return toRes(menu);
}
```

### 방법 3: @Query로 직접 UPDATE

```java
/**
 * @Query로 특정 필드만 수정
 *
 * @Modifying: UPDATE/DELETE 쿼리임을 명시
 * @Transactional: 트랜잭션 필수
 * 반환값: 영향받은 row 수 (int)
 */

// Repository에 정의
@Modifying
@Transactional
@Query("UPDATE SiteMenu m SET m.enabled = :enabled WHERE m.id = :id")
int updateEnabled(@Param("id") Long id, @Param("enabled") Boolean enabled);
// 실행 쿼리: UPDATE site_menu SET enabled = ? WHERE id = ?

@Modifying
@Transactional
@Query("UPDATE SiteMenu m SET m.sortOrder = :sortOrder WHERE m.id = :id")
int updateSortOrder(@Param("id") Long id, @Param("sortOrder") Integer sortOrder);

// Native SQL로 UPDATE
@Modifying
@Transactional
@Query(value = "UPDATE site_menu SET enabled = ?2 WHERE id = ?1", nativeQuery = true)
int updateEnabledNative(Long id, Boolean enabled);

// Service에서 사용
@Transactional
public void toggleEnabled(Long id, Boolean enabled) {
    int updatedRows = repository.updateEnabled(id, enabled);
    if (updatedRows == 0) {
        throw new BadRequestException("메뉴를 찾을 수 없습니다.");
    }
}
```

### 특정 필드만 수정하는 방법

```java
/**
 * 특정 필드만 수정 (나머지는 유지)
 */
@Transactional
public void updateOnlyLabel(Long id, String newLabel) {
    SiteMenu menu = repository.findById(id)
        .orElseThrow(() -> new BadRequestException("메뉴가 없습니다."));

    // label만 변경, 나머지 필드는 그대로
    menu.setLabel(newLabel);

    // 자동 UPDATE (Dirty Checking)
}

@Transactional
public void incrementViewCount(Long postId) {
    BoardPost post = repository.findById(postId)
        .orElseThrow(() -> new BadRequestException("게시글이 없습니다."));

    // 조회수만 1 증가
    post.setViewCount(post.getViewCount() + 1);

    // 자동 UPDATE
}
```

---

## 삭제 (DELETE)

### 기본 삭제

```java
/**
 * ID로 삭제
 *
 * 가장 간단하고 많이 사용하는 방법
 */
@Transactional
public void delete(Long id) {
    repository.deleteById(id);
    // 실행 쿼리: DELETE FROM site_menu WHERE id = ?
}

/**
 * Entity 객체로 삭제
 */
@Transactional
public void deleteEntity(SiteMenu menu) {
    repository.delete(menu);
    // 실행 쿼리: DELETE FROM site_menu WHERE id = ?
}

/**
 * 여러 개 삭제
 */
@Transactional
public void deleteMultiple(List<Long> ids) {
    List<SiteMenu> menus = repository.findAllById(ids);
    repository.deleteAll(menus);
    // 실행 쿼리: DELETE FROM site_menu WHERE id IN (?, ?, ...)
}

/**
 * 전체 삭제 (위험! 주의!)
 */
@Transactional
public void deleteAll() {
    repository.deleteAll();
    // 실행 쿼리: DELETE FROM site_menu
}
```

### 조건으로 삭제

```java
// Repository에 메서드 정의
void deleteByLang(String lang);
// 실행 쿼리: SELECT * FROM site_menu WHERE lang = ? (먼저 조회)
//           DELETE FROM site_menu WHERE id IN (?, ?, ...) (각각 삭제)

void deleteByLangAndMenuType(String lang, String menuType);
// 실행 쿼리: SELECT * FROM site_menu WHERE lang = ? AND menu_type = ?
//           DELETE FROM site_menu WHERE id IN (?, ?, ...)

void deleteByEnabledFalse();
// 실행 쿼리: 비활성화된 모든 메뉴 삭제

// Service에서 사용
@Transactional
public void deleteByLanguage(String lang) {
    repository.deleteByLang(lang);
    // 주의: 내부적으로 SELECT 후 DELETE하므로 데이터가 많으면 느림!
}
```

### @Query로 직접 삭제 (효율적) ⭐ 권장

```java
/**
 * @Query로 DELETE (SELECT 없이 바로 삭제)
 *
 * @Modifying 필수
 * @Transactional 필수
 * 반환값: 삭제된 row 수
 */

// Repository에 정의
@Modifying
@Transactional
@Query("DELETE FROM SiteMenu m WHERE m.lang = :lang")
int deleteByLangCustom(@Param("lang") String lang);
// 실행 쿼리: DELETE FROM site_menu WHERE lang = ? (바로 삭제, 빠름!)

@Modifying
@Transactional
@Query("DELETE FROM SiteMenu m WHERE m.enabled = false")
int deleteDisabledMenus();

// Native SQL
@Modifying
@Transactional
@Query(value = "DELETE FROM site_menu WHERE lang = ?1", nativeQuery = true)
int deleteByLangNative(String lang);

// Service에서 사용
@Transactional
public int cleanupDisabledMenus() {
    int deletedCount = repository.deleteDisabledMenus();
    System.out.println(deletedCount + "개의 비활성 메뉴가 삭제되었습니다.");
    return deletedCount;
}
```

### 존재 여부 확인 후 삭제

```java
/**
 * 삭제 전 존재 여부 확인 (안전)
 */
@Transactional
public void safeDelete(Long id) {
    // 1. 존재 여부 확인
    if (!repository.existsById(id)) {
        throw new BadRequestException("메뉴가 존재하지 않습니다. id=" + id);
    }

    // 2. 삭제
    repository.deleteById(id);
}

/**
 * 조회 후 검증하고 삭제
 */
@Transactional
public void deleteWithValidation(Long id) {
    // 1. 조회
    SiteMenu menu = repository.findById(id)
        .orElseThrow(() -> new BadRequestException("메뉴가 없습니다."));

    // 2. 비즈니스 로직 검증
    if (menu.getMenuType().equals("admin")) {
        throw new BadRequestException("관리자 메뉴는 삭제할 수 없습니다.");
    }

    // 3. 삭제
    repository.delete(menu);
}
```

### 연관 데이터 함께 삭제

```java
/**
 * 부모 삭제 시 자식도 함께 삭제
 *
 * Entity에 @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true) 설정 필요
 */
@Transactional
public void deleteCategoryWithPosts(Long categoryId) {
    // 카테고리 삭제하면 해당 카테고리의 게시글도 자동 삭제
    boardCategoryRepository.deleteById(categoryId);
}

/**
 * 수동으로 연관 데이터 먼저 삭제
 */
@Transactional
public void deleteMenuWithChildren(Long parentId) {
    // 1. 자식 메뉴 먼저 삭제
    repository.deleteByParentId(parentId);

    // 2. 부모 메뉴 삭제
    repository.deleteById(parentId);
}
```

---

## 실전 예시

### 예시 1: 게시글 CRUD

```java
/**
 * 게시글 Repository
 */
public interface BoardPostRepository extends JpaRepository<BoardPost, Long> {

    // ========== 조회 ==========

    // 카테고리별 활성화된 게시글 조회 (고정글 우선, 최신순)
    List<BoardPost> findByCategoryIdAndEnabledTrueOrderByIsPinnedDescPublishedAtDesc(Long categoryId);

    // 게시글 단건 조회 (카테고리 확인)
    Optional<BoardPost> findByIdAndCategoryId(Long id, Long categoryId);

    // 인기 게시글 Top 5
    List<BoardPost> findTop5ByEnabledTrueOrderByViewCountDesc();

    // 제목/내용 검색
    @Query("SELECT b FROM BoardPost b WHERE (b.title LIKE %:keyword% OR b.content LIKE %:keyword%) AND b.enabled = true")
    List<BoardPost> searchPosts(@Param("keyword") String keyword);

    // ========== 개수/존재 여부 ==========

    // 카테고리별 게시글 수
    long countByCategoryId(Long categoryId);

    // 존재 여부 확인
    boolean existsByIdAndCategoryId(Long id, Long categoryId);

    // ========== 수정 ==========

    // 조회수 증가
    @Modifying
    @Query("UPDATE BoardPost b SET b.viewCount = b.viewCount + 1 WHERE b.id = :id")
    int incrementViewCount(@Param("id") Long id);

    // 고정 상태 변경
    @Modifying
    @Query("UPDATE BoardPost b SET b.isPinned = :isPinned WHERE b.id = :id")
    int updatePinned(@Param("id") Long id, @Param("isPinned") Boolean isPinned);

    // ========== 삭제 ==========

    // 카테고리의 모든 게시글 삭제
    @Modifying
    @Query("DELETE FROM BoardPost b WHERE b.categoryId = :categoryId")
    int deleteByCategoryId(@Param("categoryId") Long categoryId);
}

/**
 * 게시글 Service
 */
@Service
@RequiredArgsConstructor
public class BoardPostService {

    private final BoardPostRepository repository;

    // ========== 조회 ==========

    @Transactional(readOnly = true)
    public List<BoardPostRes> listByCategory(Long categoryId) {
        List<BoardPost> posts = repository
            .findByCategoryIdAndEnabledTrueOrderByIsPinnedDescPublishedAtDesc(categoryId);
        return posts.stream().map(this::toRes).toList();
    }

    @Transactional(readOnly = true)
    public BoardPostRes getById(Long id) {
        BoardPost post = repository.findById(id)
            .orElseThrow(() -> new BadRequestException("게시글이 존재하지 않습니다."));

        // 조회수 증가 (별도 트랜잭션)
        repository.incrementViewCount(id);

        return toRes(post);
    }

    // ========== 생성 ==========

    @Transactional
    public BoardPostRes create(BoardPostUpsertReq req) {
        BoardPost post = new BoardPost();
        post.setCategoryId(req.getCategoryId());
        post.setLang(req.getLang());
        post.setTitle(req.getTitle());
        post.setContent(req.getContent());
        post.setIsPinned(req.getIsPinned());
        post.setEnabled(req.getEnabled());
        post.setPublishedAt(LocalDateTime.now());

        BoardPost saved = repository.save(post);
        return toRes(saved);
    }

    // ========== 수정 ==========

    @Transactional
    public BoardPostRes update(Long id, BoardPostUpsertReq req) {
        BoardPost post = repository.findById(id)
            .orElseThrow(() -> new BadRequestException("게시글이 없습니다."));

        // Dirty Checking으로 자동 UPDATE
        post.setTitle(req.getTitle());
        post.setContent(req.getContent());
        post.setIsPinned(req.getIsPinned());
        post.setEnabled(req.getEnabled());

        return toRes(post);
    }

    @Transactional
    public void togglePin(Long id) {
        BoardPost post = repository.findById(id)
            .orElseThrow(() -> new BadRequestException("게시글이 없습니다."));

        // 고정 상태 토글
        post.setIsPinned(!post.getIsPinned());
    }

    // ========== 삭제 ==========

    @Transactional
    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new BadRequestException("게시글이 존재하지 않습니다.");
        }
        repository.deleteById(id);
    }
}
```

### 예시 2: 메뉴 관리 (계층 구조)

```java
/**
 * 메뉴 Service (부모-자식 관계)
 */
@Service
@RequiredArgsConstructor
public class SiteMenuService {

    private final SiteMenuRepository repository;

    /**
     * 메뉴 트리 조회 (부모-자식 구조)
     */
    @Transactional(readOnly = true)
    public List<MenuTreeRes> getMenuTree(String lang, String menuType) {
        // 1. 해당 언어/타입의 모든 메뉴 조회
        List<SiteMenu> allMenus = repository
            .findByLangAndMenuTypeAndEnabledTrueOrderBySortOrderAsc(lang, menuType);

        // 2. 부모 메뉴만 필터링
        List<SiteMenu> parentMenus = allMenus.stream()
            .filter(m -> m.getParentId() == null || m.getParentId() == 0)
            .toList();

        // 3. 각 부모에 자식 메뉴 매핑
        return parentMenus.stream()
            .map(parent -> {
                List<MenuRes> children = allMenus.stream()
                    .filter(m -> parent.getId().equals(m.getParentId()))
                    .map(this::toRes)
                    .toList();

                return new MenuTreeRes(toRes(parent), children);
            })
            .toList();
    }

    /**
     * 메뉴 순서 변경 (Drag & Drop)
     */
    @Transactional
    public void reorder(List<Long> menuIds) {
        for (int i = 0; i < menuIds.size(); i++) {
            Long menuId = menuIds.get(i);
            SiteMenu menu = repository.findById(menuId)
                .orElseThrow(() -> new BadRequestException("메뉴가 없습니다."));

            // sortOrder 업데이트 (Dirty Checking)
            menu.setSortOrder(i + 1);
        }
        // @Transactional 종료 시 일괄 UPDATE
    }

    /**
     * 메뉴 삭제 (자식 메뉴 함께 삭제)
     */
    @Transactional
    public void deleteWithChildren(Long menuId) {
        // 1. 자식 메뉴 삭제
        List<SiteMenu> children = repository.findByParentId(menuId);
        repository.deleteAll(children);

        // 2. 부모 메뉴 삭제
        repository.deleteById(menuId);
    }
}
```

### 예시 3: 검색 기능

```java
/**
 * 검색 Service
 */
@Service
@RequiredArgsConstructor
public class SearchService {

    private final BoardPostRepository postRepository;
    private final ContentPageRepository pageRepository;

    /**
     * 통합 검색 (게시글 + 컨텐츠 페이지)
     */
    @Transactional(readOnly = true)
    public SearchResultRes search(String keyword) {
        // 1. 게시글 검색
        List<BoardPost> posts = postRepository.searchPosts(keyword);

        // 2. 컨텐츠 페이지 검색
        List<ContentPage> pages = pageRepository
            .findByTitleContainingOrContentContaining(keyword, keyword);

        // 3. 결과 조합
        return SearchResultRes.builder()
            .posts(posts.stream().map(this::toPostRes).toList())
            .pages(pages.stream().map(this::toPageRes).toList())
            .totalCount(posts.size() + pages.size())
            .build();
    }
}

/**
 * 컨텐츠 페이지 Repository
 */
public interface ContentPageRepository extends JpaRepository<ContentPage, Long> {

    // 제목 또는 내용에 키워드 포함
    List<ContentPage> findByTitleContainingOrContentContaining(String titleKeyword, String contentKeyword);

    // 활성화된 페이지만 검색
    @Query("""
        SELECT c FROM ContentPage c
        WHERE (c.title LIKE %:keyword% OR c.content LIKE %:keyword%)
          AND c.enabled = true
        """)
    List<ContentPage> searchActivePages(@Param("keyword") String keyword);
}
```

---

## 주의사항

### 1. @Transactional 필수

```java
// ❌ 잘못된 예시 - @Transactional 없음
public void update(Long id, String newTitle) {
    SiteMenu menu = repository.findById(id).orElseThrow();
    menu.setTitle(newTitle);
    // UPDATE 쿼리가 실행되지 않음!
}

// ✅ 올바른 예시 - @Transactional 있음
@Transactional
public void update(Long id, String newTitle) {
    SiteMenu menu = repository.findById(id).orElseThrow();
    menu.setTitle(newTitle);
    // 트랜잭션 종료 시 자동 UPDATE 실행
}
```

### 2. Optional 처리

```java
// ❌ 잘못된 예시 - NullPointerException 위험
public MenuRes get(Long id) {
    SiteMenu menu = repository.findById(id).get(); // NPE 위험!
    return toRes(menu);
}

// ✅ 올바른 예시 - orElseThrow 사용
public MenuRes get(Long id) {
    SiteMenu menu = repository.findById(id)
        .orElseThrow(() -> new BadRequestException("메뉴가 없습니다."));
    return toRes(menu);
}

// ✅ 또는 orElse 사용
public MenuRes get(Long id) {
    SiteMenu menu = repository.findById(id)
        .orElse(null); // null 허용하는 경우
    return menu != null ? toRes(menu) : null;
}
```

### 3. Entity vs DTO

```java
// ❌ 잘못된 예시 - Entity를 직접 반환
@GetMapping("/menus")
public List<SiteMenu> list() {
    return repository.findAll(); // Entity 노출 위험!
}

// ✅ 올바른 예시 - DTO로 변환해서 반환
@GetMapping("/menus")
public List<MenuRes> list() {
    List<SiteMenu> menus = repository.findAll();
    return menus.stream()
        .map(this::toRes) // DTO로 변환
        .toList();
}
```

### 4. N+1 문제 (성능 이슈)

```java
// ❌ 잘못된 예시 - N+1 문제 발생
@Transactional(readOnly = true)
public List<PostWithCategoryRes> listPosts() {
    List<BoardPost> posts = postRepository.findAll(); // 1번 쿼리

    return posts.stream()
        .map(post -> {
            // 각 post마다 category 조회 - N번 쿼리 발생!
            BoardCategory category = categoryRepository.findById(post.getCategoryId()).orElse(null);
            return new PostWithCategoryRes(post, category);
        })
        .toList();
}

// ✅ 올바른 예시 - JOIN FETCH 사용
@Query("SELECT p FROM BoardPost p JOIN FETCH p.category")
List<BoardPost> findAllWithCategory(); // 1번의 JOIN 쿼리로 해결
```

### 5. @Modifying 쿼리 주의사항

```java
// ✅ @Modifying 쿼리 실행 후 영속성 컨텍스트 초기화
@Modifying(clearAutomatically = true) // 중요!
@Query("UPDATE SiteMenu m SET m.enabled = :enabled WHERE m.id = :id")
int updateEnabled(@Param("id") Long id, @Param("enabled") Boolean enabled);

// 사용
@Transactional
public void disableMenu(Long id) {
    repository.updateEnabled(id, false);

    // clearAutomatically = true가 없으면
    // 이후 findById로 조회해도 변경 전 데이터가 나올 수 있음!
    SiteMenu menu = repository.findById(id).orElseThrow();
    System.out.println(menu.getEnabled()); // false 출력
}
```

### 6. 메서드 이름 길이 제한

```java
// ❌ 너무 긴 메서드 이름 (가독성 저하)
List<BoardPost> findByCategoryIdAndEnabledTrueAndIsPinnedFalseAndPublishedAtAfterOrderByViewCountDesc(
    Long categoryId, LocalDateTime date
);

// ✅ @Query로 작성하는 것이 나음
@Query("""
    SELECT b FROM BoardPost b
    WHERE b.categoryId = :categoryId
      AND b.enabled = true
      AND b.isPinned = false
      AND b.publishedAt > :date
    ORDER BY b.viewCount DESC
    """)
List<BoardPost> findPopularRecentPosts(
    @Param("categoryId") Long categoryId,
    @Param("date") LocalDateTime date
);
```

### 7. 대량 데이터 삭제/수정 시 주의

```java
// ❌ deleteBy... 메서드는 SELECT 후 DELETE (느림)
repository.deleteByLang("ko"); // SELECT 후 각각 DELETE

// ✅ @Query로 직접 DELETE (빠름)
@Modifying
@Query("DELETE FROM SiteMenu m WHERE m.lang = :lang")
int deleteByLangCustom(@Param("lang") String lang); // 바로 DELETE
```

---

## 참고 자료

### 메서드 이름 키워드 정리

| 키워드 | 설명 | 예시 |
|--------|------|------|
| `findBy` | 조회 | `findByLang(String lang)` |
| `getBy` | 조회 (findBy와 동일) | `getByLang(String lang)` |
| `readBy` | 조회 (findBy와 동일) | `readByLang(String lang)` |
| `countBy` | 개수 | `countByLang(String lang)` |
| `existsBy` | 존재 여부 | `existsByLang(String lang)` |
| `deleteBy` | 삭제 | `deleteByLang(String lang)` |
| `And` | AND 조건 | `findByLangAndMenuType(...)` |
| `Or` | OR 조건 | `findByLangOrMenuType(...)` |
| `Between` | 범위 | `findByIdBetween(Long start, Long end)` |
| `LessThan` | 미만 | `findByViewCountLessThan(Integer count)` |
| `GreaterThan` | 초과 | `findByViewCountGreaterThan(Integer count)` |
| `Like` / `Containing` | LIKE 검색 | `findByTitleContaining(String keyword)` |
| `StartingWith` | 시작 | `findByTitleStartingWith(String prefix)` |
| `EndingWith` | 끝 | `findByTitleEndingWith(String suffix)` |
| `In` | IN 절 | `findByIdIn(List<Long> ids)` |
| `IsNull` | NULL | `findByParentIdIsNull()` |
| `IsNotNull` | NOT NULL | `findByParentIdIsNotNull()` |
| `True` | true | `findByEnabledTrue()` |
| `False` | false | `findByEnabledFalse()` |
| `OrderBy` | 정렬 | `findByLangOrderBySortOrderAsc(...)` |
| `Asc` | 오름차순 | `...OrderByIdAsc()` |
| `Desc` | 내림차순 | `...OrderByIdDesc()` |
| `Top` / `First` | 제한 | `findTop10ByLang(String lang)` |

### 공식 문서
- [Spring Data JPA Reference](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)
- [Query Methods](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods)

---

**작성일:** 2026-01-07
**프로젝트:** elang
**작성자:** Claude Code Assistant
