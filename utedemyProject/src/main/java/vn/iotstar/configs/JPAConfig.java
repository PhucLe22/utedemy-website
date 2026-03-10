package vn.iotstar.configs;

import java.util.HashMap;
import java.util.Map;

import jakarta.persistence.*;

public class JPAConfig {

	private static final EntityManagerFactory factory = buildFactory();

	private static EntityManagerFactory buildFactory() {
		Map<String, String> overrides = new HashMap<>();

		String dbUrl = System.getenv("DB_URL");
		String dbUser = System.getenv("DB_USERNAME");
		String dbPass = System.getenv("DB_PASSWORD");

		if (dbUrl != null) {
			overrides.put("jakarta.persistence.jdbc.url", dbUrl);
		}
		if (dbUser != null) {
			overrides.put("jakarta.persistence.jdbc.user", dbUser);
		}
		if (dbPass != null) {
			overrides.put("jakarta.persistence.jdbc.password", dbPass);
		}

		return Persistence.createEntityManagerFactory("jpa-hibernate-mysql", overrides);
	}

	public static EntityManager getEntityManager() {
		return factory.createEntityManager();
	}

	public static void close() {
		if (factory != null && factory.isOpen()) {
			factory.close();
		}
	}
}
