<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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

  /* Comments Section */
  .comments-section {
    margin-top: 50px;
    padding-top: 30px;
    border-top: 1px solid #e0e0e0;
  }
  .comments-title {
    font-size: 1.3em;
    font-weight: bold;
    margin-bottom: 20px;
    color: var(--text-primary);
  }
  .comment-form {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 8px;
    margin-bottom: 30px;
  }
  .comment-form-row {
    display: flex;
    gap: 10px;
    margin-bottom: 10px;
  }
  .comment-form input[type="text"],
  .comment-form input[type="email"],
  .comment-form input[type="password"] {
    flex: 1;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
  }
  .comment-form textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
    min-height: 80px;
    resize: vertical;
  }
  .comment-form button {
    padding: 10px 20px;
    background: var(--primary);
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
  }
  .comment-form button:hover {
    background: var(--primary-dark);
  }
  .comment-list {
    list-style: none;
    padding: 0;
    margin: 0;
  }
  .comment-item {
    padding: 15px 0;
    border-bottom: 1px solid #eee;
  }
  .comment-item:last-child {
    border-bottom: none;
  }
  .comment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
  }
  .comment-author {
    font-weight: bold;
    color: var(--text-primary);
  }
  .comment-date {
    font-size: 0.85em;
    color: #999;
  }
  .comment-content {
    color: var(--text-secondary);
    line-height: 1.6;
    white-space: pre-wrap;
  }
  .comment-content.deleted {
    color: #999;
    font-style: italic;
  }
  .comment-actions {
    margin-top: 8px;
    display: flex;
    gap: 10px;
  }
  .comment-actions button {
    background: none;
    border: none;
    color: #666;
    cursor: pointer;
    font-size: 0.85em;
    padding: 0;
  }
  .comment-actions button:hover {
    color: var(--primary);
  }
  .reply-list {
    margin-left: 30px;
    padding-left: 15px;
    border-left: 2px solid #e0e0e0;
    margin-top: 10px;
  }
  .reply-form {
    margin-left: 30px;
    margin-top: 10px;
    padding: 15px;
    background: #f0f0f0;
    border-radius: 6px;
  }
  .no-comments {
    text-align: center;
    padding: 30px;
    color: #999;
  }
  .comments-disabled {
    text-align: center;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 8px;
    color: #666;
  }

  @media (max-width: 768px) {
    .comment-form-row {
      flex-direction: column;
    }
    .reply-list {
      margin-left: 15px;
      padding-left: 10px;
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
          <ul class="comment-list" id="commentList">
            <!-- Comments will be loaded here -->
          </ul>
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
      ← ${lang == 'ko' ? '목록으로' : 'Back to List'}
    </a>
  </div>
</main>

<c:if test="${post.commentsEnabled}">
<script>
const postId = ${post.id};
const lang = '${lang}';
const i18n = {
  reply: lang === 'ko' ? '답글' : 'Reply',
  edit: lang === 'ko' ? '수정' : 'Edit',
  delete: lang === 'ko' ? '삭제' : 'Delete',
  cancel: lang === 'ko' ? '취소' : 'Cancel',
  submit: lang === 'ko' ? '등록' : 'Submit',
  save: lang === 'ko' ? '저장' : 'Save',
  name: lang === 'ko' ? '이름' : 'Name',
  password: lang === 'ko' ? '비밀번호' : 'Password',
  content: lang === 'ko' ? '내용' : 'Content',
  confirmDelete: lang === 'ko' ? '댓글을 삭제하시겠습니까?' : 'Delete this comment?',
  enterPassword: lang === 'ko' ? '비밀번호를 입력하세요' : 'Enter password',
  deleted: lang === 'ko' ? '삭제된 댓글입니다.' : 'This comment has been deleted.'
};

// Load comments on page load
document.addEventListener('DOMContentLoaded', loadComments);

function loadComments() {
  fetch('/api/comments/post/' + postId)
    .then(res => res.json())
    .then(data => {
      if (data.ok) {
        renderComments(data.data);
      }
    })
    .catch(err => console.error('Failed to load comments:', err));
}

function renderComments(comments) {
  const list = document.getElementById('commentList');
  const noComments = document.getElementById('noComments');
  const countEl = document.getElementById('commentCount');

  // Count total comments (including replies)
  let total = 0;
  function countAll(cmts) {
    cmts.forEach(c => {
      if (!c.isDeleted) total++;
      if (c.replies && c.replies.length > 0) countAll(c.replies);
    });
  }
  countAll(comments);
  countEl.textContent = '(' + total + ')';

  if (comments.length === 0) {
    list.innerHTML = '';
    noComments.style.display = 'block';
    return;
  }

  noComments.style.display = 'none';
  list.innerHTML = comments.map(c => renderComment(c)).join('');
}

function renderComment(comment, isReply) {
  isReply = isReply || false;
  var dateStr = new Date(comment.createdAt).toLocaleDateString();
  var contentClass = comment.isDeleted ? 'comment-content deleted' : 'comment-content';
  var contentText = comment.isDeleted ? i18n.deleted : escapeHtml(comment.content);

  var repliesHtml = '';
  if (comment.replies && comment.replies.length > 0) {
    repliesHtml = '<div class="reply-list">' +
      comment.replies.map(function(r) { return renderComment(r, true); }).join('') +
      '</div>';
  }

  var actionsHtml = '';
  if (!comment.isDeleted) {
    actionsHtml = '<div class="comment-actions">';
    if (!isReply) {
      actionsHtml += '<button onclick="showReplyForm(' + comment.id + ')">' + i18n.reply + '</button>';
    }
    actionsHtml += '<button onclick="editComment(' + comment.id + ')">' + i18n.edit + '</button>';
    actionsHtml += '<button onclick="deleteComment(' + comment.id + ')">' + i18n.delete + '</button>';
    actionsHtml += '</div>';
  }

  return '<li class="comment-item" id="comment-' + comment.id + '">' +
    '<div class="comment-header">' +
    '<span class="comment-author">' + escapeHtml(comment.authorName) + '</span>' +
    '<span class="comment-date">' + dateStr + '</span>' +
    '</div>' +
    '<div class="' + contentClass + '" id="content-' + comment.id + '">' + contentText + '</div>' +
    actionsHtml +
    '<div id="reply-form-' + comment.id + '"></div>' +
    repliesHtml +
    '</li>';
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
    alert(lang === 'ko' ? '이름과 내용을 입력해주세요.' : 'Please enter name and content.');
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
    } else {
      alert(data.message || 'Failed to post comment');
    }
  })
  .catch(function(err) {
    console.error('Error:', err);
    alert('Error posting comment');
  });
}

