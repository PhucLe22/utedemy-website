// lấy API iframe youtube
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
let userAvatar;

let avatarURL;

// Extract YouTube video ID from URL
	  function extractYouTubeVideoId(url) {
	    if (!url) return null;

	    // Match various YouTube URL formats
	    const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
	    const match = url.match(regExp);

	    if (match && match[2].length == 11) {
	      return match[2];
	    }
	    return null;
	  }

	  function updateNavigationButtons(index, total) {
	    const btnPrev = document.querySelector(".btn-prv");
	    const btnNext = document.querySelector(".btn-next");
	    if (btnPrev) btnPrev.disabled = index <= 0;
	    if (btnNext) btnNext.disabled = index >= total - 1;
	  }

document.addEventListener("DOMContentLoaded", function () {
	  document.querySelector(".user-rating").style.display = "none";
	const autoplayCheckbox = document.querySelector(".autoplay-toggle input[type='checkbox']");

	
	  // Function to initialize YouTube player API
	  window.onYouTubeIframeAPIReady = function() {
	    initializeYouTubePlayer();
	  };

	  // Initialize player when switching lessons
	  function initializeYouTubePlayer() {
	    const iframe = document.getElementById("lesson-video");
	    if (!iframe) return;

	    // Get the video ID from src attribute
	    const videoSrc = iframe.src;
	    const videoId = extractYouTubeVideoId(videoSrc);

	    if (!videoId) return;

	    // Replace the iframe with a div that YouTube API can use
	    const videoContainer = iframe.parentNode;
	    const videoPlaceholder = document.createElement('div');
	    videoPlaceholder.id = 'youtube-player';
	    videoContainer.replaceChild(videoPlaceholder, iframe);

	    // Create new player
	    player = new YT.Player('youtube-player', {
	      height: iframe.height || '390',
	      width: iframe.width || '640',
	      videoId: videoId,
	      events: {
	        'onStateChange': onPlayerStateChange
	      }
	    });
	  }

	  // Handle player state changes
	  function onPlayerStateChange(event) {
	    if (event.data === 0) {
	      // Lấy lesson đang active để lấy ID
	      const activeLesson = document.querySelector("#lesson-container .lesson-item.active");
	      const currentLessonId = activeLesson?.getAttribute("data-lesson-id") || "1";

	      markLessonAsCompleted(currentLessonId);
		  setTimeout(() => {
			takeProgressRequest();
		  }, 3000);
	      if (autoplayCheckbox && autoplayCheckbox.checked) {
	        const nextButton = document.querySelector(".btn-next");
	        if (nextButton && !nextButton.disabled) {
	          nextButton.click();
	        }
	      }
	    }
	  }

	//Kích hoạt CKEditor
	CKEDITOR.replace('comment', {
	  toolbar: [
		{ name: 'styles', items: ['Styles', 'Format']},
	    { name: 'basicstyles', items: [ 'Bold', 'Italic' ] },
	    { name: 'paragraph', items: [ 'NumberedList', 'BulletedList' ] },
	    { name: 'links', items: [ 'Link', 'Unlink' ] },
	    { name: 'clipboard', items: [ 'Undo', 'Redo' ] }
	  ],
	  removePlugins: 'elementspath',
	  resize_enabled: false
	});

	// Xử lý click btn-comment
	document.addEventListener("click", function(e) {
	  if (e.target.closest(".btn-submit-comment")) {
		const btn = e.target.closest(".btn-submit-comment");
	    var content = CKEDITOR.instances.comment.getData();

		if (content == null || content == "") return;

		// Tạo spinner loading
		const loadingSpinner = document.createElement('div');
		loadingSpinner.classList.add('loading-spinner');
		btn.appendChild(loadingSpinner); // Thêm spinner vào nút gửi comment

		// Disable button để tránh người dùng nhấn lần nữa
		btn.disabled = true;
		
	    fetch(window.contextPath + '/views/user/Course', {
	      method: 'POST',
	      headers: {
	        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
	      },
	      body: `content=${encodeURIComponent(content)}`
	    })
	    .then(response => response.json())
	    .then(data => {

	      // Reset CKEditor
	      CKEDITOR.instances.comment.setData("");
		  
		  renderNestedComments(data);

		  // Ẩn spinner và enable lại nút
		  loadingSpinner.remove();
		  btn.disabled = false;
	    })
	    .catch(error => {
			showToast("Đã xảy ra lỗi!", "error");
			// Ẩn spinner và enable lại nút
			        loadingSpinner.remove();
			        btn.disabled = false;
	    });
	  }
	});
	
	

  // Tab switching
  const tabButtons = document.querySelectorAll(".tab-menu div");
  const tabContents = document.querySelectorAll(".tab-content");

  tabButtons.forEach(button => {
    button.addEventListener("click", function () {
      const tabName = this.getAttribute("data-tab");

      tabButtons.forEach(btn => btn.classList.remove("active"));
      this.classList.add("active");

      tabContents.forEach(content => {
        if (content.getAttribute("data-content") === tabName) {
          content.classList.add("active");
        } else {
          content.classList.remove("active");
        }
      });
    });
  });

  // Hiển thị popup tiến độ
  const progressBtn = document.getElementById('progressBtn');
  const progressPopup = document.getElementById('progressPopup');

  if (progressBtn && progressPopup) {
    progressBtn.addEventListener('click', function (e) {
      e.stopPropagation();
      progressPopup.style.display = progressPopup.style.display === 'block' ? 'none' : 'block';
    });

    document.addEventListener('click', function (e) {
      if (progressPopup.style.display === 'block' &&
        !progressPopup.contains(e.target) &&
        e.target !== progressBtn &&
        !progressBtn.contains(e.target)) {
        progressPopup.style.display = 'none';
      }
    });
  }

  checkUPERequest();
  takeProgressRequest();
  checkRatingRequest();
  takeAvatarURLRequest();
  
  // Gọi render bài học khi DOM đã sẵn sàng
  setTimeout(() => {
    initializeYouTubePlayer();
  }, 1000); // đảm bảo DOM đã có iframe

    const loadMoreBtn = document.getElementById("load-more-btn");
    if (loadMoreBtn) {
      loadMoreBtn.addEventListener("click", function () {
        currentPage++;
        renderReviews();
      });
    }

  const sortSelect = document.getElementById("comment-sort");
  if (sortSelect) {
    sortSelect.addEventListener("change", function () {
      const selectedFilter = this.value;
      renderNestedComments(allComments, selectedFilter);
    });
  }

  const firstItem = document.querySelector("#lesson-container .lesson-item");
    if (firstItem) {
      firstItem.classList.add("active");
      const url = firstItem.getAttribute("data-video-url");
      document.getElementById("lesson-video").src = url;
	  document.getElementById("lesson-title").innerText = firstItem.querySelector("span").innerText;
	  document.getElementById("lesson-description").innerText = firstItem.getAttribute("data-description") || "";
    }

	// Xử lý chuyển bài học tiếp theo hoặc trước đó
	const btnNext = document.querySelector(".btn-next");
	const btnPrev = document.querySelector(".btn-prv");

	function updateNavigationButtons(index, total) {
	  if (btnPrev) btnPrev.disabled = index <= 0;
	  if (btnNext) btnNext.disabled = index >= total - 1;
	}

	function switchLesson(direction) {
	  const activeItem = document.querySelector(".lesson-item.active");
	  if (!activeItem) return;

	  const allItems = Array.from(document.querySelectorAll(".lesson-item"));
	  const currentIndex = allItems.indexOf(activeItem);
	  let newIndex = direction === "next" ? currentIndex + 1 : currentIndex - 1;

	  if (newIndex >= 0 && newIndex < allItems.length) {
	    allItems[currentIndex].classList.remove("active");
	    const newItem = allItems[newIndex];
	    newItem.classList.add("active");

	    const url = newItem.getAttribute("data-video-url");

	    // Cập nhật tiêu đề và mô tả trước
	    document.getElementById("lesson-title").innerText = newItem.querySelector("span").innerText;
	    document.getElementById("lesson-description").innerText = newItem.getAttribute("data-description") || "";

	    // Kiểm tra xem đang dùng player API hay iframe gốc
	    const ytPlayer = document.getElementById('youtube-player');
	    if (ytPlayer && window.YT && window.YT.Player && player) {
	      // Nếu đang dùng player API, load video mới
	      const videoId = extractYouTubeVideoId(url);
	      if (videoId) {
	        player.loadVideoById(videoId);
	      }
	    } else {
	      // Nếu vẫn dùng iframe gốc
	      const iframe = document.getElementById("lesson-video");
	      if (iframe) {
	        iframe.src = url;
	      }
	    }

	    // Mở phần chứa bài học nếu bị đóng
	    const section = newItem.closest(".lesson-section");
	    const lessonList = section.querySelector(".lesson-list");
	    const arrow = section.querySelector(".arrow");

	    if (lessonList.style.display === "none") {
	      lessonList.style.display = "block";
	      if (arrow) arrow.innerHTML = "&#9660;"; // đổi sang ▼
	    }

	    // Cuộn đến bài học trong khung
	    newItem.scrollIntoView({ behavior: "smooth", block: "center" });

	    // Cập nhật trạng thái nút
	    updateNavigationButtons(newIndex, allItems.length);
	  }
	}


	btnNext?.addEventListener("click", () => switchLesson("next"));
	btnPrev?.addEventListener("click", () => switchLesson("prev"));

	// Cập nhật trạng thái nút sau khi DOM sẵn sàng
	const allLessons = document.querySelectorAll(".lesson-item");
	const initialIndex = Array.from(allLessons).findIndex(item => item.classList.contains("active"));
	updateNavigationButtons(initialIndex, allLessons.length);

	const ratingBtn = document.getElementById("btn-rating");
		  const ratingModal = document.getElementById("ratingModal");
		  const closeRatingModal = document.querySelector("#ratingModal .close");

		  if (ratingBtn && ratingModal && closeRatingModal) {
		    ratingBtn.addEventListener("click", function () {
		      ratingModal.style.display = "block";
		    });

		    closeRatingModal.addEventListener("click", function () {
		      ratingModal.style.display = "none";
		    });

		    window.addEventListener("click", function (event) {
		      if (event.target === ratingModal) {
		        ratingModal.style.display = "none";
		      }
		    });
		  }
	
	const reportBtn = document.getElementById("btn-report");
	  const reportModal = document.getElementById("reportModal");
	  const closeModal = document.querySelector("#reportModal .close");

	  if (reportBtn && reportModal && closeModal) {
	    reportBtn.addEventListener("click", function () {
	      reportModal.style.display = "block";
	    });

	    closeModal.addEventListener("click", function () {
	      reportModal.style.display = "none";
	    });

	    window.addEventListener("click", function (event) {
	      if (event.target === reportModal) {
	        reportModal.style.display = "none";
	      }
	    });
	  }

	  const submitReportBtn = document.getElementById("submitReport");

	    if (submitReportBtn) {
	      submitReportBtn.addEventListener("click", function () {
	        // 1. Lấy tên bài học đang active
	        const activeLesson = document.querySelector(".lesson-item.active");
	        const lessonTitle = activeLesson ? activeLesson.querySelector("span")?.innerText.trim() : "Không xác định";

	        // 2. Lấy loại lỗi đã chọn (radio button)
	        const selectedErrorType = document.querySelector('input[name="errorType"]:checked');
	        const errorType = selectedErrorType ? selectedErrorType.value : "";

	        // 3. Lấy nội dung textarea
	        const errorContent = document.getElementById("errorContent").value.trim();

	        // Thêm điều kiện kiểm tra: nếu cả hai đều trống
	        if (!errorType) {
				const reportModal = document.getElementById("reportModal");
			    if (reportModal) {
					 reportModal.style.display = "none";
			    }

				showToast("Hãy chọn loại lỗi trước khi gửi!", "error");
	          return; // Không gửi nữa
	        }

	        // (Option) Đóng modal sau khi báo lỗi xong
	        const reportModal = document.getElementById("reportModal");
	        if (reportModal) {
	          reportModal.style.display = "none";

				showToast("Đã gửi báo lỗi thành công!", "success");
	        }

	        // (Option) Reset form sau khi gửi
	        document.getElementById("errorContent").value = "";
	        if (selectedErrorType) {
	          selectedErrorType.checked = false;
	        }
	      });
	    }
		
		const stars = document.querySelectorAll(".stars i");
		const ratingText = document.getElementById("ratingText");
		const feedbackForm = document.getElementById("feedbackForm"); // Lấy feedback form
		const submitFeedbackBtn = document.getElementById("submitFeedback"); // Nút Gửi
		const feedbackContent = document.getElementById("feedbackContent"); // Ô nhập nội dung
		let selectedRating = 0;

		const ratingDescriptions = [
		  "Rất tệ, hoàn toàn không như tôi mong đợi",
		  "Kém, khá thất vọng",
		  "Trung bình, lẽ ra có thể hay hơn",
		  "Tốt, như tôi mong đợi",
		  "Tuyệt vời, khóa học quá sức mong đợi!"
		];

		stars.forEach((star, index) => {
		  star.addEventListener("mouseover", () => {
		    highlightStars(index);
		    ratingText.textContent = ratingDescriptions[index];
		  });

		  star.addEventListener("mouseout", () => {
		    if (selectedRating === 0) {
		      ratingText.textContent = "Hãy chọn một mức đánh giá";
		    } else {
		      ratingText.textContent = ratingDescriptions[selectedRating - 1];
		    }
		    highlightStars(selectedRating - 1);
		  });

		  star.addEventListener("click", () => {
		    selectedRating = index + 1;
		    ratingText.textContent = ratingDescriptions[index];
		    highlightStars(index);
			
			feedbackForm.style.display = "block";
		  });
		});

		function highlightStars(index) {
		  stars.forEach((star, i) => {
		    if (i <= index) {
		      star.classList.remove("far");
		      star.classList.add("fas");
		    } else {
		      star.classList.remove("fas");
		      star.classList.add("far");
		    }
		  });
		}
		
		// Xử lý khi click nút Gửi
		submitFeedbackBtn.addEventListener("click", () => {
		  const feedback = feedbackContent.value.trim();
		  if (selectedRating === 0) {
		    showToast("Vui lòng chọn số sao đánh giá!", "error");
		    return;
		  }
		  if (feedback === "") {
		    showToast("Vui lòng nhập nội dung đánh giá!", "error");
		    return;
		  }
		  sendFeedback(selectedRating, feedback);
		  showToast("Đánh giá của bạn đã được ghi nhận!", "success");
		  document.querySelector(".user-rating").style.display = "none";
		  // Reset lại form
		  selectedRating = 0;
		  highlightStars(-1);
		  feedbackContent.value = "";
		  feedbackForm.style.display = "none";
		  ratingText.textContent = "Hãy chọn một mức đánh giá";
		  ratingModal.style.display = "none";
		});
		
});

