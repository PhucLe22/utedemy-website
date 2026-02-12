<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Utedemy - Đăng Ký</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/loginpage.css">
</head>
<body>
    <div class="login-wrapper">
        <div class="login-card">
            <div class="logo">Utedemy</div>
            <p class="subtitle">Tạo tài khoản mới</p>

            <c:if test="${not empty alert}">
                <div class="alert-error">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                        <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
                    </svg>
                    <span>${alert}</span>
                </div>
                <c:remove var="alert" scope="session" />
            </c:if>

            <form id="registrationForm" action="${pageContext.request.contextPath}/user/register" method="post">
                <div class="form-group">
                    <label for="fullname">Họ tên</label>
                    <input type="text" id="fullname" name="fullname" placeholder="Nhập họ tên" required>
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="Nhập email" required>
                </div>

                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <input type="tel" id="phone" name="phone" placeholder="Nhập số điện thoại" required>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                    </div>
                    <div id="passwordError" style="font-size:12px;color:#dc2626;margin-top:5px;"></div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Nhập lại mật khẩu</label>
                    <div class="password-container">
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                    </div>
                    <div id="confirmError" style="font-size:12px;color:#dc2626;margin-top:5px;"></div>
                </div>

                <button type="submit" class="login-btn">Đăng ký</button>
            </form>

            <div class="signup-link">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
            var password = document.getElementById('password').value;
            var confirm = document.getElementById('confirmPassword').value;
            var pwError = document.getElementById('passwordError');
            var cfError = document.getElementById('confirmError');

            pwError.textContent = '';
            cfError.textContent = '';

            if (password.length < 6) {
                e.preventDefault();
                pwError.textContent = 'Mật khẩu phải có ít nhất 6 ký tự';
                return;
            }

            if (password !== confirm) {
                e.preventDefault();
                cfError.textContent = 'Mật khẩu không khớp';
                return;
            }
        });

        document.addEventListener('DOMContentLoaded', function() {
            var alertEl = document.querySelector('.alert-error');
            if (alertEl) {
                setTimeout(function() {
                    alertEl.style.opacity = '0';
                    setTimeout(function() { alertEl.remove(); }, 400);
                }, 5000);
            }
        });
    </script>
</body>
</html>
