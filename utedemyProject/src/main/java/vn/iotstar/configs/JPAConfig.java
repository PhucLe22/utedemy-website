package vn.iotstar.configs;

import jakarta.persistence.*;

public class JPAConfig {

	private static final EntityManagerFactory factory =
			Persistence.createEntityManagerFactory("jpa-hibernate-mysql");

	public static EntityManager getEntityManager() {
		return factory.createEntityManager();
	}

	public static void close() {
		if (factory != null && factory.isOpen()) {
			factory.close();
		}
	}
}