function checkRatingRequest() {
	const checkRating = true;
	fetch(window.contextPath + '/views/user/Course', {
		method: 'POST',
		headers: {
			'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
		},
		body: `checkRating=${checkRating}`
	})
	.then(response => response.json())
	.then(data => {
		if (data) {
			document.querySelector(".user-rating").style.display = "block";
		}
	})
	.catch(error => {
	});
}

function checkUPERequest() {
	const checkUPE = true;
	fetch(window.contextPath + '/views/user/Course', {
		method: 'POST',
		headers: {
			'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
		},
		body: `checkUPE=${checkUPE}`
	})
	.then(response => response.json())
	.then(data => {
	})
	.catch(error => {
	});
}

function takeAvatarURLRequest() {
	const takeavatarURL = true;
		  
		  fetch(window.contextPath + '/views/user/Course', {
		  		method: 'POST',
		  		headers: {
		  			'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
		  		},
		  		body: `takeavatarURL=${takeavatarURL}`
		  	})
		  	.then(response => response.json())
		  	.then(data => {
		  		if (data != null) {
		  			userAvatar = data;
		  		}
		  	})
		  	.catch(error => {
		  	});
}

function takeProgressRequest() {
	const takeProgress = true;
	fetch(window.contextPath + '/views/user/Course', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
			},
			body: `takeProgress=${takeProgress}`
		})
		.then(response => response.json())
		.then(data => {
			renderProgressPopup(data);
		})
		.catch(error => {
		});
}

