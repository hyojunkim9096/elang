# Elang Camp CMS

## Tech Stack
- **Backend**: Spring Boot 3.3.6, Java 17, JPA, Flyway
- **Frontend**: JSP + JSTL, jQuery
- **DB**: MariaDB (Cafe24 10.1.x compatible)
- **Deploy**: Cafe24 Tomcat 10, WAR

## Project Structure
```
src/main/java/com/elang/camp/
├── config/          # SecurityConfig, WebMvcConfig
├── web/
│   ├── admin/       # /admin/** controllers
│   ├── publicweb/   # /{ko,en}/** controllers
│   └── advice/      # GlobalControllerAdvice
├── domain/cms/
│   ├── layout/      # SiteLayout (logo, footer, social)
│   ├── menu/        # SiteMenu (header nav)
│   ├── banner/      # SiteBanner, BannerCategory
│   ├── board/       # BoardPost, BoardCategory
│   ├── content/     # ContentPage, ContentCategory
│   └── inquiry/     # Inquiry (contact form)
├── domain/file/     # AttachFile
└── common/          # ApiResponse, exceptions, utils

src/main/webapp/WEB-INF/
├── jsp/admin/       # Admin pages
├── jsp/public/      # Public pages
└── tags/            # layout-public.tag, etc.
```

## Key Patterns
- **Domain**: Entity + Repository + Service + DTO (Res/Req)
- **Controller**: REST API returns `ApiResponse<T>`
- **Category**: extends `BaseCategory`, uses `AbstractCategoryService`
- **Lang**: `Lang.KO`, `Lang.EN` enum for i18n

## Commands
```bash
./mvnw spring-boot:run      # Local dev
./mvnw package -DskipTests  # Build WAR
```

## DB Migrations
- Location: `src/main/resources/db/migration/`
- Naming: `V{number}__{description}.sql`
- Flyway auto-runs on startup

## File Uploads
- Path: `/uploads/{type}/{filename}`
- Controller: `FileUploadController`

## URLs
- Public: `/{ko,en}/`, `/{ko,en}/board/{slug}`, `/{ko,en}/content/{slug}`
- Admin: `/admin/**` (Spring Security protected)
- API: `/api/admin/**`
