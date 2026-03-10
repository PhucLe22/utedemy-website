package vn.iotstar.configs;

import java.util.HashMap;
import java.util.Map;

import jakarta.persistence.*;

public class JPAConfig {

	private static EntityManagerFactory factory;

	static {
		try {
			factory = buildFactory();
			System.out.println("[JPAConfig] EntityManagerFactory created successfully");
		} catch (Exception e) {
			System.err.println("[JPAConfig] FAILED to create EntityManagerFactory: " + e.getMessage());
			e.printStackTrace();
			factory = null;
		}
	}

	private static EntityManagerFactory buildFactory() {
		Map<String, String> overrides = new HashMap<>();

		String dbUrl = System.getenv("DB_URL");
		String dbUser = System.getenv("DB_USERNAME");
		String dbPass = System.getenv("DB_PASSWORD");

		System.out.println("[JPAConfig] DB_URL env: "
				+ (dbUrl != null ? dbUrl.substring(0, Math.min(30, dbUrl.length())) + "..." : "NULL"));
		System.out.println("[JPAConfig] DB_USERNAME env: " + (dbUser != null ? dbUser : "NULL"));
		System.out.println("[JPAConfig] DB_PASSWORD env: " + (dbPass != null ? "***set***" : "NULL"));

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
