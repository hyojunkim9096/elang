<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/sidebar.jsp"/>

<c:set var="isEn" value="${adminLang == 'en'}"/>

<main class="admin-content">
  <div class="page-header">
    <h1>${isEdit ? (isEn ? 'Edit Admin' : '관리자 수정') : (isEn ? 'Add Admin' : '관리자 추가')}</h1>
    <p class="subtitle">${isEn ? 'Enter admin information' : '관리자 정보를 입력하세요'}</p>
  </div>

  <div class="panel">
    <div class="panel-header">
      <h2>${isEn ? 'Admin Information' : '관리자 정보'}</h2>
      <a href="/admin/users?lang=${adminLang}" class="btn btn-secondary">
        ← ${isEn ? 'Back to List' : '목록으로'}
      </a>
    </div>
    <div class="panel-body">
      <form action="/admin/users/save" method="post" class="form">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="lang" value="${adminLang}"/>
        <c:if test="${isEdit}">
          <input type="hidden" name="id" value="${user.id}"/>
        </c:if>

        <div class="form-group">
          <label>${isEn ? 'Username' : '아이디'}<span class="required">*</span></label>
          <input type="text" name="username" class="form-input"
                 value="${user.username}" required
                 placeholder="${isEn ? 'Enter username' : '아이디를 입력하세요'}"
                 pattern="[a-zA-Z0-9_]+" title="${isEn ? 'Only letters, numbers, and underscores' : '영문, 숫자, 밑줄만 사용 가능'}"/>
          <small class="hint">${isEn ? 'Letters, numbers, and underscores only' : '영문, 숫자, 밑줄(_)만 사용 가능'}</small>
        </div>

        <div class="form-group">
          <label>${isEn ? 'Password' : '비밀번호'}${isEdit ? '' : '<span class="required">*</span>'}</label>
          <input type="password" name="password" class="form-input"
                 ${isEdit ? '' : 'required'}
                 placeholder="${isEdit ? (isEn ? 'Leave blank to keep current' : '변경하지 않으려면 비워두세요') : (isEn ? 'Enter password' : '비밀번호를 입력하세요')}"
                 minlength="4"/>
          <c:if test="${isEdit}">
            <small class="hint">${isEn ? 'Leave blank to keep current password' : '변경하지 않으려면 비워두세요'}</small>
          </c:if>
        </div>

        <div class="form-group">
          <label>${isEn ? 'Name' : '이름'}<span class="required">*</span></label>
          <input type="text" name="name" class="form-input"
                 value="${user.name}" required
                 placeholder="${isEn ? 'Enter name' : '이름을 입력하세요'}"/>
        </div>

        <div class="form-group">
          <label>${isEn ? 'Email' : '이메일'}</label>
          <input type="email" name="email" class="form-input"
                 value="${user.email}"
                 placeholder="${isEn ? 'Enter email' : '이메일을 입력하세요'}"/>
        </div>

        <div class="form-group">
          <label>${isEn ? 'Role' : '역할'}</label>
          <select name="role" class="form-select">
            <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>${isEn ? 'Administrator' : '관리자'}</option>
            <option value="MANAGER" ${user.role == 'MANAGER' ? 'selected' : ''}>${isEn ? 'Manager' : '매니저'}</option>
          </select>
        </div>

        <div class="form-group">
          <label>
            <input type="checkbox" name="enabled" value="1"
                   ${empty user or user.enabled ? 'checked' : ''}/>
            ${isEn ? 'Active' : '활성화'}
          </label>
          <small class="hint">${isEn ? 'Inactive users cannot log in' : '비활성화된 계정은 로그인할 수 없습니다'}</small>
        </div>

        <div class="form-actions">
          <a href="/admin/users?lang=${adminLang}" class="btn btn-secondary">${isEn ? 'Cancel' : '취소'}</a>
          <button type="submit" class="btn btn-primary">${isEn ? 'Save' : '저장'}</button>
        </div>
      </form>
    </div>
  </div>
</main>

<jsp:include page="../common/footer.jsp"/>
