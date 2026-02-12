<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <!-- Table -->
    <div style="background-color: #ffffff; padding: 20px; border: 1px solid #ddd; border-radius: 8px; margin-left: 0px; margin-top: 0px">
        <h2 style="margin-bottom: 20px;">Khóa học</h2>
        <table id="reservationTable" style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr style="background-color: #f8f9fa; border-bottom: 1px solid #ddd;">
                    <th style="padding: 10px; text-align: left;">STT</th>
                    <th style="padding: 10px; text-align: left;">Tên khóa học</th>
                    <th style="padding: 10px; text-align: left;">Giá</th>
                    <th style="padding: 10px; text-align: left;">Loại khóa học</th>
                    <th style="padding: 10px; text-align: left;">Giáo viên</th>
                    <th style="padding: 10px; text-align: left;">Trạng thái</th>
                    <th style="padding: 10px; text-align: left;">Thao tác</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach items="${listCourse}" var="course" varStatus="STT">
            		<tr style="border-bottom: 1px solid #ddd;">
	                    <td style="padding: 10px;">${STT.index+1}</td>
	                    <td style="padding: 10px;">${course.courseName}</td>
	                    <td style="padding: 10px;">${course.coursePrice}</td>
	                    <td style="padding: 10px;">${course.courseType.courseTypeName}</td>
	                    <td style="padding: 10px;">${course.teacher.fullname}</td>
	                    <td style="padding: 10px;">
						    <c:choose>
						        <c:when test="${course.status == 0}">
						            <span style="color: red;">Tạm ngừng</span>
						        </c:when>
						        <c:when test="${course.status == 1}">
						            <span style="color: green;">Hoạt động</span>
						        </c:when>
						        <c:when test="${course.status == 2}">
						            <span style="color: orange;">Đang kiểm duyệt</span>
						        </c:when>
						        <c:when test="${course.status == 3}">
						            <span style="color: blue;">Đang tạo</span>
						        </c:when>
						        <c:otherwise>
						            <span>Không xác định</span>
						        </c:otherwise>
						    </c:choose>
						</td>
	                    <td style="padding: 10px;">
					        <c:if test="${course.status == 2}">
					           <a href="<c:url value='/admin/reviewCourse?id=${course.id}' />"
   style="background-color: #28a745; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; display: inline-block; text-decoration: none;">
   Chấp nhận
</a>

					        </c:if>
					        <c:if test="${course.status == 1 || course.status == 2}">
					             <button type="button" class="btn-modal"
					               onclick="openModal(${course.id})"
					               style="background-color: #dc3545; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; display: inline-block; text-decoration: none;">
					               Hủy
					            </button>
					        </c:if>
					        <c:if test="${course.status == 0}">
							    <a href="<c:url value='/admin/restoreCourse?id=${course.id}'/>" 
							       style="background-color: #007bff; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; display: inline-block; text-decoration: none;">
							       Khôi phục
							    </a>
							</c:if>
					    </td>
	                </tr>

            	</c:forEach>

            </tbody>
        </table>
    </div>
	<div id="thongbao" class="modal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 style="margin: 0; font-size: 18px; color: #333;">Thông báo</h5>
					<button type="button" class="close" onclick="closeModal()">
						<span>&times;</span>
					</button>
				</div>
				<form action="${pageContext.request.contextPath}/admin/cancelCourse" method="get">
					<div class="modal-body">
						<div style="margin-bottom: 15px;">
							<input type="hidden" id="modal-id" name="id" value="">
						</div>	
						<div style="margin-bottom: 15px;">
							<label for="noidung"
								style="display: block; margin-bottom: 5px; font-size: 14px; color: #555;">Nội
								Dung</label>
							<textarea id="noidung" name="noidung" rows="4"
								style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px;"></textarea>
						</div>
						<button type="submit"
							style="width: 100%; padding: 10px; background-color: #28A745; color: white; border: none; border-radius: 5px; font-size: 16px; cursor: pointer;">
							Gửi</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script>
		// Lấy phần tử modal
		const modal = document.getElementById('thongbao');
		
		// Hàm mở modal và set ID
		function openModal(id) {
			document.getElementById('modal-id').value = id;
			modal.style.display = 'block';
			modal.classList.add('fade-in');
		}
		
		// Hàm đóng modal
		function closeModal() {
			modal.style.display = 'none';
		}
		
		// Đóng modal khi click ra ngoài
		window.onclick = function(event) {
			if (event.target == modal) {
				closeModal();
			}
		}
	</script>
</body>
</html>