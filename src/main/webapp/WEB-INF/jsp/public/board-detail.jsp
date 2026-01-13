<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags" %>

<layout:layout-public pageTitle="${post.title}" pageClass="board-detail-page">

<style>
  .post-header {
    border-bottom: 2px solid #333;
    padding-bottom: 20px;
    margin-bottom: 30px;
  }
  .post-title {
    font-size: 2em;
    font-weight: bold;
    margin-bottom: 10px;
    color: var(--text-primary);
  }
  .post-meta {
    color: #666;
    font-size: 0.9em;
  }
  .post-content {
    line-height: 1.8;
    font-size: 1.05em;
    color: var(--text-secondary);
  }
  .post-content img {
    max-width: 100%;
    height: auto;
  }
  .btn-back {
    display: inline-block;
    margin-top: 30px;
    padding: 10px 20px;
    background: var(--primary);
    color: white;
    text-decoration: none;
    border-radius: 4px;
    transition: background 0.2s;
  }
  .btn-back:hover {
    background: var(--primary-dark);
  }

  /* Attachments Section */
  .attachments-section {
    margin-top: 30px;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 8px;
    border: 1px solid #e9ecef;
  }
  .attachments-title {
    font-size: 1rem;
    font-weight: 600;
    margin-bottom: 12px;
    color: var(--text-primary);
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .attachment-list {
    list-style: none;
    padding: 0;
    margin: 0;
  }
  .attachment-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 10px 12px;
    background: white;
    border: 1px solid #e0e0e0;
    border-radius: 6px;
    margin-bottom: 8px;
  }
  .attachment-item:last-child {
    margin-bottom: 0;
  }
  .attachment-info {
    display: flex;
    align-items: center;
    gap: 10px;
    flex: 1;
    min-width: 0;
  }
  .attachment-icon {
    width: 32px;
    height: 32px;
    background: #e3f2fd;
    border-radius: 6px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #1976d2;
    font-size: 14px;
    flex-shrink: 0;
  }
  .attachment-name {
    font-size: 0.9rem;
    color: #333;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .attachment-size {
    font-size: 0.8rem;
    color: #888;
    flex-shrink: 0;
    margin-left: 8px;
  }
  .attachment-download {
    padding: 6px 12px;
    background: var(--primary);
    color: white;
    text-decoration: none;
    border-radius: 4px;
    font-size: 0.8rem;
    flex-shrink: 0;
    transition: background 0.2s;
  }
  .attachment-download:hover {
    background: var(--primary-dark);
  }

  /* Comments Section */
  .comments-section {
    margin-top: 50px;
    padding-top: 30px;
    border-top: 1px solid #e0e0e0;
  }
  .comments-title {
    font-size: 1.2em;
    font-weight: 600;
    margin-bottom: 20px;
    color: var(--text-primary);
  }
  .comment-form {
    background: #f8f9fa;
    padding: 16px;
    border-radius: 8px;
    margin-bottom: 20px;
  }
  .comment-form-row {
    display: flex;
    gap: 10px;
    margin-bottom: 10px;
  }
  .comment-form input[type="text"],
  .comment-form input[type="password"] {
    flex: 1;
    padding: 8px 12px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 13px;
  }
  .comment-form textarea {
    width: 100%;
    padding: 8px 12px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 13px;
    min-height: 60px;
    resize: vertical;
  }
  .comment-form button {
    padding: 8px 16px;
    background: var(--primary);
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 13px;
  }
  .comment-form button:hover {
    background: var(--primary-dark);
  }

  /* Comment List Container */
  .comment-list-container {
    max-height: 600px;
    overflow-y: auto;
    padding-right: 8px;
  }
  .comment-list-container::-webkit-scrollbar {
    width: 6px;
  }
  .comment-list-container::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 3px;
  }
  .comment-list-container::-webkit-scrollbar-thumb {
    background: #c1c1c1;
    border-radius: 3px;
  }
  .comment-list-container::-webkit-scrollbar-thumb:hover {
    background: #a1a1a1;
  }

  .comment-list {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  /* Comment Item - Lighter style */
  .comment-item {
    padding: 14px 16px;
    margin-bottom: 8px;
    background: #fff;
    border: 1px solid #e8e8e8;
    border-radius: 8px;
  }
  .comment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 6px;
  }
  .comment-author-info {
    display: flex;
    align-items: center;
    gap: 6px;
  }
  .comment-author {
    font-weight: 500;
    color: #333;
    font-size: 0.9rem;
  }
  .comment-date {
    font-size: 0.8em;
    color: #aaa;
  }
  .comment-content {
    color: #555;
    line-height: 1.5;
    white-space: pre-wrap;
    font-size: 0.9rem;
  }
  .comment-content.deleted {
    color: #aaa;
    font-style: italic;
  }
  /* Admin: Deleted comment styling */
  .comment-item.admin-deleted {
    background: #fff5f5;
    border-color: #fed7d7;
  }
  .deleted-badge {
    display: inline-block;
    padding: 2px 6px;
    background: #fee2e2;
    color: #dc2626;
    font-size: 0.7rem;
    border-radius: 4px;
    margin-left: 6px;
  }
  .comment-actions {
    margin-top: 8px;
    display: flex;
    gap: 8px;
  }
  .comment-actions button {
    background: none;
    border: none;
    color: #888;
    cursor: pointer;
    font-size: 0.8em;
    padding: 2px 6px;
    border-radius: 3px;
    transition: all 0.2s;
  }
  .comment-actions button:hover {
    background: #f0f0f0;
    color: var(--primary);
  }
  .comment-actions button.btn-admin-delete {
    color: #dc2626;
  }
  .comment-actions button.btn-admin-delete:hover {
    background: #fef2f2;
  }

  /* Reply Toggle Button */
  .reply-toggle {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    margin-top: 10px;
    padding: 4px 10px;
    background: #f5f5f5;
    border: none;
    border-radius: 4px;
    color: #666;
    font-size: 0.8rem;
    cursor: pointer;
    transition: all 0.2s;
  }
  .reply-toggle:hover {
    background: #eee;
    color: #333;
  }
  .reply-toggle .arrow {
    transition: transform 0.2s;
    font-size: 10px;
  }
  .reply-toggle.open .arrow {
    transform: rotate(180deg);
  }

  /* Reply List - Indented */
  .reply-list {
    list-style: none;
    margin: 10px 0 0 0;
    padding: 0 0 0 20px;
    border-left: 2px solid #e0e0e0;
    display: none;
  }
  .reply-list.show {
    display: block;
  }
  .reply-list .comment-item {
    background: #fafbfc;
    border-color: #e8e8e8;
    padding: 12px 14px;
    margin-bottom: 6px;
    margin-left: 0;
  }
  .reply-badge {
    display: inline-block;
    padding: 1px 6px;
    background: #e3f2fd;
    color: #1976d2;
    font-size: 0.7rem;
    border-radius: 8px;
    font-weight: 500;
  }

  /* Reply Form */
  .reply-form {
    margin-top: 12px;
    margin-left: 20px;
    padding: 12px;
    background: #f5f7f9;
    border-radius: 6px;
    border: 1px solid #e2e8f0;
  }
  .reply-form input,
  .reply-form textarea {
    padding: 8px 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 13px;
    width: 100%;
    box-sizing: border-box;
    margin-bottom: 8px;
  }
  .reply-form textarea {
    min-height: 50px;
    resize: vertical;
  }
  .reply-form-buttons {
    display: flex;
    justify-content: flex-end;
    gap: 6px;
  }
  .reply-form-buttons button {
    padding: 6px 12px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 12px;
  }
  .reply-form-buttons .btn-cancel {
    background: #e5e5e5;
    color: #555;
  }
  .reply-form-buttons .btn-submit {
    background: var(--primary);
    color: white;
  }

  .no-comments {
    text-align: center;
    padding: 30px 20px;
    color: #aaa;
    background: #f9fafb;
    border-radius: 8px;
    font-size: 0.9rem;
  }
  .comments-disabled {
    text-align: center;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 8px;
    color: #666;
    font-size: 0.9rem;
  }

  /* Comment Modal */
  .comment-modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    z-index: 9999;
    align-items: center;
    justify-content: center;
  }
  .comment-modal.active {
    display: flex;
  }
  .comment-modal-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
  }
  .comment-modal-content {
    position: relative;
    background: white;
    padding: 24px;
    border-radius: 10px;
    max-width: 360px;
    width: 90%;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
    animation: modalSlideIn 0.25s ease;
  }
  @keyframes modalSlideIn {
    from { opacity: 0; transform: translateY(-20px); }
    to { opacity: 1; transform: translateY(0); }
  }
  .comment-modal-title {
    font-size: 1.1rem;
    font-weight: 600;
    margin-bottom: 16px;
    color: #1f2937;
  }
  .comment-modal-input {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #d1d5db;
    border-radius: 6px;
    font-size: 0.95rem;
    margin-bottom: 12px;
    box-sizing: border-box;
  }
  .comment-modal-input:focus {
    outline: none;
    border-color: var(--primary);
  }
  .comment-modal-buttons {
    display: flex;
    gap: 8px;
    justify-content: flex-end;
  }
  .comment-modal-buttons button {
    padding: 8px 16px;
    border: none;
    border-radius: 6px;
    font-size: 0.9rem;
    cursor: pointer;
  }
  .comment-modal-buttons .btn-cancel {
    background: #f3f4f6;
    color: #4b5563;
  }
  .comment-modal-buttons .btn-confirm {
    background: var(--primary);
    color: white;
  }
  .comment-modal-buttons .btn-danger {
    background: #dc2626;
    color: white;
  }

  /* Alert Modal */
  .alert-modal-icon {
    width: 50px;
    height: 50px;
    margin: 0 auto 16px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .alert-modal-icon.success {
    background: #dcfce7;
    color: #16a34a;
  }
  .alert-modal-icon.error {
    background: #fef2f2;
    color: #dc2626;
  }
  .alert-modal-icon svg {
    width: 24px;
    height: 24px;
  }
  .alert-modal-message {
    text-align: center;
    color: #4b5563;
    margin-bottom: 16px;
    font-size: 0.9rem;
  }

  @media (max-width: 768px) {
    .comment-form-row {
      flex-direction: column;
    }
    .comment-list-container {
      max-height: 400px;
    }
    .reply-list {
      margin-left: 12px;
      padding-left: 12px;
    }
    .reply-form {
      margin-left: 12px;
    }
  }
</style>

<main class="content-wrapper">
  <div class="container">
    <div class="post-header">
      <h1 class="post-title">${post.title}</h1>
      <div class="post-meta">
        ${lang == 'ko' ? '조회' : 'Views'} ${post.viewCount} · ${post.publishedAt}
      </div>
    </div>

    <div class="post-content">
      ${post.content}
    </div>

    <!-- Attachments Section -->
    <c:if test="${not empty attachments}">
      <div class="attachments-section">
        <h3 class="attachments-title">
          📎 ${lang == 'ko' ? '첨부파일' : 'Attachments'} (${attachments.size()})
        </h3>
        <ul class="attachment-list">
          <c:forEach var="file" items="${attachments}">
            <li class="attachment-item">
              <div class="attachment-info">
                <div class="attachment-icon">📄</div>
                <span class="attachment-name">${file.originalName}</span>
                <span class="attachment-size">
                  <c:choose>
                    <c:when test="${file.fileSize >= 1048576}">
                      <fmt:formatNumber value="${file.fileSize / 1048576.0}" maxFractionDigits="1"/> MB
                    </c:when>
                    <c:otherwise>
                      <fmt:formatNumber value="${file.fileSize / 1024.0}" maxFractionDigits="1"/> KB
                    </c:otherwise>
                  </c:choose>
                </span>
              </div>
              <a href="${file.url}" class="attachment-download" download="${file.originalName}">
                ${lang == 'ko' ? '다운로드' : 'Download'}
              </a>
            </li>
          </c:forEach>
        </ul>
      </div>
    </c:if>

    <!-- Comments Section -->
    <div class="comments-section">
      <h2 class="comments-title">
        ${lang == 'ko' ? '댓글' : 'Comments'} <span id="commentCount">(0)</span>
      </h2>

      <c:choose>
        <c:when test="${post.commentsEnabled}">
          <!-- Comment Form -->
          <div class="comment-form" id="mainCommentForm">
            <div class="comment-form-row">
              <input type="text" id="authorName" placeholder="${lang == 'ko' ? '이름' : 'Name'}" required maxlength="50"/>
              <input type="password" id="password" placeholder="${lang == 'ko' ? '비밀번호' : 'Password'}" maxlength="20"/>
            </div>
            <textarea id="commentContent" placeholder="${lang == 'ko' ? '댓글을 입력하세요' : 'Write a comment'}" required></textarea>
            <div style="margin-top: 10px; text-align: right;">
              <button type="button" onclick="submitComment()">
                ${lang == 'ko' ? '댓글 작성' : 'Submit'}
              </button>
            </div>
          </div>

          <!-- Comment List -->
          <div class="comment-list-container">
            <ul class="comment-list" id="commentList">
              <!-- Comments will be loaded here -->
            </ul>
          </div>
          <div class="no-comments" id="noComments" style="display: none;">
            ${lang == 'ko' ? '첫 번째 댓글을 작성해보세요!' : 'Be the first to comment!'}
          </div>
        </c:when>
        <c:otherwise>
          <div class="comments-disabled">
            ${lang == 'ko' ? '이 게시글은 댓글이 비활성화되어 있습니다.' : 'Comments are disabled for this post.'}
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <a href="/${lang}/board/${categoryKey}" class="btn-back">
      &larr; ${lang == 'ko' ? '목록으로' : 'Back to List'}
    </a>
  </div>
</main>

<!-- Comment Modal -->
<div class="comment-modal" id="commentModal">
  <div class="comment-modal-overlay" onclick="closeCommentModal()"></div>
  <div class="comment-modal-content">
    <h3 class="comment-modal-title" id="modalTitle"></h3>
    <div id="modalBody"></div>
    <div class="comment-modal-buttons" id="modalButtons"></div>
  </div>
</div>

<!-- Alert Modal -->
<div class="comment-modal" id="alertModal">
  <div class="comment-modal-overlay" onclick="closeAlertModal()"></div>
  <div class="comment-modal-content">
    <div class="alert-modal-icon" id="alertIcon"></div>
    <div class="alert-modal-message" id="alertMessage"></div>
    <div class="comment-modal-buttons">
      <button class="btn-confirm" onclick="closeAlertModal()">${lang == 'ko' ? '확인' : 'OK'}</button>
    </div>
  </div>
</div>

<c:if test="${post.commentsEnabled}">
<script>
var postId = ${post.id};
var lang = '${lang}';
var isAdmin = ${isAdmin};

var i18n = {
  reply: lang === 'ko' ? '답글' : 'Reply',
  replyBadge: lang === 'ko' ? '답글' : 'Reply',
  showReplies: lang === 'ko' ? '답글 보기' : 'Show replies',
  hideReplies: lang === 'ko' ? '답글 접기' : 'Hide replies',
  edit: lang === 'ko' ? '수정' : 'Edit',
  delete: lang === 'ko' ? '삭제' : 'Delete',
  adminDelete: lang === 'ko' ? '관리자 삭제' : 'Admin Delete',
  cancel: lang === 'ko' ? '취소' : 'Cancel',
  submit: lang === 'ko' ? '등록' : 'Submit',
  save: lang === 'ko' ? '저장' : 'Save',
  confirm: lang === 'ko' ? '확인' : 'Confirm',
  name: lang === 'ko' ? '이름' : 'Name',
  password: lang === 'ko' ? '비밀번호' : 'Password',
  content: lang === 'ko' ? '내용' : 'Content',
  enterPassword: lang === 'ko' ? '비밀번호를 입력하세요' : 'Enter password',
  editComment: lang === 'ko' ? '댓글 수정' : 'Edit Comment',
  deleteComment: lang === 'ko' ? '댓글 삭제' : 'Delete Comment',
  confirmDelete: lang === 'ko' ? '이 댓글을 삭제하시겠습니까?' : 'Delete this comment?',
  adminConfirmDelete: lang === 'ko' ? '관리자 권한으로 이 댓글을 삭제하시겠습니까?' : 'Delete this comment as admin?',
  deleted: lang === 'ko' ? '삭제된 댓글입니다.' : 'This comment has been deleted.',
  success: lang === 'ko' ? '완료되었습니다.' : 'Completed successfully.',
  error: lang === 'ko' ? '오류가 발생했습니다.' : 'An error occurred.',
  wrongPassword: lang === 'ko' ? '비밀번호가 일치하지 않습니다.' : 'Incorrect password.',
  fillRequired: lang === 'ko' ? '이름과 내용을 입력해주세요.' : 'Please enter name and content.'
};

document.addEventListener('DOMContentLoaded', loadComments);

function loadComments() {
  fetch('/api/comments/post/' + postId)
    .then(function(res) { return res.json(); })
    .then(function(data) {
      if (data.ok) {
        renderComments(data.data);
      }
    })
    .catch(function(err) { console.error('Failed to load comments:', err); });
}

function renderComments(comments) {
  var list = document.getElementById('commentList');
  var noComments = document.getElementById('noComments');
  var countEl = document.getElementById('commentCount');

  // 일반 사용자: 삭제된 댓글 필터링, 관리자: 모든 댓글 표시
  var filteredComments = filterDeletedComments(comments);

  var total = 0;
  function countAll(cmts) {
    cmts.forEach(function(c) {
      if (!c.isDeleted) total++;
      if (c.replies && c.replies.length > 0) countAll(c.replies);
    });
  }
  countAll(filteredComments);
  countEl.textContent = '(' + total + ')';

  if (filteredComments.length === 0) {
    list.innerHTML = '';
    noComments.style.display = 'block';
    return;
  }

  noComments.style.display = 'none';
  list.innerHTML = filteredComments.map(function(c) { return renderComment(c, false); }).join('');
}

// 삭제된 댓글 필터링 (사용자 페이지에서는 항상 삭제된 댓글 숨김)
function filterDeletedComments(comments) {
  return comments.map(function(c) {
    var comment = Object.assign({}, c);
    // 답글도 필터링
    if (comment.replies && comment.replies.length > 0) {
      comment.replies = filterDeletedComments(comment.replies);
    }
    return comment;
  }).filter(function(c) {
    // 사용자 페이지에서는 삭제된 댓글 항상 숨김
    return !c.isDeleted;
  });
}

function renderComment(comment, isReply) {
  var dateStr = new Date(comment.createdAt).toLocaleDateString();

  // 관리자: 삭제된 댓글도 원본 내용 표시
  // 일반 사용자: 삭제된 댓글은 필터링되어 여기까지 오지 않음
  var contentClass = 'comment-content';
  var contentText = escapeHtml(comment.content);
  var itemClass = 'comment-item';
  var deletedBadgeHtml = '';

  if (comment.isDeleted && isAdmin) {
    // 관리자에게 삭제된 댓글 표시 (원본 내용 + 삭제됨 배지)
    itemClass += ' admin-deleted';
    deletedBadgeHtml = '<span class="deleted-badge">' + (lang === 'ko' ? '삭제됨' : 'Deleted') + '</span>';
  }

  // Reply toggle and list
  var replyToggleHtml = '';
  var repliesHtml = '';
  if (!isReply && comment.replies && comment.replies.length > 0) {
    var replyCount = comment.replies.filter(function(r) { return isAdmin || !r.isDeleted; }).length;
    if (replyCount > 0) {
      replyToggleHtml = '<button class="reply-toggle" onclick="toggleReplies(' + comment.id + ', this)">' +
        '<span class="arrow">&#9660;</span> ' + i18n.showReplies + ' (' + replyCount + ')' +
        '</button>';
      repliesHtml = '<ul class="reply-list" id="replies-' + comment.id + '">' +
        comment.replies.map(function(r) { return renderComment(r, true); }).join('') +
        '</ul>';
    }
  }

  var badgeHtml = isReply ? '<span class="reply-badge">' + i18n.replyBadge + '</span>' : '';

  var actionsHtml = '';
  if (!comment.isDeleted) {
    actionsHtml = '<div class="comment-actions">';
    if (!isReply) {
      actionsHtml += '<button onclick="showReplyForm(' + comment.id + ')">' + i18n.reply + '</button>';
    }
    actionsHtml += '<button onclick="showEditModal(' + comment.id + ')">' + i18n.edit + '</button>';
    actionsHtml += '<button onclick="showDeleteModal(' + comment.id + ')">' + i18n.delete + '</button>';
    if (isAdmin) {
      actionsHtml += '<button class="btn-admin-delete" onclick="showAdminDeleteModal(' + comment.id + ')">' + i18n.adminDelete + '</button>';
    }
    actionsHtml += '</div>';
  }

  return '<li class="' + itemClass + '" id="comment-' + comment.id + '" data-content="' + escapeAttr(comment.content) + '">' +
    '<div class="comment-header">' +
    '<div class="comment-author-info">' +
    '<span class="comment-author">' + escapeHtml(comment.authorName) + '</span>' +
    badgeHtml +
    deletedBadgeHtml +
    '</div>' +
    '<span class="comment-date">' + dateStr + '</span>' +
    '</div>' +
    '<div class="' + contentClass + '" id="content-' + comment.id + '">' + contentText + '</div>' +
    actionsHtml +
    '<div id="reply-form-' + comment.id + '"></div>' +
    replyToggleHtml +
    repliesHtml +
    '</li>';
}

function toggleReplies(commentId, btn) {
  var replyList = document.getElementById('replies-' + commentId);
  var isOpen = replyList.classList.contains('show');

  if (isOpen) {
    replyList.classList.remove('show');
    btn.classList.remove('open');
    btn.innerHTML = '<span class="arrow">&#9660;</span> ' + i18n.showReplies + ' (' + replyList.children.length + ')';
  } else {
    replyList.classList.add('show');
    btn.classList.add('open');
    btn.innerHTML = '<span class="arrow">&#9660;</span> ' + i18n.hideReplies;
  }
}

function submitComment(parentId) {
  parentId = parentId || null;
  var nameInput = parentId ? document.getElementById('reply-name-' + parentId) : document.getElementById('authorName');
  var pwInput = parentId ? document.getElementById('reply-pw-' + parentId) : document.getElementById('password');
  var contentInput = parentId ? document.getElementById('reply-content-' + parentId) : document.getElementById('commentContent');

  var authorName = nameInput.value.trim();
  var pw = pwInput.value;
  var contentVal = contentInput.value.trim();

  if (!authorName || !contentVal) {
    showAlert('error', i18n.fillRequired);
    return;
  }

  fetch('/api/comments', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      postId: postId,
      parentId: parentId,
      authorName: authorName,
      password: pw,
      content: contentVal
    })
  })
  .then(function(res) { return res.json(); })
  .then(function(data) {
    if (data.ok) {
      if (!parentId) {
        nameInput.value = '';
        pwInput.value = '';
        contentInput.value = '';
      } else {
        hideReplyForm(parentId);
      }
      loadComments();
      showAlert('success', i18n.success);
    } else {
      showAlert('error', data.message || i18n.error);
    }
  })
  .catch(function(err) {
    console.error('Error:', err);
    showAlert('error', i18n.error);
  });
}

