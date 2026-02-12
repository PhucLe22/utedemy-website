<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!-- Thêm ở đầu file -->

<!DOCTYPE html>
<html lang="vi">
<body>

	<div class="search-header">
		<h1>"${searchAmount}" kết quả cho "${keyWord}"</h1>

		<div class="filter-container">
			<button class="filter-btn">
				<span>Bộ lọc</span>
			</button>

			<div class="sort-dropdown">
				<button class="sort-btn">
					<span>Sắp xếp theo</span> <span>Học nhiều nhất</span> <span>▼</span>
				</button>
			</div>
		</div>
	</div>
	<!-- Main Content -->
	<div class="container">


		<!-- Nút hiển thị lại bộ lọc -->
		<button class="show-filter-btn">Hiển thị bộ lọc</button>

		<form action="${pageContext.request.contextPath}/user/filter"
			method="post">
			<div class="content-wrapper">
				<!-- Sidebar Filters -->
				<div class="sidebar">
					<div class="filter-section">
						<h3 class="filter-title">Đánh giá</h3>
						<div class="rating-filter">
							<label class="rating-item"> <input type="radio"
								name="rating" value="4.5"> <span class="star-rating">★
									★ ★ ★ ★</span> <span>Từ 4.5 trở lên</span>
							</label> <label class="rating-item"> <input type="radio"
								name="rating" value="4"> <span class="star-rating">★
									★ ★ ★ ☆</span> <span>Từ 4.0 trở lên</span>
							</label> <label class="rating-item"> <input type="radio"
								name="rating" value="3.5"> <span class="star-rating">★
									★ ★ ☆ ☆</span> <span>Từ 3.5 trở lên</span>
							</label> <label class="rating-item"> <input type="radio"
								name="rating" value="3.0"> <span class="star-rating">★
									★ ★ ☆ ☆</span> <span>Từ 3.0 trở lên</span>
							</label>
						</div>
					</div>
					<div class="filter-section">
						<!-- <button type="submit" class="btn-filter">Lọc</button> -->
						<button type="submit"
							style="padding: 10px 20px; font-size: 16px; color: white; background-color: #007bff; border: none; border-radius: 15px; cursor: pointer; transition: background-color 0.3s, transform 0.2s;">
							Lọc khóa học</button>
					</div>
				</div>
			</div>
		</form>
		<div class="course-list">
			<c:forEach items="${CourseList}" var="i">
				<div
					style="display: flex; background-color: white; border-radius: 5px; overflow: hidden; margin-bottom: 15px; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);">
					<div
						style="padding: 15px; flex: 1; display: flex; flex-direction: column; justify-content: space-between;">
						<div>
				<h3 id="courseName"  
    style="font-size: 16px; font-weight: bold; margin-bottom: 5px; color: #333; cursor: pointer;"
    onclick="window.location.href='${pageContext.request.contextPath}/course/courseDetail?courseId=${i.id}'">
    ${i.courseName}
</h3>

							<p class="instructor">${i.teacher.fullname}</p>
							<c:set var="reviewCount" value="0" scope="page" />
							<div class="rating">
								<c:set var="sum" value="0" />
								<c:set var="reviewCount" value="0" />

								<!-- Lặp qua Review để tính tổng điểm và đếm số lượng -->
								<c:forEach items="${Review}" var="r">
									<c:if test="${r.course.id == i.id}">
										<c:set var="sum" value="${sum + r.rate}" />
										<c:set var="reviewCount" value="${reviewCount + 1}" />
									</c:if>
								</c:forEach>

								<!-- Kiểm tra nếu có review -->
								<c:choose>
									<c:when test="${reviewCount > 0}">
										<!-- Tính trung bình -->
										<c:set var="average" value="${sum / reviewCount}" />

										<!-- Làm tròn: ví dụ 3.4 => 3; 3.5 => 4 -->
										<c:set var="roundedRating"
											value="${average - (average % 1) + (average % 1 ge 0.5 ? 1 : 0)}" />
										<c:if test="${roundedRating > 5}">
											<c:set var="roundedRating" value="5" />
										</c:if>
										<c:if test="${roundedRating < 0}">
											<c:set var="roundedRating" value="0" />
										</c:if>
										<span class="stars"
											style="color: gold; font-size: 20px; margin-left: -130px;">
											<c:forEach begin="1" end="${roundedRating}" var="star">★
												</c:forEach> <!-- Empty stars to complete 5 stars --> <c:forEach
												begin="1" end="${5 - roundedRating}" var="star">☆</c:forEach>
										</span>
									</c:when>
									<c:otherwise>
										<span>No reviews yet</span>
									</c:otherwise>
								</c:choose>

								<!-- Hiển thị tổng số đánh giá -->
								<span class="rating-count">(${reviewCount})</span>
							</div>

							<c:if
								test="${i.courseDetail.courseImage.substring(0,5) != 'https' }">
								<c:url value="/image?fname=${i.courseDetail.courseImage}"
									var="imgUrl"></c:url>
							</c:if>
							<c:if
								test="${i.courseDetail.courseImage.substring(0,5) == 'https' }">
								<c:url value="${i.courseDetail.courseImage}" var="imgUrl"></c:url>
							</c:if>

							<img src="${imgUrl}" alt="Picture"
								style="width: 200px; height: auto;">
						</div>
					</div>

					<div class="price-container">
						<!-- Display course price and original price -->
						<span class="price">${i.coursePrice}</span>
					</div>
				</div>
			</c:forEach>
		</div>

		<!-- Chat Bubble -->
		<div class="chat-bubble">
			💬 <span class="notification">1</span>
		</div>
	</div>
</body>
</html>