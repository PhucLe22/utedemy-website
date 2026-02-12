<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/viewCourseDetails.css">

<c:if test="${not empty error}">
    <div class="alert-banner alert-error">${error}</div>
</c:if>
<c:if test="${not empty warning}">
    <div class="alert-banner alert-warning">${warning}</div>
</c:if>

<!-- Popup -->
<div id="overlay" class="overlay"></div>
<div id="customPopup" class="popup">
    <div id="popupMessage" class="popup-message"></div>
    <button id="popupClose" class="popup-close">Đóng</button>
</div>

<!-- Banner -->
<section class="course-banner">
    <div class="banner-inner">
        <div class="banner-info">
            <div class="banner-category">${courseTypeName}</div>
            <h1 class="banner-title">${courseName}</h1>
            <p class="banner-desc">${courseIntroduction}</p>
            <div class="banner-meta">
                <span class="meta-stars">★★★★★</span>
                <span class="meta-text">(258 đánh giá)</span>
                <span class="meta-divider">|</span>
                <span class="meta-text">${courseLearner}</span>
            </div>
            <div class="banner-instructor">Giảng viên: <a href="#">${teacherName}</a></div>
        </div>
        <div class="banner-video">
            <c:choose>
                <c:when test="${not empty courseVideo}">
                    <c:set var="embedUrl" value="${fn:replace(courseVideo, 'watch?v=', 'embed/')}" />
                    <iframe src="${embedUrl}" title="Video" frameborder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowfullscreen></iframe>
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/image?fname=${courseImage}" alt="Course">
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<!-- Main layout -->
<div class="detail-container">
    <div class="detail-main">

        <!-- Learning outcomes -->
        <div class="card">
            <h2 class="card-title">Bạn sẽ học được</h2>
            <div class="learning-grid">
                <c:forEach var="achievement" items="${learnerAchievements}">
                    <div class="learning-item">
                        <span class="learning-check">✓</span>
                        <span>${achievement}</span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Description -->
        <div class="card">
            <h2 class="card-title">Giới thiệu khóa học</h2>
            <div class="card-body">
                <p>${description}</p>
            </div>
        </div>

        <!-- Course content / sections -->
        <div class="card">
            <h2 class="card-title">Nội dung khóa học</h2>
            <div class="modules">
                <c:choose>
                    <c:when test="${not empty sections}">
                        <c:forEach var="section" items="${sections}">
                            <div class="module">
                                <div class="module-header">
                                    <span class="module-arrow">▼</span>
                                    <span class="module-name">${section.title}</span>
                                </div>
                                <div class="module-body collapsed">
                                    <c:forEach var="lesson" items="${section.lessons}">
                                        <div class="lesson-row">
                                            <span class="lesson-icon">▶</span>
                                            <span class="lesson-name">${lesson.title}</span>
                                        </div>
                                    </c:forEach>
                                    <c:forEach var="quiz" items="${section.quizs}">
                                        <div class="lesson-row">
                                            <span class="lesson-icon">📝</span>
                                            <span class="lesson-name">${quiz.title}</span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="empty-text">Chưa có nội dung khóa học.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Instructor -->
        <div class="card">
            <h2 class="card-title">Giảng viên</h2>
            <div class="instructor-card">
                <div class="instructor-avatar">
                    <c:choose>
                        <c:when test="${teacherAvatar.substring(0,5) == 'https'}">
                            <img src="${teacherAvatar}" alt="${teacherName}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/image?fname=${teacherAvatar}" alt="${teacherName}">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="instructor-detail">
                    <c:choose>
                        <c:when test="${not empty teacher and not empty teacher.id}">
                            <a href="${pageContext.request.contextPath}/viewTeacherProfile?id=${teacher.id}" class="instructor-name">${teacher.fullname}</a>
                        </c:when>
                        <c:otherwise>
                            <span class="instructor-name">${teacher.fullname}</span>
                        </c:otherwise>
                    </c:choose>
                    <p class="instructor-meta-item"><i class="fas fa-map-marker-alt"></i> ${teacher.address}</p>
                    <p class="instructor-meta-item"><i class="fas fa-envelope"></i> ${teacher.email}</p>
                    <p class="instructor-meta-item"><i class="fas fa-phone-alt"></i> ${teacher.phoneNumber}</p>
                    <c:if test="${not empty teacher.description}">
                        <p class="instructor-bio-text">${teacher.description}</p>
                    </c:if>
                    <c:if test="${not empty teacher.socialUrl}">
                        <a href="${teacher.socialUrl}" target="_blank" class="instructor-social"><i class="fas fa-link"></i> Mạng xã hội</a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Reviews -->
        <div class="card">
            <h2 class="card-title">Đánh giá của học viên</h2>
            <c:choose>
                <c:when test="${not empty reviews}">
                    <c:forEach var="review" items="${reviews}">
                        <div class="review-item">
                            <div class="review-top">
                                <span class="review-author">${review.createdBy.fullname}</span>
                                <span class="review-date"><fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/></span>
                            </div>
                            <div class="review-stars">
                                <fmt:parseNumber var="rateDouble" value="${review.rate}" type="number" />
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= rateDouble}">★</c:when>
                                        <c:otherwise>☆</c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span class="review-rate">${review.rate}</span>
                            </div>
                            <p class="review-text">${review.content}</p>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="empty-text">Chưa có đánh giá nào cho khóa học này.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Sidebar -->
    <aside class="detail-sidebar">
        <div class="sidebar-card">
            <div class="sidebar-price">
                <span class="price-current">
                    <fmt:formatNumber value="${currentPrice}" type="currency" currencySymbol="" groupingUsed="true" pattern="#,###"/>đ
                </span>
                <span class="price-original">
                    <fmt:formatNumber value="${originalPrice}" type="currency" currencySymbol="" groupingUsed="true" pattern="#,###"/>đ
                </span>
            </div>

            <div class="sidebar-actions">
                <c:if test="${orderStatus != 'COMPLETED'}">
                    <button class="btn btn-outline" onclick="addToCart(${courseDetail.course.id})">Thêm vào giỏ hàng</button>
                </c:if>
                <c:choose>
                    <c:when test="${orderStatus == 'COMPLETED'}">
                        <button class="btn btn-primary" onclick="goToLearn(${courseDetail.course.id})">Vào học ngay</button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-primary" onclick="buyNow(${courseDetail.course.id})">Mua ngay</button>
                    </c:otherwise>
                </c:choose>
            </div>

            <button class="btn-wishlist" id="wishlistButton" data-course-id="${courseDetail.course.id}" data-user-id="${sessionScope.account.id}">
                <span style="color: ${isFavorite ? 'red' : '#999'}">❤</span>
                <span>Yêu thích</span>
            </button>

            <div class="sidebar-features">
                <div class="feature-row">
                    <span>📚</span>
                    <span>${courseLessions} Bài giảng</span>
                </div>
                <div class="feature-row">
                    <span>🔄</span>
                    <span>Sở hữu trọn đời</span>
                </div>
            </div>
        </div>
    </aside>
