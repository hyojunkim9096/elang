package com.elang.camp.web;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        String errorMessage;
        String errorTitle;
        int statusCode = 500;

        if (status != null) {
            statusCode = Integer.parseInt(status.toString());
        }

        switch (statusCode) {
            case 400:
                errorTitle = "잘못된 요청";
                errorMessage = "요청이 잘못되었습니다.";
                break;
            case 403:
                errorTitle = "접근 금지";
                errorMessage = "이 페이지에 접근할 권한이 없습니다.";
                break;
            case 404:
                errorTitle = "페이지를 찾을 수 없음";
                errorMessage = "요청하신 페이지를 찾을 수 없습니다.";
                break;
            case 500:
                errorTitle = "서버 오류";
                errorMessage = "서버에서 오류가 발생했습니다.";
                break;
            default:
                errorTitle = "오류 발생";
                errorMessage = "알 수 없는 오류가 발생했습니다.";
        }

        model.addAttribute("statusCode", statusCode);
        model.addAttribute("errorTitle", errorTitle);
        model.addAttribute("errorMessage", errorMessage);

        return "public/error";
    }
}
