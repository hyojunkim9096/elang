<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<main class="admin-content">

<div class="page-header">
  <h1>${adminLang == 'en' ? 'Transform History' : '문제 변형 히스토리'}</h1>
  <p class="subtitle">${adminLang == 'en' ? 'View all transformation records' : '모든 변형 기록을 조회합니다'}</p>
</div>

<c:if test="${not empty message}">
  <div style="padding: 12px 20px; background: #d1fae5; color: #065f46; border-radius: 8px; margin-bottom: 20px;">
    ${message}
  </div>
</c:if>

<!-- 통계 카드 -->
<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 24px;">
  <div style="padding: 20px; background: #d1fae5; border-radius: 12px;">
    <div style="font-size: 14px; color: #065f46;">${adminLang == 'en' ? 'Completed' : '완료'}</div>
    <div style="font-size: 32px; font-weight: 700; color: #059669;">${completedCount}</div>
  </div>
  <div style="padding: 20px; background: #fee2e2; border-radius: 12px;">
    <div style="font-size: 14px; color: #991b1b;">${adminLang == 'en' ? 'Failed' : '실패'}</div>
    <div style="font-size: 32px; font-weight: 700; color: #dc2626;">${failedCount}</div>
  </div>
  <div style="padding: 20px; background: #dbeafe; border-radius: 12px;">
    <div style="font-size: 14px; color: #1e40af;">${adminLang == 'en' ? 'Total' : '전체'}</div>
    <div style="font-size: 32px; font-weight: 700; color: #2563eb;">${totalCount}</div>
  </div>
</div>

<!-- 필터 + 새 변형 버튼 -->
<div class="panel" style="margin-bottom: 20px;">
  <div class="panel-body" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
    <div style="display: flex; gap: 12px; align-items: center;">
      <span style="font-weight: 500;">${adminLang == 'en' ? 'Filter:' : '필터:'}</span>
      <a href="/admin/question-transform?lang=${adminLang}"
         class="btn ${empty difficultyFilter ? 'btn-primary' : 'btn-secondary'}" style="font-size: 13px;">
        ${adminLang == 'en' ? 'All' : '전체'}
      </a>
      <a href="/admin/question-transform?difficulty=HIGH&lang=${adminLang}"
         class="btn ${difficultyFilter == 'HIGH' ? 'btn-primary' : 'btn-secondary'}" style="font-size: 13px;">
        상 (HIGH)
      </a>
      <a href="/admin/question-transform?difficulty=MEDIUM&lang=${adminLang}"
         class="btn ${difficultyFilter == 'MEDIUM' ? 'btn-primary' : 'btn-secondary'}" style="font-size: 13px;">
        중 (MEDIUM)
      </a>
      <a href="/admin/question-transform?difficulty=LOW&lang=${adminLang}"
         class="btn ${difficultyFilter == 'LOW' ? 'btn-primary' : 'btn-secondary'}" style="font-size: 13px;">
        하 (LOW)
      </a>
    </div>
    <a href="/admin/question-transform/new?lang=${adminLang}" class="btn btn-primary">
      + ${adminLang == 'en' ? 'New Transform' : '새 변형'}
    </a>
  </div>
</div>

<div class="panel">
  <div class="panel-header">
    <h2>${adminLang == 'en' ? 'History' : '변형 목록'}</h2>
  </div>
  <div class="panel-body">
    <c:choose>
      <c:when test="${empty transforms}">
        <p class="hint">${adminLang == 'en' ? 'No records found.' : '기록이 없습니다.'}</p>
      </c:when>
      <c:otherwise>
        <table class="data-table">
          <thead>
            <tr>
              <th style="width:60px;">ID</th>
              <th style="width:80px;">${adminLang == 'en' ? 'Difficulty' : '난이도'}</th>
              <th>${adminLang == 'en' ? 'Original Text' : '원본 (일부)'}</th>
              <th style="width:80px;">${adminLang == 'en' ? 'Status' : '상태'}</th>
              <th style="width:160px;">${adminLang == 'en' ? 'Date' : '생성일'}</th>
              <th style="width:140px;">${adminLang == 'en' ? 'Actions' : '작업'}</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="item" items="${transforms}">
              <tr>
                <td>${item.id}</td>
                <td>
                  <span class="badge" style="background:#dbeafe; color:#1e40af;">${item.difficultyLabel}</span>
                </td>
                <td style="max-width: 400px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                  <c:choose>
                    <c:when test="${item.originalText.length() > 80}">
                      <c:out value="${item.originalText.substring(0, 80)}"/>...
                    </c:when>
                    <c:otherwise>
                      <c:out value="${item.originalText}"/>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${item.status == 'COMPLETED'}">
                      <span class="badge badge-success">${item.statusLabel}</span>
                    </c:when>
                    <c:when test="${item.status == 'FAILED'}">
                      <span class="badge" style="background:#fee2e2; color:#991b1b;">${item.statusLabel}</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge">${item.statusLabel}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td style="font-size: 13px;">
                  ${item.createdAtFormatted}
                </td>
                <td>
                  <a href="/admin/question-transform/${item.id}?lang=${adminLang}" class="btn btn-sm btn-secondary">
                    ${adminLang == 'en' ? 'View' : '상세'}
                  </a>
                  <form id="deleteForm${item.id}" action="/admin/question-transform/${item.id}/delete" method="post" style="display:inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="button" class="btn btn-sm btn-danger" onclick="confirmDelete(${item.id})">
                      ${adminLang == 'en' ? 'Delete' : '삭제'}
                    </button>
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

<script>
function confirmDelete(id) {
  var confirmMsg = '${adminLang == 'en' ? 'Are you sure you want to delete?' : '정말 삭제하시겠습니까?'}';
  var confirmTitle = '${adminLang == 'en' ? 'Confirm Delete' : '삭제 확인'}';
  if (typeof showConfirm === 'function') {
    showConfirm(confirmMsg, function() {
      document.getElementById('deleteForm' + id).submit();
    }, { type: 'warning', title: confirmTitle });
  } else {
    if (confirm(confirmMsg)) {
      document.getElementById('deleteForm' + id).submit();
    }
  }
}
</script>

</main>
<jsp:include page="../common/footer.jsp"/>