function showReplyForm(parentId) {
  var container = document.getElementById('reply-form-' + parentId);
  container.innerHTML = '<div class="reply-form">' +
    '<div class="comment-form-row">' +
    '<input type="text" id="reply-name-' + parentId + '" placeholder="' + i18n.name + '" required maxlength="50"/>' +
    '<input type="password" id="reply-pw-' + parentId + '" placeholder="' + i18n.password + '" maxlength="20"/>' +
    '</div>' +
    '<textarea id="reply-content-' + parentId + '" placeholder="' + i18n.content + '" required></textarea>' +
    '<div style="margin-top: 10px; text-align: right;">' +
    '<button type="button" onclick="hideReplyForm(' + parentId + ')" style="background: #6c757d;">' + i18n.cancel + '</button>' +
    '<button type="button" onclick="submitComment(' + parentId + ')">' + i18n.submit + '</button>' +
    '</div>' +
    '</div>';
}

function hideReplyForm(parentId) {
  document.getElementById('reply-form-' + parentId).innerHTML = '';
}

function editComment(commentId) {
  const contentEl = document.getElementById('content-' + commentId);
  const currentContent = contentEl.textContent;
  const password = prompt(i18n.enterPassword);

  if (password === null) return;

  const newContent = prompt(i18n.content, currentContent);
  if (!newContent || newContent === currentContent) return;

  fetch('/api/comments/' + commentId, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ content: newContent, password: password })
  })
  .then(res => res.json())
  .then(data => {
    if (data.ok) {
      loadComments();
    } else {
      alert(data.message || 'Failed to edit comment');
    }
  })
  .catch(err => alert('Error editing comment'));
}

function deleteComment(commentId) {
  if (!confirm(i18n.confirmDelete)) return;

  const password = prompt(i18n.enterPassword);
  if (password === null) return;

  fetch('/api/comments/' + commentId + '?password=' + encodeURIComponent(password), {
    method: 'DELETE'
  })
  .then(res => res.json())
  .then(data => {
    if (data.ok) {
      loadComments();
    } else {
      alert(data.message || 'Failed to delete comment');
    }
  })
  .catch(err => alert('Error deleting comment'));
}

function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}
</script>
</c:if>

</layout:layout-public>
