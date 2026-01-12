<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags" %>

<layout:layout-public pageTitle="${category.name}" pageClass="board-page board-list-type">

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

        <table class="board-table">
            <thead>
                <tr>
                    <th class="th-num">${lang == 'ko' ? '번호' : 'No.'}</th>
                    <th class="th-title">${lang == 'ko' ? '제목' : 'Title'}</th>
                    <th class="th-date">${lang == 'ko' ? '작성일' : 'Date'}</th>
                    <th class="th-views">${lang == 'ko' ? '조회수' : 'Views'}</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty posts}">
                        <c:forEach var="post" items="${posts}" varStatus="status">
                            <tr>
                                <td>${posts.size() - status.index}</td>
                                <td class="text-left">
                                    <a href="/${lang}/board/${category.categoryKey}/${post.id}">${post.title}</a>
                                </td>
                                <td>
                                    ${fn:substring(post.createdAt, 0, 10)}
                                </td>
                                <td>${post.viewCount}</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="4">${lang == 'ko' ? '게시글이 없습니다.' : 'No posts available.'}</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

</layout:layout-public>
