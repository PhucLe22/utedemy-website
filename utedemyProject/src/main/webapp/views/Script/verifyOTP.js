/**
 * 
 */
		// Khởi tạo đồng hồ đếm ngược
		function startCountdown(email) {
		  let timeLeft = 90; // 1:30 in seconds
		  const countdownElement = document.getElementById('countdown');
		  
		  // Xóa interval cũ nếu có
		  if (window.countdownInterval) {
		    clearInterval(window.countdownInterval);
		  }
		  
		  window.countdownInterval = setInterval(() => {
		    timeLeft--;
		    const minutes = Math.floor(timeLeft / 60);
		    const seconds = timeLeft % 60;
		    countdownElement.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
		    
		    if (timeLeft <= 0) {
		      clearInterval(countdownInterval);
		      // Vô hiệu hóa tất cả các ô nhập OTP
		      disableOTPInputs();
		      // Hiển thị thông báo cho người dùng biết thời gian đã hết
		      showTimeoutMessage();
		      
		      deleteOTPFromDatabase(email);
		    }
		  }, 1000);
		}
		
		// Hàm để xóa mã OTP trong database
		function deleteOTPFromDatabase(email) {
		  // Sử dụng fetch API để gọi đến API xóa OTP
		  fetch(window.contextPath + '/user/deleteOTP', {
		    method: 'POST',
		    headers: {
		      'Content-Type': 'application/json',
		    },
		    body: JSON.stringify({
		      email: email
		    })
		  })
		  .then(response => {
		    if (!response.ok) {
		      throw new Error('Network response was not ok');
		    }
		    return response.json();
		  })
		  .then(data => {
		    console.log('OTP deleted successfully:', data);
		  })
		  .catch(error => {
		    console.error('Error deleting OTP:', error);
		  });
		}
		
		// Hàm vô hiệu hóa tất cả các ô nhập OTP
		function disableOTPInputs() {
		  const otpInputs = document.querySelectorAll('.otp-input');
		  otpInputs.forEach(input => {
		    input.disabled = true;
		    input.style.backgroundColor = "#f0f0f0"; // Đổi màu nền để thể hiện trạng thái vô hiệu hóa
		    input.style.cursor = "not-allowed"; // Thay đổi con trỏ khi di chuột qua
		  });
		  
		  // Vô hiệu hóa nút Tiếp tục
		  const continueBtn = document.getElementById('continueBtn');
		  if (continueBtn) {
		    continueBtn.disabled = true;
		  }
		}
		
		// Hiển thị thông báo khi thời gian hết
		function showTimeoutMessage() {
		  const resendTimer = document.querySelector('.resend-timer');
		  if (resendTimer) {
		    // Thay đổi nội dung của phần đếm ngược
		    resendTimer.innerHTML = '<span style="color: #ff3333;">Bạn đã nhập sai quá 5 lần hoặc thời gian nhập OTP đã hết. Vui lòng </span>' + 
                           '<a href="#" id="resendOTPLink" style="color: #0066cc; text-decoration: underline;">gửi lại mã OTP</a>.';
		    
		    // Thêm sự kiện cho liên kết gửi lại OTP
		    const resendLink = document.getElementById('resendOTPLink');
		    if (resendLink) {
		      resendLink.onclick = function(e) {
		        e.preventDefault();
		        resendOTP();
		        return false;
		      };
		    }
		  }
		}
		
		// Hàm xử lý gửi lại OTP
		function resendOTP() {
		  const email = document.querySelector('input[name="email"]').value;
		  // Hiển thị thông báo đang xử lý
		  const errorMessage = document.getElementById('error-message');
		  errorMessage.textContent = 'Đang gửi lại mã OTP mới...';
		  errorMessage.style.display = 'block';
		  
		  // Gọi API để gửi lại OTP
		  fetch(window.contextPath + '/user/resendOTP', {
		    method: 'POST',
		    headers: {
		      'Content-Type': 'application/x-www-form-urlencoded',
		      'X-Requested-With': 'XMLHttpRequest'
		    },
		    body: 'email=' + encodeURIComponent(email)
		  })
		  .then(response => response.json())
		  .then(data => {
		    if (data.success) {
		      // Ẩn thông báo lỗi
		      errorMessage.style.display = 'none';
		      errorMessage.textContent = '';
		      
		      // Kích hoạt lại các ô nhập OTP
		      enableOTPInputs();
		      
		      // Cập nhật lại nội dung hiển thị đếm ngược về trạng thái ban đầu
		      const resendTimer = document.querySelector('.resend-timer');
		      if (resendTimer) {
		        resendTimer.innerHTML = 'Gửi lại email <span id="countdown" class="countdown">01:30</span>';
		      }
		      
		      // Bắt đầu lại đồng hồ đếm ngược
		      startCountdown(email);
		      
		      // Hiển thị thông báo thành công
		      alert("Mã OTP mới đã được gửi đến email của bạn!");
		    } else {
		      // Hiển thị thông báo lỗi
		      errorMessage.textContent = data.message || 'Không thể gửi lại mã OTP. Vui lòng thử lại sau.';
		      errorMessage.style.display = 'block';
		    }
		  })
		  .catch(error => {
		    console.error('Error:', error);
		    errorMessage.textContent = 'Đã có lỗi xảy ra. Vui lòng thử lại sau.';
		    errorMessage.style.display = 'block';
		  });
		}
		
		// Kích hoạt lại các ô nhập OTP
		function enableOTPInputs() {
		  const otpInputs = document.querySelectorAll('.otp-input');
		  otpInputs.forEach(input => {
		    input.disabled = false;
		    input.value = ''; // Xóa giá trị cũ
		    input.style.backgroundColor = ""; // Trả lại màu nền mặc định
		    input.style.cursor = ""; // Trả lại con trỏ mặc định
		  });
		  
		  // Vô hiệu hóa nút Tiếp tục cho đến khi điền đầy đủ OTP mới
		  const continueBtn = document.getElementById('continueBtn');
		  if (continueBtn) {
		    continueBtn.disabled = true;
		  }
		}
		
		// Đặt lại và bắt đầu đồng hồ đếm ngược
		function resetAndStartCountdown(email) {
		  const countdownElement = document.getElementById('countdown');
		  if (countdownElement) {
		    const resendTimer = document.querySelector('.resend-timer');
		    if (resendTimer) {
		      resendTimer.innerHTML = 'Gửi lại email <span id="countdown" class="countdown">01:30</span>';
		      startCountdown(email);
		    }
		  }
		}
		
		// Bắt đầu đồng hồ đếm ngược khi trang được tải
		document.addEventListener('DOMContentLoaded', startCountdown);
        
        // Chỉ cho phép nhập số và tự động chuyển sang ô tiếp theo
		function onlyNumbersAndMove(input) {
		  // Thay thế tất cả ký tự không phải số
		  input.value = input.value.replace(/[^0-9]/g, '');
		  
		  // Kiểm tra và kích hoạt nút tiếp tục nếu tất cả ô đã được điền
		  checkAllInputsFilled();
		  
		  // Chuyển sang ô tiếp theo nếu đã nhập một số
		  if (input.value !== '') {
		    const nextInput = input.nextElementSibling;
		    if (nextInput && nextInput.tagName === 'INPUT') {
		      nextInput.focus();
		    }
		  }
		}
		
		// Xử lý khi nhấn phím
		function handleKeyDown(event, input) {
		  // Nếu nhấn Backspace và ô trống, quay lại ô trước đó
		  if (event.key === 'Backspace' && input.value === '') {
		    const prevInput = input.previousElementSibling;
		    if (prevInput && prevInput.tagName === 'INPUT') {
		      prevInput.focus();
		      setTimeout(() => {
		        prevInput.value = '';
		        checkAllInputsFilled(); // Kiểm tra lại trạng thái nút khi xóa
		      }, 0);
		    }
		  } 
		  // Chặn các phím không phải số trừ Backspace, Tab, các phím điều hướng
		  else if (!/^[0-9]$/.test(event.key) && 
		           !['Backspace', 'Tab', 'ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown', 'Delete'].includes(event.key)) {
		    event.preventDefault();
		  }
		}
        
        // Kiểm tra tất cả các ô đã được điền chưa
			function checkAllInputsFilled() {
			  const inputs = document.querySelectorAll('.otp-input');
			  const continueBtn = document.getElementById('continueBtn');
			  let allFilled = true;
			  
			  inputs.forEach(input => {
			    if (input.value === '') {
			      allFilled = false;
			    }
			  });
			  
			  continueBtn.disabled = !allFilled;
			}
        
        // Thêm sự kiện keydown để xử lý khi nhấn Backspace
		document.querySelectorAll('.otp-input').forEach(input => {
		  input.addEventListener('keydown', function(e) {
		    if (e.key === 'Backspace' && input.value === '') {
		      const prevInput = input.previousElementSibling;
		      if (prevInput && prevInput.tagName === 'INPUT') {
		        prevInput.focus();
		        // Xóa giá trị của ô trước đó
		        setTimeout(() => {
		          prevInput.value = '';
		        }, 0);
		      }
		    }
		  });
		});
		function updateContinueBtnUI() {
		  const continueBtn = document.getElementById('continueBtn');
		  if (!continueBtn.disabled) {
		    continueBtn.style.backgroundColor = "#0066cc";
		    continueBtn.style.color = "white";
		    continueBtn.style.cursor = "pointer";
		  } else {
		    continueBtn.style.backgroundColor = "#e0e0e0";
		    continueBtn.style.color = "#888";
		    continueBtn.style.cursor = "default";
		  }
		}
		


		  // Hàm xử lý submit form bằng AJAX
		  function submitOTPForm() {
		    const form = document.getElementById('otpForm');
		    const formData = new FormData(form);
		    
		    // Lấy mã OTP từ các ô input
		    const otp1 = formData.get('otp1');
		    const otp2 = formData.get('otp2');
		    const otp3 = formData.get('otp3');
		    const otp4 = formData.get('otp4');
		    const otp5 = formData.get('otp5');
		    const otp6 = formData.get('otp6');
		    const email = formData.get('email');
		    
		    // Gửi request bằng fetch API
		    fetch(window.contextPath + '/user/verifyOTP', {
		      method: 'POST',
		      headers: {
		        'Content-Type': 'application/x-www-form-urlencoded',
		        'X-Requested-With': 'XMLHttpRequest' // Để server biết đây là request AJAX
		      },
		      body: 'otp1=' + otp1 + '&otp2=' + otp2 + '&otp3=' + otp3 + '&otp4=' + otp4 + 
		            '&otp5=' + otp5 + '&otp6=' + otp6 + '&email=' + encodeURIComponent(email)
		    })
		    .then(response => response.json())
		    .then(data => {
		      if (data.success) {
		        // Nếu xác thực thành công, chuyển hướng đến trang mới
		        window.location.href = data.redirectUrl || '/sheller/dangChoNghi/ThongTinCoBan';
		      } else {
		        // Nếu thất bại, hiển thị thông báo lỗi
		        const errorMessage = document.getElementById('error-message');
		        errorMessage.textContent = data.message || 'Mã OTP không chính xác. Vui lòng thử lại.';
		        errorMessage.style.display = 'block';
		        
		        // Nếu nhập sai quá 5 lần
		      	if (data.attemptsExceeded) {
		        	// Dừng đồng hồ đếm ngược
		        	clearAllIntervals();
		        
		        	// Hiển thị thông báo và liên kết gửi lại OTP
		        	showTimeoutMessage();
		        
		        	// Vô hiệu hóa tất cả các ô nhập OTP
		        	disableOTPInputs();
		      	} else {
		        	// Xóa nội dung các ô OTP để người dùng nhập lại
		        	const otpInputs = document.querySelectorAll('.otp-input');
		        	otpInputs.forEach(input => {
		          	input.value = '';
		        	});
		        
		        	// Focus vào ô đầu tiên
		        	otpInputs[0].focus();
		        
		        	// Vô hiệu hóa nút Tiếp tục
		        	document.getElementById('continueBtn').disabled = true;
		      	}
		      }
		    })
		    .catch(error => {
		      console.error('Error:', error);
		      // Hiển thị thông báo lỗi nếu có lỗi xảy ra
		      const errorMessage = document.getElementById('error-message');
		      errorMessage.textContent = 'Đã có lỗi xảy ra. Vui lòng thử lại sau.';
		      errorMessage.style.display = 'block';
		    });
		  }
		  // Hàm để xóa tất cả các interval đang chạy
			function clearAllIntervals() {
		  		// Nếu có biến lưu interval
		  		if (window.countdownInterval) {
		    		clearInterval(window.countdownInterval);
		  		}
			}