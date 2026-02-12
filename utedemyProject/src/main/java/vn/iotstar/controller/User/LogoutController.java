package vn.iotstar.controller.User;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/logout")
public class LogoutController extends HttpServlet{

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		 getLogOut(req, resp);
         return;
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		super.doGet(req, resp);
	}
	  private void getLogOut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	    	
	    	//khi logout xoa session
	    	HttpSession session = req.getSession();
			session.removeAttribute("account");
			session.removeAttribute("id");

	        // Xóa JWT , fb trong cookie
	        Cookie[] cookies = req.getCookies();
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if (cookie.getName().equals("id")) {
	                    cookie.setMaxAge(0);
	                    resp.addCookie(cookie);
	                    break;
	                }
	            }
	        }
	        resp.sendRedirect(req.getContextPath() + "/user/homepage");
	    }

}
