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

        <table class="board-table">
            <thead>
                <tr>
                    <th class="th-num">번호</th>
                    <th class="th-title">제목</th>
                    <th class="th-date">작성일</th>
                    <th class="th-views">조회수</th>
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
                                    <%-- 날짜 형식 변환 수정 --%>
                                    ${fn:substring(post.createdAt, 0, 10)}
                                </td>
                                <td>${post.viewCount}</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="4">게시글이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
