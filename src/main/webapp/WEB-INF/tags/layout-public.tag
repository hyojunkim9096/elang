<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ attribute name="pageTitle" required="false" %>
<%@ attribute name="pageClass" required="false" %>
<%@ attribute name="isHome" required="false" type="java.lang.Boolean" %>
<!DOCTYPE html>
<html lang="${lang}">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>${not empty pageTitle ? pageTitle : (lang == 'ko' ? 'E-LANG 영어캠프' : 'E-LANG English Camp')}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/assets/css/public.css?v=${System.currentTimeMillis()}"/>
  <c:if test="${not isHome}">
  <style>
    .content-wrapper {
      padding-top: 80px;
      min-height: calc(100vh - 200px);
    }
  </style>
  </c:if>
</head>
<body class="${pageClass}">

<!-- Header -->
<header class="site-header ${not isHome ? 'scrolled' : ''}" id="siteHeader">
  <div class="header-inner">
    <a href="/${lang}" class="site-logo">
      <span class="brand-text">E-LANG</span>
    </a>

    <nav class="site-nav">
      <button class="mobile-menu-toggle" id="mobileMenuToggle" aria-label="Menu">
        <span></span>
        <span></span>
        <span></span>
      </button>

      <ul class="nav-menu" id="navMenu">
        <c:forEach var="m" items="${menus}">
          <c:if test="${m.parentId == null}">
            <li class="nav-item">
              <c:set var="finalHref" value="${m.href}" />
              <c:set var="hasChildren" value="false" />
              <c:set var="isFirstChildFound" value="false" />

              <c:forEach var="child" items="${menus}">
                <c:if test="${child.parentId == m.id}">
                  <c:set var="hasChildren" value="true" />
                  <c:if test="${m.href == '#' && !isFirstChildFound}">
                    <c:set var="finalHref" value="${child.href}" />
                    <c:set var="isFirstChildFound" value="true" />
                  </c:if>
                </c:if>
              </c:forEach>

              <c:choose>
                <c:when test="${fn:startsWith(finalHref, 'http')}">
                  <a href="${finalHref}"><c:out value="${m.label}"/></a>
                </c:when>
                <c:otherwise>
                  <a href="/${lang}${finalHref}"><c:out value="${m.label}"/></a>
                </c:otherwise>
              </c:choose>

              <c:if test="${hasChildren}">
                <ul class="sub-menu">
                  <c:forEach var="child" items="${menus}">
                    <c:if test="${child.parentId == m.id}">
                      <li>
                        <c:choose>
                          <c:when test="${fn:startsWith(child.href, 'http')}">
                            <a href="${child.href}"><c:out value="${child.label}"/></a>
                          </c:when>
                          <c:otherwise>
                            <a href="/${lang}${child.href}"><c:out value="${child.label}"/></a>
                          </c:otherwise>
                        </c:choose>
                      </li>
                    </c:if>
                  </c:forEach>
                </ul>
              </c:if>
            </li>
          </c:if>
        </c:forEach>
        <li class="nav-item lang-switch-item">
          <a href="${switchLangUrl}" class="lang-switch">${lang == 'ko' ? 'ENG' : 'KOR'}</a>
        </li>
      </ul>
    </nav>
  </div>
</header>

<!-- Main Content -->
<jsp:doBody/>

<!-- Footer -->
<footer class="site-footer">
  <c:choose>
    <c:when test="${not empty layout.footerHtml}">
      <c:out value="${layout.footerHtml}" escapeXml="false"/>
    </c:when>
    <c:otherwise>
      <div class="container">
        <div class="footer-bottom">
          <p>&copy; 2025 E-LANG Camp. All rights reserved.</p>
        </div>
      </div>
    </c:otherwise>
  </c:choose>
</footer>

