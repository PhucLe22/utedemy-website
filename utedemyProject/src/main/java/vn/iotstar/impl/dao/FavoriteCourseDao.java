package vn.iotstar.impl.dao;

import java.util.HashSet;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.IFavoriteCourseDao;
import vn.iotstar.entity.Course;
import vn.iotstar.entity.FavoriteCourse;
import vn.iotstar.entity.User;

public class FavoriteCourseDao implements IFavoriteCourseDao {

	@Override
	public FavoriteCourse findByIdUser(int idUser) {
		EntityManager em = JPAConfig.getEntityManager();
	    try {
            return em.createQuery("SELECT f FROM FavoriteCourse f WHERE f.user.id = :userId", FavoriteCourse.class)
                    .setParameter("userId", idUser)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
	}

	@Override
	public boolean addCourseToFavorite(User user, Course course) {
		EntityManager em = JPAConfig.getEntityManager();
	    try {
	        em.getTransaction().begin();

	        User managedUser = em.find(User.class, user.getId());
	        Course managedCourse = em.find(Course.class, course.getId());
	        
	        if (managedUser == null || managedCourse == null) {
	            return false;
	        }
	        
	        FavoriteCourse favoriteCourse = findByIdUser(managedUser.getId());
	        if (favoriteCourse == null) {
	            favoriteCourse = new FavoriteCourse();
	            favoriteCourse.setUser(managedUser);
	            favoriteCourse.setCourses(new HashSet<>());
	            managedUser.setFavoriteCourse(favoriteCourse);
	        } else {
	            favoriteCourse = em.merge(favoriteCourse);
	        }
	        
	        if (!favoriteCourse.getCourses().contains(managedCourse)) {
	            favoriteCourse.getCourses().add(managedCourse);
	        }
	        
	        if (favoriteCourse.getId() == 0) {
	            em.persist(favoriteCourse);
	        } else {
	            favoriteCourse = em.merge(favoriteCourse);
	        }
	        
	        // Commit transaction
	        em.getTransaction().commit();
	        return true;
	    } catch (Exception e) {
	        if (em.getTransaction().isActive()) {
	            em.getTransaction().rollback();
	        }
	        e.printStackTrace();
	        return false;
	    } finally {
	        em.close();
	    }
	}

	@Override
	public boolean removeCourseFromFavorite(User user, Course course) {
		EntityManager em = JPAConfig.getEntityManager();
	    try {
	        em.getTransaction().begin();

	        User managedUser = em.find(User.class, user.getId());
	        Course managedCourse = em.find(Course.class, course.getId());

	        FavoriteCourse favoriteCourse = findByIdUser(managedUser.getId());
	        
	        if (favoriteCourse != null) {
	            favoriteCourse = em.merge(favoriteCourse);
	            
	            if (favoriteCourse.getCourses().contains(managedCourse)) {
	                favoriteCourse.getCourses().remove(managedCourse);
	                em.merge(favoriteCourse);
	                em.flush();
	            }
	        }

	        em.getTransaction().commit();
	        return true;
	    } catch (Exception e) {
	        if (em.getTransaction().isActive()) {
	            em.getTransaction().rollback();
	        }
	        e.printStackTrace();
	        return false;
	    } finally {
	        if (em != null && em.isOpen()) {
	            em.close();
	        }
	    }
	}

	@Override
	public boolean isCourseInFavorite(User user, Course course) {
		if (user == null || course == null) {
            return false;
        }
        
        FavoriteCourse favoriteCourse = findByIdUser(user.getId());
        return favoriteCourse != null && favoriteCourse.getCourses().contains(course);
	}

}