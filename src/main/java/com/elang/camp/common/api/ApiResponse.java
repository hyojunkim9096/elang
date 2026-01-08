package com.elang.camp.common.api;

import com.fasterxml.jackson.annotation.JsonInclude;

/**
 * 공통 API 응답 포맷
 *
 * ✅ record로도 만들 수 있지만, record 컴포넌트 이름이 "ok"인 경우
 *    accessor(ok())와 static factory(ok())가 이름 충돌을 일으켜 컴파일 에러가 발생할 수 있습니다.
 *    (사용자가 ApiResponse.ok(...) 패턴을 계속 쓰기 쉬우려면 클래스 형태가 제일 안전합니다.)
 *
 * JSON 예)
 *  {"ok":true,"data":{...},"message":null}
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {

    private final boolean ok;
    private final T data;
    private final String message;

    public ApiResponse(boolean ok, T data, String message) {
        this.ok = ok;
        this.data = data;
        this.message = message;
    }

    public boolean isOk() {
        return ok;
    }

    public T getData() {
        return data;
    }

    public String getMessage() {
        return message;
    }

    /** 성공 응답(데이터 포함) */
    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>(true, data, null);
    }

    /** 성공 응답(데이터 없음) */
    public static ApiResponse<Void> ok() {
        return new ApiResponse<>(true, null, null);
    }

    /** 실패 응답 */
    public static <T> ApiResponse<T> fail(String message) {
        return new ApiResponse<>(false, null, message);
    }
}
