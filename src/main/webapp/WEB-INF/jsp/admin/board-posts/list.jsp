<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">

<div class="page-header">
  <h1>게시글 관리 - ${categoryKey}</h1>
  <p class="subtitle">게시판 게시글을 작성하고 관리합니다</p>
</div>

<c:if test="${not empty message}">
  <div style="padding: 12px 20px; background: #d1fae5; color: #065f46; border-radius: 8px; margin-bottom: 20px;">
    ✅ ${message}
  </div>
</c:if>

<c:if test="${empty categoryId}">
  <div class="panel">
    <div class="panel-header">
      <h2>카테고리 선택</h2>
      <a href="/admin/board-categories" class="btn btn-secondary">카테고리 관리</a>
    </div>
    <div class="panel-body">
      <c:choose>
        <c:when test="${empty categories}">
          <p class="hint">등록된 카테고리가 없습니다.</p>
          <a href="/admin/board-categories/new" class="btn btn-primary">➕ 카테고리 추가하기</a>
        </c:when>
        <c:otherwise>
          <p class="hint" style="margin-bottom: 20px;">게시글을 관리할 카테고리를 선택하세요.</p>
          <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 16px;">
            <c:forEach var="cat" items="${categories}">
              <a href="/admin/board-posts?categoryId=${cat.id}&categoryKey=${cat.categoryKey}"
                 style="display: block; padding: 20px; border: 2px solid #e5e7eb; border-radius: 8px; text-decoration: none; color: inherit; transition: all 0.2s;"
                 onmouseover="this.style.borderColor='#3b82f6'; this.style.background='#eff6ff';"
                 onmouseout="this.style.borderColor='#e5e7eb'; this.style.background='white';">
                <div style="font-weight: 600; font-size: 16px; margin-bottom: 8px;">${cat.name}</div>
                <div style="font-size: 13px; color: #6b7280; margin-bottom: 4px;">키: ${cat.categoryKey}</div>
                <div style="font-size: 13px; color: #6b7280;">언어: ${cat.lang} | 타입: ${cat.displayType}</div>
                <c:if test="${!cat.enabled}">
                  <div style="margin-top: 8px;">
                    <span class="badge badge-secondary">비활성화</span>
                  </div>
                </c:if>
              </a>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</c:if>

<c:if test="${not empty categoryId}">
  <div class="panel">
    <div class="panel-header">
      <h2>게시글 목록</h2>
      <div class="panel-actions">
        <a href="/admin/board-categories" class="btn btn-secondary">← 카테고리 목록</a>
        <a href="/admin/board-posts/new?categoryId=${categoryId}&categoryKey=${categoryKey}" class="btn btn-primary">➕ 새 게시글 작성</a>
      </div>
    </div>
    <div class="panel-body">
      <c:choose>
        <c:when test="${empty posts}">
          <p class="hint">등록된 게시글이 없습니다.</p>
        </c:when>
        <c:otherwise>
          <table class="data-table">
            <thead>
              <tr>
                <th style="width:60px;">ID</th>
                <th style="width:80px;">언어</th>
                <th>제목</th>
                <th style="width:80px;">조회수</th>
                <th style="width:70px;">고정</th>
                <th style="width:80px;">활성화</th>
                <th style="width:140px;">작성일</th>
                <th style="width:200px;">작업</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="post" items="${posts}">
                <tr>
                  <td>${post.id}</td>
                  <td>${post.lang}</td>
                  <td><strong>${post.title}</strong></td>
                  <td>${post.viewCount != null ? post.viewCount : 0}</td>
                  <td>
                    <c:choose>
                      <c:when test="${post.isPinned}">
                        <span class="badge" style="background:#fef3c7; color:#92400e;">고정</span>
                      </c:when>
                      <c:otherwise>-</c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${post.enabled}">
                        <span class="badge badge-success">활성화</span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge badge-secondary">비활성화</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td style="font-size: 13px;">
                    <fmt:formatDate value="${post.publishedAt}" pattern="yyyy-MM-dd HH:mm"/>
                  </td>
                  <td>
                    <a href="/admin/board-posts/${post.id}/edit?categoryId=${categoryId}&categoryKey=${categoryKey}" class="btn btn-sm btn-secondary">✏️ 수정</a>
                    <c:if test="${post.commentCount > 0}">
                      <a href="/admin/comments?postId=${post.id}&categoryId=${categoryId}&categoryKey=${categoryKey}" class="btn btn-sm btn-primary">💬 ${post.commentCount}</a>
                    </c:if>
                    <form id="deleteForm${post.id}" action="/admin/board-posts/${post.id}/delete?categoryId=${categoryId}&categoryKey=${categoryKey}" method="post" style="display:inline;">
                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                      <button type="button" class="btn btn-sm btn-danger" onclick="confirmDelete(${post.id})">🗑</button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</c:if>

<script>
function confirmDelete(postId) {
  console.log('confirmDelete 호출됨, postId:', postId);
  console.log('showConfirm 함수 존재 여부:', typeof showConfirm);

  if (typeof showConfirm === 'function') {
    showConfirm('정말 삭제하시겠습니까?', function() {
      console.log('확인 버튼 클릭됨');
      document.getElementById('deleteForm' + postId).submit();
    }, {
      type: 'warning',
      title: '삭제 확인'
    });
  } else {
    console.error('showConfirm 함수가 없습니다. modal.js가 로드되지 않았습니다.');
    if (confirm('정말 삭제하시겠습니까?')) {
      document.getElementById('deleteForm' + postId).submit();
    }
  }
}
</script>

</main>
<jsp:include page="../common/footer.jsp"/>
