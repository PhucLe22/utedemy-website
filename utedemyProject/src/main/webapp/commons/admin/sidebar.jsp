<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>	
<!-- BEGIN SIDEBAR -->
<div class="container-flex">
        <div class="sidebar">
            <div class="sidebar-header">
                <h3>Admin Dashboard</h3>
                <p>Quản lý hệ thống</p>
            </div>
            
            
            <div class="sidebar-category">Quản lý chung</div>
            
            <a href="${pageContext.request.contextPath}/admin/accountManagement" class="sidebar-item" data-path="accountManagement">
	            <i class="fas fa-user"></i>
	            <span>Tài khoản</span>
	        </a>
	
	        <a href="${pageContext.request.contextPath}/admin/courseManagement" class="sidebar-item" data-path="courseManagement">
	            <i class="fas fa-graduation-cap"></i>
	            <span>Khóa học</span>
	        </a>
            
            <a href="${pageContext.request.contextPath}/admin/category2" class="sidebar-item" data-path="category2">
                <i class="fas fa-th-list"></i>
                <span>Danh mục</span>
            </a>
            
            <div class="sidebar-divider"></div>
            
            <div class="sidebar-category">Khuyến mãi & Tài chính</div>
            
            <a href="#" class="sidebar-item">
                <i class="fas fa-gift"></i>
                <span>Khuyến mãi</span>
                <span class="badge">5</span>
            </a>
            
            <a href="#" class="sidebar-item">
                <i class="fas fa-chart-line"></i>
                <span>Doanh thu</span>
            </a>
        </div>
        
        <div class="main-section">
            <div class="main">
	            <sitemesh:write property="body" />
	         </div>
        </div>
    </div>
	<script>
	    // Đợi trang tải xong
	    document.addEventListener('DOMContentLoaded', function() {
	        // Lấy đường dẫn hiện tại
	        const currentPath = window.location.pathname;
	        
	        // Lấy tất cả các mục menu
	        const menuItems = document.querySelectorAll('.sidebar-item');
	        
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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.min.js"></script>