<!-- Floating Buttons -->
<div class="floating-buttons">
  <a href="https://pf.kakao.com/_xYourKakaoID" target="_blank" class="floating-btn kakao" title="${lang == 'ko' ? '카카오톡 상담' : 'KakaoTalk'}">
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12 3C6.48 3 2 6.58 2 11c0 2.84 1.86 5.33 4.64 6.73-.2.75-.72 2.7-.83 3.12-.14.54.2.53.42.38.17-.11 2.77-1.87 3.9-2.64.61.09 1.24.14 1.87.14 5.52 0 10-3.58 10-8s-4.48-8-10-8z"/>
    </svg>
  </a>
  <a href="tel:0000000000" class="floating-btn phone" title="${lang == 'ko' ? '전화 상담' : 'Call'}">
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M6.62 10.79c1.44 2.83 3.76 5.15 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/>
    </svg>
  </a>
  <c:if test="${isHome}">
  <button class="floating-btn inquiry" id="inquiryModalBtn" title="${lang == 'ko' ? '빠른 상담' : 'Quick Inquiry'}">
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H6l-2 2V4h16v12z"/>
    </svg>
  </button>
  </c:if>
  <button class="floating-btn top" id="scrollTopBtn" title="${lang == 'ko' ? '맨 위로' : 'Back to Top'}">
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M7.41 15.41L12 10.83l4.59 4.58L18 14l-6-6-6 6z"/>
    </svg>
  </button>
</div>

<!-- Common Scripts -->
<script>
document.addEventListener('DOMContentLoaded', function() {
  // ===== 페이지 로드 시 상태 초기화 =====
  document.body.style.overflow = '';

  // ===== Header Scroll Effect =====
  const header = document.getElementById('siteHeader');
  const isHome = ${isHome ? 'true' : 'false'};

  if (header) {
    window.addEventListener('scroll', function() {
      if (window.scrollY > 100) {
        header.classList.add('scrolled');
      } else if (isHome) {
        header.classList.remove('scrolled');
      }
    });

    // 서브페이지는 기본적으로 scrolled
    if (!isHome) {
      header.classList.add('scrolled');
    }
  }

  // ===== Mobile Menu Toggle =====
  const mobileToggle = document.getElementById('mobileMenuToggle');
  const navMenu = document.getElementById('navMenu');

  if (mobileToggle && navMenu) {
    // 페이지 로드 시 메뉴 상태 초기화
    navMenu.classList.remove('active');
    mobileToggle.classList.remove('active');
    header.classList.remove('menu-open');

    mobileToggle.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();

      const isActive = navMenu.classList.contains('active');

      if (isActive) {
        // 메뉴 닫기
        navMenu.classList.remove('active');
        mobileToggle.classList.remove('active');
        header.classList.remove('menu-open');
        document.body.style.overflow = '';
      } else {
        // 메뉴 열기
        navMenu.classList.add('active');
        mobileToggle.classList.add('active');
        header.classList.add('menu-open');
        document.body.style.overflow = 'hidden';
        // 메뉴 스크롤 위치 초기화
        requestAnimationFrame(function() {
          navMenu.scrollTop = 0;
        });
      }
    });

    // Close menu when clicking on a link
    navMenu.addEventListener('click', function(e) {
      if (e.target.tagName === 'A' && !e.target.classList.contains('has-submenu')) {
        navMenu.classList.remove('active');
        mobileToggle.classList.remove('active');
        header.classList.remove('menu-open');
        document.body.style.overflow = '';
      }
    });

    // Mobile submenu toggle
    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => {
      const submenu = item.querySelector('.sub-menu');
      if (submenu) {
        const link = item.querySelector('a');
        link.classList.add('has-submenu');
        link.addEventListener('click', function(e) {
          if (window.innerWidth <= 768) {
            e.preventDefault();
            navItems.forEach(otherItem => {
              if (otherItem !== item) {
                otherItem.classList.remove('open');
              }
            });
            item.classList.toggle('open');
          }
        });
      }
    });
  }

  // ===== Scroll to Top Button =====
  const scrollTopBtn = document.getElementById('scrollTopBtn');
  if (scrollTopBtn) {
    window.addEventListener('scroll', function() {
      if (window.scrollY > 500) {
        scrollTopBtn.classList.add('visible');
      } else {
        scrollTopBtn.classList.remove('visible');
      }
    });

    scrollTopBtn.addEventListener('click', function() {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  // ===== Side Banner =====
  const sideBanner = document.getElementById('sideBanner');
  const sideBannerClose = document.getElementById('sideBannerClose');
  if (sideBanner && sideBannerClose) {
    sideBannerClose.addEventListener('click', function() {
      sideBanner.classList.add('hidden');
    });
  }
});
</script>

</body>
</html>