function sendFeedback(selectedRating, feedback)
{
	fetch(window.contextPath + '/views/user/Course', {
	      method: 'POST',
	      headers: {
	        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
	      },
	      body: `feedback=${feedback}&selectedRating=${selectedRating}`
	    })
	      .then(response => response.json())
	      .then(data => {
	      })
		.catch(error => {
		  console.error('Lỗi khi gửi đánh giá:', error);
		});
}

let currentToast = null; 

function markLessonAsCompleted(lessonId) {
  fetch(window.contextPath + '/views/user/Course', {
    method: 'POST',
    headers: {
		'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    },
	body: `lessonId=${lessonId}`
  })
  .then(response => {
    if (!response.ok) {
      throw new Error('Có lỗi khi gửi dữ liệu về server');
    }
    return response.json();
  })
  .then(data => {
	checkRatingRequest();
  })
  .catch(error => {
    console.error('Lỗi khi gửi lessonId:', error);
  });
}

function showToast(message, type = "success") {
  if (currentToast) {
    currentToast.remove();
    currentToast = null;
  }

  const toast = document.createElement("div");
  toast.innerText = message;
  toast.style.position = "fixed";
  toast.style.top = "50%";
  toast.style.left = "50%";
  toast.style.transform = "translate(-50%, -500%)";
  toast.style.color = "white";
  toast.style.padding = "15px 30px";
  toast.style.borderRadius = "8px";
  toast.style.boxShadow = "0 2px 10px rgba(0,0,0,0.3)";
  toast.style.zIndex = "9999";
  toast.style.fontSize = "18px";
  toast.style.textAlign = "center";
  toast.style.minWidth = "200px";

  switch (type) {
    case "error":
      toast.style.background = "#f44336";
      break;
    case "success":
      toast.style.background = "#4caf50";
      break;
    case "warning":
      toast.style.background = "#ff9800";
      break;
    case "info":
      toast.style.background = "#2196f3";
      break;
    default:
      toast.style.background = "#4caf50";
  }

  document.body.appendChild(toast);
  currentToast = toast; 

  setTimeout(() => {
    if (currentToast === toast) { 
      toast.remove();
      currentToast = null;
    }
  }, 3000);
}


//Xử lý click like
document.addEventListener("click", function(e) {
  if (e.target.closest(".fa-thumbs-up")) {
    const icon = e.target.closest(".reply-editor");
    icon.classList.toggle("liked");
  }
});

//render CKEditor comment
function attachCommentListeners() {
  document.querySelectorAll('.fa-comment').forEach(icon => {
    icon.addEventListener('click', function () {
      const commentDiv = this.closest('.comment');
      const replyDiv = commentDiv.querySelector('.comment-reply-editor');
      const parentId = commentDiv.getAttribute('data-comment-id');
      const editorId = `reply-editor-${parentId}`;

      // Ẩn tất cả reply editors khác và destroy CKEditor
      document.querySelectorAll('.comment-reply-editor').forEach(div => {
        div.style.display = 'none';
        if (div.querySelector('textarea')) {
          const ta = div.querySelector('textarea');
          const id = ta.id;
          if (CKEDITOR.instances[id]) {
            CKEDITOR.instances[id].destroy();
            delete CKEDITOR.instances[id];
          }
        }
        div.innerHTML = '';
      });

      // Toggle nếu đã mở
      if (replyDiv.style.display === 'block') {
        replyDiv.style.display = 'none';
        replyDiv.innerHTML = '';
        return;
      }

      // Tạo layout reply
      replyDiv.style.display = 'block';
      replyDiv.innerHTML = `
        <div class="editor-wrapper">
          <div class="editor-top">
            <img class="avatar" src="${userAvatar}" alt="Avatar">
            <div class="editor-content">
              <textarea id="${editorId}"></textarea>
            </div>
          </div>
          <div class="editor-bottom">
            <button class="submit-reply-btn" data-editor-id="${editorId}" data-parent-id="${parentId}">Gửi</button>
          </div>
        </div>
      `;

      // Khởi tạo CKEditor
      CKEDITOR.replace(editorId, {
        toolbar: [
          { name: 'styles', items: ['Styles', 'Format'] },
          { name: 'basicstyles', items: ['Bold', 'Italic'] },
          { name: 'paragraph', items: ['NumberedList', 'BulletedList'] },
          { name: 'links', items: ['Link', 'Unlink'] },
          { name: 'clipboard', items: ['Undo', 'Redo'] }
        ],
        removePlugins: 'elementspath',
        resize_enabled: false
      });
    });
  });
}

// GẮN SỰ KIỆN MỘT LẦN DUY NHẤT Ở NGOÀI
document.addEventListener("click", function (e) {
  if (e.target.closest(".submit-reply-btn")) {
    const btn = e.target.closest(".submit-reply-btn");
    const editorId = btn.getAttribute("data-editor-id");
    const parentId = btn.getAttribute("data-parent-id");
    const replyDiv = btn.closest('.comment-reply-editor');
	
    const editorInstance = CKEDITOR.instances[editorId];
    const replyContent = editorInstance.getData();

    if (!replyContent.trim()) return;

	const loadingSpinner = document.createElement('div');
	loadingSpinner.classList.add('loading-spinner');
	btn.appendChild(loadingSpinner);
	btn.disabled = true;

    fetch(window.contextPath + '/views/user/Course', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      body: `content=${encodeURIComponent(replyContent)}&parentId=${parentId}`
    })
      .then(response => response.json())
      .then(data => {
        editorInstance.setData("");
        editorInstance.destroy();
        delete CKEDITOR.instances[editorId];
        replyDiv.style.display = 'none';
        replyDiv.innerHTML = '';
        renderNestedComments(data);
		document.querySelectorAll('.comment').forEach(commentDiv => {
		    limitReplyDisplay(commentDiv);
		  });
		  
		  // Ẩn spinner và enable lại nút
		          loadingSpinner.remove();
		          btn.disabled = false;
      })
      .catch(error => {
        showToast("Gửi trả lời thất bại!", "error");
		
		// Ẩn spinner và enable lại nút
		        loadingSpinner.remove();
		        btn.disabled = false;
      });
  }
});

