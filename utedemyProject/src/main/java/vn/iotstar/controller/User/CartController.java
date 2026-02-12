package vn.iotstar.controller.User;

import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Set;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.Cart;
import vn.iotstar.entity.Course;
import vn.iotstar.entity.User;
import vn.iotstar.impl.service.CartService;
import vn.iotstar.impl.service.CourseService;
import vn.iotstar.service.ICartService;
import vn.iotstar.service.ICourseService;


@SuppressWarnings("serial")
@WebServlet(urlPatterns = {"/user/cart","/user/addcart","/user/deletecart"})
public class CartController extends HttpServlet{
	
	ICartService cart_service = new CartService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String url = req.getRequestURI();
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		
		HttpSession session = req.getSession();
		User u = (User) session.getAttribute("account");
		int userId = u.getId();
		
		if (url.contains("cart"))
		{
		Cart cart = cart_service.findByUserId(userId);
		Set<Course> courses = Collections.emptySet(); // khởi tạo mặc định tránh lỗi
		
		if (cart != null) {
		    courses = cart.getCourses();
		    // xử lý tiếp với courses ở đây
		}
		
		double totalAmount = 0;
		for (Course course : courses) {
		    totalAmount += course.getCoursePrice();
		    System.out.println("hehe" + course.getCourseName());
		}
		
		
		System.out.println("Testcart"+cart);
		session.setAttribute("totalAmount",totalAmount);
		session.setAttribute("cart", cart);
		
		List<Course> recommendedCourses = cart_service.getRandomCoursesNotInCartByUserId(userId, 5);
		// Giả sử recommendedCourses là danh sách các khóa học đề xuất
		

		System.out.println("Recommended Courses: ");
		if (recommendedCourses != null && !recommendedCourses.isEmpty()) {
		    for (Course course : recommendedCourses) {
		        System.out.println("Course Name: " + course.getCourseName());
		        // Nếu bạn muốn in thêm các thông tin khác, có thể tiếp tục
		        // ví dụ: System.out.println("Course Description: " + course.getDescription());
		    }
		} else {
		    System.out.println("No courses found.");
		}
		session.setAttribute("recommendedCourses",recommendedCourses);
		
		req.getRequestDispatcher("/views/user/cartpage.jsp").forward(req, resp);
		}
		
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String url = req.getRequestURI();
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		HttpSession session = req.getSession();
		User u = (User) session.getAttribute("account");
		
		if (url.contains("deletecart"))
		{
			  String action = req.getParameter("action");

		        if (action != null) {
		            if (action.equals("deleteAll")) {
		                boolean bool = cart_service.removeAllCoursesByUserId(u.getId());
		                System.out.println("Test"+bool);
		                resp.sendRedirect(req.getContextPath() + "/user/cart");
		            	return;
		            }
		            if ("deleteSelected".equals(action)) {
		                // Lấy các id khóa học được chọn
		                String[] selectedCourses = req.getParameterValues("selectedCourses");

		                if (selectedCourses != null && selectedCourses.length > 0) {
		                    // Lấy cart từ session
		                    Cart cart = (Cart) session.getAttribute("cart");

		                    if (cart != null) {
		                        // Chuyển mảng sang List để tiện xử lý
		                        List<String> selectedList = Arrays.asList(selectedCourses);
		                        
		                        List<Integer> selectedIds = selectedList.stream()
                                        .map(Integer::parseInt)
                                        .toList();


		                        // Xóa từng khóa học khỏi cart
		                        boolean result = cart_service.deleteSelectedCourses(cart, selectedIds);
		                        
		                        if (result) {
		                            System.out.println("Xóa thành công các khóa học đã chọn.");
		                        } else {
		                            System.out.println("Xóa thất bại.");
		                        }

		                        // Cập nhật lại cart vào session
		                        session.setAttribute("cart", cart);
		                    }
		                }

		                // Redirect về trang cart sau khi xóa
		                resp.sendRedirect(req.getContextPath() + "/user/cart");
		                return;
		            }
		        }
		}
		if (url.contains("addcart")) {
			System.out.println("đã vô đây");
		    String courseId = req.getParameter("id");
		 
		    	System.out.println("bị null");
		    boolean check = cart_service.addCourseToCart(u.getId(), Integer.parseInt(courseId));

		    resp.setContentType("text/plain");
		    resp.setCharacterEncoding("UTF-8");

		    if (check) {
		        resp.getWriter().write("success");
		    } else {
		        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		        resp.getWriter().write("error");
		    }
		    return;

		}

		
		
	}
	

}