function showReplyForm(parentId) {
  var container = document.getElementById('reply-form-' + parentId);
  container.innerHTML = '<div class="reply-form">' +
    '<input type="text" id="reply-name-' + parentId + '" placeholder="' + i18n.name + '" required maxlength="50"/>' +
    '<input type="password" id="reply-pw-' + parentId + '" placeholder="' + i18n.password + '" maxlength="20"/>' +
    '<textarea id="reply-content-' + parentId + '" placeholder="' + i18n.content + '" required></textarea>' +
    '<div class="reply-form-buttons">' +
    '<button type="button" class="btn-cancel" onclick="hideReplyForm(' + parentId + ')">' + i18n.cancel + '</button>' +
    '<button type="button" class="btn-submit" onclick="submitComment(' + parentId + ')">' + i18n.submit + '</button>' +
    '</div>' +
    '</div>';
}

function hideReplyForm(parentId) {
  document.getElementById('reply-form-' + parentId).innerHTML = '';
}

// ===== Edit Flow =====
function showEditModal(commentId) {
  var modal = document.getElementById('commentModal');
  document.getElementById('modalTitle').textContent = i18n.enterPassword;
  document.getElementById('modalBody').innerHTML = '<input type="password" class="comment-modal-input" id="editPasswordInput" placeholder="' + i18n.password + '" />';
  document.getElementById('modalButtons').innerHTML =
    '<button class="btn-cancel" onclick="closeCommentModal()">' + i18n.cancel + '</button>' +
    '<button class="btn-confirm" onclick="verifyPasswordForEdit(' + commentId + ')">' + i18n.confirm + '</button>';
  modal.classList.add('active');
  document.getElementById('editPasswordInput').focus();
}

