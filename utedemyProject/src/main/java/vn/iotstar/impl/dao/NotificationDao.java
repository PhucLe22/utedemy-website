package vn.iotstar.impl.dao;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.INotificationDao;
import vn.iotstar.entity.Notification;

public class NotificationDao implements INotificationDao {

	@Override
	public List<Notification> findByIdUser(int id) {

	    EntityManager enma = JPAConfig.getEntityManager();
	    try {
	        String jpql = "SELECT n FROM Notification n WHERE n.receiver.id = :UserId";
	        TypedQuery<Notification> query = enma.createQuery(jpql, Notification.class);
	        query.setParameter("UserId", id);
	        return query.getResultList();
	    } finally {
	        enma.close();
	    }
	}

	@Override
	public boolean insert(Notification notification) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();

	    try {
	        trans.begin();
	        em.merge(notification);
	        trans.commit();
	        return true;
	    } catch (Exception e) {
	        if (trans.isActive()) {
	            trans.rollback();
	        }
	        e.printStackTrace();
	        return false;
	    } finally {
	        em.close();
	    }
	}

}
