<%@ page contentType="text/html; charset=UTF-8" %>
</div>

<script src="/assets/js/admin-common.js"></script>
<script src="/resources/js/modal.js?v=1.0.3"></script>
<script>
// Mobile Menu Toggle
(function() {
  const menuToggle = document.getElementById('mobileMenuToggle');
  const sidebar = document.querySelector('.admin-sidebar');
  const overlay = document.getElementById('sidebarOverlay');

  if (menuToggle && sidebar && overlay) {
    menuToggle.addEventListener('click', function() {
      sidebar.classList.toggle('open');
      overlay.classList.toggle('open');
    });

    overlay.addEventListener('click', function() {
      sidebar.classList.remove('open');
      overlay.classList.remove('open');
    });
  }
})();
</script>
</body>
</html>