function verifyPasswordForEdit(commentId) {
  var password = document.getElementById('editPasswordInput').value;
  var commentEl = document.getElementById('comment-' + commentId);
  var currentContent = commentEl.getAttribute('data-content') || '';

  document.getElementById('modalTitle').textContent = i18n.editComment;
  document.getElementById('modalBody').innerHTML =
    '<input type="hidden" id="editCommentPassword" value="' + escapeAttr(password) + '" />' +
    '<textarea class="comment-modal-input" id="editContentInput" style="min-height: 80px;">' + escapeHtml(currentContent) + '</textarea>';
  document.getElementById('modalButtons').innerHTML =
    '<button class="btn-cancel" onclick="closeCommentModal()">' + i18n.cancel + '</button>' +
    '<button class="btn-confirm" onclick="submitEdit(' + commentId + ')">' + i18n.save + '</button>';
  document.getElementById('editContentInput').focus();
}

function submitEdit(commentId) {
  var password = document.getElementById('editCommentPassword').value;
  var newContent = document.getElementById('editContentInput').value.trim();

  if (!newContent) {
    showAlert('error', i18n.fillRequired);
    return;
  }

  fetch('/api/comments/' + commentId, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ content: newContent, password: password })
  })
  .then(function(res) { return res.json(); })
  .then(function(data) {
    closeCommentModal();
    if (data.ok) {
      loadComments();
      showAlert('success', i18n.success);
    } else {
      showAlert('error', data.message || i18n.wrongPassword);
    }
  })
  .catch(function(err) {
    closeCommentModal();
    showAlert('error', i18n.error);
  });
}