// Hàm render hiển thị popup với tiến độ khóa học
function renderProgressPopup(data) {
    const progressPopup = document.getElementById("progressPopup");
    const progressHeader = progressPopup.querySelector(".progress-header");

    const total = data.total;
    const current = data.current;

    // Tính phần trăm đã học, làm tròn xuống
    const percent = total > 0 ? Math.floor((current / total) * 100) : 0;

    progressHeader.textContent = `Đã học ${percent}% (${current}/${total} bài học)`;
}


// Toggle phần học (mở/đóng)
function toggleLesson(header) {
  const lessonList = header.nextElementSibling;
  const arrow = header.querySelector(".arrow");

  const isExpanded = lessonList.style.display !== "none";
  lessonList.style.display = isExpanded ? "none" : "block";
  arrow.innerHTML = isExpanded ? "&#9654;" : "&#9660;";
}

// Render các phần học
function renderLessons(data) {
  const container = document.getElementById("lesson-container");
  if (!container) return;
  container.innerHTML = "";

  data.forEach((section, index) => {
    const sectionDiv = document.createElement("div");
    sectionDiv.classList.add("lesson-section");

    const titleDiv = document.createElement("div");
    titleDiv.classList.add("lesson-group-title");
    titleDiv.setAttribute("onclick", "toggleLesson(this)");
    titleDiv.innerHTML = `
      ${section.title}
      <span class="arrow">${index === 0 ? "&#9660;" : "&#9654;"}</span>
    `;

    const lessonList = document.createElement("div");
    lessonList.classList.add("lesson-list");
    if (index !== 0) {
      lessonList.style.display = "none";
    }

    section.lessons.forEach((lesson, i) => {
      const item = document.createElement("div");
      item.classList.add("lesson-item");

      const isFirstLesson = index === 0 && i === 0;
      if (isFirstLesson) item.classList.add("active");

      item.setAttribute("data-video-url", lesson.videoUrl);
      item.setAttribute("data-description", lesson.description || "");
      item.setAttribute("data-lesson-id", lesson.id);

      item.innerHTML = `<span>${lesson.title}</span>`;
      lessonList.appendChild(item);

	  if (isFirstLesson) {
	    const url = lesson.videoUrl;
	    const title = lesson.title;
	    const description = lesson.description || "";
	    const lessonId = lesson.id;

	    window.currentLessonId = lessonId; 

	    const playerContainer = document.getElementById("youtube-player");
	    if (playerContainer && lessonId) {
	      playerContainer.setAttribute("data-lesson-id", lessonId);
	    }

	    document.getElementById("lesson-title").innerText = title;
	    document.getElementById("lesson-description").innerText = description;

	    if (window.YT && window.YT.Player && player) {
	      const videoId = extractYouTubeVideoId(url);
	      if (videoId) {
	        player.loadVideoById(videoId);
	      }
	    } else {
	      const iframe = document.getElementById("lesson-video");
	      if (iframe) {
	        iframe.src = url;
	      }
	    }

	    updateNavigationButtons(0, document.querySelectorAll(".lesson-item").length);
	  }


      item.addEventListener("click", function () {
        document.querySelectorAll(".lesson-item").forEach(el => el.classList.remove("active"));
        this.classList.add("active");

        const url = this.getAttribute("data-video-url");
        const title = this.querySelector("span").innerText;
        const description = this.getAttribute("data-description") || "";
        const lessonId = this.getAttribute("data-lesson-id");

        const playerContainer = document.getElementById("youtube-player");
        if (playerContainer && lessonId) {
          playerContainer.setAttribute("data-lesson-id", lessonId);
        }

        document.getElementById("lesson-title").innerText = title;
        document.getElementById("lesson-description").innerText = description;

        if (window.YT && window.YT.Player && player) {
          const videoId = extractYouTubeVideoId(url);
          if (videoId) {
            player.loadVideoById(videoId);
          }
        } else {
          const iframe = document.getElementById("lesson-video");
          if (iframe) {
            iframe.src = url;
          }
        }

        this.scrollIntoView({ behavior: "smooth", block: "center" });

        const allLessons = document.querySelectorAll(".lesson-item");
        const currentIndex = Array.from(allLessons).indexOf(this);
        updateNavigationButtons(currentIndex, allLessons.length);
      });
    });

    sectionDiv.appendChild(titleDiv);
    sectionDiv.appendChild(lessonList);
    container.appendChild(sectionDiv);
  });
}


