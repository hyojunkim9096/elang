<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>

<c:set var="isEn" value="${lang == 'en'}"/>

<main class="admin-content">
  <div class="page-header">
    <h1>${isEn ? 'Access Settings' : '접근 설정'}</h1>
    <p class="subtitle">${isEn ? 'Configure IP restriction for Admin page access.' : 'Admin 페이지 접근 IP 제한을 설정합니다.'}</p>
  </div>

  <!-- 접근 모드 설정 -->
  <div class="panel">
    <div class="panel-header">
      <h2>${isEn ? 'Access Mode' : '접근 모드'}</h2>
    </div>
    <div class="panel-body">
      <div class="access-mode-container">
        <div class="access-mode-options">
          <label class="access-mode-option ${config.accessMode == 'ALL' ? 'active' : ''}">
            <input type="radio" name="accessMode" value="ALL"
                   ${config.accessMode == 'ALL' ? 'checked' : ''} onchange="updateAccessMode('ALL')"/>
            <div class="mode-content">
              <span class="mode-title">${isEn ? 'Allow All' : '전체 허용'}</span>
              <span class="mode-desc">${isEn ? 'Admin page accessible from any IP' : '모든 IP에서 Admin 페이지 접근 가능'}</span>
            </div>
          </label>
          <label class="access-mode-option ${config.accessMode == 'IP_ONLY' ? 'active' : ''}">
            <input type="radio" name="accessMode" value="IP_ONLY"
                   ${config.accessMode == 'IP_ONLY' ? 'checked' : ''} onchange="updateAccessMode('IP_ONLY')"/>
            <div class="mode-content">
              <span class="mode-title">${isEn ? 'IP Restriction' : 'IP 제한'}</span>
              <span class="mode-desc">${isEn ? 'Only registered IPs can access Admin page' : '등록된 IP만 Admin 페이지 접근 가능'}</span>
            </div>
          </label>
        </div>
        <div class="current-ip-info">
          <span class="label">${isEn ? 'Current IP:' : '현재 접속 IP:'}</span>
          <span class="ip-value">${currentIp}</span>
          <button type="button" class="btn btn-sm btn-outline" onclick="addCurrentIp()">${isEn ? 'Register Current IP' : '현재 IP 등록'}</button>
        </div>
      </div>
    </div>
  </div>

  <!-- 허용 IP 목록 -->
  <div class="panel">
    <div class="panel-header">
      <h2>${isEn ? 'Allowed IP List' : '허용 IP 목록'}</h2>
      <button type="button" class="btn btn-primary" onclick="openAddIpModal()">${isEn ? 'Add IP' : 'IP 추가'}</button>
    </div>
    <div class="panel-body">
      <c:choose>
        <c:when test="${empty allowedIps}">
          <div class="empty-state">
            <p>${isEn ? 'No registered IPs.' : '등록된 IP가 없습니다.'}</p>
            <p class="text-muted">${isEn ? 'Please register IPs first to use IP restriction mode.' : 'IP 제한 모드를 사용하려면 먼저 IP를 등록해주세요.'}</p>
          </div>
        </c:when>
        <c:otherwise>
          <table class="data-table">
            <thead>
              <tr>
                <th>${isEn ? 'IP Address' : 'IP 주소'}</th>
                <th>${isEn ? 'Description' : '설명'}</th>
                <th>${isEn ? 'Registered' : '등록일'}</th>
                <th style="width: 100px;">${isEn ? 'Actions' : '관리'}</th>
              </tr>
            </thead>
            <tbody id="ipTableBody">
              <c:forEach var="ip" items="${allowedIps}">
                <tr data-id="${ip.id}">
                  <td>
                    <code>${ip.ipAddress}</code>
                    <c:if test="${ip.ipAddress == currentIp}">
                      <span class="badge badge-success">${isEn ? 'Current' : '현재 IP'}</span>
                    </c:if>
                  </td>
                  <td>${ip.description}</td>
                  <td>${ip.createdAt}</td>
                  <td>
                    <button type="button" class="btn btn-sm btn-danger" onclick="deleteIp(${ip.id})">${isEn ? 'Delete' : '삭제'}</button>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</main>