// ===== Delete Flow =====
function showDeleteModal(commentId) {
  var modal = document.getElementById('commentModal');
  document.getElementById('modalTitle').textContent = i18n.deleteComment;
  document.getElementById('modalBody').innerHTML =
    '<p style="margin-bottom: 12px; color: #555; font-size: 0.9rem;">' + i18n.confirmDelete + '</p>' +
    '<input type="password" class="comment-modal-input" id="deletePasswordInput" placeholder="' + i18n.password + '" />';
  document.getElementById('modalButtons').innerHTML =
    '<button class="btn-cancel" onclick="closeCommentModal()">' + i18n.cancel + '</button>' +
    '<button class="btn-danger" onclick="submitDelete(' + commentId + ')">' + i18n.delete + '</button>';
  modal.classList.add('active');
  document.getElementById('deletePasswordInput').focus();
}

function submitDelete(commentId) {
  var password = document.getElementById('deletePasswordInput').value;

  fetch('/api/comments/' + commentId + '?password=' + encodeURIComponent(password), {
    method: 'DELETE'
  })
  .then(function(res) { return res.json(); })
  .then(function(data) {
    closeCommentModal();
    if (data.ok) {
      loadComments();
      showAlert('success', i18n.success);
    } else {
      showAlert('error', data.message || i18n.wrongPassword);
    }
  })
  .catch(function(err) {
    closeCommentModal();
    showAlert('error', i18n.error);
  });
}

