<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">

<div class="page-header">
  <h1>${adminLang == 'en' ? 'Inquiries' : '상담/문의 관리'}</h1>
  <p class="subtitle">${adminLang == 'en' ? 'Check and process customer inquiries' : '고객 문의를 확인하고 처리합니다'}</p>
</div>

<c:if test="${not empty message}">
  <div style="padding: 12px 20px; background: #d1fae5; color: #065f46; border-radius: 8px; margin-bottom: 20px;">
    ${message}
  </div>
</c:if>

<!-- 통계 카드 -->
<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 24px;">
  <div style="padding: 20px; background: #fef3c7; border-radius: 12px;">
    <div style="font-size: 14px; color: #92400e;">${adminLang == 'en' ? 'Pending' : '대기 중'}</div>
    <div style="font-size: 32px; font-weight: 700; color: #b45309;">${pendingCount}</div>
  </div>
  <div style="padding: 20px; background: #dbeafe; border-radius: 12px;">
    <div style="font-size: 14px; color: #1e40af;">${adminLang == 'en' ? 'Unread' : '읽지 않음'}</div>
    <div style="font-size: 32px; font-weight: 700; color: #2563eb;">${unreadCount}</div>
  </div>
  <div style="padding: 20px; background: #d1fae5; border-radius: 12px;">
    <div style="font-size: 14px; color: #065f46;">${adminLang == 'en' ? 'Total' : '전체 문의'}</div>
    <div style="font-size: 32px; font-weight: 700; color: #059669;">${totalCount}</div>
  </div>
</div>

<!-- 필터 -->
<div class="panel" style="margin-bottom: 20px;">
  <div class="panel-body" style="display: flex; gap: 12px; align-items: center;">
    <span style="font-weight: 500;">${adminLang == 'en' ? 'Filter:' : '필터:'}</span>
    <a href="/admin/inquiries?lang=${adminLang}" class="btn ${empty statusFilter ? 'btn-primary' : 'btn-secondary'}" style="font-size: 13px;">${adminLang == 'en' ? 'All' : '전체'}</a>
    <a href="/admin/inquiries?status=PENDING&lang=${adminLang}" class="btn ${statusFilter == 'PENDING' ? 'btn-primary' : 'btn-secondary'}" style="font-size: 13px;">${adminLang == 'en' ? 'Pending' : '대기중'}</a>
    <a href="/admin/inquiries?status=IN_PROGRESS&lang=${adminLang}" class="btn ${statusFilter == 'IN_PROGRESS' ? 'btn-primary' : 'btn-secondary'}" style="font-size: 13px;">${adminLang == 'en' ? 'In Progress' : '처리중'}</a>
    <a href="/admin/inquiries?status=COMPLETED&lang=${adminLang}" class="btn ${statusFilter == 'COMPLETED' ? 'btn-primary' : 'btn-secondary'}" style="font-size: 13px;">${adminLang == 'en' ? 'Completed' : '완료'}</a>
  </div>
</div>

<div class="panel">
  <div class="panel-header">
    <h2>${adminLang == 'en' ? 'Inquiry List' : '문의 목록'}</h2>
  </div>
  <div class="panel-body">
    <c:choose>
      <c:when test="${empty inquiries}">
        <p class="hint">${adminLang == 'en' ? 'No inquiries found.' : '등록된 문의가 없습니다.'}</p>
      </c:when>
      <c:otherwise>
        <table class="data-table">
          <thead>
            <tr>
              <th style="width:60px;">ID</th>
              <th style="width:80px;">${adminLang == 'en' ? 'Status' : '상태'}</th>
              <th style="width:100px;">${adminLang == 'en' ? 'Name' : '이름'}</th>
              <th>${adminLang == 'en' ? 'Subject' : '제목'}</th>
              <th style="width:120px;">${adminLang == 'en' ? 'Phone' : '연락처'}</th>
              <th style="width:80px;">${adminLang == 'en' ? 'Read' : '읽음'}</th>
              <th style="width:160px;">${adminLang == 'en' ? 'Date' : '작성일'}</th>
              <th style="width:140px;">${adminLang == 'en' ? 'Actions' : '작업'}</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="inq" items="${inquiries}">
              <tr style="${!inq.isRead ? 'background: #fffbeb;' : ''}">
                <td>${inq.id}</td>
                <td>
                  <c:choose>
                    <c:when test="${inq.status == 'PENDING'}">
                      <span class="badge" style="background:#fef3c7; color:#92400e;">${adminLang == 'en' ? 'Pending' : '대기중'}</span>
                    </c:when>
                    <c:when test="${inq.status == 'IN_PROGRESS'}">
                      <span class="badge" style="background:#dbeafe; color:#1e40af;">${adminLang == 'en' ? 'In Progress' : '처리중'}</span>
                    </c:when>
                    <c:when test="${inq.status == 'COMPLETED'}">
                      <span class="badge badge-success">${adminLang == 'en' ? 'Done' : '완료'}</span>
                    </c:when>
                  </c:choose>
                </td>
                <td><strong>${inq.name}</strong></td>
                <td>
                  <c:if test="${!inq.isRead}">
                    <span style="color: #dc2626; font-weight: 600;">NEW </span>
                  </c:if>
                  ${inq.subject}
                </td>
                <td style="font-size: 13px;">${inq.phone}</td>
                <td>
                  <c:choose>
                    <c:when test="${inq.isRead}">
                      <span style="color: #9ca3af;">${adminLang == 'en' ? 'Read' : '읽음'}</span>
                    </c:when>
                    <c:otherwise>
                      <span style="color: #dc2626; font-weight: 600;">${adminLang == 'en' ? 'Unread' : '안읽음'}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td style="font-size: 13px;">
                  <fmt:parseDate value="${inq.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                  <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm"/>
                </td>
                <td>
                  <a href="/admin/inquiries/${inq.id}?lang=${adminLang}" class="btn btn-sm btn-secondary">${adminLang == 'en' ? 'View' : '상세보기'}</a>
                  <form id="deleteForm${inq.id}" action="/admin/inquiries/${inq.id}/delete" method="post" style="display:inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="button" class="btn btn-sm btn-danger" onclick="confirmDelete(${inq.id})">${adminLang == 'en' ? 'Delete' : '삭제'}</button>
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
