<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
  <button class="floating-btn top" id="scrollTopBtn" title="${lang == 'ko' ? '맨 위로' : 'Back to Top'}">
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M7.41 15.41L12 10.83l4.59 4.58L18 14l-6-6-6 6z"/>
    </svg>
  </button>
</div>

<script>
// Scroll to Top button
const scrollTopBtn = document.getElementById('scrollTopBtn');
if (scrollTopBtn) {
  window.addEventListener('scroll', function() {
    if (window.scrollY > 300) {
      scrollTopBtn.classList.add('visible');
    } else {
      scrollTopBtn.classList.remove('visible');
    }
  });

  scrollTopBtn.addEventListener('click', function() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });
}
</script>

</body>
</html>