// ===== Admin Delete =====
function showAdminDeleteModal(commentId) {
  var modal = document.getElementById('commentModal');
  document.getElementById('modalTitle').textContent = i18n.adminDelete;
  document.getElementById('modalBody').innerHTML =
    '<p style="color: #555; font-size: 0.9rem;">' + i18n.adminConfirmDelete + '</p>';
  document.getElementById('modalButtons').innerHTML =
    '<button class="btn-cancel" onclick="closeCommentModal()">' + i18n.cancel + '</button>' +
    '<button class="btn-danger" onclick="submitAdminDelete(' + commentId + ')">' + i18n.delete + '</button>';
  modal.classList.add('active');
}

function submitAdminDelete(commentId) {
  fetch('/api/comments/admin/' + commentId, {
    method: 'DELETE'
  })
  .then(function(res) { return res.json(); })
  .then(function(data) {
    closeCommentModal();
    if (data.ok) {
      loadComments();
      showAlert('success', i18n.success);
    } else {
      showAlert('error', data.message || i18n.error);
    }
  })
  .catch(function(err) {
    closeCommentModal();
    showAlert('error', i18n.error);
  });
}

// ===== Modal Helpers =====
function closeCommentModal() {
  document.getElementById('commentModal').classList.remove('active');
}

function showAlert(type, message) {
  var alertModal = document.getElementById('alertModal');
  var icon = document.getElementById('alertIcon');
  var msg = document.getElementById('alertMessage');

  icon.className = 'alert-modal-icon ' + type;
  if (type === 'success') {
    icon.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>';
  } else {
    icon.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>';
  }
  msg.textContent = message;
  alertModal.classList.add('active');
}

function closeAlertModal() {
  document.getElementById('alertModal').classList.remove('active');
}

function escapeHtml(text) {
  var div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

function escapeAttr(text) {
  return String(text || '').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
}
</script>
</c:if>

</layout:layout-public>
