<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Unica - Học online mọi kỹ nằng từ chuyện gia hàng đầu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/Course.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/views/Script/Course.js"></script>
<script src="https://cdn.ckeditor.com/4.22.1/full/ckeditor.js"></script>
</head>

<header class="header-bar">
    <div class="logo-area">
        <a href="${pageContext.request.contextPath}/user/homepage" class="logo-link">
			<img src="https://photo.salekit.com/uploads/salekit_c196362f511b1291152d3dec9805e706/logo-unica-2.png" alt="Unica Logo" class="logo-circle" id="logoImg">
		</a>
        <span class="header-title">Tổng quan về thuế</span>
    </div>
    <div class="user-controls">
    		<div class="user-rating" id="btn-rating">
    			<i class="far fa-star"></i>
    			<span>Đưa ra đánh giá</span>
    		</div>
    		<div id="ratingModal" class="modal" style="display:none;">
			    <div class="modal-content">
			        <span class="close">&times;</span>
			        <h3>Bạn sẽ xếp hạng khóa học này ở mức nào?</h3>
			        <div class="rating-text" id="ratingText">Hãy chọn một mức đánh giá</div>
			
			        <div class="stars">
			            <i class="far fa-star" data-value="1"></i>
			            <i class="far fa-star" data-value="2"></i>
			            <i class="far fa-star" data-value="3"></i>
			            <i class="far fa-star" data-value="4"></i>
			            <i class="far fa-star" data-value="5"></i>
			        </div>
			        <div id="feedbackForm" style="display: none; margin-top: 20px;">
			            <textarea id="feedbackContent" placeholder="Nhập nội dung đánh giá..." rows="4" style="width:100%; padding:8px; border: 1px solid #ccc; border-radius: 4px;"></textarea>
			            <button id="submitFeedback" style="margin-top:10px; padding:10px 20px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer;">Gửi đánh giá</button>
			        </div>
			    </div>
			</div>
            <div class="user-progress" id="progressBtn">
                <i class="fas fa-chart-line"></i>
                <span>Tiến độ của bạn</span>
                <i class="fas fa-chevron-down"></i>
            </div>
        </div>

        <!-- Popup tiến độ -->
        <div class="progress-popup" id="progressPopup">
            <div class="progress-content">
                <div class="progress-header"></div>
            </div>
        </div>
</header>

