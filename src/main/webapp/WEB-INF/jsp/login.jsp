<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <title>Admin Login</title>
  <link rel="stylesheet" href="/assets/css/admin.css"/>
</head>
<body class="admin-body">
<div class="admin-login">
  <h1>관리자 로그인</h1>

  <form method="post" action="/login">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

    <label>
      <span>아이디</span>
      <input type="text" name="username" autocomplete="username" required/>
    </label>

    <label>
      <span>비밀번호</span>
      <input type="password" name="password" autocomplete="current-password" required/>
    </label>

    <button type="submit">로그인</button>
  </form>

  <p class="hint">기본 계정: admin / admin1234</p>
</div>
</body>
</html>
