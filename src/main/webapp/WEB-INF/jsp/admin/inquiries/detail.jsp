<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<!-- Main Content -->
<main class="admin-content">

<div class="page-header">
  <h1>${adminLang == 'en' ? 'Inquiry Detail' : '문의 상세'}</h1>
  <p class="subtitle">${adminLang == 'en' ? 'View and process customer inquiry' : '고객 문의 내용을 확인하고 처리합니다'}</p>
</div>

<c:if test="${not empty message}">
  <div style="padding: 12px 20px; background: #d1fae5; color: #065f46; border-radius: 8px; margin-bottom: 20px;">
    ${message}
  </div>
</c:if>

<div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px;">
  <!-- 문의 내용 -->
  <div class="panel">
    <div class="panel-header">
      <h2>${adminLang == 'en' ? 'Inquiry Content' : '문의 내용'}</h2>
      <c:choose>
        <c:when test="${inquiry.status == 'PENDING'}">
          <span class="badge" style="background:#fef3c7; color:#92400e; font-size: 14px; padding: 6px 12px;">${adminLang == 'en' ? 'Pending' : '대기중'}</span>
        </c:when>
        <c:when test="${inquiry.status == 'IN_PROGRESS'}">
          <span class="badge" style="background:#dbeafe; color:#1e40af; font-size: 14px; padding: 6px 12px;">${adminLang == 'en' ? 'In Progress' : '처리중'}</span>
        </c:when>
        <c:when test="${inquiry.status == 'COMPLETED'}">
          <span class="badge badge-success" style="font-size: 14px; padding: 6px 12px;">${adminLang == 'en' ? 'Done' : '완료'}</span>
        </c:when>
      </c:choose>
    </div>
    <div class="panel-body">
      <div style="margin-bottom: 24px;">
        <h3 style="font-size: 20px; margin: 0 0 16px;">${inquiry.subject}</h3>
        <div style="display: flex; gap: 24px; color: #6b7280; font-size: 14px; margin-bottom: 16px;">
          <span><strong>${adminLang == 'en' ? 'Name:' : '이름:'}</strong> ${inquiry.name}</span>
          <span><strong>${adminLang == 'en' ? 'Email:' : '이메일:'}</strong> ${inquiry.email != null ? inquiry.email : '-'}</span>
          <span><strong>${adminLang == 'en' ? 'Phone:' : '연락처:'}</strong> ${inquiry.phone != null ? inquiry.phone : '-'}</span>
        </div>
        <div style="color: #6b7280; font-size: 13px;">
          <fmt:parseDate value="${inquiry.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
          <c:choose>
            <c:when test="${adminLang == 'en'}">
              Date: <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy HH:mm"/>
            </c:when>
            <c:otherwise>
              작성일: <fmt:formatDate value="${parsedDate}" pattern="yyyy년 MM월 dd일 HH:mm"/>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <div style="padding: 20px; background: #f9fafb; border-radius: 8px; white-space: pre-wrap; line-height: 1.8;">${inquiry.content}</div>
    </div>
  </div>

  <!-- 관리자 처리 -->
  <div>
    <div class="panel">
      <div class="panel-header">
        <h2>${adminLang == 'en' ? 'Update Status' : '상태 변경'}</h2>
      </div>
      <div class="panel-body">
        <form action="/admin/inquiries/${inquiry.id}/update" method="post">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

          <div class="form-group">
            <label>${adminLang == 'en' ? 'Status' : '처리 상태'}</label>
            <select name="status" class="form-control">
              <option value="PENDING" ${inquiry.status == 'PENDING' ? 'selected' : ''}>${adminLang == 'en' ? 'Pending' : '대기중'}</option>
              <option value="IN_PROGRESS" ${inquiry.status == 'IN_PROGRESS' ? 'selected' : ''}>${adminLang == 'en' ? 'In Progress' : '처리중'}</option>
              <option value="COMPLETED" ${inquiry.status == 'COMPLETED' ? 'selected' : ''}>${adminLang == 'en' ? 'Completed' : '완료'}</option>
            </select>
          </div>

          <div class="form-group">
            <label>${adminLang == 'en' ? 'Admin Memo' : '관리자 메모'}</label>
            <textarea name="adminMemo" class="form-control" rows="5" placeholder="${adminLang == 'en' ? 'Enter internal memo...' : '내부 메모를 입력하세요...'}">${inquiry.adminMemo}</textarea>
          </div>

          <button type="submit" class="btn btn-primary" style="width: 100%;">${adminLang == 'en' ? 'Save' : '저장'}</button>
        </form>
      </div>
    </div>

    <div class="panel" style="margin-top: 16px;">
      <div class="panel-body">
        <a href="/admin/inquiries?lang=${adminLang}" class="btn btn-secondary" style="width: 100%;">${adminLang == 'en' ? 'Back to List' : '목록으로'}</a>
      </div>
    </div>
  </div>
</div>

</main>
<jsp:include page="../common/footer.jsp"/>
