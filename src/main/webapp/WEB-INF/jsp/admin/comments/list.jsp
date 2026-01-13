<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<style>
  .comment-tree {
    list-style: none;
    padding: 0;
    margin: 0;
  }
  .comment-tree-item {
    padding: 16px;
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    margin-bottom: 12px;
  }
  .comment-tree-item.deleted {
    background: #fff5f5;
    border-color: #fed7d7;
  }
  .comment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
  }
  .comment-author-info {
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .comment-author {
    font-weight: 600;
    color: #1f2937;
  }
  .comment-date {
    font-size: 12px;
    color: #9ca3af;
  }
  .comment-id {
    font-size: 11px;
    color: #9ca3af;
    background: #f3f4f6;
    padding: 2px 6px;
    border-radius: 4px;
  }
  .comment-content {
    color: #4b5563;
    line-height: 1.6;
    white-space: pre-wrap;
    margin-bottom: 8px;
  }
  .badge-deleted {
    display: inline-block;
    padding: 2px 8px;
    background: #fee2e2;
    color: #dc2626;
    font-size: 11px;
    border-radius: 4px;
    font-weight: 500;
  }
  .badge-reply {
    display: inline-block;
    padding: 2px 8px;
    background: #e0e7ff;
    color: #3730a3;
    font-size: 11px;
    border-radius: 4px;
    font-weight: 500;
  }
  .reply-list {
    list-style: none;
    margin: 12px 0 0 0;
    padding: 0 0 0 20px;
    border-left: 2px solid #e5e7eb;
  }
  .reply-list .comment-tree-item {
    background: #f9fafb;
    margin-bottom: 8px;
    padding: 12px;
  }
  .reply-list .comment-tree-item.deleted {
    background: #fef2f2;
  }
  .comment-actions {
    display: flex;
    gap: 8px;
    margin-top: 8px;
  }
</style>

<!-- Main Content -->
<main class="admin-content">

<div class="page-header">
  <c:choose>
    <c:when test="${not empty post}">
      <h1>${adminLang == 'en' ? 'Comments' : '댓글 관리'}</h1>
      <p class="subtitle">"${post.title}" ${adminLang == 'en' ? 'post comments' : '게시글의 댓글'}</p>
    </c:when>
    <c:otherwise>
      <h1>${adminLang == 'en' ? 'All Comments' : '전체 댓글 관리'}</h1>
      <p class="subtitle">${adminLang == 'en' ? 'Manage all comments and replies' : '모든 댓글과 답글을 관리합니다'}</p>
    </c:otherwise>
  </c:choose>
</div>

<c:if test="${not empty message}">
  <div style="padding: 12px 20px; background: #d1fae5; color: #065f46; border-radius: 8px; margin-bottom: 20px;">
    ${message}
  </div>
</c:if>

<!-- 통계 카드 -->
<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 24px;">
  <div style="padding: 20px; background: #dbeafe; border-radius: 12px;">
    <div style="font-size: 14px; color: #1e40af;">${adminLang == 'en' ? 'Total Comments' : '전체 댓글'}</div>
    <div style="font-size: 32px; font-weight: 700; color: #2563eb;">${totalCount}</div>
  </div>
</div>

<div class="panel">
  <div class="panel-header">
    <h2>${adminLang == 'en' ? 'Comment List' : '댓글 목록'}</h2>
    <c:if test="${not empty categoryId}">
      <a href="/admin/board-posts?categoryId=${categoryId}&categoryKey=${categoryKey}" class="btn btn-secondary">
        ← ${adminLang == 'en' ? 'Back to Posts' : '게시글 목록'}
      </a>
    </c:if>
  </div>
  <div class="panel-body">
    <c:choose>
      <c:when test="${empty comments}">
        <p class="hint">${adminLang == 'en' ? 'No comments found.' : '등록된 댓글이 없습니다.'}</p>
      </c:when>
      <c:otherwise>
        <c:choose>
          <%-- 특정 게시글의 댓글: 트리 구조로 표시 --%>
          <c:when test="${not empty postId}">
            <ul class="comment-tree">
              <c:forEach var="comment" items="${comments}">
                <li class="comment-tree-item ${comment.isDeleted ? 'deleted' : ''}">
                  <div class="comment-header">
                    <div class="comment-author-info">
                      <span class="comment-id">#${comment.id}</span>
                      <span class="comment-author">${comment.authorName}</span>
                      <c:if test="${comment.isDeleted}">
                        <span class="badge-deleted">${adminLang == 'en' ? 'Deleted' : '삭제됨'}</span>
                      </c:if>
                    </div>
                    <span class="comment-date">
                      <fmt:parseDate value="${comment.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                      <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm"/>
                    </span>
                  </div>
                  <div class="comment-content">${comment.content}</div>
                  <div class="comment-actions">
                    <c:if test="${!comment.isDeleted}">
                      <form action="/admin/comments/${comment.id}/delete" method="post" style="display:inline;" onsubmit="return confirm('${adminLang == 'en' ? 'Delete this comment?' : '이 댓글을 삭제하시겠습니까?'}');">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="postId" value="${postId}"/>
                        <input type="hidden" name="categoryId" value="${categoryId}"/>
                        <input type="hidden" name="categoryKey" value="${categoryKey}"/>
                        <button type="submit" class="btn btn-sm btn-danger">${adminLang == 'en' ? 'Delete' : '삭제'}</button>
                      </form>
                    </c:if>
                  </div>

                  <%-- 답글 목록 --%>
                  <c:if test="${not empty comment.replies}">
                    <ul class="reply-list">
                      <c:forEach var="reply" items="${comment.replies}">
                        <li class="comment-tree-item ${reply.isDeleted ? 'deleted' : ''}">
                          <div class="comment-header">
                            <div class="comment-author-info">
                              <span class="comment-id">#${reply.id}</span>
                              <span class="badge-reply">${adminLang == 'en' ? 'Reply' : '답글'}</span>
                              <span class="comment-author">${reply.authorName}</span>
                              <c:if test="${reply.isDeleted}">
                                <span class="badge-deleted">${adminLang == 'en' ? 'Deleted' : '삭제됨'}</span>
                              </c:if>
                            </div>
                            <span class="comment-date">
                              <fmt:parseDate value="${reply.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="replyDate" type="both"/>
                              <fmt:formatDate value="${replyDate}" pattern="yyyy-MM-dd HH:mm"/>
                            </span>
                          </div>
                          <div class="comment-content">${reply.content}</div>
                          <div class="comment-actions">
                            <c:if test="${!reply.isDeleted}">
                              <form action="/admin/comments/${reply.id}/delete" method="post" style="display:inline;" onsubmit="return confirm('${adminLang == 'en' ? 'Delete this reply?' : '이 답글을 삭제하시겠습니까?'}');">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="postId" value="${postId}"/>
                                <input type="hidden" name="categoryId" value="${categoryId}"/>
                                <input type="hidden" name="categoryKey" value="${categoryKey}"/>
                                <button type="submit" class="btn btn-sm btn-danger">${adminLang == 'en' ? 'Delete' : '삭제'}</button>
                              </form>
                            </c:if>
                          </div>
                        </li>
                      </c:forEach>
                    </ul>
                  </c:if>
                </li>
              </c:forEach>
            </ul>
          </c:when>

          <%-- 전체 댓글: 테이블로 표시 --%>
          <c:otherwise>
            <table class="data-table">
              <thead>
                <tr>
                  <th style="width:60px;">ID</th>
                  <th style="width:80px;">${adminLang == 'en' ? 'Type' : '유형'}</th>
                  <th style="width:100px;">${adminLang == 'en' ? 'Author' : '작성자'}</th>
                  <th>${adminLang == 'en' ? 'Content' : '내용'}</th>
                  <th style="width:200px;">${adminLang == 'en' ? 'Post' : '게시글'}</th>
                  <th style="width:80px;">${adminLang == 'en' ? 'Status' : '상태'}</th>
                  <th style="width:140px;">${adminLang == 'en' ? 'Date' : '작성일'}</th>
                  <th style="width:80px;">${adminLang == 'en' ? 'Actions' : '작업'}</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="comment" items="${comments}">
                  <tr style="${comment.isDeleted ? 'background: #fff5f5;' : ''}">
                    <td>${comment.id}</td>
                    <td>
                      <c:choose>
                        <c:when test="${comment.parentId != null}">
                          <span class="badge" style="background:#e0e7ff; color:#3730a3;">${adminLang == 'en' ? 'Reply' : '답글'}</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge" style="background:#dbeafe; color:#1e40af;">${adminLang == 'en' ? 'Comment' : '댓글'}</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td><strong>${comment.authorName}</strong></td>
                    <td style="max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                      ${comment.content}
                    </td>
                    <td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                      <c:if test="${not empty comment.postTitle}">
                        <a href="/admin/comments?postId=${comment.postId}" style="color: #2563eb; text-decoration: underline;">
                          ${comment.postTitle}
                        </a>
                      </c:if>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${comment.isDeleted}">
                          <span class="badge" style="background:#fee2e2; color:#991b1b;">${adminLang == 'en' ? 'Deleted' : '삭제됨'}</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-success">${adminLang == 'en' ? 'Active' : '활성'}</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td style="font-size: 13px;">
                      <fmt:parseDate value="${comment.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                      <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                    <td>
                      <c:if test="${!comment.isDeleted}">
                        <form action="/admin/comments/${comment.id}/delete" method="post" style="display:inline;" onsubmit="return confirm('${adminLang == 'en' ? 'Delete?' : '삭제하시겠습니까?'}');">
                          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                          <button type="submit" class="btn btn-sm btn-danger">${adminLang == 'en' ? 'Delete' : '삭제'}</button>
                        </form>
                      </c:if>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </c:otherwise>
    </c:choose>
  </div>
</div>

</main>
<jsp:include page="../common/footer.jsp"/>
