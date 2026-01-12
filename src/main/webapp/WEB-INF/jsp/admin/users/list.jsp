<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<c:set var="isEn" value="${adminLang == 'en'}"/>

<main class="admin-content">
  <div class="page-header">
    <h1>${isEn ? 'Admin Users' : '관리자 계정 관리'}</h1>
    <p class="subtitle">${isEn ? 'Manage administrator accounts' : '관리자 계정을 관리합니다'}</p>
  </div>

  <c:if test="${not empty message}">
    <div class="alert alert-success">${message}</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
  </c:if>

  <div class="panel">
    <div class="panel-header">
      <h2>${isEn ? 'Admin List' : '관리자 목록'}</h2>
      <a href="/admin/users/new?lang=${adminLang}" class="btn btn-primary">
        + ${isEn ? 'Add Admin' : '관리자 추가'}
      </a>
    </div>
    <div class="panel-body">
      <table class="data-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>${isEn ? 'Username' : '아이디'}</th>
            <th>${isEn ? 'Name' : '이름'}</th>
            <th>${isEn ? 'Email' : '이메일'}</th>
            <th>${isEn ? 'Role' : '역할'}</th>
            <th>${isEn ? 'Status' : '상태'}</th>
            <th>${isEn ? 'Last Login' : '마지막 로그인'}</th>
            <th>${isEn ? 'Actions' : '관리'}</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="user" items="${users}">
            <tr>
              <td>${user.id}</td>
              <td><strong>${user.username}</strong></td>
              <td>${user.name}</td>
              <td>${user.email}</td>
              <td><span class="badge">${user.role}</span></td>
              <td>
                <c:choose>
                  <c:when test="${user.enabled}">
                    <span class="badge badge-success">${isEn ? 'Active' : '활성'}</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-secondary">${isEn ? 'Inactive' : '비활성'}</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:if test="${not empty user.lastLoginAt}">
                  <fmt:parseDate value="${user.lastLoginAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                  <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm"/>
                </c:if>
                <c:if test="${empty user.lastLoginAt}">-</c:if>
              </td>
              <td>
                <a href="/admin/users/${user.id}/edit?lang=${adminLang}" class="btn btn-sm btn-secondary">
                  ${isEn ? 'Edit' : '수정'}
                </a>
                <form action="/admin/users/${user.id}/delete?lang=${adminLang}" method="post" style="display: inline;"
                      onsubmit="return confirm('${isEn ? 'Are you sure?' : '정말 삭제하시겠습니까?'}');">
                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                  <button type="submit" class="btn btn-sm btn-danger">${isEn ? 'Delete' : '삭제'}</button>
                </form>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty users}">
            <tr>
              <td colspan="8" style="text-align: center; padding: 40px; color: #999;">
                ${isEn ? 'No admin users found' : '등록된 관리자가 없습니다'}
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </div>
</main>

<style>
.alert {
  padding: 12px 16px;
  border-radius: 8px;
  margin-bottom: 20px;
}
.alert-success {
  background: #d1fae5;
  color: #065f46;
  border: 1px solid #a7f3d0;
}
.alert-danger {
  background: #fee2e2;
  color: #991b1b;
  border: 1px solid #fecaca;
}
</style>

<jsp:include page="../common/footer.jsp"/>
