<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="common/header.jsp"/>

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
    color: var(--text-primary);
  }
  .post-meta {
    color: #666;
    font-size: 0.9em;
  }
  .post-content {
    line-height: 1.8;
    font-size: 1.05em;
    color: var(--text-secondary);
  }
  .post-content img {
    max-width: 100%;
    height: auto;
  }
  .btn-back {
    display: inline-block;
    margin-top: 30px;
    padding: 10px 20px;
    background: var(--primary);
    color: white;
    text-decoration: none;
    border-radius: 4px;
    transition: background 0.2s;
  }
  .btn-back:hover {
    background: var(--primary-dark);
  }
</style>

<main class="content-wrapper">
  <div class="container">
    <div class="post-header">
      <h1 class="post-title">${post.title}</h1>
      <div class="post-meta">
        ${lang == 'ko' ? '조회' : 'Views'} ${post.viewCount} · ${post.publishedAt}
      </div>
    </div>

    <div class="post-content">
      ${post.content}
    </div>

    <a href="/${lang}/board/${categoryKey}" class="btn-back">
      ← ${lang == 'ko' ? '목록으로' : 'Back to List'}
    </a>
  </div>
</main>

<jsp:include page="common/footer.jsp"/>
