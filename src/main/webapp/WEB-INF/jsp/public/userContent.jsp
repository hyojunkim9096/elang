<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="${lang}">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${pageTitle}</title>
  <link rel="stylesheet" href="/assets/css/public.css"/>
</head>
<body>
  ${headerHtml}

  <main class="content-wrapper">
    <div class="container">
      <h1 class="page-title">${pageTitle}</h1>
      <div class="content-body">
        ${content}
      </div>
    </div>
  </main>

  ${footerHtml}
</body>
</html>
