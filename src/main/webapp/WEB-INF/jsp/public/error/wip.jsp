<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags" %>

<layout:layout-public pageTitle="${lang == 'ko' ? '준비 중' : 'Coming Soon'}" pageClass="wip-page">

<main class="content-wrapper">
    <div class="container text-center" style="padding-top: 100px; padding-bottom: 100px;">
        <h1 style="font-size: 3rem; margin-bottom: 20px;">&#128679;</h1>
        <h2>${lang == 'ko' ? '페이지 준비 중입니다.' : 'Coming Soon'}</h2>
        <p style="color: #666; margin-bottom: 40px;">
            ${lang == 'ko' ? '현재 페이지는 더 나은 서비스를 위해 준비 중에 있습니다.' : 'This page is currently under construction.'}
            <br/>
            ${lang == 'ko' ? '빠른 시일 내에 찾아뵙겠습니다.' : 'We will be back soon.'}
        </p>
        <a href="/${lang}" class="btn btn-primary">${lang == 'ko' ? '홈으로 돌아가기' : 'Back to Home'}</a>
    </div>
</main>

</layout:layout-public>
