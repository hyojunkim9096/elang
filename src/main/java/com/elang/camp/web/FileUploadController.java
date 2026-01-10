package com.elang.camp.web;

import com.elang.camp.domain.file.AttachFile;
import com.elang.camp.domain.file.AttachFileService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
public class FileUploadController {

    private final AttachFileService attachFileService;

    // application.yml 또는 활성화된 프로필의 yml 파일에서 'app.upload-dir' 값을 주입받습니다.
    @Value("${app.upload-dir}")
    private String uploadPath;

    /**
     * 이미지 업로드 (CKEditor, 썸네일 등)
     */
    @PostMapping("/admin/upload-image")
    @ResponseBody
    public Map<String, Object> uploadImage(@RequestParam("upload") MultipartFile file) {
        Map<String, Object> result = new HashMap<>();

        try {
            if (file.isEmpty()) {
                result.put("uploaded", 0);
                result.put("error", Map.of("message", "파일이 비어있습니다."));
                return result;
            }

            // 파일 크기 체크 (5MB)
            long maxSize = 5 * 1024 * 1024;
            if (file.getSize() > maxSize) {
                double sizeMB = file.getSize() / 1024.0 / 1024.0;
                result.put("uploaded", 0);
                result.put("error", Map.of("message",
                    String.format("파일 크기가 너무 큽니다. 최대 5MB까지 업로드 가능합니다. (현재: %.2fMB)", sizeMB)));
                return result;
            }

            // 파일 정보 추출
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename != null && originalFilename.contains(".")
                ? originalFilename.substring(originalFilename.lastIndexOf("."))
                : "";
            String savedFilename = UUID.randomUUID().toString() + extension;

            // 업로드 디렉토리 생성
            File uploadDir = new File(this.uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 파일 저장
            Path filePath = Paths.get(this.uploadPath, savedFilename);
            Files.write(filePath, file.getBytes());

            // DB에 파일 정보 저장
            AttachFile attachFile = new AttachFile();
            attachFile.setOriginalName(originalFilename);
            attachFile.setSavedName(savedFilename);
            attachFile.setFilePath(filePath.toString());
            attachFile.setFileSize(file.getSize());
            attachFile.setContentType(file.getContentType());
            attachFile.setFileExtension(extension);
            attachFile.setUploadType("editor");  // 기본값: CKEditor 이미지
            // referenceType, referenceId는 나중에 게시글 저장 시 업데이트 가능

            AttachFile saved = attachFileService.save(attachFile);

            // CKEditor 형식으로 URL 반환
            result.put("url", saved.getUrl());
            result.put("uploaded", 1);
            result.put("fileId", saved.getId());  // 파일 ID 반환 (추후 참조용)

        } catch (IOException e) {
            result.put("uploaded", 0);
            result.put("error", Map.of("message", "파일 업로드 실패: " + e.getMessage()));
        } catch (Exception e) {
            result.put("uploaded", 0);
            result.put("error", Map.of("message", "서버 오류: " + e.getMessage()));
        }

        return result;
    }
}
