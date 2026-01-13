package com.elang.camp.web.admin;

import com.elang.camp.domain.cms.menu.SiteMenuService;
import com.elang.camp.domain.cms.menu.dto.MenuRes;
import com.elang.camp.domain.question.DifficultyLevel;
import com.elang.camp.domain.question.QuestionTransformService;
import com.elang.camp.domain.question.dto.QuestionTransformReq;
import com.elang.camp.domain.question.dto.QuestionTransformRes;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.Base64;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/question-transform")
public class QuestionTransformController {

    private final QuestionTransformService service;
    private final SiteMenuService menuService;

    /**
     * 히스토리 목록
     */
    @GetMapping
    public String list(@RequestParam(required = false) String difficulty,
                       @RequestParam(required = false, defaultValue = "ko") String lang,
                       Model model) {
        addCommonAttributes(model, "문제 변형 히스토리", "question-transform", lang);

        List<QuestionTransformRes> list;
        if (difficulty != null && !difficulty.isEmpty()) {
            list = service.listByDifficulty(DifficultyLevel.valueOf(difficulty));
            model.addAttribute("difficultyFilter", difficulty);
        } else {
            list = service.listAll();
        }

        model.addAttribute("transforms", list);
        model.addAttribute("completedCount", service.countCompleted());
        model.addAttribute("failedCount", service.countFailed());
        model.addAttribute("totalCount", list.size());

        return "admin/question-transform/list";
    }

    /**
     * 새 변형 폼
     */
    @GetMapping("/new")
    public String newForm(@RequestParam(required = false, defaultValue = "ko") String lang,
                          Model model) {
        addCommonAttributes(model, "문제 변형 생성", "question-transform", lang);
        model.addAttribute("difficulties", DifficultyLevel.values());
        return "admin/question-transform/form";
    }

    /**
     * 변형 실행 (텍스트 + 파일 업로드 지원)
     */
    @PostMapping("/transform")
    public String transform(@RequestParam(required = false) String originalText,
                           @RequestParam DifficultyLevel difficulty,
                           @RequestParam(required = false) MultipartFile file,
                           @RequestParam(required = false, defaultValue = "ko") String lang,
                           @RequestParam(required = false, defaultValue = "KO") String questionLang,
                           @RequestParam(required = false, defaultValue = "KO") String choiceLang,
                           Model model,
                           RedirectAttributes redirectAttributes) {

        try {
            QuestionTransformReq req = new QuestionTransformReq();
            req.setDifficulty(difficulty);
            req.setQuestionLang(questionLang);
            req.setChoiceLang(choiceLang);

            // 파일이 있으면 처리
            if (file != null && !file.isEmpty()) {
                String contentType = file.getContentType();
                log.info("File uploaded: name={}, type={}, size={}", file.getOriginalFilename(), contentType, file.getSize());

                if (contentType != null && contentType.startsWith("image/")) {
                    // 이미지: Base64로 변환해서 Vision API 사용
                    String base64 = Base64.getEncoder().encodeToString(file.getBytes());
                    String dataUrl = "data:" + contentType + ";base64," + base64;
                    req.setImageBase64(dataUrl);
                    req.setInputType("IMAGE");
                    req.setOriginalText("[이미지에서 추출]");
                } else if (contentType != null && contentType.equals("application/pdf")) {
                    // PDF: 텍스트 추출
                    String extractedText = extractTextFromPdf(file);
                    req.setOriginalText(extractedText);
                    req.setInputType("PDF");
                } else {
                    throw new IllegalArgumentException("지원하지 않는 파일 형식입니다. (이미지 또는 PDF만 가능)");
                }
            } else if (originalText != null && !originalText.isBlank()) {
                // 텍스트 직접 입력
                req.setOriginalText(originalText);
                req.setInputType("TEXT");
            } else {
                throw new IllegalArgumentException("텍스트를 입력하거나 파일을 업로드해주세요.");
            }

            QuestionTransformRes result = service.transform(req);
            model.addAttribute("result", result);
            model.addAttribute("difficulties", DifficultyLevel.values());
            model.addAttribute("selectedQuestionLang", questionLang);
            model.addAttribute("selectedChoiceLang", choiceLang);
            addCommonAttributes(model, "변형 결과", "question-transform", lang);
            return "admin/question-transform/form";

        } catch (Exception e) {
            log.error("Transform failed", e);
            addCommonAttributes(model, "문제 변형 생성", "question-transform", lang);
            model.addAttribute("difficulties", DifficultyLevel.values());
            model.addAttribute("error", "변형 처리 중 오류가 발생했습니다: " + e.getMessage());
            model.addAttribute("originalText", originalText);
            model.addAttribute("selectedDifficulty", difficulty);
            model.addAttribute("selectedQuestionLang", questionLang);
            model.addAttribute("selectedChoiceLang", choiceLang);
            return "admin/question-transform/form";
        }
    }

    /**
     * PDF에서 텍스트 추출
     */
    private String extractTextFromPdf(MultipartFile file) throws IOException {
        try (PDDocument document = Loader.loadPDF(file.getBytes())) {
            PDFTextStripper stripper = new PDFTextStripper();
            String text = stripper.getText(document);
            if (text == null || text.isBlank()) {
                throw new IllegalArgumentException("PDF에서 텍스트를 추출할 수 없습니다. 이미지 기반 PDF는 이미지로 업로드해주세요.");
            }
            return text.trim();
        }
    }

    /**
     * 상세 보기
     */
    @GetMapping("/{id}")
    public String detail(@PathVariable Long id,
                         @RequestParam(required = false, defaultValue = "ko") String lang,
                         Model model) {
        addCommonAttributes(model, "변형 상세", "question-transform", lang);
        QuestionTransformRes result = service.getById(id);
        model.addAttribute("result", result);
        model.addAttribute("difficulties", DifficultyLevel.values());
        model.addAttribute("selectedQuestionLang", result.getQuestionLang());
        model.addAttribute("selectedChoiceLang", result.getChoiceLang());
        return "admin/question-transform/form";
    }

    /**
     * 삭제
     */
    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        service.delete(id);
        redirectAttributes.addFlashAttribute("message", "삭제되었습니다.");
        return "redirect:/admin/question-transform";
    }

    private void addCommonAttributes(Model model, String title, String active, String lang) {
        model.addAttribute("title", title);
        model.addAttribute("pageTitle", title);
        model.addAttribute("active", active);
        model.addAttribute("adminLang", lang);

        // DB에서 메뉴 로드
        List<MenuRes> adminMenus = menuService.list(lang, "admin", true);
        if (adminMenus.isEmpty() && !"ko".equals(lang)) {
            adminMenus = menuService.list("ko", "admin", true);
        }
        model.addAttribute("adminMenus", adminMenus);
    }
}
