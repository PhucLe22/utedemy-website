<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" buffer="64kb"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" scope="request" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/homepage.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<!DOCTYPE html>
<html lang="vi">
<body>
   

    <main>
    
        <section class="hero-banner-slider" aria-label="Course Promotions">
            <div class="slider-container">
                <div class="slider-content">
                    <!-- Existing slider items with added accessibility -->
                    <div class="slider-item" role="group" aria-roledescription="slide">
                        <!-- Existing content with semantic improvements -->
                    </div>
                </div>
                <div class="slider-controls">
                    <button class="slider-prev" aria-label="Previous Slide">&#10094;</button>
                    <button class="slider-next" aria-label="Next Slide">&#10095;</button>
                </div>
                <div class="slider-dots" role="tablist"></div>
            </div>
        </section>
        <nav class="category-menu">
            <div class="category-menu-inner">
                <ul>
                    <li><a href="#office-it">Tin học văn phòng</a></li>
                    <li><a href="#design">Thiết kế</a></li>
                    <li><a href="#languages">Ngoại ngữ</a></li>
                    <li><a href="#marketing">Marketing</a></li>
                    <li><a href="#finance">Tài chính kế toán</a></li>
                    <li><a href="#technology">Công nghệ</a></li>
                    <li><a href="#health-beauty">Sức khỏe - Làm đẹp</a></li>
                    <li><a href="#family">Hôn nhân gia đình</a></li>
                    <li><a href="#books">Sách hay nên đọc</a></li>
                    <li><a href="#inhouse">Đào tạo inhouse</a></li>
                </ul>
            </div>
        </nav>
        <section class="top-courses" aria-labelledby="bestseller-title"> 
            <h3 id="bestseller-title">TOP BÁN CHẠY</h3>
            <div id="bestseller-courses" class="course-grid" aria-live="polite"></div>
          </section>

          <section class="top-courses" aria-labelledby="today-sale-title">
            <h3 id="today-sale-title">SIÊU ƯU ĐÃI HÔM NAY</h3>
            <div id="today-sale-courses" class="course-grid" aria-live="polite"></div>
          </section>

       <section class="topics-of-interest" aria-labelledby="topics-title">
    <h3 id="topics-title">CHỦ ĐỀ CÓ THỂ BẠN QUAN TÂM</h3>
    <div class="topic-tags" role="list">
        <a href="#office-it" role="listitem" class="topic-tag">Tin học văn phòng</a>
        <a href="#design" role="listitem" class="topic-tag">Thiết kế</a>
        <a href="#languages" role="listitem" class="topic-tag">Ngoại ngữ</a>
        <a href="#marketing" role="listitem" class="topic-tag">Marketing</a>
        <a href="#finance" role="listitem" class="topic-tag">Tài chính kế toán</a>
        <a href="#technology" role="listitem" class="topic-tag">Công nghệ</a>
        <a href="#health-beauty" role="listitem" class="topic-tag">Sức khỏe - Làm đẹp</a>
        <a href="#family" role="listitem" class="topic-tag">Hôn nhân gia đình</a>
        <a href="#books" role="listitem" class="topic-tag">Sách hay nên đọc</a>
        <a href="#inhouse" role="listitem" class="topic-tag">Đào tạo inhouse</a>
    </div>
</section>

        <section class="featured-instructors" aria-labelledby="instructors-title">
            <h3 id="instructors-title">GIẢNG VIÊN TIÊU BIỂU</h3>
            <div class="instructors-container" aria-live="polite"></div>
        </section>

        <section class="instructor-recruitment hero" aria-labelledby="recruitment-title">
            <div class="hero-content">
                <h2 id="recruitment-title">Trở thành Giảng viên Unica</h2>
                <p>Giúp mọi người trở nên tốt hơn - bao gồm cả chính bạn</p>
                <form action="${pageContext.request.contextPath}/user/homeRegisterTeacher" method="get" style="display:inline;">
                    <button type="submit" class="btn btn-register" aria-label="Register as Instructor">Đăng ký ngay</button>
                </form>
            </div>
        </section>
    </main>

  <script>
  
