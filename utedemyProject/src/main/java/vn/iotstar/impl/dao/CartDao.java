package vn.iotstar.impl.dao;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.ICartDao;
import vn.iotstar.entity.Cart;
import vn.iotstar.entity.Course;
import vn.iotstar.entity.User;

public class CartDao implements ICartDao{

	@Override
	public Cart findByUserId(int userId) {

		EntityManager em = JPAConfig.getEntityManager();

		 try {
	            return em.createQuery("SELECT c FROM Cart c WHERE c.user.id = :userId", Cart.class)
	                     .setParameter("userId", userId)
	                     .getSingleResult();
	        } catch (NoResultException e) {
	            return null;
	        } finally {
	            em.close();
	        }
	}
	public boolean removeAllCoursesByUserId(int userId) {

		EntityManager em = JPAConfig.getEntityManager();

	    try {
	        em.getTransaction().begin();

	        TypedQuery<Cart> query = em.createQuery(
	            "SELECT c FROM Cart c WHERE c.user.id = :userId", Cart.class);
	        query.setParameter("userId", userId);
	        Cart cart = query.getSingleResult();

	        if (cart != null) {
	            cart.getCourses().clear();
	            em.merge(cart);

	            em.getTransaction().commit();
	            return true;
	        } else {
	            em.getTransaction().rollback();
	            return false;
	        }

	    } catch (NoResultException e) {
	        System.out.println("Cart not found for user id: " + userId);
	        if (em.getTransaction().isActive()) em.getTransaction().rollback();
	        return false;
	    } catch (Exception e) {
	        e.printStackTrace();
	        if (em.getTransaction().isActive()) em.getTransaction().rollback();
	        return false;
	    } finally {
	        em.close();
	    }
	}
	public boolean deleteSelectedCourses(Cart cart, List<Integer> selectedCourseIds) {
	    EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();

	    try {
	        trans.begin();

	        // Lấy lại cart từ DB để đồng bộ context
	        Cart managedCart = em.find(Cart.class, cart.getId());

	        if (managedCart != null) {
	            // Lọc ra các course cần xóa
	            managedCart.getCourses().removeIf(course -> selectedCourseIds.contains(course.getId()));
	            trans.commit();
	            return true;  // Thành công
	        } else {
	            trans.rollback();
	            return false; // Cart không tồn tại
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        if (trans.isActive()) trans.rollback();
	        return false; // Lỗi
	    } finally {
	        em.close();
	    }
	}
	public List<Course> getRandomCoursesNotInCartByUserId(int userId, int limit) {
	    EntityManager em = JPAConfig.getEntityManager();
	    try {
	        // Sử dụng JOIN FETCH để tránh LazyInitializationException và lấy các cart cùng lúc
	        String jpql = "SELECT c FROM Course c " +
	                      "WHERE c.id NOT IN (" +
	                      "  SELECT co.id FROM Cart ca " +
	                      "  JOIN ca.courses co " + // Thay FETCH bằng JOIN
	                      "  WHERE ca.user.id = :userId" +
	                      ") " +
	                      "ORDER BY FUNCTION('RAND')";

	        TypedQuery<Course> query = em.createQuery(jpql, Course.class);
	        query.setParameter("userId", userId);
	        query.setMaxResults(limit); // Số lượng random muốn lấy

	        return query.getResultList(); // Trả về danh sách các course
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null; // Nếu có lỗi, trả về null
	    } finally {
	        em.close();
	    }
	}
	@Override
	public boolean addCourseToCart(int userId, int courseId) {
	    EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();

	    try {
	        trans.begin();

	        // Tìm cart theo userId hoặc tạo mới nếu chưa có
	        TypedQuery<Cart> cartQuery = em.createQuery(
	            "SELECT c FROM Cart c WHERE c.user.id = :userId", Cart.class);
	        cartQuery.setParameter("userId", userId);

	        Cart cart;
	        List<Cart> result = cartQuery.getResultList();
	        if (!result.isEmpty()) {
	            cart = result.get(0);
	        } else {
	            cart = new Cart();
	            User user = em.find(User.class, userId);
	            if (user == null) {
	                trans.rollback();
	                return false;
	            }
	            cart.setUser(user);
	            em.persist(cart);
	        }

	        // Tìm course theo courseId
	        Course course = em.find(Course.class, courseId);
	        if (course == null) {
	            trans.rollback();
	            return false;
	        }

	        // Check nếu course đã tồn tại trong cart
	        if (cart.getCourses().contains(course)) {
	            trans.rollback();
	            return false;  // đã có rồi, không thêm nữa
	        }

	        // Thêm course vào cart
	        cart.getCourses().add(course);

	        // merge lại cart
	        em.merge(cart);

	        trans.commit();
	        return true; // Thêm thành công

	    } catch (Exception e) {
	        e.printStackTrace();
	        if (trans.isActive()) trans.rollback();
	        return false;
	    } finally {
	        em.close();
	    }
	}



}
