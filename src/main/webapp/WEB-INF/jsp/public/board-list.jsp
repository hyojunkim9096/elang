<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="common/header.jsp"/>

<style>
  /* 리스트형 스타일 */
  .board-list-view .post-item {
    border-bottom: 1px solid #ddd;
    padding: 15px 0;
  }
  .board-list-view .post-item:hover {
    background: #f8f9fa;
  }
  .board-list-view .post-title {
    font-size: 1.1em;
    font-weight: bold;
    color: #333;
  }
  .board-list-view .post-meta {
    color: #666;
    font-size: 0.9em;
    margin-top: 5px;
  }

  /* 카드형 스타일 */
  .board-card-view {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
  }
  .board-card-view .post-card {
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 20px;
    transition: box-shadow 0.3s;
  }
  .board-card-view .post-card:hover {
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  }
  .board-card-view .post-title {
    font-size: 1.2em;
    font-weight: bold;
    margin-bottom: 10px;
  }

  /* 썸네일형 스타일 */
  .board-thumbnail-view {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 20px;
  }
  .board-thumbnail-view .post-thumb-card {
    border: 1px solid #ddd;
    border-radius: 8px;
    overflow: hidden;
    transition: transform 0.3s;
  }
  .board-thumbnail-view .post-thumb-card:hover {
    transform: translateY(-5px);
  }
  .board-thumbnail-view .post-thumbnail {
    width: 100%;
    height: 180px;
    object-fit: cover;
    background: #e0e0e0;
  }
  .board-thumbnail-view .post-info {
    padding: 15px;
  }
  .board-thumbnail-view .post-title {
    font-size: 1.1em;
    font-weight: bold;
  }

  .pin-badge {
    display: inline-block;
    background: #ff4444;
    color: white;
    padding: 2px 8px;
    border-radius: 3px;
    font-size: 0.8em;
    margin-right: 5px;
  }

  .category-description {
    color: #666;
    margin-bottom: 30px;
    font-size: 1.05em;
  }
</style>

<main class="content-wrapper">
  <div class="container">
    <h1 class="page-title">${categoryName}</h1>
    <c:if test="${not empty categoryDescription}">
      <p class="category-description">${categoryDescription}</p>
    </c:if>

    <c:choose>
      <c:when test="${displayType == 'LIST'}">
        <!-- 리스트형 -->
        <div class="board-list-view">
          <c:forEach var="post" items="${posts}">
            <div class="post-item">
              <a href="/${lang}/board/${categoryKey}/${post.id}" style="text-decoration: none; color: inherit;">
                <div class="post-title">
                  <c:if test="${post.isPinned}">
                    <span class="pin-badge">${lang == 'ko' ? '고정' : 'Pinned'}</span>
                  </c:if>
                  ${post.title}
                </div>
                <div class="post-meta">
                  ${lang == 'ko' ? '조회' : 'Views'} ${post.viewCount} · ${post.publishedAt}
                </div>
              </a>
            </div>
          </c:forEach>
        </div>
      </c:when>

      <c:when test="${displayType == 'CARD'}">
        <!-- 카드형 -->
        <div class="board-card-view">
          <c:forEach var="post" items="${posts}">
            <a href="/${lang}/board/${categoryKey}/${post.id}" style="text-decoration: none;">
              <div class="post-card">
                <div class="post-title">
                  <c:if test="${post.isPinned}">
                    <span class="pin-badge">${lang == 'ko' ? '고정' : 'Pinned'}</span>
                  </c:if>
                  ${post.title}
                </div>
                <div class="post-meta">
                  ${lang == 'ko' ? '조회' : 'Views'} ${post.viewCount} · ${post.publishedAt}
                </div>
              </div>
            </a>
          </c:forEach>
        </div>
      </c:when>

      <c:when test="${displayType == 'THUMBNAIL'}">
        <!-- 썸네일형 -->
        <div class="board-thumbnail-view">
          <c:forEach var="post" items="${posts}">
            <a href="/${lang}/board/${categoryKey}/${post.id}" style="text-decoration: none; color: inherit;">
              <div class="post-thumb-card">
                <c:choose>
                  <c:when test="${not empty post.thumbnail}">
                    <img src="${post.thumbnail}" alt="${post.title}" class="post-thumbnail">
                  </c:when>
                  <c:otherwise>
                    <div class="post-thumbnail" style="display: flex; align-items: center; justify-content: center; color: #999;">
                      No Image
                    </div>
                  </c:otherwise>
                </c:choose>
                <div class="post-info">
                  <div class="post-title">
                    <c:if test="${post.isPinned}">
                      <span class="pin-badge">${lang == 'ko' ? '고정' : 'Pinned'}</span>
                    </c:if>
                    ${post.title}
                  </div>
                  <div class="post-meta">
                    ${lang == 'ko' ? '조회' : 'Views'} ${post.viewCount}
                  </div>
                </div>
              </div>
            </a>
          </c:forEach>
        </div>
      </c:when>
    </c:choose>

    <c:if test="${empty posts}">
      <p style="text-align: center; padding: 50px 0; color: #999;">
        ${lang == 'ko' ? '등록된 게시글이 없습니다.' : 'No posts available.'}
      </p>
    </c:if>
  </div>
</main>

<jsp:include page="common/footer.jsp"/>
