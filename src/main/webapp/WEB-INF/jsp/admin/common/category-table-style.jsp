<%@ page contentType="text/html; charset=UTF-8" %>
<style>
  .category-table {
    width: 100%;
    border-collapse: collapse;
  }
  .category-table th {
    background: #f9fafb;
    padding: 12px;
    text-align: left;
    font-size: 13px;
    font-weight: 600;
    color: #6b7280;
    border-bottom: 2px solid #e5e7eb;
  }
  .category-table td {
    padding: 12px;
    font-size: 14px;
    border-bottom: 1px solid #e5e7eb;
    vertical-align: middle;
  }
  .category-table tbody tr:hover {
    background: #f9fafb;
  }
  .category-table tbody tr {
    cursor: move;
  }
  .category-table tbody tr.dragging {
    opacity: 0.5;
  }
  .category-table tbody tr.drag-over {
    border-top: 3px solid #3b82f6;
  }
  .drag-handle {
    cursor: grab;
    color: #d1d5db;
    font-size: 18px;
    user-select: none;
  }
  .drag-handle:active {
    cursor: grabbing;
  }
</style>
