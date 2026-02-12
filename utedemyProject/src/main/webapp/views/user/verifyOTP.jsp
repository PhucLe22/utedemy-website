<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập bằng OTP</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/verifyOTP.css">
</head>
<body>
    <div class="otp-container">
        <h1 class="otp-header">Đăng nhập bằng OTP</h1>
        <p class="otp-instructions">Nhập OTP được cung cấp trong thư điện tử gửi cho ${email}.</p>
        
        <form id="otpForm" action="${pageContext.request.contextPath}/user/verifyOTP" method="post">
        	<input type="hidden" name="email" value="${email}">
			<div class="otp-input-group">
				<input class="otp-input" name="otp1" type="text" maxlength="1" oninput="onlyNumbersAndMove(this)" onkeydown="handleKeyDown(event, this)">
				<input class="otp-input" name="otp2" type="text" maxlength="1" oninput="onlyNumbersAndMove(this)" onkeydown="handleKeyDown(event, this)">
				<input class="otp-input" name="otp3" type="text" maxlength="1" oninput="onlyNumbersAndMove(this)" onkeydown="handleKeyDown(event, this)">
				<input class="otp-input" name="otp4" type="text" maxlength="1" oninput="onlyNumbersAndMove(this)" onkeydown="handleKeyDown(event, this)">
				<input class="otp-input" name="otp5" type="text" maxlength="1" oninput="onlyNumbersAndMove(this)" onkeydown="handleKeyDown(event, this)">
				<input class="otp-input" name="otp6" type="text" maxlength="1" oninput="onlyNumbersAndMove(this)" onkeydown="handleKeyDown(event, this)">
			</div>
			
			<button id="continueBtn" type="button" class="otp-submit-btn" disabled>Tiếp tục</button>
		</form>
        
        <!-- Thêm phần hiển thị thông báo lỗi -->
  		<div id="error-message" style="color: red; text-align: center; margin-top: 10px; display: none;"></div>
  
        <div class="resend-timer">
            Gửi lại email <span id="countdown" class="countdown">01:30</span>
        </div>
        
        <hr class="divider">
        
        <div class="alt-login">Đăng nhập bằng cách khác</div>
        <a href="/do_An/sheller/dangNhap" class="password-link">Sử dụng mật khẩu</a>
        
        <div class="footer-note">
            Khi đăng nhập, tôi đồng ý với các <a href="#">Điều khoản</a>.
        </div>
    </div>

	<script src="${pageContext.request.contextPath}/views/Script/verifyOTP.js"></script>
    <script>
    	document.addEventListener('DOMContentLoaded', function() {
    	  const email = "${email}";
    	  startCountdown(email);
    	  
    	  // Thêm sự kiện cho nút Tiếp tục
    	  const continueBtn = document.getElementById('continueBtn');
    	  continueBtn.addEventListener('click', function() {
    	    submitOTPForm();
    	  });
    	  
    	// Đảm bảo rằng liên kết "gửi lại mã OTP" cũng hoạt động nếu đã hiển thị
    	  const resendLink = document.getElementById('resendOTPLink');
    	  if (resendLink) {
    	    resendLink.onclick = function(e) {
    	      e.preventDefault();
    	      resendOTP();
    	      return false;
    	    };
    	  }
    	});
		 
    </script>
</body>
</html>
