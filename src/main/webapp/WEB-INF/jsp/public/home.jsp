<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="${lang}">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>${lang == 'ko' ? 'E-LANG 영어캠프' : 'E-LANG English Camp'}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/assets/css/public.css"/>
</head>
<body>

<!-- Header -->
<header class="site-header" id="siteHeader">
  <div class="header-inner">
    <a href="/${lang}" class="site-logo">
      <span class="brand-text">${lang == 'ko' ? 'E-LANG' : 'E-LANG'}</span>
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
              <a href="${m.href}"><c:out value="${m.label}"/></a>
              <c:set var="hasChildren" value="false"/>
              <c:forEach var="child" items="${menus}">
                <c:if test="${child.parentId == m.id}">
                  <c:set var="hasChildren" value="true"/>
                </c:if>
              </c:forEach>
              <c:if test="${hasChildren}">
                <ul class="sub-menu">
                  <c:forEach var="child" items="${menus}">
                    <c:if test="${child.parentId == m.id}">
                      <li><a href="${child.href}"><c:out value="${child.label}"/></a></li>
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
<main class="main-content">

  <%-- 배너 카테고리별 섹션 렌더링 --%>
  <c:forEach var="category" items="${bannerCategories}">
    <c:if test="${category.enabled}">
      <c:set var="categoryKey" value="${category.categoryKey}"/>
      <c:set var="banners" value="${bannersByCategory[categoryKey]}"/>

      <c:if test="${not empty banners}">
        <%-- 배너 카테고리 섹션 --%>
        <section class="banner-section banner-${categoryKey}" data-category="${categoryKey}">
          <c:choose>
            <%-- top_banner: 풀스크린 히어로 배너 --%>
            <c:when test="${categoryKey == 'top_banner'}">
              <div class="hero-banner">
                <div class="banner-slider">
                  <c:forEach var="b" items="${banners}" varStatus="status">
                    <div class="slide ${status.first ? 'active' : ''}" data-index="${status.index}">
                      <c:choose>
                        <c:when test="${b.type.name() == 'IMAGE'}">
                          <a href="${b.linkUrl != null ? b.linkUrl : '#'}" class="banner-link">
                            <img src="${b.url}" alt="${b.title}" class="banner-img"/>
                          </a>
                        </c:when>
                        <c:when test="${b.type.name() == 'YOUTUBE'}">
                          <div class="video-wrapper">
                            <iframe src="${b.url}?autoplay=1&mute=1&loop=1&controls=0&rel=0&modestbranding=1&playlist=${b.url.substring(b.url.lastIndexOf('/') + 1)}" title="${b.title}" frameborder="0"
                                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                    allowfullscreen></iframe>
                          </div>
                        </c:when>
                        <c:otherwise>
                          <video src="${b.url}" autoplay muted loop class="banner-video"></video>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </c:forEach>
                </div>

                <!-- Hero Overlay & Content -->
                <div class="hero-overlay"></div>
                <div class="hero-content">
                  <span class="subtitle">${lang == 'ko' ? 'Global Talent Development' : 'Global Talent Development'}</span>
                  <h1>${lang == 'ko' ? '최고의 영어캠프<br>E-LANG과 함께' : 'Best English Camp<br>With E-LANG'}</h1>
                  <p>${lang == 'ko' ? '전문 강사진과 체계적인 프로그램으로 영어 실력을 한 단계 업그레이드하세요' : 'Upgrade your English skills with professional instructors and systematic programs'}</p>
                  <div class="hero-buttons">
                    <a href="#inquiry" class="btn btn-primary">${lang == 'ko' ? '상담 신청' : 'Contact Us'}</a>
                    <a href="/${lang}/page/about" class="btn btn-outline">${lang == 'ko' ? '자세히 보기' : 'Learn More'}</a>
                  </div>
                </div>

                <c:if test="${banners.size() > 1}">
                  <div class="slider-controls">
                    <button class="slider-prev" aria-label="Previous">&#10094;</button>
                    <div class="slider-dots">
                      <c:forEach var="b" items="${banners}" varStatus="status">
                        <span class="dot ${status.first ? 'active' : ''}" data-index="${status.index}"></span>
                      </c:forEach>
                    </div>
                    <button class="slider-next" aria-label="Next">&#10095;</button>
                  </div>
                </c:if>
              </div>
            </c:when>

            <%-- middle_banner: 프로그램 섹션 --%>
            <c:when test="${categoryKey == 'middle_banner'}">
              <section class="section programs-section fade-in">
                <div class="container">
                  <div class="section-header">
                    <span class="section-label">${lang == 'ko' ? '프로그램' : 'Programs'}</span>
                    <h2 class="section-title">
                      <c:choose>
                        <c:when test="${not empty category.name}"><c:out value="${category.name}"/></c:when>
                        <c:otherwise>${lang == 'ko' ? '다양한 캠프 프로그램' : 'Various Camp Programs'}</c:otherwise>
                      </c:choose>
                    </h2>
                    <c:if test="${not empty category.description}">
                      <p class="section-desc"><c:out value="${category.description}"/></p>
                    </c:if>
                  </div>
                  <div class="programs-grid">
                    <c:forEach var="b" items="${banners}">
                      <div class="program-card">
                        <c:choose>
                          <c:when test="${b.type.name() == 'IMAGE'}">
                            <a href="${b.linkUrl != null ? b.linkUrl : '#'}">
                              <img src="${b.url}" alt="${b.title}"/>
                            </a>
                          </c:when>
                          <c:when test="${b.type.name() == 'YOUTUBE'}">
                            <div class="video-wrapper">
                              <iframe src="${b.url}" title="${b.title}" frameborder="0"
                                      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                      allowfullscreen></iframe>
                            </div>
                          </c:when>
                          <c:otherwise>
                            <video src="${b.url}" controls></video>
                          </c:otherwise>
                        </c:choose>
                        <c:if test="${not empty b.title}">
                          <div class="card-content">
                            <h3><c:out value="${b.title}"/></h3>
                          </div>
                        </c:if>
                      </div>
                    </c:forEach>
                  </div>
                </div>
              </section>
            </c:when>

            <%-- popup_banner: 팝업 배너 (별도 처리) --%>
            <c:when test="${categoryKey == 'popup_banner'}">
              <div id="popup-banner-data" style="display:none;"
                   data-banners='<c:forEach var="b" items="${banners}" varStatus="s">{"id":${b.id},"title":"${b.title}","url":"${b.url}","linkUrl":"${b.linkUrl}","type":"${b.type.name()}"}<c:if test="${!s.last}">,</c:if></c:forEach>'
                   data-max-count="${category.popupMaxCount}"
                   data-duration="${category.popupDuration}"
                   data-lang="${lang}">
              </div>
            </c:when>

            <%-- 기타 카테고리: 기본 섹션 형태 --%>
            <c:otherwise>
              <section class="section fade-in">
                <div class="container">
                  <c:if test="${not empty category.name}">
                    <div class="section-header">
                      <h2 class="section-title"><c:out value="${category.name}"/></h2>
                      <c:if test="${not empty category.description}">
                        <p class="section-desc"><c:out value="${category.description}"/></p>
                      </c:if>
                    </div>
                  </c:if>
                  <div class="banner-grid">
                    <c:forEach var="b" items="${banners}">
                      <div class="banner-card">
                        <c:choose>
                          <c:when test="${b.type.name() == 'IMAGE'}">
                            <a href="${b.linkUrl != null ? b.linkUrl : '#'}">
                              <img src="${b.url}" alt="${b.title}"/>
                            </a>
                          </c:when>
                          <c:when test="${b.type.name() == 'YOUTUBE'}">
                            <div class="video-wrapper">
                              <iframe src="${b.url}" title="${b.title}" frameborder="0"
                                      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                      allowfullscreen></iframe>
                            </div>
                          </c:when>
                          <c:otherwise>
                            <video src="${b.url}" controls></video>
                          </c:otherwise>
                        </c:choose>
                        <c:if test="${not empty b.title}">
                          <div class="caption"><c:out value="${b.title}"/></div>
                        </c:if>
                      </div>
                    </c:forEach>
                  </div>
                </div>
              </section>
            </c:otherwise>
          </c:choose>
        </section>
      </c:if>
    </c:if>
  </c:forEach>

  <!-- Features Section -->
  <section class="section features-section fade-in">
    <div class="container">
      <div class="section-header">
        <span class="section-label">${lang == 'ko' ? '특징' : 'Features'}</span>
        <h2 class="section-title">${lang == 'ko' ? '왜 E-LANG 캠프인가?' : 'Why E-LANG Camp?'}</h2>
        <p class="section-desc">${lang == 'ko' ? 'E-LANG만의 차별화된 교육 시스템으로 영어 실력 향상을 경험하세요' : 'Experience English improvement with E-LANG\'s differentiated education system'}</p>
      </div>
      <div class="features-grid">
        <div class="feature-card">
          <div class="feature-icon">&#127891;</div>
          <h3>${lang == 'ko' ? '전문 강사진' : 'Expert Instructors'}</h3>
          <p>${lang == 'ko' ? '원어민 및 경력 강사진의 체계적인 교육' : 'Systematic education by native and experienced instructors'}</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">&#128218;</div>
          <h3>${lang == 'ko' ? '맞춤형 커리큘럼' : 'Customized Curriculum'}</h3>
          <p>${lang == 'ko' ? '수준별 맞춤 교육 프로그램 제공' : 'Level-based customized education programs'}</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">&#127968;</div>
          <h3>${lang == 'ko' ? '최적의 환경' : 'Best Environment'}</h3>
          <p>${lang == 'ko' ? '집중력을 높이는 쾌적한 학습 환경' : 'Pleasant learning environment for better concentration'}</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">&#127942;</div>
          <h3>${lang == 'ko' ? '검증된 성과' : 'Proven Results'}</h3>
          <p>${lang == 'ko' ? '다년간의 우수한 교육 성과와 만족도' : 'Excellent educational results and satisfaction over the years'}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- Contact Section -->
  <section class="section contact-section fade-in" id="inquiry">
    <div class="container">
      <div class="contact-grid">
        <div class="contact-info">
          <h2>${lang == 'ko' ? '상담 신청' : 'Contact Us'}</h2>
          <p>${lang == 'ko' ? '궁금한 점이 있으시면 언제든지 문의해주세요.<br>친절하게 상담해 드리겠습니다.' : 'If you have any questions, please feel free to contact us.<br>We will kindly assist you.'}</p>
        </div>
        <div class="inquiry-form-container">
          <h3>${lang == 'ko' ? '빠른 상담' : 'Quick Inquiry'}</h3>
          <form id="inquiryForm">
            <input type="hidden" name="lang" value="${lang}"/>
            <div class="form-group">
              <label>${lang == 'ko' ? '이름' : 'Name'} *</label>
              <input type="text" name="name" class="form-control" placeholder="${lang == 'ko' ? '이름을 입력하세요' : 'Enter your name'}" required/>
            </div>
            <div class="form-group">
              <label>${lang == 'ko' ? '연락처' : 'Phone'} *</label>
              <input type="tel" name="phone" class="form-control" placeholder="${lang == 'ko' ? '연락처를 입력하세요' : 'Enter your phone number'}" required/>
            </div>
            <div class="form-group">
              <label>${lang == 'ko' ? '이메일' : 'Email'}</label>
              <input type="email" name="email" class="form-control" placeholder="${lang == 'ko' ? '이메일을 입력하세요' : 'Enter your email'}"/>
            </div>
            <div class="form-group">
              <label>${lang == 'ko' ? '문의 내용' : 'Message'} *</label>
              <textarea name="content" class="form-control" rows="4" placeholder="${lang == 'ko' ? '문의 내용을 입력하세요' : 'Enter your message'}" required></textarea>
            </div>
            <button type="submit" class="btn btn-primary btn-submit">${lang == 'ko' ? '상담 신청하기' : 'Submit Inquiry'}</button>
          </form>
        </div>
      </div>
    </div>
  </section>

