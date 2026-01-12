<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:if test="${empty isHomePage}">
    <!DOCTYPE html>
    <html lang="${lang}">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>${pageTitle != null ? pageTitle : (lang == 'ko' ? 'E-LANG 영어캠프' : 'E-LANG English Camp')}</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="/assets/css/public.css"/>
        <%-- Swiper.js CSS --%>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
        <c:if test="${not empty pageCss}">
            <link rel="stylesheet" href="${pageCss}"/>
        </c:if>
    </head>
    <body>
</c:if>

<!-- Header -->
<header class="site-header" id="siteHeader">
  <%-- ... (기존 헤더 내용은 동일) ... --%>
</header>

<%-- Swiper.js JS --%>
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
