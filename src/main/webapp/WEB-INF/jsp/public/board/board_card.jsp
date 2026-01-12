<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags" %>

<layout:layout-public pageTitle="${category.name}" pageClass="board-page board-card-type">

<link rel="stylesheet" href="/assets/css/board.css"/>

<main class="content-wrapper">
    <div class="container">
        <div class="page-header">
            <h1>${category.name}</h1>
            <p>${category.description}</p>
        </div>

        <!-- 검색 폼 -->
        <div class="search-form-container">
            <form action="/${lang}/board/${category.categoryKey}" method="get">
                <select name="searchType">
                    <option value="title" ${searchType == 'title' ? 'selected' : ''}>${lang == 'ko' ? '제목' : 'Title'}</option>
                    <option value="content" ${searchType == 'content' ? 'selected' : ''}>${lang == 'ko' ? '내용' : 'Content'}</option>
                </select>
                <input type="text" name="keyword" placeholder="${lang == 'ko' ? '검색어를 입력하세요' : 'Enter keyword'}" value="${keyword}">
                <button type="submit">${lang == 'ko' ? '검색' : 'Search'}</button>
            </form>
        </div>

        <div class="card-list">
            <c:choose>
                <c:when test="${not empty posts}">
                    <c:forEach var="post" items="${posts}">
                        <div class="card-item">
                            <a href="/${lang}/board/${category.categoryKey}/${post.id}" class="card-link">
                                <div class="card-thumbnail">
                                    <c:if test="${not empty post.thumbnail}">
                                        <img src="${post.thumbnail}" alt="${post.title}">
                                    </c:if>
                                </div>
                                <div class="card-content">
                                    <h5 class="card-title">${post.title}</h5>
                                    <p class="card-text">
                                        ${fn:substring(post.createdAt, 0, 10)}
                                    </p>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>${lang == 'ko' ? '게시글이 없습니다.' : 'No posts available.'}</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

</layout:layout-public>