//Hàm điều hướng đến trang chi tiết khóa học
  function redirectToCourseDetail(courseId) {
    const contextPath = "<c:out value='${contextPath}'/>";
    // Đảm bảo courseId là số hoặc chuỗi hợp lệ
    const id = Number(courseId) || null;
    if (id && id > 0) {
        console.log('Course ID:', id);
        // Nối chuỗi thủ công và kiểm tra
        const redirectUrl = contextPath + "/course/courseDetail?courseId=" + id;
        console.log('Redirecting to:', redirectUrl);
        window.location.href = redirectUrl;
    } else {
        console.error('Course ID is missing or invalid:', courseId);
        alert('Không thể xem chi tiết khóa học. Vui lòng thử lại sau.');
    }
}
  
  
  document.addEventListener('DOMContentLoaded', () => {
      const featuredInstructors = [
          {
              name: 'Trần Đăng Khoa',
              specialty: 'Chuyên gia Digital Marketing',
              image: '/api/placeholder/200/200'
          },
          {
              name: 'Phạm Văn Minh',
              specialty: 'Chuyên gia Thiết kế',
              image: '/api/placeholder/200/200'
          },
          {
              name: 'Nguyễn Thị Hương',
              specialty: 'Chuyên gia Ngoại ngữ',
              image: '/api/placeholder/200/200'
          },
          {
              name: 'Lê Văn Tuấn',
              specialty: 'Chuyên gia Tài chính',
              image: '/api/placeholder/200/200'
          }
      ];
      
      const bestsellerCourses = [
    	    <c:forEach var="course" items="${bestSellerCourses}" varStatus="status">
    	        <c:choose>
    	            <c:when test="${not empty course[4] && course[4].substring(0,5) == 'https'}">
    	                <c:url value="${course[4]}" var="imgUrl" />
    	            </c:when>
    	            <c:when test="${not empty course[4]}">
    	                <c:url value="/image?fname=${course[4]}" var="imgUrl" />
    	            </c:when>
    	            <c:otherwise>
    	                <c:set var="imgUrl" value="/api/placeholder/300/200" />
    	            </c:otherwise>
    	        </c:choose>
    	    {
    	        id: ${course[5] != null ? course[5] : 0},
    	        title: "${fn:escapeXml(course[0])}",
    	        instructor: "${fn:escapeXml(course[1])}",
    	        rating: ${course[2] != null ? course[2] : 0},
    	        price: ${course[3] != null ? course[3] : 0},
    	        originalPrice: ${course[3] != null ? course[3] * 1.5 : 0},
    	        image: "${imgUrl}",
    	        badge: "Bán chạy"
    	    }${!status.last ? ',' : ''}
    	    </c:forEach>
    	];

    	console.log('bestsellerCourses:', bestsellerCourses); // Log dữ liệu

    	const todaySaleCourses = [
    	    <c:forEach var="course" items="${todaySaleCourses}" varStatus="status">
    	        <c:choose>
    	            <c:when test="${not empty course[4] && course[4].substring(0,5) == 'https'}">
    	                <c:url value="${course[4]}" var="imgUrl" />
    	            </c:when>
    	            <c:when test="${not empty course[4]}">
    	                <c:url value="/image?fname=${course[4]}" var="imgUrl" />
    	            </c:when>
    	            <c:otherwise>
    	                <c:set var="imgUrl" value="/api/placeholder/300/200" />
    	            </c:otherwise>
    	        </c:choose>
    	    {
    	        id: ${course[6] != null ? course[6] : 0},
    	        title: "${fn:escapeXml(course[0])}",
    	        instructor: "${fn:escapeXml(course[1])}",
    	        rating: ${course[2] != null ? course[2] : 0},
    	        price: ${course[3] != null ? course[3] * 1 : 0},
    	        originalPrice: ${course[3] != null ? course[3] * 1.5 : 0},
    	        image: "${imgUrl}",
    	        badge: "Giảm ${course[5] != null ? course[5] : 0}%"
    	    }${!status.last ? ',' : ''}
    	    </c:forEach>
    	];
    	console.log('todaySaleCourses:', todaySaleCourses); // Log dữ liệu


      const bannerSlides = [
          {
              title: 'Khóa Học Mới Nhất',
              subtitle: 'Ưu đãi giảm 50% tất cả các khóa học',
              gradient: 'linear-gradient(135deg, #0f2027, #203a43, #2c5364)'
          },
          {
              title: 'Học Trực Tuyến',
              subtitle: 'Học mọi lúc, mọi nơi với Unica',
              gradient: 'linear-gradient(135deg, #141e30, #243b55)'
          },
          {
              title: 'Giảng Viên Hàng Đầu',
              subtitle: 'Được đào tạo bởi các chuyên gia trong ngành',
              gradient: 'linear-gradient(135deg, #1a2a6c, #b21f1f, #fdbb2d)'
          }
      ];

      function renderBannerSlides() {
          const sliderContent = document.querySelector('.slider-content');
          if (!sliderContent) return;

          sliderContent.innerHTML = '';

          bannerSlides.forEach((slide, index) => {
              let slideItem = document.createElement('div');
              slideItem.classList.add('slider-item');
              slideItem.setAttribute('data-index', index);
              slideItem.style.background = slide.gradient;

              let textContainer = document.createElement('div');
              textContainer.classList.add('slider-text');

              let title = document.createElement('h2');
              title.textContent = slide.title;

              let subtitle = document.createElement('p');
              subtitle.textContent = slide.subtitle;

              let button = document.createElement('button');
              button.classList.add('view-course-btn');
              button.textContent = 'Xem khóa học';

              textContainer.append(title, subtitle, button);
              slideItem.appendChild(textContainer);
              sliderContent.appendChild(slideItem);
          });
      }
      
      function renderBestsellerCourses() {
    	    const container = document.getElementById('bestseller-courses');
    	    if (!container) return;

    	    container.innerHTML = '';

    	    bestsellerCourses.forEach(course => {
    	        console.log('Rendering course with ID:', course.id); // Thêm log để kiểm tra
    	        let card = document.createElement('div');
    	        card.classList.add('course-card');

    	        let img = document.createElement('img');
    	        img.src = course.image;
    	        img.alt = course.title;

    	        let content = document.createElement('div');
    	        content.classList.add('course-card-content');

    	        let title = document.createElement('h4');
    	        title.textContent = course.title;

    	        let instructor = document.createElement('p');
    	        instructor.textContent = course.instructor;

    	        let ratingContainer = document.createElement('div');
    	        ratingContainer.classList.add('course-rating');

    	        let stars = document.createElement('div');
    	        stars.classList.add('stars');
    	        stars.style.setProperty('--rating', course.rating);

    	        let reviews = document.createElement('span');
    	        let ratingValue = Number(course.rating);
    	        reviews.textContent = '(' + ratingValue.toFixed(1) + ')';

    	        let pricing = document.createElement('div');
    	        pricing.classList.add('course-pricing');

    	        let currentPrice = document.createElement('span');
    	        currentPrice.classList.add('real-price');
    	        currentPrice.textContent = Number(course.price).toLocaleString('vi-VN') + 'đ';

    	        let originalPrice = document.createElement('span');
    	        originalPrice.classList.add('product-price');
    	        originalPrice.textContent = Number(course.originalPrice).toLocaleString('vi-VN') + 'đ';

    	        let badge = document.createElement('div');
    	        badge.classList.add('course-badge');
    	        badge.textContent = course.badge;

    	        let actions = document.createElement('div');
    	        actions.classList.add('course-actions');

    	        let cartBtn = document.createElement('button');
    	        cartBtn.classList.add('icon-btn', 'add-to-cart');
    	        cartBtn.innerHTML = '<i class="fas fa-cart-shopping cart-icon"></i>';
    	        cartBtn.title = 'Thêm vào giỏ';
    	        
    	        cartBtn.addEventListener('click', () => {
    	        	  fetch("addcart", {
    	        	    method: "POST",
    	        	    headers: {
    	        	      "Content-Type": "application/x-www-form-urlencoded"
    	        	    },
    	        	    body: "id=" + course.id
    	        	  })
    	        	  .then(response => {
    	        	    if (response.ok) {
    	        	      return response.text(); // đọc response dạng text
    	        	    } else {
    	        	      throw new Error("Thêm vào giỏ thất bại");
    	        	    }
    	        	  })
    	        	  .then(data => {
    	        	    if (data === "success") {
    	        	      console.log("🛒 Đã thêm vào giỏ: " + course.id);
    	        	      showToast("Bạn đã thêm thành công vào giỏ hàng 🛒", "success");
    	        	    } else {
    	        	      console.error("Có lỗi xảy ra khi thêm vào giỏ");
    	        	      showToast("Đã xảy ra lỗi vui lòng thử lại sau", "error");
    	        	    }
    	        	  })
    	        	  .catch(error => console.error("Lỗi: " + error));
    	        	});


    	        let favBtn = document.createElement('button');
    	        favBtn.classList.add('icon-btn', 'add-to-favorite');
    	        favBtn.innerHTML = '<i class="fas fa-heart heart-icon"></i>';
    	        favBtn.title = 'Yêu thích';
    	        favBtn.setAttribute('data-course-id', course.id);
                favBtn.addEventListener('click', (e) => {
                    console.log('❤️ Yêu thích:', course.id);
                    e.preventDefault();
                    const courseId = e.currentTarget.getAttribute('data-course-id');
                    console.log('❤️ Yêu thích1:', courseId);
                    // AJAX request to add favorite course
                    fetch('${pageContext.request.contextPath}/user/addFavoriteCourse', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'courseId=' + courseId
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Change heart color to indicate it's favorited
                            favBtn.querySelector('.heart-icon').style.color = 'red'; 	
                            // You can add a class in your CSS like:
                            // .favorited { color: red; }
                        } else {
                            // Handle error
                            console.error('Failed to add favorite course:', data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error adding favorite course:', error);
                    });
                });

    	        let detailsBtn = document.createElement('button');
    	        detailsBtn.classList.add('details-btn');
    	        detailsBtn.textContent = 'Xem chi tiết';
    	        detailsBtn.addEventListener('click', () => redirectToCourseDetail(course.id));

    	        actions.append(cartBtn, favBtn, detailsBtn);
    	        ratingContainer.append(stars, reviews);
    	        pricing.append(currentPrice, originalPrice, badge);
    	        content.append(title, instructor, ratingContainer, pricing, actions);
    	        card.append(img, content);
    	        container.appendChild(card);
    	    });
    	}

    	function renderTodaySaleCourses() {
    	    const container = document.getElementById('today-sale-courses');
    	    if (!container) return;

    	    container.innerHTML = '';

    	    todaySaleCourses.forEach(course => {
    	        console.log('Rendering course with ID:', course.id); // Thêm log để kiểm tra
    	        let card = document.createElement('div');
    	        card.classList.add('course-card');

    	        let img = document.createElement('img');
    	        img.src = course.image;
    	        img.alt = course.title;

    	        let content = document.createElement('div');
    	        content.classList.add('course-card-content');

    	        let title = document.createElement('h4');
    	        title.textContent = course.title;

    	        let instructor = document.createElement('p');
    	        instructor.textContent = course.instructor;

    	        let ratingContainer = document.createElement('div');
    	        ratingContainer.classList.add('course-rating');

    	        let stars = document.createElement('div');
    	        stars.classList.add('stars');
    	        stars.style.setProperty('--rating', course.rating);

    	        let reviews = document.createElement('span');
    	        let ratingValue = Number(course.rating);
    	        reviews.textContent = '(' + ratingValue.toFixed(1) + ')';

    	        let pricing = document.createElement('div');
    	        pricing.classList.add('course-pricing');

    	        let currentPrice = document.createElement('span');
    	        currentPrice.classList.add('real-price');
    	        currentPrice.textContent = Number(course.price).toLocaleString('vi-VN') + 'đ';

    	        let originalPrice = document.createElement('span');
    	        originalPrice.classList.add('product-price');
    	        originalPrice.textContent = Number(course.originalPrice).toLocaleString('vi-VN') + 'đ';

    	        let badge = document.createElement('div');
    	        badge.classList.add('course-badge');
    	        badge.textContent = course.badge;

    	        let actions = document.createElement('div');
    	        actions.classList.add('course-actions');

    	        let cartBtn = document.createElement('button');
    	        cartBtn.classList.add('icon-btn', 'add-to-cart');
    	        cartBtn.innerHTML = '<i class="fas fa-cart-shopping cart-icon"></i>';
    	        cartBtn.title = 'Thêm vào giỏ';
    	        cartBtn.addEventListener('click', () => console.log('🛒 Thêm vào giỏ:', course.id));

    	        let favBtn = document.createElement('button');
    	        favBtn.classList.add('icon-btn', 'add-to-favorite');
    	        favBtn.innerHTML = '<i class="fas fa-heart heart-icon"></i>';
    	        favBtn.title = 'Yêu thích';
    	        favBtn.setAttribute('data-course-id', course.id);
                favBtn.addEventListener('click', (e) => {
                    console.log('❤️ Yêu thích:', course.id);
                    e.preventDefault();
                    const courseId = e.currentTarget.getAttribute('data-course-id');
                    console.log('❤️ Yêu thích1:', courseId);
                    // AJAX request to add favorite course
                    fetch('${pageContext.request.contextPath}/user/addFavoriteCourse', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'courseId=' + courseId
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Change heart color to indicate it's favorited
                            favBtn.querySelector('.heart-icon').classList.add('favorited');
                            // You can add a class in your CSS like:
                            // .favorited { color: red; }
                        } else {
                            // Handle error
                            console.error('Failed to add favorite course:', data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error adding favorite course:', error);
                    });
                });

    	        let detailsBtn = document.createElement('button');
    	        detailsBtn.classList.add('details-btn');
    	        detailsBtn.textContent = 'Xem chi tiết';
    	        detailsBtn.addEventListener('click', () => redirectToCourseDetail(course.id));

    	        actions.append(cartBtn, favBtn, detailsBtn);
    	        ratingContainer.append(stars, reviews);
    	        pricing.append(currentPrice, originalPrice, badge);
    	        content.append(title, instructor, ratingContainer, pricing, actions);
    	        card.append(img, content);
    	        container.appendChild(card);
    	    });
    	}
	   
	      
      function formatPrices(className) {
          var elements = document.querySelectorAll('.' + className);
          elements.forEach(function(element) {
              var value = element.innerText;
              value = value.replace('₫', '').trim();
              if (!isNaN(value)) {
                  value = Number(value).toLocaleString('vi-VN') + '₫';
                  element.innerText = value;
              }
          });
      }
      
      function initializeSlider() {
          const sliderContent = document.querySelector('.slider-content');
          const sliderItems = document.querySelectorAll('.slider-item');
          const sliderDots = document.querySelector('.slider-dots');
          const prevBtn = document.querySelector('.slider-prev');
          const nextBtn = document.querySelector('.slider-next');

          let currentSlide = 0;
          const totalSlides = sliderItems.length;

          // Create dots
          if (sliderDots) {
              sliderItems.forEach((_, index) => {
                  const dot = document.createElement('button');
                  dot.classList.add('slider-dot');
                  dot.setAttribute('aria-label', `Go to slide ${index + 1}`);
                  if (index === 0) dot.classList.add('active');
                  dot.addEventListener('click', () => goToSlide(index));
                  sliderDots.appendChild(dot);
              });
          }

          const dots = document.querySelectorAll('.slider-dot');

          function goToSlide(slideIndex) {
              currentSlide = (slideIndex + totalSlides) % totalSlides;
              
              if (sliderContent) {
                  sliderContent.style.transform = `translateX(-${currentSlide * 100}%)`;
              }
              
              dots.forEach((dot, index) => {
                  dot.classList.toggle('active', index === currentSlide);
              });
          }

          function nextSlide() {
              goToSlide(currentSlide + 1);
          }

          function prevSlide() {
              goToSlide(currentSlide - 1);
          }

          // Auto slide
          let autoSlideInterval = setInterval(nextSlide, 5000);

          // Event listeners for manual navigation
          if (nextBtn) {
              nextBtn.addEventListener('click', () => {
                  nextSlide();
                  resetAutoSlide();
              });
          }

          if (prevBtn) {
              prevBtn.addEventListener('click', () => {
                  prevSlide();
                  resetAutoSlide();
              });
          }

          // Reset auto slide timer when user interacts
          function resetAutoSlide() {
              clearInterval(autoSlideInterval);
              autoSlideInterval = setInterval(nextSlide, 5000);
          }
      }

      // Render components
      renderBannerSlides();
      renderBestsellerCourses();
      renderTodaySaleCourses();
      initializeSlider();
  });
  let currentToast = null;

  function showToast(message, type = "success") {
    if (currentToast) {
      currentToast.remove();
      currentToast = null;
    }

    const toast = document.createElement("div");
    toast.innerText = message;
    toast.className = "toast-notification toast-" + type;
    document.body.appendChild(toast);
    currentToast = toast;

    requestAnimationFrame(() => {
      toast.classList.add("show");
    });

    setTimeout(() => {
      if (currentToast === toast) {
        toast.classList.remove("show");
        setTimeout(() => toast.remove(), 300);
        currentToast = null;
      }
    }, 3000);
  }
  </script>
</body>
</html>