<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/forgotPassword.css">
</head>
<body>
    <div class="forgot-password-container">
        <h1 class="title">QUÊN MẬT KHẨU</h1>
        
        <% if(request.getAttribute("message") != null) { %>
            <div class="success-message" style="display: block;">
                <%= request.getAttribute("message") %>
            </div>
        <% } %>
        
        <% if(request.getAttribute("error") != null) { %>
            <div class="error-message" style="display: block;">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/user/forgotPassword" method="POST" id="forgotPasswordForm">
            <div class="label">EMAIL</div>
            <input type="text" class="input-field" name="email" id="email" placeholder="Email" required>
            <div id="emailError" class="error-message"></div>
            
            <button type="submit" class="submit-btn">GỬI THÔNG TIN</button>
        </form>
        
        <div class="footer">
            <a href="${pageContext.request.contextPath}/login" class="login-link">Đăng nhập</a>
            <div>Bạn chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" class="register-link">Đăng ký ngay</a></div>
        </div>
    </div>
    
    <script>
        // Hàm kiểm tra email hợp lệ
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }
        
        document.getElementById('forgotPasswordForm').addEventListener('submit', function(event) {
            const email = document.getElementById('email').value.trim();
            const emailError = document.getElementById('emailError');
            
            // Kiểm tra trường nhập có hợp lệ không
            if (!isValidEmail(email)) {
                emailError.textContent = "Vui lòng nhập email hợp lệ";
                emailError.style.display = "block";
                event.preventDefault(); // Ngăn form submit nếu không hợp lệ
            } else {
                emailError.style.display = "none";
            }
        });
    </script>
</body>
</html>