//render chỉ hiển thị 2 reply
function limitReplyDisplay(commentDiv) {
  const replies = commentDiv.querySelectorAll('.reply');
  const replyList = commentDiv.querySelector('.reply-list');

  if (replies.length > 2) {
    // Ẩn các reply từ thứ 3 trở đi
    replies.forEach((reply, index) => {
      if (index >= 2) reply.style.display = 'none';
    });

    // Kiểm tra xem đã có nút "Xem thêm phản hồi" chưa để tránh thêm nhiều lần
    if (!commentDiv.querySelector('.show-more-btn')) {
      const showMoreBtn = document.createElement('button');
      showMoreBtn.className = 'show-more-btn';
      showMoreBtn.textContent = 'Xem thêm phản hồi';

      showMoreBtn.addEventListener('click', () => {
        replies.forEach(reply => reply.style.display = 'block');
        showMoreBtn.style.display = 'none';
      });

      // Thêm nút vào sau danh sách reply (nên gắn sau reply-list nếu có)
      if (replyList) {
        replyList.appendChild(showMoreBtn);
      } else {
        commentDiv.appendChild(showMoreBtn);
      }
    }
  }
}


function decodeHtmlEntities(str) {
  const txt = document.createElement('textarea');
  txt.innerHTML = str;
  return txt.value;
}


