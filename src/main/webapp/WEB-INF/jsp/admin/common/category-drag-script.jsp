<%@ page contentType="text/html; charset=UTF-8" %>
<%--
  카테고리 테이블 드래그앤드롭 기능 스크립트
  Parameters:
    - tbodyId: tbody 엘리먼트의 ID (required)
    - reorderUrl: 순서 저장 API URL (required)
    - sortOrderColumnIndex: sortOrder 컬럼 인덱스 (default: 6)
--%>
<script>
document.addEventListener('DOMContentLoaded', function() {
  const tbodyId = '${param.tbodyId}';
  const reorderUrl = '${param.reorderUrl}';
  const sortOrderColumnIndex = ${empty param.sortOrderColumnIndex ? 6 : param.sortOrderColumnIndex};

  const tbody = document.getElementById(tbodyId);
  if (!tbody) return;

  const rows = tbody.querySelectorAll('tr[draggable="true"]');
  let draggedElement = null;

  rows.forEach(row => {
    row.addEventListener('dragstart', function(e) {
      draggedElement = this;
      this.classList.add('dragging');
      e.dataTransfer.effectAllowed = 'move';
    });

    row.addEventListener('dragend', function(e) {
      this.classList.remove('dragging');
      rows.forEach(r => r.classList.remove('drag-over'));
      saveOrder();
    });

    row.addEventListener('dragover', function(e) {
      e.preventDefault();
      if (this === draggedElement) return;
      this.classList.add('drag-over');
    });

    row.addEventListener('dragleave', function(e) {
      this.classList.remove('drag-over');
    });

    row.addEventListener('drop', function(e) {
      e.preventDefault();
      if (this === draggedElement) return;
      this.classList.remove('drag-over');

      const allRows = [...tbody.querySelectorAll('tr[draggable="true"]')];
      const draggedIndex = allRows.indexOf(draggedElement);
      const targetIndex = allRows.indexOf(this);

      if (draggedIndex < targetIndex) {
        this.parentNode.insertBefore(draggedElement, this.nextSibling);
      } else {
        this.parentNode.insertBefore(draggedElement, this);
      }
    });
  });

  function saveOrder() {
    const rows = tbody.querySelectorAll('tr[draggable="true"]');
    const ids = Array.from(rows).map(row => parseInt(row.dataset.id));

    const csrfToken = '${_csrf.token}';
    const csrfHeader = '${_csrf.headerName}';

    fetch(reorderUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        [csrfHeader]: csrfToken
      },
      body: JSON.stringify(ids)
    })
    .then(response => {
      if (response.ok) {
        console.log('순서 저장 완료');
        rows.forEach((row, index) => {
          const sortOrderCell = row.cells[sortOrderColumnIndex];
          if (sortOrderCell) sortOrderCell.textContent = index + 1;
        });
      } else {
        console.error('순서 저장 실패:', response.status);
        alert('순서 저장에 실패했습니다.');
      }
    })
    .catch(error => {
      console.error('순서 저장 에러:', error);
      alert('오류가 발생했습니다.');
    });
  }
});
</script>