</div>

<script>
function buyNow(courseId) {
    window.location.href = '${pageContext.request.contextPath}/user/viewcheckout?courseIdnow=' + courseId;
}

function goToLearn(courseId) {
    window.location.href = '${pageContext.request.contextPath}/views/user/Course?courseId=' + courseId;
}

function showPopup(message, isSuccess) {
    var popup = document.getElementById('customPopup');
    var msg = document.getElementById('popupMessage');
    var overlay = document.getElementById('overlay');
    msg.textContent = message;
    popup.className = 'popup ' + (isSuccess ? 'success' : 'error');
    popup.style.display = 'block';
    overlay.style.display = 'block';
}

function hidePopup() {
    document.getElementById('customPopup').style.display = 'none';
    document.getElementById('overlay').style.display = 'none';
}

document.getElementById('popupClose').addEventListener('click', hidePopup);

// Wishlist
document.getElementById('wishlistButton').addEventListener('click', function() {
    var courseId = this.getAttribute('data-course-id');
    var userId = this.getAttribute('data-user-id');

    if (!userId) {
        showPopup('Vui lòng đăng nhập để thêm vào danh sách yêu thích!', false);
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open('POST', '${pageContext.request.contextPath}/user/addFavoriteCourse', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var response = JSON.parse(xhr.responseText);
            if (response.success) {
                showPopup('Đã thêm vào danh sách yêu thích!', true);
            } else {
                showPopup(response.message || 'Đã xảy ra lỗi!', false);
            }
        }
    };
    xhr.send('courseId=' + encodeURIComponent(courseId) + '&userId=' + encodeURIComponent(userId));
});

// Add to cart
function addToCart(courseId) {
    var userId = '${sessionScope.account.id}';
    if (!userId) {
        showPopup('Vui lòng đăng nhập để thêm vào giỏ hàng!', false);
        return;
    }

    fetch('${pageContext.request.contextPath}/user/addcart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'id=' + encodeURIComponent(courseId)
    })
    .then(function(r) { return r.text(); })
    .then(function(data) {
        if (data === 'success') {
            showPopup('Thêm vào giỏ hàng thành công!', true);
        } else {
            showPopup('Thêm vào giỏ hàng thất bại!', false);
        }
    });
}

// Module toggle
document.addEventListener('DOMContentLoaded', function() {
    var headers = document.querySelectorAll('.module-header');
    headers.forEach(function(header) {
        header.addEventListener('click', function() {
            var body = this.nextElementSibling;
            var arrow = this.querySelector('.module-arrow');
            if (body.classList.contains('collapsed')) {
                body.classList.remove('collapsed');
                body.classList.add('expanded');
                arrow.textContent = '▲';
            } else {
                body.classList.remove('expanded');
                body.classList.add('collapsed');
                arrow.textContent = '▼';
            }
        });
    });
});
</script>
