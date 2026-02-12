<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/addCourse.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
</head>
<body>
<script>window.contextPath = '${pageContext.request.contextPath}';</script>
	<div class="header">
		<div class="header-left">
			<a href="${pageContext.request.contextPath}/teacher/course" class="back-button">&#9664;</a>
			<div class="header-title">Quay lại danh sách khóa học
				&nbsp;|&nbsp; ${course.courseName}</div>
		</div>
		<div class="header-status">
			<c:choose>
				<c:when test="${course.status == 0}">
					<div class="status-tag updating-tag">Đang tạm ngừng</div>
				</c:when>
				<c:when test="${course.status == 1}">
					<div class="status-tag updating-tag">Đang hoạt động</div>
				</c:when>
				<c:when test="${course.status == 2}">
					<div class="status-tag updating-tag">Đang kiểm duyệt</div>
				</c:when>
				<c:when test="${course.status == 3}">
					<div class="status-tag updating-tag">Đang tạo</div>
				</c:when>
				<c:otherwise>
					<span>Không xác định</span>
				</c:otherwise>
			</c:choose>
			<button class="save-button">Lưu</button>
		</div>
	</div>
	<div class="container">
		<div class="sidebar">
			<div class="sidebar-menu">
				<a href="${pageContext.request.contextPath}/teacher/editBasicInformation"
					class="sidebar-item"
					style="display: inline-block; text-decoration: none;"> <span>Thông
						tin cơ bản</span>
				</a>
				<a href="${pageContext.request.contextPath}/teacher/editTarget" class="sidebar-item"
					style="display: inline-block; text-decoration: none;"> <span>Mục
						tiêu khóa học</span>
				</a>  <a href="${pageContext.request.contextPath}/teacher/edit" class="sidebar-item"
					style="display: inline-block; text-decoration: none;"> <span>Danh
						sách bài học</span>
				</a>
			</div>
			<a href="<c:url value='/teacher/submitReviewCourse?id=${course.id}'/>"
				class="submit-button" style="display: inline-block; text-decoration: none;">
				Gửi duyệt </a>
		</div>
		<div class="main-content">
			<sitemesh:write property="body" />
		</div>
	</div>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script type="text/javascript">
		// Thêm event listener cho nút lưu
		document.querySelector('.save-button').addEventListener('click', function() {
		    saveTargetData();
		});
	
		// Hàm thu thập và gửi dữ liệu
		function saveTargetData() {
		    // Kiểm tra URL hiện tại để biết đang ở trang nào
		    const currentPath = window.location.pathname;
		    
			if (currentPath.includes('/teacher/editBasicInformation')) {
				// Create FormData object to handle file uploads and form data together
				const courseTitle = document.querySelector('input[name="courseTitle"]').value.trim();
				const shortDescription = document.querySelector('textarea.form-input').value.trim();
				const courseTypeId = document.querySelector('select[name="courseTypeId"]').value;
				const coursePrice = document.querySelector('input[name="courseName"]').value.trim();
				const courseIntro = CKEDITOR.instances.courseIntroduction.getData().trim();
				const videoLink = document.querySelector('.video-upload-container .form-input').value.trim();
				const imageFile = document.getElementById('imageUpload').files[0];

				// Kiểm tra các trường bắt buộc
				if (!courseTitle || !shortDescription || !courseTypeId || !coursePrice || !courseIntro || !imageFile) {
				    Swal.fire({
				        title: 'Thiếu thông tin!',
				        text: 'Vui lòng điền đầy đủ các trường bắt buộc (bao gồm cả ảnh).',
				        icon: 'warning'
				    });
				    return; // Không gửi dữ liệu
				}

				// Tạo và gửi FormData
				const formData = new FormData();
				formData.append("courseTitle", courseTitle);
				formData.append("shortDescription", shortDescription);
				formData.append("courseTypeId", courseTypeId);
				formData.append("coursePrice", coursePrice);
				formData.append("courseIntroduction", courseIntro);
				formData.append("videoLink", videoLink || "");
				formData.append("courseImage", imageFile);
				  
				  // Get the file input and append file if one was selected
				  const fileInput = document.getElementById('imageUpload');
				  if (fileInput.files.length > 0) {
					  formData.append("courseImage", fileInput.files[0]);
					}
				  
				  // Send FormData to server (need to modify the sendDataToServer function)
				  sendDataToServer('${pageContext.request.contextPath}/teacher/updateBasicInformation', formData);
			}
			if (currentPath.includes('/teacher/editTarget')) {
		        const objectives = [];
		        document.querySelectorAll('.objective-item').forEach(item => {
		            const objectiveText = item.querySelector('.objective-text').textContent;
		            objectives.push(objectiveText);
		        });
		        
	            const editorContents = document.querySelectorAll('.editor-content');
	            
	            let targetAudience = "";
	            
	            if (editorContents.length >= 1) {
	                targetAudience = editorContents[0].textContent || "";
	            }

	            console.log("Objectives:", objectives);
	            console.log("Target Audience:", targetAudience);
		        
		        const targetData = {
		            objectives: objectives,
		            targetAudience: targetAudience,
		        };
		        
		        sendDataToServer('${pageContext.request.contextPath}/teacher/updateTarget', targetData);
		    }
			if (currentPath.includes('/teacher/edit')) {
				  
				  // Log data for debugging (note: can't easily log FormData contents)
				  console.log("Form data created with all fields including possible file upload");
				  
				  // Send FormData to server (need to modify the sendDataToServer function)
				  sendDataToServer('${pageContext.request.contextPath}/teacher/add');
			}
		}
		
	
		function sendDataToServer(url, data) {
			  // Tạo request
			  const xhr = new XMLHttpRequest();
			  xhr.open('POST', url, true);
			  
			  // Không đặt header nếu data là FormData
			  if (!(data instanceof FormData)) {
			    xhr.setRequestHeader('Content-Type', 'application/json');
			  }
			  
			  // Xử lý phản hồi
			  xhr.onload = function() {
				    if (xhr.status >= 200 && xhr.status < 300) {
				    	const response = JSON.parse(xhr.responseText);
				    	if (response.success) {
				            Swal.fire({
				                title: 'Đã lưu thành công!',
				                text: 'Bạn có muốn tiếp tục chỉnh sửa hay quay lại trang chính?',
				                icon: 'success',
				                showCancelButton: true,
				                confirmButtonText: 'Tiếp tục',
				                cancelButtonText: 'Về trang chủ'
				            }).then((result) => {
				                if (!result.isConfirmed) {
				                    window.location.href = "${pageContext.request.contextPath}/teacher/course";
				                }
				            });
				        } else {
				            Swal.fire({
				                title: 'Thất bại!',
				                text: response.message || 'Không thể lưu dữ liệu.',
				                icon: 'error'
				            });
				        }
				    } else {
				        Swal.fire({
				            title: 'Lỗi khi lưu!',
				            text: xhr.statusText,
				            icon: 'error'
				        });
				    }
				};
			  
			  // Xử lý lỗi mạng
			  xhr.onerror = function() {
				  Swal.fire({
				    title: 'Lỗi kết nối!',
				    text: 'Không thể kết nối tới máy chủ. Vui lòng kiểm tra mạng hoặc thử lại sau.',
				    icon: 'error'
				  });
				};
			  
			  // Gửi dữ liệu (nếu là FormData thì gửi trực tiếp, nếu không thì chuyển sang JSON)
			  if (data instanceof FormData) {
				Swal.showLoading();
			    xhr.send(data);
			  } else {
				Swal.showLoading();
			    xhr.send(JSON.stringify(data));
			  }
			}
	</script>
</body>
</html>