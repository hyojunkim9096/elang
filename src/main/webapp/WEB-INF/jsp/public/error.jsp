<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${errorTitle} - E-LANG</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .error-container {
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        .error-code {
            font-size: 8rem;
            font-weight: 800;
            color: #2563eb;
            line-height: 1;
            margin-bottom: 16px;
            text-shadow: 4px 4px 0 #e2e8f0;
        }
        .error-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 12px;
        }
        .error-message {
            font-size: 1.1rem;
            color: #6b7280;
            margin-bottom: 40px;
            line-height: 1.6;
        }
        .error-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 14px 28px;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 12px;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background: #2563eb;
            color: white;
        }
        .btn-primary:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.3);
        }
        .btn-outline {
            background: white;
            color: #374151;
            border: 2px solid #e5e7eb;
        }
        .btn-outline:hover {
            border-color: #2563eb;
            color: #2563eb;
        }
        .error-illustration {
            margin-bottom: 30px;
        }
        .error-illustration svg {
            width: 200px;
            height: 200px;
        }

        @media (max-width: 480px) {
            .error-code {
                font-size: 5rem;
            }
            .error-title {
                font-size: 1.4rem;
            }
            .error-message {
                font-size: 1rem;
                margin-bottom: 30px;
            }
            .btn {
                padding: 12px 24px;
                font-size: 0.95rem;
                width: 100%;
            }
            .error-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-illustration">
            <svg viewBox="0 0 200 200" fill="none" xmlns="http://www.w3.org/2000/svg">
                <circle cx="100" cy="100" r="80" fill="#EEF2FF" stroke="#2563EB" stroke-width="4"/>
                <path d="M70 80C70 80 80 70 100 70C120 70 130 80 130 80" stroke="#2563EB" stroke-width="6" stroke-linecap="round"/>
                <circle cx="70" cy="90" r="8" fill="#2563EB"/>
                <circle cx="130" cy="90" r="8" fill="#2563EB"/>
                <path d="M70 130C70 130 85 115 100 115C115 115 130 130 130 130" stroke="#2563EB" stroke-width="6" stroke-linecap="round"/>
            </svg>
        </div>
        <div class="error-code">${statusCode}</div>
        <h1 class="error-title">${errorTitle}</h1>
        <p class="error-message">${errorMessage}</p>
        <div class="error-actions">
            <a href="/" class="btn btn-primary">메인으로 가기</a>
            <a href="javascript:history.back()" class="btn btn-outline">이전 페이지</a>
        </div>
    </div>
</body>
</html>
