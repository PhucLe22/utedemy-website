package vn.iotstar.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import vn.iotstar.entity.Role;
import vn.iotstar.entity.User;
import vn.iotstar.impl.service.RoleService;
import vn.iotstar.impl.service.UserService;
import vn.iotstar.service.IRoleService;
import vn.iotstar.service.IUserService;
import vn.iotstar.utils.AESUtil;

@WebListener
public class DemoAccountInitializer implements ServletContextListener {

	private static final String DEMO_EMAIL = "demo@utedemy.com";
	private static final String DEMO_PASSWORD = "Demo@1234";
	private static final String DEMO_FULLNAME = "Demo User";
	private static final String DEMO_PHONE = "091 234 56 78";

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		IUserService userService = new UserService();
		IRoleService roleService = new RoleService();

		if (!userService.checkExistEmail(DEMO_EMAIL)) {
			try {
				String encryptedPassword = AESUtil.encrypt(DEMO_PASSWORD);
				Role userRole = roleService.getDefaultUserRole();

				User demo = new User();
				demo.setAvatarUrl("default-avatar.png");
				demo.setFullname(DEMO_FULLNAME);
				demo.setEmail(DEMO_EMAIL);
				demo.setPassword(encryptedPassword);
				demo.setPhoneNumber(DEMO_PHONE);
				demo.addRole(userRole);
				demo.setIsActive(true);

				userService.insert(demo);
				System.out.println("[DemoAccountInitializer] Demo account created: " + DEMO_EMAIL);
			} catch (Exception e) {
				System.err.println("[DemoAccountInitializer] Failed to create demo account: " + e.getMessage());
			}
		} else {
			System.out.println("[DemoAccountInitializer] Demo account already exists: " + DEMO_EMAIL);
		}
	}
}
