<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="${lang}">
<head>
  <meta charset="UTF-8"/>
  <title>English Camp</title>
  <link rel="stylesheet" href="./assets/css/public.css"/>
</head>
<body>

<c:out value="${layout.headerHtml}" escapeXml="false"/>

<nav class="site-nav">
  <div class="container">
    <ul>
      <c:forEach var="m" items="${menus}">
        <li><a href="${m.href}"><c:out value="${m.label}"/></a></li>
      </c:forEach>
    </ul>
  </div>
</nav>

<main class="container">
  <section class="hero">
    <h1><c:out value="${lang == 'ko' ? '영어캠프' : 'English Camp'}"/></h1>
    <p class="sub">CMS로 관리되는 프로토타입입니다. (퍼블리셔 작업 전 임시 UI)</p>
    <a class="btn" href="${switchLangUrl}">${lang == 'ko' ? 'ENG' : 'KOR'}</a>
  </section>

  <section class="banners">
    <h2>${lang == 'ko' ? '배너' : 'Banners'}</h2>
    <div class="banner-grid">
      <c:forEach var="b" items="${banners}">
        <div class="banner-card">
          <c:choose>
            <c:when test="${b.type.name() == 'IMAGE'}">
              <a href="${b.linkUrl != null ? b.linkUrl : '#'}">
                <img src="${b.imageUrl}" alt="${b.title}"/>
              </a>
            </c:when>
            <c:otherwise>
              <div class="video">
                <iframe
                  src="${b.youtubeUrl}"
                  title="${b.title}"
                  frameborder="0"
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                  allowfullscreen></iframe>
              </div>
            </c:otherwise>
          </c:choose>
          <div class="caption">
            <div class="title"><c:out value="${b.title}"/></div>
          </div>
        </div>
      </c:forEach>
    </div>
  </section>
</main>

<c:out value="${layout.footerHtml}" escapeXml="false"/>

</body>
</html>
