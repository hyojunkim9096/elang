<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="common/header.jsp" />

<main class="main-content">
    <div class="container">
        <div class="content-entry">
            <%-- 페이지 제목 --%>
            <h1 class="content-title">${title}</h1>

            <%-- Quill 에디터 등으로 작성된 HTML 컨텐츠 --%>
            <div class="content-body">
                ${content}
            </div>
        </div>
    </div>
</main>

<style>
/* 컨텐츠 페이지 기본 스타일 */
.content-entry {
    padding: 60px 0;
    max-width: 900px;
    margin: 0 auto;
}
.content-title {
    font-size: 2.5rem;
    font-weight: 700;
    margin-bottom: 40px;
    border-bottom: 2px solid #eee;
    padding-bottom: 20px;
}
.content-body {
    line-height: 1.8;
    font-size: 1.1rem;
}
/* 에디터로 작성된 컨텐츠 내부의 태그 스타일 (필요 시 추가) */
.content-body h1, .content-body h2, .content-body h3 {
    margin-top: 2em;
    margin-bottom: 1em;
    font-weight: 600;
}
.content-body img {
    max-width: 100%;
    height: auto;
    margin: 20px 0;
    border-radius: 8px;
}
</style>

<jsp:include page="common/footer.jsp" />