</main>

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
  <button class="floating-btn inquiry" id="inquiryModalBtn" title="${lang == 'ko' ? '빠른 상담' : 'Quick Inquiry'}">
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H6l-2 2V4h16v12z"/>
    </svg>
  </button>
  <button class="floating-btn top" id="scrollTopBtn" title="${lang == 'ko' ? '맨 위로' : 'Back to Top'}">
    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
      <path d="M7.41 15.41L12 10.83l4.59 4.58L18 14l-6-6-6 6z"/>
    </svg>
  </button>
</div>

<!-- Inquiry Modal -->
<div class="inquiry-modal" id="inquiryModal">
  <div class="inquiry-modal-overlay"></div>
  <div class="inquiry-modal-content">
    <button class="inquiry-modal-close" id="inquiryModalClose">&times;</button>
    <h3>${lang == 'ko' ? '빠른 상담 신청' : 'Quick Inquiry'}</h3>
    <p>${lang == 'ko' ? '아래 양식을 작성해주시면 빠르게 연락드리겠습니다.' : 'Please fill out the form below and we will contact you shortly.'}</p>
    <form id="modalInquiryForm">
      <input type="hidden" name="lang" value="${lang}"/>
      <input type="hidden" name="subject" value="${lang == 'ko' ? '빠른 상담 신청' : 'Quick Inquiry'}"/>
      <div class="form-group">
        <label>${lang == 'ko' ? '이름' : 'Name'} *</label>
        <input type="text" name="name" class="form-control" required/>
      </div>
      <div class="form-group">
        <label>${lang == 'ko' ? '연락처' : 'Phone'} *</label>
        <input type="tel" name="phone" class="form-control" required/>
      </div>
      <div class="form-group">
        <label>${lang == 'ko' ? '문의 내용' : 'Message'}</label>
        <textarea name="content" class="form-control" rows="3"></textarea>
      </div>
      <button type="submit" class="btn btn-primary btn-submit">${lang == 'ko' ? '신청하기' : 'Submit'}</button>
    </form>
  </div>
