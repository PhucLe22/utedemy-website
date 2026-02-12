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

            <form action="${pageContext.request.contextPath}/user/search" method="post">
                <div class="search-box-inner">
                    <input type="text" name="keyword" placeholder="Tìm khóa học, giảng viên">
                    <button class="search-btn">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
             </form>
           <c:if test="${not empty sessionScope.account}">
    <!-- User is logged in - show cart, favorites and avatar with dropdown -->
    <div class="user-menu-container">
      <a href="${pageContext.request.contextPath}/user/cart"><i class="fas fa-shopping-cart cart-icon"></i></a>
      <a href="${pageContext.request.contextPath}/user/favoriteCourse"><i class="fas fa-heart heart-icon"></i></a>
      <div class="dropdown">    
       <c:if test="${sessionScope.account.avatarUrl != ''}">
                                          <c:if test ="${sessionScope.account.avatarUrl.substring(0,5) != 'https' }">
                                             <c:url value="/image?fname=${sessionScope.account.avatarUrl}" var="imgUrl_avt"></c:url>
                                         </c:if>
                                  <c:if test ="${sessionScope.account.avatarUrl.substring(0,5) == 'https' }">
                                          <c:url value="${sessionScope.account.avatarUrl}" var="imgUrl_avt"></c:url>
                                 </c:if>
                         </c:if>                   
        <img src="${imgUrl_avt}" alt="User Avatar" class="avatar-img" id="avatarDropdown">
        
        <div class="dropdown-content" id="userDropdown">
         <a href="${pageContext.request.contextPath}/user/mycourse">Vào học</a>
          <a href="/member">Hội viên</a>
          <a href="/activate-course">Kích hoạt khóa học</a>
        <c:forEach var="role" items="${sessionScope.account.roles}">
    <c:if test="${role.id == 2}">
        <a href="${pageContext.request.contextPath}/teacher/course">Giảng viên</a>
    </c:if>
</c:forEach>

          <a href="${pageContext.request.contextPath}/user/InformationManagement">Cập nhật hồ sơ</a>
          <a href="/wallet">Ví của bạn</a>
           <a href="${pageContext.request.contextPath}/user/viewcheckout">Xem đơn hàng đang đặt</a>
          <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </div>
      </div>
    </div>
  </c:if>
  
  <c:if test="${empty sessionScope.account}">
    <!-- User is not logged in - show login and signup buttons -->
    <a href="${pageContext.request.contextPath}/login"><i class="fas fa-shopping-cart cart-icon"></i></a>
    <a href="${pageContext.request.contextPath}/login"><i class="fas fa-heart heart-icon"></i></a>
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