function renderNestedComments(allComments, filterType = "recent") {
  const container = document.getElementById("comment-container");
  if (!container) return;

  // Tách comment gốc và reply
  const comments = allComments.filter(c => c.parentId == null);
  const repliesMap = {};

  allComments.forEach(c => {
    if (c.parentId !== null) {
      if (!repliesMap[c.parentId]) repliesMap[c.parentId] = [];
      repliesMap[c.parentId].push(c);
    }
  });

  sortComments(comments, filterType);

  container.innerHTML = "";

  comments.forEach(comment => {
    const commentDiv = createCommentElement(comment);

    // Thêm replies nếu có
    const replies = repliesMap[comment.id] || [];
	if (replies.length > 0) {
	  replies.sort((a, b) => b.id - a.id);

	  const replyList = document.createElement("div");
	  replyList.classList.add("reply-list");

	  replies.forEach(reply => {
	    const replyDiv = createReplyElement(reply);
	    replyList.appendChild(replyDiv);
	  });

	  commentDiv.appendChild(replyList);
	  limitReplyDisplay(commentDiv);
	}


    // Thêm khung soạn thảo trả lời (ẩn)
    const replyEditorDiv = document.createElement("div");
    replyEditorDiv.className = "comment-reply-editor";
    replyEditorDiv.style.display = "none";
    commentDiv.appendChild(replyEditorDiv);

    container.appendChild(commentDiv);
  });

  // Re-attach các listener sau khi render lại
  attachCommentListeners();
}