</div>

<!-- Result Modal (성공/실패 알림) -->
<div class="result-modal" id="resultModal">
  <div class="result-modal-overlay"></div>
  <div class="result-modal-content">
    <div class="result-icon" id="resultIcon"></div>
    <h3 id="resultTitle"></h3>
    <p id="resultMessage"></p>
    <button class="btn btn-primary" id="resultCloseBtn">${lang == 'ko' ? '확인' : 'OK'}</button>
  </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const lang = '${lang}';

  // ===== Header Scroll Effect =====
  const header = document.getElementById('siteHeader');
  window.addEventListener('scroll', function() {
    if (window.scrollY > 100) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
  });

  // ===== Mobile Menu Toggle =====
  const mobileToggle = document.getElementById('mobileMenuToggle');
  const navMenu = document.getElementById('navMenu');
  if (mobileToggle && navMenu) {
    mobileToggle.addEventListener('click', function() {
      navMenu.classList.toggle('active');
    });
  }

  // ===== Banner Slider =====
  const slider = document.querySelector('.banner-slider');
  if (slider) {
    const slides = slider.querySelectorAll('.slide');
    const dots = document.querySelectorAll('.slider-dots .dot');
    const prevBtn = document.querySelector('.slider-prev');
    const nextBtn = document.querySelector('.slider-next');
    let currentIndex = 0;
    let autoSlideInterval;

    function showSlide(index) {
      if (index >= slides.length) index = 0;
      if (index < 0) index = slides.length - 1;
      currentIndex = index;

      slides.forEach((slide, i) => {
        slide.classList.toggle('active', i === index);
      });
      dots.forEach((dot, i) => {
        dot.classList.toggle('active', i === index);
      });
    }

    function nextSlide() {
      showSlide(currentIndex + 1);
    }

    function prevSlide() {
      showSlide(currentIndex - 1);
    }

    function startAutoSlide() {
      autoSlideInterval = setInterval(nextSlide, 5000);
    }

    function stopAutoSlide() {
      clearInterval(autoSlideInterval);
    }

    if (prevBtn) prevBtn.addEventListener('click', function() {
      stopAutoSlide();
      prevSlide();
      startAutoSlide();
    });

    if (nextBtn) nextBtn.addEventListener('click', function() {
      stopAutoSlide();
      nextSlide();
      startAutoSlide();
    });

    dots.forEach((dot, index) => {
      dot.addEventListener('click', function() {
        stopAutoSlide();
        showSlide(index);
        startAutoSlide();
      });
    });

    if (slides.length > 1) {
      startAutoSlide();
    }
  }

  // ===== Scroll Animations =====
  const fadeElements = document.querySelectorAll('.fade-in');
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
      }
    });
  }, { threshold: 0.1 });

  fadeElements.forEach(el => observer.observe(el));

  // ===== Scroll to Top Button =====
  const scrollTopBtn = document.getElementById('scrollTopBtn');
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

  // ===== Inquiry Modal =====
  const inquiryModal = document.getElementById('inquiryModal');
  const inquiryModalBtn = document.getElementById('inquiryModalBtn');
  const inquiryModalClose = document.getElementById('inquiryModalClose');
  const inquiryModalOverlay = document.querySelector('.inquiry-modal-overlay');

  function openModal() {
    inquiryModal.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function closeModal() {
    inquiryModal.classList.remove('active');
    document.body.style.overflow = '';
  }

  inquiryModalBtn.addEventListener('click', openModal);
  inquiryModalClose.addEventListener('click', closeModal);
  inquiryModalOverlay.addEventListener('click', closeModal);

  // ===== Result Modal =====
  const resultModal = document.getElementById('resultModal');
  const resultModalOverlay = document.querySelector('.result-modal-overlay');
  const resultIcon = document.getElementById('resultIcon');
  const resultTitle = document.getElementById('resultTitle');
  const resultMessage = document.getElementById('resultMessage');
  const resultCloseBtn = document.getElementById('resultCloseBtn');

  function showResultModal(isSuccess, title, message) {
    resultIcon.innerHTML = isSuccess
      ? '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>'
      : '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>';
    resultIcon.className = 'result-icon ' + (isSuccess ? 'success' : 'error');
    resultTitle.textContent = title;
    resultMessage.textContent = message;
    resultModal.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function closeResultModal() {
    resultModal.classList.remove('active');
    document.body.style.overflow = '';
  }

  resultCloseBtn.addEventListener('click', closeResultModal);
  resultModalOverlay.addEventListener('click', closeResultModal);

  // ===== Inquiry Form Submit =====
  function submitInquiry(form, successCallback) {
    const formData = new FormData(form);
    const data = {
      lang: formData.get('lang') || lang,
      name: formData.get('name'),
      email: formData.get('email') || '',
      phone: formData.get('phone'),
      subject: formData.get('subject') || (lang === 'ko' ? '홈페이지 문의' : 'Website Inquiry'),
      content: formData.get('content') || ''
    };

    // 버튼 비활성화
    const submitBtn = form.querySelector('button[type="submit"]');
    const originalText = submitBtn.textContent;
    submitBtn.disabled = true;
    submitBtn.textContent = lang === 'ko' ? '전송 중...' : 'Sending...';

    fetch('/api/inquiry', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(result => {
      submitBtn.disabled = false;
      submitBtn.textContent = originalText;

      if (result.ok) {
        form.reset();
        if (successCallback) successCallback();
        showResultModal(
          true,
          lang === 'ko' ? '상담 신청 완료' : 'Inquiry Submitted',
          lang === 'ko' ? '상담 신청이 완료되었습니다.\n빠른 시일 내에 연락드리겠습니다.' : 'Your inquiry has been submitted.\nWe will contact you soon.'
        );
      } else {
        showResultModal(
          false,
          lang === 'ko' ? '오류 발생' : 'Error',
          lang === 'ko' ? '오류가 발생했습니다. 다시 시도해주세요.' : 'An error occurred. Please try again.'
        );
      }
    })
    .catch(error => {
      console.error('Error:', error);
      submitBtn.disabled = false;
      submitBtn.textContent = originalText;
      showResultModal(
        false,
        lang === 'ko' ? '오류 발생' : 'Error',
        lang === 'ko' ? '오류가 발생했습니다. 다시 시도해주세요.' : 'An error occurred. Please try again.'
      );
    });
  }

  // Main form
  const inquiryForm = document.getElementById('inquiryForm');
  if (inquiryForm) {
    inquiryForm.addEventListener('submit', function(e) {
      e.preventDefault();
      submitInquiry(this);
    });
  }

  // Modal form
  const modalInquiryForm = document.getElementById('modalInquiryForm');
  if (modalInquiryForm) {
    modalInquiryForm.addEventListener('submit', function(e) {
      e.preventDefault();
      submitInquiry(this, closeModal);
    });
  }

  // ===== Popup Banner =====
  const popupData = document.getElementById('popup-banner-data');
  if (popupData) {
    const bannersAttr = popupData.getAttribute('data-banners');
    if (bannersAttr) {
      try {
        const banners = JSON.parse('[' + bannersAttr + ']');
        const maxCount = parseInt(popupData.getAttribute('data-max-count')) || 1;
        const duration = parseInt(popupData.getAttribute('data-duration')) || 24;
        const popupLang = popupData.getAttribute('data-lang') || 'ko';

        const cookieName = 'popup_closed_' + new Date().toISOString().split('T')[0];
        if (document.cookie.indexOf(cookieName) === -1 && banners.length > 0) {
          banners.slice(0, maxCount).forEach(function(banner, index) {
            const popup = document.createElement('div');
            popup.className = 'popup-banner';
            popup.style.cssText = 'position:fixed;top:50%;left:50%;transform:translate(-50%,-50%);z-index:' + (10000 - index) + ';background:#fff;box-shadow:0 4px 20px rgba(0,0,0,0.3);border-radius:12px;overflow:hidden;';

            let content = '';
            if (banner.type === 'IMAGE') {
              content = '<a href="' + (banner.linkUrl || '#') + '"><img src="' + banner.url + '" alt="' + banner.title + '" style="max-width:600px;max-height:80vh;display:block;"/></a>';
            } else if (banner.type === 'YOUTUBE') {
              content = '<div style="width:560px;height:315px;"><iframe src="' + banner.url + '" width="100%" height="100%" frameborder="0" allowfullscreen></iframe></div>';
            }

            const closeText = popupLang === 'ko' ? '오늘 그만 보기' : "Don't show today";
            const closeBtn = popupLang === 'ko' ? '닫기' : 'Close';

            popup.innerHTML = content + '<div style="padding:12px 16px;text-align:right;border-top:1px solid #eee;display:flex;justify-content:space-between;align-items:center;"><label style="cursor:pointer;font-size:14px;color:#666;"><input type="checkbox" class="popup-today-close" style="margin-right:6px;"/> ' + closeText + '</label><button class="popup-close" style="padding:8px 16px;cursor:pointer;background:#2563eb;color:white;border:none;border-radius:6px;font-weight:500;">' + closeBtn + '</button></div>';

            document.body.appendChild(popup);

            popup.querySelector('.popup-close').addEventListener('click', function() {
              if (popup.querySelector('.popup-today-close').checked) {
                document.cookie = cookieName + '=1;path=/;max-age=' + (duration * 3600);
              }
              popup.remove();
              if (document.querySelectorAll('.popup-banner').length === 0) {
                const overlay = document.querySelector('.popup-overlay');
                if (overlay) overlay.remove();
              }
            });
          });

          const overlay = document.createElement('div');
          overlay.className = 'popup-overlay';
          overlay.style.cssText = 'position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);z-index:9999;';
          document.body.appendChild(overlay);
          overlay.addEventListener('click', function() {
            document.querySelectorAll('.popup-banner').forEach(p => p.remove());
            overlay.remove();
          });
        }
      } catch (e) {
        console.error('Popup banner parse error:', e);
      }
    }
  }
});
</script>

</body>
</html>
