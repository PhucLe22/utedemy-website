<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giảng viên Dashboard</title>
    
</head>
<body>
    <main class="content">
        <div class="content-header">
            <h1 class="content-title">Bài giảng của tôi</h1>
        </div>
        
        <!-- Stats cards -->
        <div class="course-stats">
            <div class="stat-card">
                <span class="stat-title">Khóa học đang hoạt động</span>
                <span class="stat-value">${activeCoursesCount}</span>
            </div>
             <div class="stat-card">
                <span class="stat-title">Khóa học đang tạo</span>
                <span class="stat-value">${creatingCoursesCount}</span>
            </div>
            <div class="stat-card">
                <span class="stat-title">Khóa học đang duyệt</span>
                <span class="stat-value">${reviewingCoursesCount}</span>
            </div>
            <div class="stat-card">
                <span class="stat-title">Khóa học tạm ngừng</span>
                <span class="stat-value">${suspendedCoursesCount}</span>
            </div>
        </div>

        <div class="search-filter-container">
            <div class="search-bar">
                <input type="text" class="search-input" placeholder="Nhập tên khóa học">
                <button class="search-button">
                    <i class="fas fa-search"></i> Tìm kiếm
                </button>
            </div>
            
            <div class="filter-container">
                <select class="filter-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="1">Đang hoạt động</option>
                    <option value="0">Tạm ngưng</option>
                    <option value="2">Đang kiểm duyệt</option>
                    <option value="3">Đang tạo</option>
                </select>
                
                <select class="filter-select">
                    <option value="">Sắp xếp theo</option>
                    <option value="newest">Mới nhất</option>
                    <option value="oldest">Cũ nhất</option>
                    <option value="name_asc">Tên A-Z</option>
                    <option value="name_desc">Tên Z-A</option>
                    <option value="students">Số học viên</option>
                    <option value="rating">Đánh giá</option>
                </select>
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/teacher/addCourse" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Tạo khóa học
                </a>
            </div>
        </div>

        <div class="course-list">
            <c:choose>
                <c:when test="${not empty listCourse}">
                    <c:forEach var="course" items="${listCourse}">
                        <div class="course-card">
                            <div class="course-image">
                                <c:if test="${course.courseDetail.courseImage.substring(0,5) != 'https' }">
                                    <c:url value="/image?fname=${course.courseDetail.courseImage}" var="imgUrl"></c:url>
                                </c:if>
                                <c:if test="${course.courseDetail.courseImage.substring(0,5) == 'https' }">
                                    <c:url value="${course.courseDetail.courseImage}" var="imgUrl"></c:url>
                                </c:if>
                                <img id="courseImage${course.id}" src="${imgUrl}" alt="${course.courseName}" />
                            </div>
                            <div class="course-info">
                                <div class="course-options">
                                    <button class="options-btn" onclick="toggleOptionsMenu(${course.id})">
                                        <i class="fas fa-ellipsis-vertical"></i>
                                    </button>
                                    <div id="optionsMenu${course.id}" class="options-menu">
                                        <a href="<c:url value='/teacher/editBasicInformation?id=${course.id}'/>" class="options-item">
                                            <i class="fas fa-edit"></i> Chỉnh sửa
                                        </a>
                                        <a href="<c:url value='/teacher/manageLessons?id=${course.id}'/>" class="options-item">
                                            <i class="fas fa-list-check"></i> Quản lý bài học
                                        </a>
                                        <a href="<c:url value='/teacher/viewStudents?id=${course.id}'/>" class="options-item">
                                            <i class="fas fa-users"></i> Học viên đăng ký
                                        </a>
                                        <a href="<c:url value='/teacher/viewAnalytics?id=${course.id}'/>" class="options-item">
                                            <i class="fas fa-chart-line"></i> Thống kê
                                        </a>
                                        <c:if test="${course.status == 1}">
                                            <a href="<c:url value='/teacher/pauseCourse?id=${course.id}'/>" class="options-item">
                                                <i class="fas fa-pause"></i> Tạm ngưng
                                            </a>
                                        </c:if>
                                        <c:if test="${course.status == 0}">
                                            <a href="<c:url value='/teacher/activateCourse?id=${course.id}'/>" class="options-item">
                                                <i class="fas fa-play"></i> Kích hoạt
                                            </a>
                                        </c:if>
                                        <a href="#" onclick="confirmDelete(${course.id})" class="options-item danger">
                                            <i class="fas fa-trash"></i> Xóa
                                        </a>
                                    </div>
                                </div>
                                
                                <div>
                                    <h3 class="course-title">${course.courseName}</h3>
                                    
                                    <c:if test="${course.status == 3}">
                                        <span class="course-tag">Khóa học mới</span>
                                    </c:if>
                                    
                                    <div class="course-status">
                                        <c:choose>
                                            <c:when test="${course.status == 0}">
                                                <span class="status-dot dot-stopped"></span>
                                                <span class="status-stopped">Trạng thái: Tạm ngưng</span>
                                            </c:when>
                                            <c:when test="${course.status == 1}">
                                                <span class="status-dot dot-active"></span>
                                                <span class="status-active">Trạng thái: Hoạt động</span>
                                            </c:when>
                                            <c:when test="${course.status == 2}">
                                                <span class="status-dot dot-pending"></span>
                                                <span class="status-pending">Trạng thái: Đang kiểm duyệt</span>
                                            </c:when>
                                            <c:when test="${course.status == 3}">
                                                <span class="status-dot dot-draft"></span>
                                                <span class="status-draft">Trạng thái: Đang tạo</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-dot"></span>
                                                <span>Trạng thái: Không xác định</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                   
                                </div>
                                
                                <div class="course-bottom">
                                    
                                    <div class="course-actions">
                                        <a href="<c:url value='/teacher/editBasicInformation?id=${course.id}'/>" class="action-btn btn-edit">
                                            <i class="fas fa-edit"></i> Sửa
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <div style="margin-left: -150px">
					    <ul style="display: flex; list-style-type: none; padding: 0; justify-content: center; align-items: center;">
					        <!-- Nút đầu tiên và nút trước -->
					        <li style="margin: 0 5px;">
					            <a href="?page=1" style="display: block; padding: 8px 12px; text-decoration: none; color: ${currentPage == 1 ? '#ccc' : '#333'}; border: 1px solid #ddd; border-radius: 4px;">&laquo;</a>
					        </li>
					        <li style="margin: 0 5px;">
					            <a href="?page=${currentPage > 1 ? currentPage - 1 : 1}" style="display: block; padding: 8px 12px; text-decoration: none; color: ${currentPage == 1 ? '#ccc' : '#333'}; border: 1px solid #ddd; border-radius: 4px;">&lsaquo;</a>
					        </li>
					
					        <!-- Các trang giữa -->
					        <c:forEach var="i" begin="1" end="${endPage}">
					            <li style="margin: 0 5px;">
					                <a href="?page=${i}" style="display: block; padding: 8px 12px; text-decoration: none; color: ${currentPage == i ? '#fff' : '#333'}; border: 1px solid ${currentPage == i ? '#007bff' : '#ddd'}; border-radius: 4px; background-color: ${currentPage == i ? '#007bff' : 'transparent'};">
					                    ${i}
					                </a>
					            </li>
					        </c:forEach>
					
					        <!-- Nút kế tiếp và nút cuối -->
					        <li style="margin: 0 5px;">
					            <a href="?page=${currentPage < endPage ? currentPage + 1 : endPage}" style="display: block; padding: 8px 12px; text-decoration: none; color: ${currentPage == endPage ? '#ccc' : '#333'}; border: 1px solid #ddd; border-radius: 4px;">&rsaquo;</a>
					        </li>
					        <li style="margin: 0 5px;">
					            <a href="?page=${endPage}" style="display: block; padding: 8px 12px; text-decoration: none; color: ${currentPage == endPage ? '#ccc' : '#333'}; border: 1px solid #ddd; border-radius: 4px;">&raquo;</a>
					        </li>
					    </ul>
					</div>
                </c:when>
                <c:otherwise>
                    <div class="no-courses">
                        <div class="no-courses-icon">
                            <i class="fas fa-book"></i>
                        </div>
                        <h3 class="no-courses-text">Bạn chưa có khóa học nào</h3>
                        <a href="${pageContext.request.contextPath}/teacher/addCourse" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Tạo khóa học đầu tiên
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    
    <!-- Toast Notification -->
    <div id="toast" class="toast">
        <div class="toast-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        <div class="toast-content">
            <div class="toast-title">Thành công!</div>
            <div class="toast-message">Thao tác đã được thực hiện thành công.</div>
        </div>
        <button class="toast-close" onclick="closeToast()">
            <i class="fas fa-times"></i>
        </button>
    </div>
        <script>
	     
		     // Preview hình ảnh khi upload
		        function previewFile(courseId) {
		            const preview = document.getElementById(`courseImage${courseId}`);
		            const file = document.getElementById(`courseImage${courseId}Upload`).files[0];
		            const reader = new FileReader();
		            
		            reader.onloadend = function() {
		                preview.src = reader.result;
		            }
		            
		            if (file) {
		                reader.readAsDataURL(file);
		            }
		        }
		 
  		</script>
</body>
</html>