function sortComments(comments, filterType) {
  return comments.sort((a, b) => {
    if (filterType === "newest") {
      return new Date(b.time) - new Date(a.time); 
    } else if (filterType === "oldest") {
      return new Date(a.time) - new Date(b.time); 
    } else {
      return 0;
    }
  });
}

function createCommentElement(comment) {
  const div = document.createElement("div");
  div.classList.add("comment");
  div.setAttribute("data-comment-id", comment.id);

  const avatar = comment.avatar || 'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg';
  const timeAgo = formatTimeAgo(comment.time) || "";

  div.innerHTML = `
    <div class="comment-body">
      <img class="avatar" src="${avatar}" alt="avatar">
      <div class="comment-content">
        <div class="author-name"><strong>${comment.author}</strong></div>
        <div class="comment-text">${decodeHtmlEntities(comment.content)}</div>
        <div class="comment-actions">
          <div class="left-actions">${timeAgo}</div>
          <div class="right-actions">
            <span class="reply-editor"><i class="fa-regular fa-comment"></i> ${comment.replies || 0}</span>
          </div>
        </div>
      </div>
    </div>
  `;
  return div;
}

function createReplyElement(reply) {
  const div = document.createElement("div");
  div.classList.add("reply");

  const avatar = reply.avatar || 'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg';
  const timeAgo = formatTimeAgo(reply.time) || "";

  div.innerHTML = `
    <div class="reply-body">
      <img class="avatar" src="${avatar}" alt="avatar">
      <div class="reply-content-box">
        <strong>${reply.author}</strong> <span class="reply-time">${timeAgo}</span>
        <div class="reply-content">${decodeHtmlEntities(reply.content)}</div>
      </div>
    </div>
  `;
  return div;
}

function formatTimeAgo(dateString) {
  const now = new Date();
  const time = new Date(dateString);
  const diff = Math.floor((now - time) / 1000); // tính bằng giây

  if (isNaN(diff)) return "Thời gian không xác định";

  const minute = 60;
  const hour = 60 * minute;
  const day = 24 * hour;
  const month = 30 * day;
  const year = 365 * day;

  if (diff < minute) return "Vừa xong";
  if (diff < hour) return `${Math.floor(diff / minute)} phút trước`;
  if (diff < day) return `${Math.floor(diff / hour)} giờ trước`;
  if (diff < 2 * day) return "Hôm qua";
  if (diff < month) return `${Math.floor(diff / day)} ngày trước`;
  if (diff < year) return `${Math.floor(diff / month)} tháng trước`;
  return `${Math.floor(diff / year)} năm trước`;
}

//Hàm toggle dùng hiển thị thông tin
function toggleContent(id, button) {
  const content = document.getElementById(id);
  if (!content) return;

  content.classList.toggle("expanded");

  if (content.classList.contains("expanded")) {
    button.textContent = "Thu gọn";
  } else {
    button.textContent = "Hiển thị thêm";
  }
}


//render giới thiệu khóa học
function renderOverviewIntro() {
  const container = document.getElementById("course-intro");
  if (!container) return;

  container.innerHTML = `
    <div class="course-description">
  <h3>Giới thiệu khóa học</h3>
      <div class="collapsible-container" id="course-description-content">
        ${courseDescription}
      </div>
      <span class="toggle-button" onclick="toggleContent('course-description-content', this)">Hiển thị thêm</span>
    </div>
  `;
}


