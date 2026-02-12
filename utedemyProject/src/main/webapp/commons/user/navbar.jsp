<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<nav class="nav-menu">
<ul>
<li data-path="mycourse"><a href="${pageContext.request.contextPath}/user/mycourse" style="display: inline-block; text-decoration: none; color: white">Khóa học</a></li>
<li data-path="favoriteCourse"><a href="${pageContext.request.contextPath}/user/favoriteCourse" style="display: inline-block; text-decoration: none; color: white"">Yêu thích</a></li>
<li data-path="courseBookingHistory"><a href="${pageContext.request.contextPath}/user/courseBookingHistory" style="display: inline-block; text-decoration: none; color: white"">Lịch sử đặt hàng</a></li>
</ul>
</nav>

<script>
// Đợi trang tải xong
document.addEventListener('DOMContentLoaded', function() {
  // Lấy đường dẫn hiện tại
  const currentPath = window.location.pathname;
  // Lấy tất cả các mục menu
  const menuItems = document.querySelectorAll('.nav-menu li');
  // Xóa class 'active' từ tất cả các mục
  menuItems.forEach(item => {
    item.classList.remove('active');
  });
  // Thêm class 'active' cho mục phù hợp
  menuItems.forEach(item => {
    const path = item.getAttribute('data-path');
    if (path && currentPath.includes(path)) {
      item.classList.add('active');
    }
  });
});
</script>