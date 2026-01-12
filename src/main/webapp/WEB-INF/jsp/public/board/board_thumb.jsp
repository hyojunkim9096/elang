<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="/assets/css/board.css"/>

<main class="main-content">
    <div class="container">
        <div class="page-header">
            <h1>${category.name}</h1>
            <p>${category.description}</p>
        </div>

        <!-- 검색 폼 -->
        <div class="search-form-container">
            <form action="/${lang}/board/${category.categoryKey}" method="get">
                <select name="searchType">
                    <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
                    <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
                </select>
                <input type="text" name="keyword" placeholder="검색어를 입력하세요" value="${keyword}">
                <button type="submit">검색</button>
            </form>
        </div>

        <div class="thumbnail-list">
            <c:choose>
                <c:when test="${not empty posts}">
                    <c:forEach var="post" items="${posts}">
                        <div class="thumbnail-item">
                            <a href="/${lang}/board/${category.categoryKey}/${post.id}">
                                <div class="thumbnail-img">
                                    <c:if test="${not empty post.thumbnail}">
                                        <img src="${post.thumbnail}" alt="${post.title}">
                                    </c:if>
                                </div>
                                <div class="thumbnail-content">
                                    <h4>${post.title}</h4>
                                    <span>
                                        <%-- 날짜 형식 변환 수정 --%>
                                        ${fn:substring(post.createdAt, 0, 10)}
                                    </span>
                                    <span>조회수 ${post.viewCount}</span>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>게시글이 없습니다.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
