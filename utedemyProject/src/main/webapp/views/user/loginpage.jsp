<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Utedemy - Đăng Nhập</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/loginpage.css">
</head>
<body>
    <div class="login-wrapper">
        <div class="login-card">
            <div class="logo">Utedemy</div>
            <p class="subtitle">Đăng nhập vào tài khoản của bạn</p>

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

            <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="email">Email / Số điện thoại</label>
                    <input type="text" id="email" name="email" placeholder="Nhập email hoặc số điện thoại" required>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                        <span class="password-toggle" onclick="togglePassword()">
                            <svg id="eye-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                                <path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8zM1.173 8a13.133 13.133 0 0 1 1.66-2.043C4.12 4.668 5.88 3.5 8 3.5c2.12 0 3.879 1.168 5.168 2.457A13.133 13.133 0 0 1 14.828 8c-.058.087-.122.183-.195.288-.335.48-.83 1.12-1.465 1.755C11.879 11.332 10.119 12.5 8 12.5c-2.12 0-3.879-1.168-5.168-2.457A13.134 13.134 0 0 1 1.172 8z"/>
                                <path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5zM4.5 8a3.5 3.5 0 1 1 7 0 3.5 3.5 0 0 1-7 0z"/>
                            </svg>
                        </span>
                    </div>
                </div>

                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember">
                        <span>Ghi nhớ đăng nhập</span>
                    </label>
                    <a href="${pageContext.request.contextPath}/views/user/forgotPassword.jsp" class="forgot-link">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="login-btn">Đăng nhập</button>
            </form>

            <div class="signup-link">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/user/register">Đăng ký ngay</a>
            </div>

            <div class="test-accounts">
                <div class="test-accounts-title">Tài khoản thử nghiệm</div>
                <div class="test-account-row" onclick="fillDemo()">
                    <div class="test-account-role">Demo</div>
                    <div class="test-account-info">
                        <span>demo@utedemy.com</span>
                        <span>Demo@1234</span>
                    </div>
                </div>
                <div class="test-account-row" onclick="fillTeacher()">
                    <div class="test-account-role">Giảng viên</div>
                    <div class="test-account-info">
                        <span>teacher@utedemy.com</span>
                        <span>test123</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function fillDemo() {
            document.getElementById('email').value = 'demo@utedemy.com';
            document.getElementById('password').value = 'Demo@1234';
        }

        function fillTeacher() {
            document.getElementById('email').value = 'teacher@utedemy.com';
            document.getElementById('password').value = 'test123';
        }

        function togglePassword() {
            const field = document.getElementById('password');
            field.type = field.type === 'password' ? 'text' : 'password';
        }

        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value.trim();
            if (email === '' || password === '') {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin đăng nhập');
            }
        });

        document.addEventListener('DOMContentLoaded', function() {
            const alertEl = document.querySelector('.alert-error');
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
