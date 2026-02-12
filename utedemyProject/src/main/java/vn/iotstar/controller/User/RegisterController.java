package vn.iotstar.controller.User;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.Role;
import vn.iotstar.entity.User;
import vn.iotstar.impl.service.*;
import vn.iotstar.service.*;
import vn.iotstar.utils.AESUtil;


@WebServlet(urlPatterns = {"/user/register"})
public class RegisterController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	private IRoleService roleService = new RoleService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		resp.setCharacterEncoding("UTF-8");
		req.setCharacterEncoding("UTF-8");
		String path = req.getServletPath();
		if(path.contains("register")) {
		resp.sendRedirect(req.getContextPath() + "/views/user/registerpage.jsp");	
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		resp.setCharacterEncoding("UTF-8");
		req.setCharacterEncoding("UTF-8");
		
		IUserService service = new UserService();
		HttpSession session = req.getSession();
		String path = req.getServletPath();
		if (path.contains("register")) {
			
			String fullname = req.getParameter("fullname");
			session.setAttribute("fullname",fullname);
			
			String password = req.getParameter("password");
			session.setAttribute("password",password);
			
			String email = req.getParameter("email");
			session.setAttribute("email",email);
			
			String phone = req.getParameter("phone");
			session.setAttribute("phone",phone);
		
			
			String confirmPassword = req.getParameter("confirmPassword");
			session.setAttribute("confirmPassword", confirmPassword);
			
			
			if(service.checkPasswordAndConfirmPassword(password,confirmPassword)==false) {
				session.setAttribute("alert", "Mật khẩu và xác nhận mật khẩu không khớp");
				 resp.sendRedirect(req.getContextPath() + "/user/register");
				    return;
			}
			else {
			  if(service.checkPasswordFormat(confirmPassword)==false) {
				 session.setAttribute("alert", "Mật khẩu không đúng định dạng");
				 resp.sendRedirect(req.getContextPath() + "/user/register");
		         return;
		     	}
			}
			
			if (service.checkFormatMail(email)==false) {
				session.setAttribute("alert", "Email không đúng định dạng");
			    resp.sendRedirect(req.getContextPath() + "/user/register");
			    return;
			}
			if (!service.checkFormatPhone(phone)==false) {
				session.setAttribute("alert", "Số điện thoại không đúng định dạng");
			    resp.sendRedirect(req.getContextPath() + "/user/register");
			    return;
			}
		
			if (service.checkExistEmail(email)) {
				session.setAttribute("alert", "Email đã được đăng kí");
			    resp.sendRedirect(req.getContextPath() + "/user/register");
			    return;
			}
			
			if (service.checkExistPhoneNumber(phone)) {
				session.setAttribute("alert", "Số điện thoại đã được đăng kí");
				 resp.sendRedirect(req.getContextPath() + "/user/register?error=phone_exist");
				 return;
			}

			// Create user directly without OTP
			String encryptedPassword = null;
			try {
				encryptedPassword = AESUtil.encrypt(password);
			} catch (Exception e) {
				e.printStackTrace();
			}

			Role userRole = roleService.getDefaultUserRole();

			User user = new User();
			user.setAvatarUrl("default-avatar.png");
			user.setFullname(fullname);
			user.setEmail(email);
			user.setPassword(encryptedPassword);
			user.setPhoneNumber(phone);
			user.addRole(userRole);
			user.setIsActive(true);

			service.insert(user);

			session.setAttribute("account", user);
			resp.sendRedirect(req.getContextPath() + "/user/homepage");
		}
		

	}

}
