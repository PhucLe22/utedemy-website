<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/header.css">
<header class="header-container">
	<div class="top-bar">
		<div class="logo-section">
			    <a href="${pageContext.request.contextPath}/user/homepage">
        <span class="unica-logo">unica</span>
    </a>
		</div>
		<form action="${pageContext.request.contextPath}/user/search"
			method="post">
			<div class="search-box-inner">
				<input type="text" name="keyword"
					placeholder="Tìm khóa học, giảng viên">
				<button class="search-btn">
					<i class="fas fa-search"></i>
				</button>
			</div>
		</form>
		<c:if test="${not empty sessionScope.account}">
			<!-- User is logged in - show cart, favorites and avatar with dropdown -->
			<div>
				<div class="dropdown"
					style="position: relative; display: inline-block;">
					<!-- Hình ảnh thông báo -->
					<c:if test="${!empty slthongbao}">
						<a href="#" onclick="toggleDropdown(event)" class="nav-link"
							style="color: white; margin: 0 10px; text-decoration: none; padding: 8px; border-radius: 4px; position: relative;">
							
							<img src="/do_An/Content/Images/notification.png"
							
							alt="Notification" valign="middle" width="20" height="20" /> <span
							class="notification-count"
							style="position: absolute; top: 0; right: -5px; background: red; color: white; font-size: 10px; padding: 2px 5px; border-radius: 50%;">${slthongbao}</span>
						</a>
					</c:if>

					<!-- Nội dung dropdown -->
					<div class="dropdown-content" id="notificationDropdown"
						style="display: none; position: absolute; background-color: white; padding: 15px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2); border-radius: 8px; width: 300px; right: 0; z-index: 1000; max-height: 400px; overflow-y: auto;">
						<p style="font-weight: bold; margin: 0 0 10px; color: #333;">Các
							thông báo</p>
						<c:forEach items="${listthongbao}" var="thongbao">
							<div class="notification-item"
								style="border-bottom: 1px solid #ddd; padding: 10px 0;">
								<div
									style="display: flex; justify-content: space-between; align-items: center;">
									<p style="margin: 0; color: black; flex: 1;">${thongbao.content}</p>
									<!-- Nút xóa -->
									<a href="deleteNotification?id=${thongbao.id}"
										style="color: red; text-decoration: none; font-size: 12px; margin-left: 10px;">Xóa</a>
								</div>
								<p style="margin: 5px 0; color: gray; font-size: 12px;">${thongbao.sentDate}</p>
								<a href="#"
									style="color: #007BFF; text-decoration: none; font-size: 12px;">View
									full notification</a>
							</div>
						</c:forEach>
						<a href="#"
							style="display: block; text-align: center; color: #007BFF; text-decoration: none; margin-top: 10px; font-weight: bold;">See
							all</a>
					</div>
				</div>
			</div>
			<div class="user-menu-container">
				<div class="dropdown">
					<c:if test="${sessionScope.account.avatarUrl != ''}">
						<c:if
							test="${sessionScope.account.avatarUrl.substring(0,5) != 'https' }">
							<c:url value="/image?fname=${sessionScope.account.avatarUrl}"
								var="imgUrl_avt"></c:url>
						</c:if>
						<c:if
							test="${sessionScope.account.avatarUrl.substring(0,5) == 'https' }">
							<c:url value="${sessionScope.account.avatarUrl}" var="imgUrl_avt"></c:url>
						</c:if>
					</c:if>
					<img src="${imgUrl_avt}" alt="User Avatar" class="avatar-img"
						id="avatarDropdown">

					<div class="dropdown-content" id="userDropdown">
						<a href="${pageContext.request.contextPath}/user/mycourse">Vào học</a> <a href="/member">Hội viên</a> <a
							href="/activate-course">Kích hoạt khóa học</a> <c:forEach var="role" items="${sessionScope.account.roles}">
    <c:if test="${role.id == 2}">
        <a href="${pageContext.request.contextPath}/teacher/course">Giảng viên</a>
    </c:if>
</c:forEach> <a href="/profile">Cập nhật
							hồ sơ</a> <a href="/wallet">Ví của bạn</a> <a href="${pageContext.request.contextPath}/logout">Đăng
							xuất</a>
					</div>
				</div>
			</div>
		</c:if>

		<c:if test="${empty sessionScope.account}">
			<!-- User is not logged in - show login and signup buttons -->
			<a href="/cart"><i class="fas fa-shopping-cart cart-icon"></i></a>
			<a href="/favorites"><i class="fas fa-heart heart-icon"></i></a>
			<a href="${pageContext.request.contextPath}/login">
				<button class="login-btn">Đăng nhập</button>
			</a>
			<a href="${pageContext.request.contextPath}/user/register">
				<button class="signup-btn">Đăng ký</button>
			</a>


		</c:if>
	</div>

</header>
<script src="${pageContext.request.contextPath}/views/Script/header.js"></script>