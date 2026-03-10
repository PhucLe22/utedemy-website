package vn.iotstar.impl.dao;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.EntityManager;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.IReviewDao;
import vn.iotstar.entity.*;

public class ReviewDao implements IReviewDao{

	@Override
	public List<Review> getAllReviews() {
	    EntityManager em = JPAConfig.getEntityManager();
	    List<Review> reviews = new ArrayList<>();
	    try {
	        String sql = "SELECT o FROM Review o";
	        reviews = em.createQuery(sql, Review.class).getResultList();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (em != null && em.isOpen()) {
	            em.close();
	        }
	    }
	    return reviews;
	}
}
