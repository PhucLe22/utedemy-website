<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unica - ${teacher.fullname} Profile</title>
   
</head>
<body>
    <!-- Profile Header -->
    <div style="position: relative; height: 250px; background: linear-gradient(rgba(255,255,255,0.8), rgba(255,255,255,0.8)), url('https://via.placeholder.com/1200x250') center/cover; display: flex; padding: 20px 50px;">
        <div style="display: flex; align-items: center; margin-top: 30px;">
            <c:choose>
                <c:when test="${not empty teacher.avatarUrl}">
                    <img src="${teacher.avatarUrl}" alt="${teacher.fullname}" style="width: 150px; height: 150px; border-radius: 50%; border: 5px solid white; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/views/images/default-avatar.jpg" alt="${teacher.fullname}" style="width: 150px; height: 150px; border-radius: 50%; border: 5px solid white; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                </c:otherwise>
            </c:choose>
            <div style="margin-left: 30px;">
                <h1 style="font-size: 28px; font-weight: bold; margin-bottom: 5px;">${teacher.fullname}</h1>
                <p style="font-size: 16px; color: #555; margin-bottom: 20px;">${teacher.description}</p>
                <div style="margin-top: 10px;">
                    <button style="background-color: transparent; border: 1px solid #ccc; padding: 8px 16px; border-radius: 4px; margin-right: 10px; cursor: pointer; display: inline-flex; align-items: center;">
                        <span style="margin-right: 5px;">👨‍👦‍👦</span> Follow mình
                    </button>
                    <button style="background-color: transparent; border: 1px solid #ccc; padding: 8px 16px; border-radius: 4px; margin-right: 10px; cursor: pointer; display: inline-flex; align-items: center;">
                        <span style="margin-right: 5px;">✉️</span> Nhắn cho mình
                    </button>
                </div>
                <div style="margin-top: 10px; color: #666;">
                    <p style="margin: 5px 0;"><strong>Email:</strong> ${teacher.email}</p>
                    <p style="margin: 5px 0;"><strong>Số điện thoại:</strong> ${teacher.phoneNumber}</p>
                </div>
            </div>
        </div>

        <div style="position: absolute; right: 50px; bottom: 30px; display: flex; text-align: center;">
            <div style="margin-left: 20px;">
                <span style="font-size: 30px; font-weight: bold; display: block; color: #333;">${teacher.course != null ? teacher.course.size() : 0}</span>
                <span style="font-size: 14px; color: #666;">khóa học</span>
            </div>
            <div style="margin-left: 20px;">
                <span style="font-size: 30px; font-weight: bold; display: block; color: #333;">14725</span>
                <span style="font-size: 14px; color: #666;">học viên</span>
            </div>
            <div style="margin-left: 20px;">
                <span style="font-size: 30px; font-weight: bold; display: block; color: #333;">5 <span style="color: orange; font-size: 32px;">★</span></span>
                <span style="font-size: 14px; color: #666;">đánh giá</span>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div style="display: flex; padding: 30px 50px; gap: 30px;">
        <div style="flex: 2;">
            <!-- Bio Section -->
            <div style="background-color: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); padding: 20px; margin-bottom: 30px;">
                <h2 style="font-size: 20px; font-weight: bold; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid #eee;">Giới thiệu</h2>
                <div>
                    <p style="margin-bottom: 15px; line-height: 1.6;">${teacher.description}</p>
                    <c:if test="${not empty teacher.socialUrl}">
                        <p style="margin-bottom: 15px; line-height: 1.6;"><strong>Link mạng xã hội:</strong> <a href="${teacher.socialUrl}" target="_blank" style="color: #1890ff; text-decoration: none;">${teacher.socialUrl}</a></p>
                    </c:if>
                </div>
            </div>

            <!-- Course Section -->
            <div style="background-color: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); padding: 20px; margin-bottom: 30px;">
                <h2 style="font-size: 20px; font-weight: bold; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid #eee;">Khóa học của giảng viên ${teacher.fullname}</h2>
                <c:if test="${not empty teacher.course}">
                    <c:forEach var="course" items="${teacher.course}">
                        <div style="display: flex; margin-bottom: 20px; border: 1px solid #eee; border-radius: 8px; overflow: hidden;">
                            <c:choose>
                                <c:when test="${not empty course.courseDetail.courseImage}">
                                    <img src="${course.courseDetail.courseImage}" alt="Course" style="width: 200px; height: 120px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/views/images/default-course.jpg" alt="Course" style="width: 200px; height: 120px; object-fit: cover;">
                                </c:otherwise>
                            </c:choose>
                            <div style="padding: 15px; flex-grow: 1;">
                         
                                <h3 id="courseName"  
    style="font-size: 18px; font-weight: bold; margin-bottom: 10px;"
    onclick="window.location.href='${pageContext.request.contextPath}/course/courseDetail?courseId=${course.id}'">
    ${course.courseName}
</h3>
                                
                                
                                <div style="display: flex; align-items: center; margin-bottom: 10px; color: #666; font-size: 14px;">
                                    <span style="margin-right: 20px; display: flex; align-items: center;"><span style="margin-right: 5px;">📝</span> ${course.sections != null ? course.sections.size() : 0} bài giảng</span>
                                </div>
                                <p style="color: #555; font-size: 14px; margin-bottom: 10px;">${course.courseDetail.courseIntroduction}</p>
                            </div>
                            <div style="text-align: right; padding: 15px;">
                                <div style="font-size: 24px; font-weight: bold; color: #333;"><fmt:formatNumber value="${course.coursePrice}" type="number" groupingUsed="true"/>₫</div>
                                <div style="font-size: 16px; color: #999; text-decoration: line-through;"><fmt:formatNumber value="${course.coursePrice * 1.5}" type="number" groupingUsed="true"/>₫</div>
                                <div style="display: inline-block; background-color: #ff4d4f; color: white; padding: 3px 8px; border-radius: 4px; font-size: 14px; font-weight: bold; margin-top: 5px;">OFF 33%</div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${empty teacher.course}">
                    <p>Giảng viên này chưa có khóa học nào.</p>
                </c:if>
            </div>
        </div>

        <div style="flex: 1;">
            <!-- Video Section đã bị xóa -->
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Page loaded successfully');
            const followButton = document.querySelector('button:nth-child(1)');
            followButton.addEventListener('click', function() {
                alert('Đã theo dõi giảng viên ${teacher.fullname}!');
            });
            
            const messageButton = document.querySelector('button:nth-child(2)');
            messageButton.addEventListener('click', function() {
                alert('Chức năng nhắn tin đang được phát triển!');
            });
        });
    </script>
</body>
</html>