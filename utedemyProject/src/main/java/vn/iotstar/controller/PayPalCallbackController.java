package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.Orders;
import vn.iotstar.entity.User;
import vn.iotstar.impl.service.OrderService;
import vn.iotstar.paypal.PayPalService;
import vn.iotstar.service.IOrderService;

@WebServlet(urlPatterns = { "/user/orderpaypal/success", "/user/orderpaypal/cancel" })
public class PayPalCallbackController extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	IOrderService order_service = new OrderService();
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		 String path = req.getServletPath();
	     HttpSession session = req.getSession();
	     User user = (User) session.getAttribute("account");
		 Orders order = order_service.findProcessingOrderByUserId(user.getId());

	        if (path.contains("success")) {
	            String orderID = req.getParameter("token");
	            System.out.println("Order ID: " + orderID);
	            // Gọi PayPal để xác nhận thanh toán
	            if (PayPalService.capturePayment(orderID)) {
	            //	OrderModel order_paypal = (OrderModel)session.getAttribute("orderpaypal");
	          
	               boolean isSucess = order_service.updateOrderStatus(order.getId(),"COMPLETED");
					if(isSucess==true) {
					session.setAttribute("order_state", "success");
				    resp.sendRedirect(req.getContextPath() + "/user/viewcheckout");
					}

	            }
	            else {
	                session.setAttribute("order_state", "fail");
	                resp.sendRedirect(req.getContextPath() + "/user/viewcheckout");
	            }
	        } else if (path.contains("cancel")) {
	        
	            session.setAttribute("order_state", "cancel");
                resp.sendRedirect(req.getContextPath() + "/user/viewcheckout");
	        }
	    }
	}

