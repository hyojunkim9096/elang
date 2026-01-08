<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="${lang}">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${post.title}</title>
  <link rel="stylesheet" href="/assets/css/public.css"/>
  <style>
    .post-header {
      border-bottom: 2px solid #333;
      padding-bottom: 20px;
      margin-bottom: 30px;
    }
    .post-title {
      font-size: 2em;
      font-weight: bold;
      margin-bottom: 10px;
    }
    .post-meta {
      color: #666;
      font-size: 0.9em;
    }
    .post-content {
      line-height: 1.8;
      font-size: 1.05em;
    }
    .post-content img {
      max-width: 100%;
      height: auto;
    }
    .btn-back {
      display: inline-block;
      margin-top: 30px;
      padding: 10px 20px;
      background: #007bff;
      color: white;
      text-decoration: none;
      border-radius: 4px;
    }
    .btn-back:hover {
      background: #0056b3;
    }
  </style>
</head>
<body>
  ${headerHtml}

  <main class="content-wrapper">
    <div class="container">
      <div class="post-header">
        <h1 class="post-title">${post.title}</h1>
        <div class="post-meta">
          조회 ${post.viewCount} · ${post.publishedAt}
        </div>
      </div>

      <div class="post-content">
        ${post.content}
      </div>

      <a href="/${lang}/board/${categoryKey}" class="btn-back">← 목록으로</a>
    </div>
  </main>

  ${footerHtml}
</body>
</html>
