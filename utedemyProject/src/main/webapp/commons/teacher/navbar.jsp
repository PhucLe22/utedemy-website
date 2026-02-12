<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<nav class="nav-menu">
<ul>
<li class="active" data-path="course"><a href="${pageContext.request.contextPath}/teacher/course" style="display: inline-block; text-decoration: none; color: white">Bài giảng</a></li>
<li data-path="coupon"><a href="${pageContext.request.contextPath}/teacher/coupon" style="display: inline-block; text-decoration: none; color: white"">Coupon</a></li>
<li data-path="orders"><a href="/path/to/orders" style="display: inline-block; text-decoration: none; color: white"">Đơn hàng</a></li>
<li data-path="income"><a href="/path/to/income" style="display: inline-block; text-decoration: none; color: white"">Thu nhập</a></li>
<li data-path="profile"><a href="/path/to/profile" style="display: inline-block; text-decoration: none; color: white"">Hồ sơ</a></li>
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