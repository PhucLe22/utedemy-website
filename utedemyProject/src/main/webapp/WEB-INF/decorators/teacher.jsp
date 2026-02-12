<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<title>Bảng điều khiển khóa học trực tuyến</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
        }
        
        body {
            background-color: #f5f7fa;
            color: #333;
        }
        
        .header {
            background-color: #003552;
            color: white;
            padding: 30px 6%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .instructor-info {
            display: flex;
            flex-direction: column;
        }
        
        .instructor-name {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 8px;
        }
        
        .instructor-id {
            font-size: 14px;
            color: #cccccc;
        }
        
        .support-info {
            text-align: left;
            line-height: 1.6;
        }
        
        .support-info p {
            font-size: 14px;
        }
        
        .nav-menu {
            background-color: #003552;
            padding: 0 6%;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .nav-menu ul {
            list-style: none;
            display: flex;
        }
        
        .nav-menu li {
            padding: 15px 20px;
            cursor: pointer;
            color: white !important;
            position: relative;
            transition: all 0.3s ease;
        }
        
        .nav-menu li:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        .nav-menu li.active {
            border-bottom: 3px solid white;
            font-weight: bold;
        }
        
        .content {
            padding: 40px 6%;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        
        .content-title {
            font-size: 28px;
            font-weight: bold;
            color: #1e3a8a;
            margin-bottom: 10px;
        }
        
        .course-stats {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            flex: 1;
            min-width: 200px;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-title {
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 5px;
        }
        
        .stat-value {
            font-size: 28px;
            font-weight: bold;
            color: #1e3a8a;
        }
        
        .stat-change {
            margin-top: 5px;
            font-size: 12px;
            display: flex;
            align-items: center;
        }
        
        .stat-change.positive {
            color: #047857;
        }
        
        .stat-change.negative {
            color: #b91c1c;
        }
        
        .search-filter-container {
            display: flex;
            width: 100%;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .search-bar {
            display: flex;
            flex: 1;
            max-width: 500px;
        }
        
        .search-input {
            padding: 12px 15px;
            border: 1px solid #e5e7eb;
            border-radius: 8px 0 0 8px;
            width: 100%;
            font-size: 14px;
            transition: border-color 0.3s;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }
        
        .search-input:focus {
            outline: none;
            border-color: #1a56db;
        }
        
        .search-button {
            background-color: #1e40af;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 0 8px 8px 0;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .search-button:hover {
            background-color: #1e3a8a;
        }
        
        .search-button i {
            margin-right: 5px;
        }
        
        .filter-container {
            display: flex;
            gap: 10px;
        }
        
        .filter-select {
            padding: 10px 15px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            background-color: white;
            font-size: 14px;
            min-width: 150px;
            cursor: pointer;
        }
        
        .action-buttons {
            display: flex;
        }
        
        .btn {
            padding: 12px 20px;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        
        .btn i {
            font-size: 16px;
        }
        
        .btn-outline {
            border: 1px solid #1e40af;
            color: #1e40af;
            background-color: white;
        }
        
        .btn-outline:hover {
            background-color: #f3f4f6;
        }
        
        .btn-primary {
            background-color: #1e40af;
            color: white;
            border: none;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .btn-primary:hover {
            background-color: #1e3a8a;
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .course-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(600px, 1fr));
            gap: 20px;
        }
        
        .course-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            height: 100%;
        }
        
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }
        
        .course-image {
            width: 260px;
            height: 180px;
            overflow: hidden;
            position: relative;
        }
        
        .course-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .course-card:hover .course-image img {
            transform: scale(1.05);
        }
        
        .course-info {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
        }
        
        .course-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #1a202c;
            line-height: 1.4;
        }
        
        .course-tag {
            display: inline-block;
            background-color: #ed3f3f;
            color: white;
            font-size: 12px;
            padding: 5px 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            font-weight: 500;
        }
        
        .course-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin: 15px 0;
            color: #4a5568;
            font-size: 14px;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .meta-item i {
            color: #1e40af;
            font-size: 16px;
        }
        
        .course-status {
            font-weight: 500;
            margin-top: 5px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .status-active {
            color: #047857;
        }
        
        .status-pending {
            color: #d97706;
        }
        
        .status-draft {
            color: #6b7280;
        }
        
        .status-stopped {
            color: #b91c1c;
        }
        
        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
        }
        
        .dot-active {
            background-color: #047857;
        }
        
        .dot-pending {
            background-color: #d97706;
        }
        
        .dot-draft {
            background-color: #6b7280;
        }
        
        .dot-stopped {
            background-color: #b91c1c;
        }
        
        .course-bottom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .progress-section {
            display: flex;
            align-items: center;
            flex: 1;
            min-width: 200px;
        }
        
        .progress-label {
            font-size: 14px;
            white-space: nowrap;
            color: #4a5568;
        }
        
        .progress-bar {
            height: 8px;
            background-color: #e5e7eb;
            flex: 1;
            border-radius: 4px;
            overflow: hidden;
            margin: 0 10px;
        }
        
        .progress-fill {
            height: 100%;
            background-color: #1e40af;
            border-radius: 4px;
        }
        
        .progress-value {
            font-size: 14px;
            font-weight: 500;
            color: #1e3a8a;
        }
        
        .course-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .action-btn {
            padding: 8px 15px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn-edit {
            background-color: #1e40af;
            color: white;
        }
        
        .btn-edit:hover {
            background-color: #1e3a8a;
        }
        
        .btn-view {
            background-color: #f3f4f6;
            color: #4b5563;
        }
        
        .btn-view:hover {
            background-color: #e5e7eb;
        }
        
        .no-courses {
            grid-column: 1 / -1;
            text-align: center;
            padding: 50px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .no-courses-icon {
            font-size: 48px;
            color: #9ca3af;
            margin-bottom: 20px;
        }
        
        .no-courses-text {
            font-size: 18px;
            color: #4b5563;
            margin-bottom: 30px;
        }
        
        .course-options {
            position: absolute;
            top: 20px;
            right: 20px;
        }
        
        .options-btn {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 18px;
            color: #6b7280;
            padding: 5px;
            transition: color 0.3s;
        }
        
        .options-btn:hover {
            color: #1e40af;
        }
        
        .options-menu {
            position: absolute;
            top: 30px;
            right: 0;
            background-color: white;
            border-radius: 6px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            width: 180px;
            z-index: 10;
            display: none;
        }
        
        .options-menu.active {
            display: block;
        }
        
        .options-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 15px;
            color: #4b5563;
            text-decoration: none;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        
        .options-item:hover {
            background-color: #f3f4f6;
        }
        
        .options-item.danger {
            color: #b91c1c;
        }
        
        .options-item.danger:hover {
            background-color: #fee2e2;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
            gap: 5px;
        }
        
        .page-item {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 40px;
            height: 40px;
            padding: 0 10px;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .page-item.active {
            background-color: #1e40af;
            color: white;
            font-weight: 500;
        }
        
        .page-item:not(.active) {
            background-color: white;
            color: #4b5563;
        }
        
        .page-item:not(.active):hover {
            background-color: #f3f4f6;
        }
        
        .page-item.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        @media (max-width: 1200px) {
            .course-list {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .course-card {
                flex-direction: column;
            }
            
            .course-image {
                width: 100%;
                height: 200px;
            }
            
            .content-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .search-filter-container {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .search-bar {
                max-width: 100%;
                width: 100%;
            }
            
            .filter-container {
                width: 100%;
                overflow-x: auto;
                padding-bottom: 10px;
            }
            
            .stat-card {
                min-width: 140px;
            }
            
            .course-stats {
                flex-wrap: wrap;
            }
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        
        .modal-content {
            background-color: #ffffff;
            width: 800px;
            max-width: 90%;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            max-height: 90vh;
            overflow-y: auto;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .modal-title {
            font-size: 24px;
            font-weight: 600;
            color: #1a202c;
        }
        
        .modal-close {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #6b7280;
            transition: color 0.3s;
        }
        
        .modal-close:hover {
            color: #b91c1c;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: #1a202c;
        }
        
        .form-hint {
            font-size: 12px;
            color: #6b7280;
            margin-bottom: 8px;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 15px;
            transition: border-color 0.3s;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #1e40af;
            box-shadow: 0 0 0 3px rgba(30, 64, 175, 0.1);
        }
        
        .form-select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 15px;
            appearance: none;
            background-image: url('data:image/svg+xml;utf8,<svg fill="gray" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/><path d="M0 0h24v24H0z" fill="none"/></svg>');
            background-repeat: no-repeat;
            background-position: right 15px center;
            transition: border-color 0.3s;
        }
        
        .form-select:focus {
            outline: none;
            border-color: #1e40af;
            box-shadow: 0 0 0 3px rgba(30, 64, 175, 0.1);
        }
        
        .form-footer {
            display: flex;
            justify-content: flex-end;
            margin-top: 30px;
            gap: 15px;
        }
        
        .empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 50px 20px;
            text-align: center;
        }
        
        .empty-icon {
            font-size: 60px;
            color: #9ca3af;
            margin-bottom: 20px;
        }
        
        .empty-text {
            font-size: 18px;
            color: #4b5563;
            margin-bottom: 30px;
            max-width: 500px;
        }
        
        /* Toast notification */
        .toast {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background-color: #fff;
            color: #1a202c;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            gap: 12px;
            z-index: 1000;
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 0.3s, transform 0.3s;
        }
        
        .toast.show {
            opacity: 1;
            transform: translateY(0);
        }
        
        .toast-success {
            border-left: 4px solid #047857;
        }
        
        .toast-error {
            border-left: 4px solid #b91c1c;
        }
        
        .toast-icon {
            font-size: 22px;
        }
        
        .toast-success .toast-icon {
            color: #047857;
        }
        
        .toast-error .toast-icon {
            color: #b91c1c;
        }
        
        .toast-content {
            flex: 1;
        }
        
        .toast-title {
            font-weight: 600;
            margin-bottom: 2px;
        }
        
        .toast-message {
            font-size: 14px;
            color: #4b5563;
        }
        
        .toast-close {
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
            color: #9ca3af;
            transition: color 0.3s;
        }
        
        .toast-close:hover {
            color: #1a202c;
        }
    </style>
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
	<script src="/do_An/Content/js/sweetalert2.min.js"></script>
</head>
<body>
<script>window.contextPath = '${pageContext.request.contextPath}';</script>
	<%@ include file="/commons/teacher/header.jsp"%>
	<header class="header">
        <div class="instructor-info">
            <div class="instructor-name">Giảng viên : ${fullname}</div>
        </div>
        <div class="support-info">
            <p>Hỗ trợ giảng viên</p>
            <p>HOTLINE: 0329802918</p>
            <p>EMAIL: teacher@unica.vn</p>
        </div>
    </header>
	<%@ include file="/commons/teacher/navbar.jsp"%>
    
	<div class="container">
		<div class="main-content">
			<sitemesh:write property="body" />
		</div>
	</div>
	<script>
        $(document).ready(function() {
            $('#reservationTable').DataTable({
                "paging": true,        // Bật phân trang
                "searching": true,    // Bật tìm kiếm
                "ordering": true,     // Bật sắp xếp cột
                "info": true,         // Hiển thị thông tin bảng
                "lengthMenu": [5, 10, 25, 50], // Số hàng mỗi trang
                "language": {
                    "lengthMenu": "Hiển thị _MENU_ dòng mỗi trang",
                    "zeroRecords": "Không tìm thấy dữ liệu",
                    "info": "Hiển thị trang _PAGE_ của _PAGES_",
                    "infoEmpty": "Không có dữ liệu",
                    "infoFiltered": "(lọc từ _MAX_ dòng)",
                    "search": "Tìm kiếm:",
                    "paginate": {
                        "first": "Đầu",
                        "last": "Cuối",
                        "next": "Tiếp",
                        "previous": "Trước"
                    }
                }
            });
        });
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.min.js"></script>
	<script>
	    function toggleDropdown(event) {
	        event.preventDefault();
	        const dropdown = document.getElementById('notificationDropdown');
	        // Toggle visibility
	        if (dropdown.style.display === 'none' || dropdown.style.display === '') {
	            dropdown.style.display = 'block';
	        } else {
	            dropdown.style.display = 'none';
	        }
	    }
	
	    // Đóng dropdown nếu click ra ngoài
	    document.addEventListener('click', function(event) {
	        const dropdown = document.getElementById('notificationDropdown');
	        if (!event.target.closest('.dropdown')) {
	            dropdown.style.display = 'none';
	        }
	    });
	</script>
	<script>
        // JavaScript functionality can be added here
        document.addEventListener('DOMContentLoaded', function() {
            // Menu item activation
            const menuItems = document.querySelectorAll('.nav-menu li');
            menuItems.forEach(item => {
                item.addEventListener('click', function() {
                    menuItems.forEach(i => i.classList.remove('active'));
                    this.classList.add('active');
                });
            });
            
            // Search functionality
            const searchButton = document.querySelector('.search-button');
            const searchInput = document.querySelector('.search-input');
            
            searchButton.addEventListener('click', function() {
                const searchTerm = searchInput.value.trim();
                if (searchTerm) {
                    // Here you would typically perform a search
                    console.log('Searching for:', searchTerm);
                    // You could then update the UI or redirect as needed
                }
            });
        });
        
     // Hiển thị menu tùy chọn cho khóa học
        function toggleOptionsMenu(courseId) {
            const menu = document.getElementById(`optionsMenu${courseId}`);
            document.querySelectorAll('.options-menu').forEach(item => {
                if (item !== menu) {
                    item.classList.remove('active');
                }
            });
            menu.classList.toggle('active');
        }
        
        // Đóng menu khi click ra ngoài
        document.addEventListener('click', function(event) {
            if (!event.target.closest('.options-btn') && !event.target.closest('.options-menu')) {
                document.querySelectorAll('.options-menu').forEach(menu => {
                    menu.classList.remove('active');
                });
            }
        });
     // Xác nhận xóa khóa học
        function confirmDelete(courseId) {
            if (confirm('Bạn có chắc chắn muốn xóa khóa học này?')) {
                window.location.href = `${pageContext.request.contextPath}/teacher/deleteCourse?id=${courseId}`;
            }
        }
        
        // Hiển thị thông báo toast
        function showToast(type, title, message) {
            const toast = document.getElementById('toast');
            toast.className = `toast toast-${type} show`;
            
            const iconEl = toast.querySelector('.toast-icon i');
            if (type === 'success') {
                iconEl.className = 'fas fa-check-circle';
            } else if (type === 'error') {
                iconEl.className = 'fas fa-exclamation-circle';
            }
            
            toast.querySelector('.toast-title').textContent = title;
            toast.querySelector('.toast-message').textContent = message;
            
            setTimeout(function() {
                closeToast();
            }, 5000);
        }
        
        // Đóng thông báo toast
        function closeToast() {
            const toast = document.getElementById('toast');
            toast.className = 'toast';
        }
        
        // Kiểm tra nếu có thông báo từ URL
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const message = urlParams.get('message');
            const status = urlParams.get('status');
            
            if (message && status) {
                const type = status === 'success' ? 'success' : 'error';
                const title = status === 'success' ? 'Thành công!' : 'Lỗi!';
                showToast(type, title, message);
            }
        });
    </script>
</body>
</html>