<body>
<div class="course-container">
    <!-- Phần video -->
    <div class="course-video-area">
        <iframe id="lesson-video"
        		src=""
                frameborder="0"
                allowfullscreen>
        </iframe>

		<!-- Controller Video -->
		<div class="control-selection">
                <div class="right-controls">
                    <button class="btn-report" id="btn-report"><i class="fas fa-exclamation-circle"></i> Báo lỗi</button>
					<div id="reportModal" class="modal" style="display: none;">
					  <div class="modal-content">
					    <span class="close">&times;</span>
					    <h2>Báo lỗi video</h2>
					    <div class="options">
					      <label><input type="radio" name="errorType" value="Không xem được video"> Không xem được video</label>
					      <label><input type="radio" name="errorType" value="Nội dung video"> Nội dung video</label>
					    </div>
					    <textarea placeholder="Nhập nội dung bạn muốn báo lỗi..." id="errorContent"></textarea>
					    <button id="submitReport" class="submit-btn">Gửi</button>
					  </div>
					</div>
                    <div class="autoplay-toggle">
                        <span>Autoplay</span>
                        <label class="switch">
                            <input type="checkbox">
                            <span class="slider round"></span>
                        </label>
                    </div>
                    <button class="btn-prv"><i class="fas fa-chevron-left"> </i> Bài Trước</button>
                    <button class="btn-next">Bài sau <i class="fas fa-chevron-right"></i></button>
				</div>
		</div>

		<h2 id="lesson-title"></h2>
		<div id="lesson-description"></div>

        <div class="course-tabs">
		  <div class="tab-menu">
		    <div class="active" data-tab="overview">Tổng quan</div>
		    <div data-tab="discussion">Thảo luận</div>
		    <div data-tab="reviews">Đánh giá</div>
		  </div>
		  <div class="tab-content active" data-content="overview">
			  <div class="overview-section">
			    <div id="course-intro">
			    </div>
			  </div>
			  <div class="overview-section">
			    <div id="instructor-info">
			    </div>
			  </div>
			</div>
		  <div class="tab-content" data-content="discussion">
			<textarea name="comment" id="comment"></textarea>
			<button class="btn-submit-comment">Gửi</button>
		    <h3 class="headerIncomment">Tất cả thảo luận trong khóa học này:</h3>
			<div id="comment-filter">
			  <label for="comment-sort">Sắp xếp theo: </label>
			  <select id="comment-sort">
			    <option value="newest">Mới nhất</option>
			    <option value="oldest">Cũ nhất</option>
			  </select>
			</div>
		    <div id="comment-container"></div>
		    <div class="reply-list"></div>
  			<div class="comment-reply-editor" style="display: none;"></div>
		  </div>

		  <div class="tab-content" data-content="reviews">
		    <div id="rating-summary" class="rating-summary"></div>
		    <h3 class="header-reviews">Đánh giá</h3>
		    <div id="rating-filter">
			  <label for="rating-sort">Sắp xếp theo: </label>
			  <select id="rating-sort">
			    <option value="All">Tất cả đánh giá</option>
			    <option value="5-stars">Đánh giá 5 sao</option>
			    <option value="4-stars">Đánh giá 4 sao</option>
			    <option value="3-stars">Đánh giá 3 sao</option>
			    <option value="2-stars">Đánh giá 2 sao</option>
			    <option value="1-stars">Đánh giá 1 sao</option>
			  </select>
			  <div id="reviews-container"></div>
			  <button id="load-more-btn">Xem thêm đánh giá</button>
			</div>
		  </div>
		</div>

    </div>

    <!-- Phần sidebar -->
<div class="course-sidebar">
    <h3 class="header-lesson-container">Nội dung khóa học</h3>

	<div id="lesson-container" class="lesson-group">
        <div class="lesson-section">
            <div class="lesson-group-title" onclick="toggleLesson(this)">
                <span class="arrow">&#9660;</span>
            </div>
            <div class="lesson-list">
                <div class="lesson-item active">
                </div>
            </div>
        </div>

        <div class="lesson-section">
            <div class="lesson-group-title" onclick="toggleLesson(this)">
                <span class="arrow">&#9654;</span>
            </div>
            <div class="lesson-list" style="display: none;">
                <div class="lesson-item">
                </div>
            </div>
        </div>

        <div class="lesson-section">
            <div class="lesson-group-title" onclick="toggleLesson(this)">
                <span class="arrow">&#9654;</span>
            </div>
            <div class="lesson-list" style="display: none;">
                <div class="lesson-item">
                </div>
            </div>
        </div>
    </div>
</div>

</div>

</body>

</html>

<script>
    let lessonData = JSON.parse('<%= request.getAttribute("lessonJson").toString().replace("'", "\\'") %>');
    let courseDescription = JSON.parse('<%= request.getAttribute("overviewJson").toString().replace("'", "\\'") %>');
    let instructorData = JSON.parse('<%= request.getAttribute("teacherJson").toString().replace("'", "\\'") %>');
    let allComments = JSON.parse('<%= request.getAttribute("allCommentsJson").toString().replace("'", "\\'") %>');
    let ratingData = JSON.parse('<%= request.getAttribute("reviewJson").toString().replace("'", "\\'") %>');
    let reviewData = JSON.parse('<%= request.getAttribute("reviewsListJson").toString().replace("'", "\\'") %>');
    renderLessons(lessonData);
    renderOverviewIntro();
    renderInstructorInfo(instructorData);
    document.addEventListener("DOMContentLoaded", function () {
    	  const sortSelect = document.getElementById("comment-sort");
    	  sortSelect.value = "newest";

    	  // Gọi render
    	  renderNestedComments(allComments, "newest");

    	  // Đợi DOM cập nhật xong rồi mới giới hạn
    	  
    	});

    renderRatingSummary(ratingData);
    renderReviews();
</script>