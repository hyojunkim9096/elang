package com.elang.camp.domain.cms.board;

import com.elang.camp.domain.cms.board.dto.BoardCommentReq;
import com.elang.camp.domain.cms.board.dto.BoardCommentRes;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BoardCommentService {

    private final BoardCommentRepository commentRepository;
    private final BoardPostRepository postRepository;
    private final PasswordEncoder passwordEncoder;

    /**
     * 게시글의 댓글 목록 조회 (계층 구조)
     */
    @Transactional(readOnly = true)
    public List<BoardCommentRes> listByPostId(Long postId) {
        List<BoardComment> allComments = commentRepository.findByPostIdOrderByCreatedAtAsc(postId);

        // 댓글을 parentId별로 그룹화
        Map<Long, List<BoardComment>> childrenMap = allComments.stream()
                .filter(c -> c.getParentId() != null)
                .collect(Collectors.groupingBy(BoardComment::getParentId));

        // 루트 댓글만 추출하여 계층 구조로 변환
        return allComments.stream()
                .filter(c -> c.getParentId() == null)
                .map(c -> toResWithReplies(c, childrenMap))
                .toList();
    }

    /**
     * 댓글 생성
     */
    @Transactional
    public BoardCommentRes create(BoardCommentReq req) {
        // 게시글 댓글 허용 여부 확인
        BoardPost post = postRepository.findById(req.getPostId())
                .orElseThrow(() -> new IllegalArgumentException("게시글을 찾을 수 없습니다."));

        if (!post.getCommentsEnabled()) {
            throw new IllegalStateException("이 게시글은 댓글이 허용되지 않습니다.");
        }

        BoardComment comment = new BoardComment();
        comment.setPostId(req.getPostId());
        comment.setParentId(req.getParentId());
        comment.setAuthorName(req.getAuthorName());
        comment.setAuthorEmail(req.getAuthorEmail());
        comment.setContent(req.getContent());

        // 비밀번호 암호화
        if (req.getPassword() != null && !req.getPassword().isEmpty()) {
            comment.setPassword(passwordEncoder.encode(req.getPassword()));
        }

        BoardComment saved = commentRepository.save(comment);
        return toRes(saved);
    }

    /**
     * 댓글 수정
     */
    @Transactional
    public BoardCommentRes update(Long id, String content, String password) {
        BoardComment comment = commentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("댓글을 찾을 수 없습니다."));

        // 비밀번호 확인 (저장된 비밀번호가 있는 경우에만)
        if (!verifyPassword(comment.getPassword(), password)) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }

        comment.setContent(content);
        return toRes(comment);
    }

    /**
     * 댓글 삭제 (소프트 삭제)
     */
    @Transactional
    public void delete(Long id, String password) {
        BoardComment comment = commentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("댓글을 찾을 수 없습니다."));

        // 비밀번호 확인 (저장된 비밀번호가 있는 경우에만)
        if (!verifyPassword(comment.getPassword(), password)) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }

        // 대댓글이 있으면 소프트 삭제, 없으면 하드 삭제
        List<BoardComment> replies = commentRepository.findByParentIdOrderByCreatedAtAsc(id);
        if (!replies.isEmpty()) {
            comment.setIsDeleted(true);
            comment.setContent("삭제된 댓글입니다.");
        } else {
            commentRepository.delete(comment);
        }
    }

    /**
     * 비밀번호 검증
     */
    private boolean verifyPassword(String storedPassword, String inputPassword) {
        // 저장된 비밀번호가 없으면 통과
        if (storedPassword == null || storedPassword.isEmpty()) {
            return true;
        }
        // 입력된 비밀번호가 없으면 실패
        if (inputPassword == null || inputPassword.isEmpty()) {
            return false;
        }
        // BCrypt 해시인지 확인 (BCrypt는 $2로 시작)
        if (!storedPassword.startsWith("$2")) {
            // BCrypt가 아니면 평문 비교 (레거시 데이터 대응)
            return storedPassword.equals(inputPassword);
        }
        // BCrypt로 비교
        return passwordEncoder.matches(inputPassword, storedPassword);
    }

    /**
     * 관리자용 댓글 삭제 (비밀번호 확인 없음)
     */
    @Transactional
    public void deleteByAdmin(Long id) {
        BoardComment comment = commentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("댓글을 찾을 수 없습니다."));

        List<BoardComment> replies = commentRepository.findByParentIdOrderByCreatedAtAsc(id);
        if (!replies.isEmpty()) {
            comment.setIsDeleted(true);
            comment.setContent("삭제된 댓글입니다.");
        } else {
            commentRepository.delete(comment);
        }
    }

    /**
     * 게시글의 댓글 수 조회
     */
    @Transactional(readOnly = true)
    public long countByPostId(Long postId) {
        return commentRepository.countByPostId(postId);
    }

    private BoardCommentRes toRes(BoardComment comment) {
        return BoardCommentRes.builder()
                .id(comment.getId())
                .postId(comment.getPostId())
                .parentId(comment.getParentId())
                .authorName(comment.getAuthorName())
                .content(comment.getContent())
                .isDeleted(comment.getIsDeleted())
                .createdAt(comment.getCreatedAt())
                .updatedAt(comment.getUpdatedAt())
                .replies(new ArrayList<>())
                .build();
    }

    private BoardCommentRes toResWithReplies(BoardComment comment, Map<Long, List<BoardComment>> childrenMap) {
        List<BoardCommentRes> replies = childrenMap.getOrDefault(comment.getId(), new ArrayList<>())
                .stream()
                .map(c -> toResWithReplies(c, childrenMap))
                .toList();

        return BoardCommentRes.builder()
                .id(comment.getId())
                .postId(comment.getPostId())
                .parentId(comment.getParentId())
                .authorName(comment.getAuthorName())
                .content(comment.getContent())
                .isDeleted(comment.getIsDeleted())
                .createdAt(comment.getCreatedAt())
                .updatedAt(comment.getUpdatedAt())
                .replies(replies)
                .build();
    }
}
