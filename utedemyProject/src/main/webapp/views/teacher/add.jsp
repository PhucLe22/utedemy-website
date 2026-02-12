<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<body>
	<div class="content-box">
		<div class="content-header">Danh sách bài học</div>
		<div class="lesson-list-container">
			<button class="add-lesson-button" id="openModal">+ Phần học
				mới</button>
			<div class="empty-state">Chưa có bài học nào được thêm vào khóa
				học.</div>
		</div>
	</div>

	<!-- Modal Dialog -->
	<div class="modal" id="lessonModal">
		<div class="modal-content">
			<div class="modal-header">
				<h3 class="modal-title">Tạo phần học</h3>
				<button class="close-button" id="closeModal">×</button>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label class="form-label">Tiêu đề<span class="required">*</span></label>
					<input type="text" id="sectionTitle" name="sectionTitle"
						class="form-input">
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn-cancel" id="cancelModal">Hủy</button>
				<button type="button" class="btn-save">Lưu</button>
			</div>
		</div>
	</div>

	<div class="modal" id="lesson"> 
	    <div class="modal-content"> 
	        <div class="modal-header"> 
	            <h3 class="modal-title">Cập nhật bài học</h3> 
	            <button class="close-button" id="closeModal">×</button> 
	        </div> 
	        <div class="modal-body"> 
	            <div class="form-group"> 
	                <label class="form-label">Tiêu đề <span class="required">*</span></label> 
	                <input type="text" class="form-input" placeholder="Nhập tiêu đề" name="sectionTitle"> 
	            </div> 
	             
	            <div class="form-group"> 
	                <label class="form-label">Mô tả ngắn</label> 
	                <textarea class="form-input" rows="4" placeholder="Nhập mô tả" name="description"></textarea> 
	            </div>
	
	            <div class="form-group">
	                <label class="checkbox-label">
	                    <input type="checkbox" id="freeTrialCheckbox"> Học thử miễn phí
	                </label>
	            </div>
	
	            <div class="form-group">
	                <label class="form-label">Nhập link Youtube/vimeo</label>
	                <div class="video-input-container">
	                    <input type="text" class="form-input video-input" placeholder="vd: https://www.youtube.com/embed?v=7fq7rQpOHuM" name="videoUrl">
	                </div>
	            </div>
	        </div> 
	        <div class="modal-footer"> 
	            <button class="btn-cancel" id="cancelModal">Hủy</button> 
	            <button class="btn-save">Lưu bài học</button> 
	        </div> 
	    </div> 
	</div>
	
	<div class="modal" id="quiz">
	  <div class="modal-content">
	    <div class="modal-header">
	      <h3 class="modal-title">Bài trắc nghiệm</h3>
	      <button class="close-button" id="closeModal">×</button>
	    </div>
	    <div class="modal-body">
	      <div class="form-group">
	        <label class="form-label">Tiêu đề <span class="required">*</span></label>
	        <input type="text" class="form-input" placeholder="Nhập tiêu đề" value="Bài Kiểm Tra">
	        <div class="character-count">67</div>
	      </div>
	
	      <div class="form-group">
	        <label class="form-label">Mô tả ngắn</label>
	        <input type="text" class="form-input" placeholder="Nhập mô tả">
	        <div class="character-count">200</div>
	      </div>
	      
	      <div class="form-group">
	        <label class="form-label">Thời gian làm bài</label>
	        <input type="number" class="form-input quiz-duration" placeholder="Thời gian làm bài (phút)">
	        <div class="character-count">200</div>
	      </div>
	      
	      <button class="quiz-actions">
	           + Câu hỏi mới
	      </button>
	    </div>
	    <div class="modal-footer">
	      <button class="btn-cancel">Hủy</button>
	      <button class="btn-save">Lưu trắc nghiệm</button>
	    </div>
	  </div>
	</div>
    
    <script src="${pageContext.request.contextPath}/views/Script/addCourse.js"></script>
</body>
</html>