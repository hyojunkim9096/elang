package com.elang.camp.domain.cms.board;

import com.elang.camp.common.exception.NotFoundException;
import com.elang.camp.domain.cms.board.dto.BoardPostRes;
import com.elang.camp.domain.cms.board.dto.BoardPostUpsertReq;
import com.elang.camp.domain.file.AttachFile;
import com.elang.camp.domain.file.AttachFileService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BoardPostService {

    private final BoardPostRepository boardPostRepository;
    private final AttachFileService attachFileService;

    public List<BoardPostRes> listByCategoryId(Long categoryId, Boolean enabledOnly) {
        if (enabledOnly != null && enabledOnly) {
            return boardPostRepository.findByCategoryIdAndEnabledOrderByIsPinnedDescPublishedAtDesc(categoryId, true)
                .stream()
                .map(BoardPostRes::from)
                .collect(Collectors.toList());
        }
        return boardPostRepository.findByCategoryIdOrderByIsPinnedDescPublishedAtDesc(categoryId)
            .stream()
            .map(BoardPostRes::from)
            .collect(Collectors.toList());
    }

    public List<BoardPostRes> listByCategoryIdAndLang(Long categoryId, String lang) {
        return boardPostRepository.findByCategoryIdAndLangAndEnabledOrderByIsPinnedDescPublishedAtDesc(categoryId, lang, true)
            .stream()
            .map(BoardPostRes::from)
            .collect(Collectors.toList());
    }

    public BoardPostRes getById(Long id) {
        BoardPost post = boardPostRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("BoardPost not found: " + id));
        return BoardPostRes.from(post);
    }

    @Transactional
    public BoardPostRes create(BoardPostUpsertReq req) {
        log.debug("Creating board post - thumbnail: {}, attachmentIds: {}",
                  req.getThumbnail(), req.getAttachmentIds());

        BoardPost post = new BoardPost();
        post.setCategoryId(req.getCategoryId());
        post.setLang(req.getLang());
        post.setTitle(req.getTitle());
        post.setContent(req.getContent());
        post.setThumbnail(req.getThumbnail());
        post.setIsPinned(req.getIsPinned());
        post.setEnabled(req.getEnabled());
        post.setPublishedAt(req.getPublishedAt());

        log.debug("Before save - post.thumbnail: {}", post.getThumbnail());
        BoardPost saved = boardPostRepository.save(post);
        log.debug("After save - saved.thumbnail: {}", saved.getThumbnail());

        // 썸네일 파일이 있으면 attach_file에 reference 업데이트
        if (saved.getThumbnail() != null && !saved.getThumbnail().isEmpty()) {
            AttachFile thumbnailFile = attachFileService.getByUrl(saved.getThumbnail());
            if (thumbnailFile != null) {
                attachFileService.updateReference(thumbnailFile.getId(), "board_post_thumbnail", saved.getId());
                log.debug("Thumbnail file linked: fileId={}, postId={}", thumbnailFile.getId(), saved.getId());
            }
        }

        // 첨부파일들도 attach_file에 reference 업데이트
        if (req.getAttachmentIds() != null && !req.getAttachmentIds().isEmpty()) {
            String[] fileIds = req.getAttachmentIds().split(",");
            for (String fileIdStr : fileIds) {
                try {
                    Long fileId = Long.parseLong(fileIdStr.trim());
                    attachFileService.updateReference(fileId, "board_post_attachment", saved.getId());
                    log.debug("Attachment file linked: fileId={}, postId={}", fileId, saved.getId());
                } catch (NumberFormatException e) {
                    log.warn("Invalid fileId format: {}", fileIdStr);
                }
            }
        }

        return BoardPostRes.from(saved);
    }

    @Transactional
    public BoardPostRes update(Long id, BoardPostUpsertReq req) {
        log.debug("Updating board post - id: {}, thumbnail: {}, attachmentIds: {}",
                  id, req.getThumbnail(), req.getAttachmentIds());

        BoardPost post = boardPostRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("BoardPost not found: " + id));

        String oldThumbnail = post.getThumbnail();

        post.setLang(req.getLang());
        post.setTitle(req.getTitle());
        post.setContent(req.getContent());
        post.setThumbnail(req.getThumbnail());
        post.setIsPinned(req.getIsPinned());
        post.setEnabled(req.getEnabled());
        post.setPublishedAt(req.getPublishedAt());

        log.debug("Before save - post.thumbnail: {}", post.getThumbnail());
        BoardPost saved = boardPostRepository.save(post);
        log.debug("After save - saved.thumbnail: {}", saved.getThumbnail());

        // 썸네일이 변경되었으면 attach_file에 reference 업데이트
        if (saved.getThumbnail() != null && !saved.getThumbnail().isEmpty()) {
            if (oldThumbnail == null || !oldThumbnail.equals(saved.getThumbnail())) {
                // 새로운 썸네일로 변경됨
                AttachFile thumbnailFile = attachFileService.getByUrl(saved.getThumbnail());
                if (thumbnailFile != null) {
                    attachFileService.updateReference(thumbnailFile.getId(), "board_post_thumbnail", saved.getId());
                    log.debug("Thumbnail file linked: fileId={}, postId={}", thumbnailFile.getId(), saved.getId());
                }
            }
        }

        // 첨부파일 처리: 기존 첨부파일 reference 제거 후 새로운 첨부파일 연결
        // 1. 기존 첨부파일들의 reference 제거
        List<AttachFile> oldAttachments = attachFileService.listByReference("board_post_attachment", saved.getId());
        for (AttachFile oldFile : oldAttachments) {
            oldFile.setReferenceType(null);
            oldFile.setReferenceId(null);
            attachFileService.save(oldFile);
            log.debug("Old attachment unlinked: fileId={}", oldFile.getId());
        }

        // 2. 새로운 첨부파일들 연결
        if (req.getAttachmentIds() != null && !req.getAttachmentIds().isEmpty()) {
            String[] fileIds = req.getAttachmentIds().split(",");
            for (String fileIdStr : fileIds) {
                try {
                    Long fileId = Long.parseLong(fileIdStr.trim());
                    attachFileService.updateReference(fileId, "board_post_attachment", saved.getId());
                    log.debug("Attachment file linked: fileId={}, postId={}", fileId, saved.getId());
                } catch (NumberFormatException e) {
                    log.warn("Invalid fileId format: {}", fileIdStr);
                }
            }
        }

        return BoardPostRes.from(saved);
    }

    @Transactional
    public void delete(Long id) {
        if (!boardPostRepository.existsById(id)) {
            throw new NotFoundException("BoardPost not found: " + id);
        }
        boardPostRepository.deleteById(id);
    }

    @Transactional
    public void incrementViewCount(Long id) {
        BoardPost post = boardPostRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("BoardPost not found: " + id));
        post.setViewCount(post.getViewCount() + 1);
        boardPostRepository.save(post);
    }
}