<!-- IP 추가 모달 -->
<div class="modal" id="addIpModal">
  <div class="modal-overlay" onclick="closeAddIpModal()"></div>
  <div class="modal-content">
    <div class="modal-header">
      <h3>${isEn ? 'Add IP' : 'IP 추가'}</h3>
      <button type="button" class="modal-close" onclick="closeAddIpModal()">&times;</button>
    </div>
    <div class="modal-body">
      <form id="addIpForm" onsubmit="submitAddIp(event)">
        <div class="form-group">
          <label>${isEn ? 'IP Address' : 'IP 주소'} *</label>
          <input type="text" name="ipAddress" id="ipAddressInput" class="form-control"
                 placeholder="${isEn ? 'e.g. 192.168.1.100' : '예: 192.168.1.100'}" required/>
        </div>
        <div class="form-group">
          <label>${isEn ? 'Description' : '설명'}</label>
          <input type="text" name="description" id="descriptionInput" class="form-control"
                 placeholder="${isEn ? 'e.g. Office' : '예: 본사 사무실'}"/>
        </div>
        <div class="form-actions">
          <button type="button" class="btn btn-secondary" onclick="closeAddIpModal()">${isEn ? 'Cancel' : '취소'}</button>
          <button type="submit" class="btn btn-primary">${isEn ? 'Add' : '추가'}</button>
        </div>
      </form>
    </div>
  </div>
</div>

<style>
/* 모달 active 상태 - admin.css에 없는 부분만 */
.modal.active {
  display: flex;
}
</style>

<script>
const isEn = '${lang}' === 'en';

function updateAccessMode(mode) {
  fetch('/api/admin/access/mode', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ mode: mode })
  })
  .then(res => res.json())
  .then(data => {
    if (data.ok) {
      document.querySelectorAll('.access-mode-option').forEach(opt => {
        opt.classList.remove('active');
        if (opt.querySelector('input').value === mode) {
          opt.classList.add('active');
        }
      });

      if (mode === 'IP_ONLY') {
        const currentIp = '${currentIp}';
        const hasCurrentIp = document.querySelector('tr[data-id] code')?.textContent === currentIp;
        if (!hasCurrentIp) {
          alert(isEn
            ? 'Warning: Current IP is not in the allowed list. You may be locked out after logout.'
            : '주의: 현재 IP가 허용 목록에 없습니다. 현재 IP를 등록하지 않으면 로그아웃 후 접속이 불가능할 수 있습니다.');
        }
      }
    } else {
      alert((isEn ? 'Error: ' : '오류: ') + data.message);
    }
  })
  .catch(err => {
    console.error(err);
    alert(isEn ? 'An error occurred.' : '오류가 발생했습니다.');
  });
}

function openAddIpModal() {
  document.getElementById('addIpModal').classList.add('active');
  document.getElementById('ipAddressInput').focus();
}

function closeAddIpModal() {
  document.getElementById('addIpModal').classList.remove('active');
  document.getElementById('addIpForm').reset();
}

function addCurrentIp() {
  document.getElementById('ipAddressInput').value = '${currentIp}';
  document.getElementById('descriptionInput').value = isEn ? 'Current IP' : '현재 접속 IP';
  openAddIpModal();
}

function submitAddIp(e) {
  e.preventDefault();
  const ipAddress = document.getElementById('ipAddressInput').value.trim();
  const description = document.getElementById('descriptionInput').value.trim();

  fetch('/api/admin/access/ip', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ ipAddress, description })
  })
  .then(res => res.json())
  .then(data => {
    if (data.ok) {
      closeAddIpModal();
      location.reload();
    } else {
      alert((isEn ? 'Error: ' : '오류: ') + data.message);
    }
  })
  .catch(err => {
    console.error(err);
    alert(isEn ? 'An error occurred.' : '오류가 발생했습니다.');
  });
}

function deleteIp(id) {
  if (!confirm(isEn ? 'Delete this IP?' : '이 IP를 삭제하시겠습니까?')) return;

  fetch('/api/admin/access/ip/' + id, {
    method: 'DELETE'
  })
  .then(res => res.json())
  .then(data => {
    if (data.ok) {
      document.querySelector('tr[data-id="' + id + '"]').remove();
      if (document.querySelectorAll('#ipTableBody tr').length === 0) {
        location.reload();
      }
    } else {
      alert((isEn ? 'Error: ' : '오류: ') + data.message);
    }
  })
  .catch(err => {
    console.error(err);
    alert(isEn ? 'An error occurred.' : '오류가 발생했습니다.');
  });
}
</script>

<%@ include file="../common/footer.jsp" %>
