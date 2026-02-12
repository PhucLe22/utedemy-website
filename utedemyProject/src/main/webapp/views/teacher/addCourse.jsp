<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <div class="content">
	    <div class="breadcrumb">
	        <a href="${pageContext.request.contextPath}/teacher/homePage" style="display: inline-block; text-decoration: none;">Bài giảng</a> > Thêm khóa học mới
	    </div>
	    <h2 class="modal-title">Thêm khóa học mới</h2>
	    <form id="createCourseForm" action="${pageContext.request.contextPath}/teacher/addCourse" method="post">
	        <div class="form-group">
	            <label class="form-label">Tên khóa học *</label>
	            <p class="form-hint">Đừng lo nếu bạn không nghĩ ra một tên ngay bây giờ. Bạn có thể thay đổi sau</p>
	            <input type="text" name="courseName" class="form-input" value="Thành Thạo Excel Từ Cơ Bản Đến Nâng Cao" required>
	        </div>
	        
	        <div class="form-group">
	            <label class="form-label">Thể loại *</label>
	            <p class="form-hint">Đừng lo nếu bạn chưa chọn được thể loại phù hợp. Bạn có thể thay đổi sau</p>
	            <select class="form-select" name="courseCategory">
				  <c:forEach items="${listCourseType}" var="courseType">
				    <option value="${courseType.id}">${courseType.courseTypeName}</option>
				  </c:forEach>
				</select>
	        </div>
	        
	       <button type="submit" style="background-color: #003552; color: white; padding: 10px 16px; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; font-weight: bold; box-shadow: 0 2px 4px rgba(0,0,0,0.2); transition: all 0.3s ease;">Tạo khóa học</button>
	    </form>
	</div>
	
	<script>
	    // Character count functionality
	    const courseNameInput = document.querySelector('input[name="courseName"]');
	    const charCount = document.querySelector('.char-count');
	    const MAX_CHARS = 100;
	    
	    function updateCharCount() {
	        const remainingChars = MAX_CHARS - courseNameInput.value.length;
	        charCount.textContent = remainingChars;
	        
	        if (remainingChars < 0) {
	            charCount.style.color = 'red';
	        } else {
	            charCount.style.color = '#888';
	        }
	    }
	    
	    // Initial count
	    updateCharCount();
	    
	    // Update count when typing
	    courseNameInput.addEventListener('input', updateCharCount);
	    
	    // Form validation
	    document.getElementById('createCourseForm').addEventListener('submit', function(event) {
	        if (courseNameInput.value.trim() === '') {
	            alert('Vui lòng nhập tên khóa học');
	            event.preventDefault();
	        }
	    });
	</script>
</body>
</html>