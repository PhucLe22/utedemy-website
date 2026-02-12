package vn.iotstar.controller.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.Cart;
import vn.iotstar.entity.Course;
import vn.iotstar.entity.Discount;
import vn.iotstar.entity.OrderItem;
import vn.iotstar.entity.Orders;
import vn.iotstar.entity.User;
import vn.iotstar.impl.service.CartService;
import vn.iotstar.impl.service.CourseService;
import vn.iotstar.impl.service.DiscountService;
import vn.iotstar.impl.service.OrderService;
import vn.iotstar.paypal.PayPalService;
import vn.iotstar.service.ICartService;
import vn.iotstar.service.ICourseService;
import vn.iotstar.service.IDiscountService;
import vn.iotstar.service.IOrderService;

@WebServlet(urlPatterns = {"/user/viewcheckout","/process-payment","/cancel-order"})
public class OrderController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	ICourseService course_service = new CourseService();
	IOrderService order_service = new OrderService();
	ICartService cart_service = new CartService();
	IDiscountService discount_service = new DiscountService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		User user = (User) session.getAttribute("account");

		String url = req.getRequestURI();
		if (url.contains("viewcheckout")) {
		    String[] selectedCourseIds = req.getParameterValues("selectedCourses");
		    if (selectedCourseIds == null || selectedCourseIds.length == 0) {
		    	// Kiểm tra xem user đã có order PROCESSING chưa
				   Orders order = order_service.findProcessingOrderByUserId(user.getId());
				   System.out.println("Đã ở đây huhu");

				   if (order == null) {
				        // Chưa có, tạo mới
				        order = new Orders();
				        order.setOrderDate(new Date(System.currentTimeMillis()));
				        order.setOrderStatus("PROCESSING");
				        order.setUser(user);
				        order.setOrderItems(new HashSet<>());
				        System.out.println("nó bị null");
				    }
				   
				   System.out.println("đã ở đây hrhr");
				   
				   Set<OrderItem> orderItems = order.getOrderItems();
				   double subtotalAmount = 0.0;

				   for (OrderItem item : orderItems) {
				       double coursePrice = item.getCourse().getCoursePrice();
				       double discountAmount = 0.0;

				       Discount discount = item.getDiscount();
				       if (discount != null) {
				           String type = discount.getType();
				           double decreasedFee = Double.parseDouble(discount.getDecreasedFee());

				           if ("PERCENTAGE".equalsIgnoreCase(type)) {
				               discountAmount = coursePrice * (decreasedFee / 100);
				           } else if ("AMOUNTMONEY".equalsIgnoreCase(type)) {
				               discountAmount = decreasedFee;
				           }
				           
				           // Đảm bảo giảm không vượt quá giá course
				           discountAmount = Math.min(discountAmount, coursePrice);
				       }

				       subtotalAmount += (coursePrice - discountAmount);
				   }

				   System.out.println("Tổng tiền sau giảm: " + subtotalAmount);
				   // Lấy courseIdnow từ query string
			        String courseIdStr = req.getParameter("courseIdnow");

			        // Nếu courseIdnow tồn tại (không null và không rỗng)
			        if (courseIdStr != null && !courseIdStr.isEmpty()) {
			            try {
			                int courseId = Integer.parseInt(courseIdStr);
			                Course course = course_service.findByIdCourse(courseId);
			                if (course != null) {
					            System.out.println("courseisnull");
					            // Kiểm tra xem order đã có course này chưa
					            boolean exists = orderItems.stream()
					                    .anyMatch(oi -> oi.getCourse().getId() == courseId);

					            if (!exists) {
					                // Nếu chưa có, thêm vào order
					            	 System.out.println("courseisnulluhuhuhu");
					                OrderItem orderItem = new OrderItem();
					                orderItem.setCourse(course);
					                orderItem.setFinishedFee(course.getCoursePrice());
					                orderItem.setOrder(order);
					                orderItems.add(orderItem);
					                subtotalAmount += course.getCoursePrice();
					            }
					        }
			            } catch (NumberFormatException e) {
			                // Nếu không phải số thì cũng không làm gì
			                // Hoặc chuyển hướng nếu muốn
			            }
			        }				    
				    order.setOrderItems(orderItems);
				    order_service.insertOrUpdateOrder(order);
				    session.setAttribute("order", order);
				    req.setAttribute("subtotalAmount", subtotalAmount);
				    req.getRequestDispatcher("/views/user/checkout.jsp").forward(req, resp);
		        return;
		    }
		   System.out.println("Đã ở đây hehe");
		 // Kiểm tra xem user đã có order PROCESSING chưa
		   Orders order = order_service.findProcessingOrderByUserId(user.getId());
		   System.out.println("Đã ở đây huhu");

		   if (order == null) {
		        // Chưa có, tạo mới
		        order = new Orders();
		        order.setOrderDate(new Date(System.currentTimeMillis()));
		        order.setOrderStatus("PROCESSING");
		        order.setUser(user);
		        order.setOrderItems(new HashSet<>());
		        System.out.println("nó bị null");
		    }
		   
		   System.out.println("đã ở đây hrhr");
		   Set<OrderItem> orderItems = order.getOrderItems();
		    double subtotalAmount = 0.0;

			   for (OrderItem item : orderItems) {
			       double coursePrice = item.getCourse().getCoursePrice();
			       double discountAmount = 0.0;

			       Discount discount = item.getDiscount();
			       if (discount != null) {
			           String type = discount.getType();
			           double decreasedFee = Double.parseDouble(discount.getDecreasedFee());

			           if ("PERCENTAGE".equalsIgnoreCase(type)) {
			               discountAmount = coursePrice * (decreasedFee / 100);
			           } else if ("AMOUNTMONEY".equalsIgnoreCase(type)) {
			               discountAmount = decreasedFee;
			           }
			           
			           // Đảm bảo giảm không vượt quá giá course
			           discountAmount = Math.min(discountAmount, coursePrice);
			       }

			       subtotalAmount += (coursePrice - discountAmount);
			   }

		    for (String courseIdStr : selectedCourseIds) {
		        int courseId = Integer.parseInt(courseIdStr);
		        System.out.println("mmm"+courseId);
		        Course course = course_service.findByIdCourse(courseId);
		        System.out.println("mmm11 "+course.getId());

		        if (course != null) {
		            System.out.println("courseisnull");
		            // Kiểm tra xem order đã có course này chưa
		            boolean exists = orderItems.stream()
		                    .anyMatch(oi -> oi.getCourse().getId() == courseId);

		            if (!exists) {
		                // Nếu chưa có, thêm vào order
		            	 System.out.println("courseisnulluhuhuhu");
		                OrderItem orderItem = new OrderItem();
		                orderItem.setCourse(course);
		                orderItem.setFinishedFee(course.getCoursePrice());
		                orderItem.setOrder(order);
		                orderItems.add(orderItem);
		                subtotalAmount += course.getCoursePrice();
		            }
		        }
		        System.out.println("hhhhhh");
		    }
		    System.out.println("đã ở đây hrhr1");
		    order.setOrderItems(orderItems);
		    boolean insertSuccess = order_service.insertOrUpdateOrder(order);
		    System.out.println("đã ở đây hrhr2");

		    if (insertSuccess) {
		        Cart cart = cart_service.findByUserId(user.getId());
		        System.out.println("đã ở đây hrhr3");
		        if (cart != null) {
		        	System.out.println("đã ở đây hrhr4");
		            List<Integer> selectedCourseIdsList = Arrays.stream(selectedCourseIds)
		                                                        .map(Integer::parseInt)
		                                                        .collect(Collectors.toList());
		            cart_service.deleteSelectedCourses(cart, selectedCourseIdsList);
		            System.out.println("đã ở đây hrhr5");
		        }
		    }
		    System.out.println("đã ở đây hrhr6");
		    
		    //phải select lại
		    order = order_service.findProcessingOrderByUserId(user.getId());
		    session.setAttribute("order", order);
		    req.setAttribute("subtotalAmount", subtotalAmount);
		    req.getRequestDispatcher("/views/user/checkout.jsp").forward(req, resp);
		    return;
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String url = req.getRequestURI();
		if (url.contains("cancel-order")) {
		    String orderIdParam = req.getParameter("orderId");
		    resp.setContentType("application/json");
		    resp.setCharacterEncoding("UTF-8");

		    Map<String, Object> jsonResponse = new HashMap<>();

		    try {
		        boolean checkStatus = order_service.updateOrderStatus(Integer.parseInt(orderIdParam), "CANCELED");

		        if (checkStatus) {
		            jsonResponse.put("success", true);
		        } else {
		            jsonResponse.put("success", false);
		            jsonResponse.put("message", "Không thể hủy đơn hàng, có thể đơn đã được xử lý.");
		        }

		    } catch (NumberFormatException e) {
		        jsonResponse.put("success", false);
		        jsonResponse.put("message", "Order ID không hợp lệ.");
		    }

		    PrintWriter out = resp.getWriter();
		    out.print(new Gson().toJson(jsonResponse));
		    out.flush();
		    return;
		}

		HttpSession session = req.getSession();
		String[] orderItemIds = req.getParameterValues("orderItemIds");
		String[] finishedFees = req.getParameterValues("finishedFees");
        String totalAmountStr = req.getParameter("totalAmount");
        session.setAttribute("orderItemIds", orderItemIds);
        session.setAttribute("finishedFees", finishedFees);
        session.setAttribute("totalAmountStr", totalAmountStr);
        
        float totalAmount = Float.parseFloat(totalAmountStr);
        
        //mình phải xử lí paypal ở đây, truyền total amount, sau khi hoàn tất thì mới chạy code ở dước
         String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
         String approveLink = PayPalService.createPayment(convertVNDToUSD(totalAmount), "USD", baseUrl + "/user/orderpaypal/success",
	            baseUrl + "/user/orderpaypal/cancel");
         if (approveLink != null) {
 	        resp.sendRedirect(approveLink);
 	        return;
 	    } else {
 	        resp.sendRedirect("/user/viewcheckout");
 	        return;
 	    }

        
       

	}
	private float convertVNDToUSD(float amountInVND) {
	    final float exchangeRate = 25376.05f; // 1 USD = 25,376.05 VND
	    return amountInVND / exchangeRate;
	}

}