//render thông tin giảng viên
function renderInstructorInfo(instructor) {
  if (!instructor) return;

  // Gán mặc định nếu undefined
  const {
    name = "Không rõ",
    avatar = "",
    url = "#",
    bio = "Chưa có thông tin",
    rating = 0,
    reviews = 0,
    students = 0,
    courses = 0,
    organization = ""
  } = instructor;

  document.getElementById("instructor-info").innerHTML = `
    <div class="instructor-wrapper">
      <h3>Giảng viên</h3>
      <p class="instructor-name">
        <a href="${url}" target="_blank" rel="noopener">
          ${name}
        </a>
      </p>
      <p class="instructor-org">${organization}</p>
      <div class="instructor-top">
        <img class="instructor-avatar" src="${avatar}" alt="Avatar">
        <div class="instructor-stats">
          <div class="instructor-stat">
            <i class="fas fa-star"></i>
            <span>${Number(rating).toFixed(1)} xếp hạng</span>
          </div>
          <div class="instructor-stat">
            <i class="far fa-star"></i>
            <span>${Number(reviews).toLocaleString()} đánh giá</span>
          </div>
          <div class="instructor-stat">
            <i class="fas fa-user"></i>
            <span>${Number(students).toLocaleString()} học viên</span>
          </div>
          <div class="instructor-stat">
            <i class="fas fa-play-circle"></i>
            <span>${Number(courses).toLocaleString()} khóa học</span>
          </div>
        </div>
      </div>
      <div class="instructor-bio-section">
        <div class="collapsible-container" id="instructor-bio-content">
          ${bio}
        </div>
        <span class="toggle-button"
              onclick="toggleContent('instructor-bio-content', this)">
          Hiển thị thêm
        </span>
      </div>
    </div>
  `;
}


//Render bảng đánh giá
function renderRatingSummary(data) {
  const container = document.getElementById("rating-summary");
  if (!container) return;

  let ratingRows = "";
  for (let i = 5; i >= 1; i--) {
    ratingRows += `
      <div class="rating-row">
        <div class="progress-bar-background">
          <div class="progress-bar-fill" style="width: ${data.distribution[i]}%;"></div>
        </div>
        <div class="star-text">${"★".repeat(i)}</div>
        <div class="percentage-text">${data.distribution[i]}%</div>
      </div>
    `;
  }

  container.innerHTML = `
    <h2>Phản hồi của học viên</h2>
    <div class="average-score">${data.average.toFixed(1)}</div>
    <div class="stars">
      ${"★".repeat(Math.round(data.average))}
    </div>
    <div class="average-text">Điểm đánh giá trung bình</div>
    ${ratingRows}
  `;
}

//render reviews
let reviewsPerPage = 10;
let currentPage = 1;
let selectedRatingFilter = "All"; // Mặc định

document.addEventListener("DOMContentLoaded", function () {
  renderReviews();

  const loadMoreBtn = document.getElementById("load-more-btn");
  if (loadMoreBtn) {
    loadMoreBtn.addEventListener("click", function () {
      currentPage++;
      renderReviews();
    });
  }

  // Sự kiện thay đổi bộ lọc sao
  const ratingSort = document.getElementById("rating-sort");
  if (ratingSort) {
    ratingSort.addEventListener("change", function () {
      selectedRatingFilter = this.value; // "All", "5-stars", ...
      currentPage = 1; // Reset lại trang
      renderReviews();
    });
  }
});

function renderReviews() {
  const container = document.getElementById("reviews-container");
  if (!container) return;

  container.innerHTML = "";

  // Lọc dữ liệu theo số sao nếu cần
  let filteredReviews = [...reviewData];
  if (selectedRatingFilter !== "All") {
    const selectedStars = parseInt(selectedRatingFilter.charAt(0)); // "5-stars" -> 5
    filteredReviews = reviewData.filter(r => r.rating === selectedStars);
  }

  const start = 0;
  const end = reviewsPerPage * currentPage;
  const currentReviews = filteredReviews.slice(start, end);

  currentReviews.forEach(review => {
    const reviewDiv = document.createElement("div");
    reviewDiv.classList.add("review-item");

    const stars = Array(5).fill(0).map((_, index) =>
      index < review.rating ? "★" : "☆"
    ).join("");

    reviewDiv.innerHTML = `
      <div class="review-body">
        <img class="avatar" src="${review.avatar || 'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg'}" alt="avatar">
        <div class="review-content">
          <div class="author-name">${review.author}</div>
          <div class="rating-stars">${stars}</div>
          <div class="review-text">${review.content}</div>
        </div>
      </div>
    `;

    container.appendChild(reviewDiv);
  });

  // Ẩn nút nếu đã load hết dữ liệu
  const loadMoreBtn = document.getElementById("load-more-btn");
  if (filteredReviews.length <= end) {
    loadMoreBtn.style.display = "none";
  } else {
    loadMoreBtn.style.display = "block";
  }
}