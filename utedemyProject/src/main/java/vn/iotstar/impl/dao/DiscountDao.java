package vn.iotstar.impl.dao;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.IDiscountDao;
import vn.iotstar.entity.Discount;

public class DiscountDao implements IDiscountDao{

	@Override
	 public Discount findByDisCode(String disCode) {
	        EntityManager em = JPAConfig.getEntityManager();
	        try {
	            String jpql = "SELECT d FROM Discount d WHERE d.disCode = :disCode";
	            TypedQuery<Discount> query = em.createQuery(jpql, Discount.class);
	            query.setParameter("disCode", disCode);
	            return query.getSingleResult();
	        } catch (NoResultException e) {
	            return null;
	        } finally {
	            em.close();
	        }
	    }
	  // check còn lượt sử dụng
	@Override
    public boolean isCodeAvailable(String disCode) {
        try {
            Discount discount = findByDisCode(disCode);
            if (discount != null) {
                return Integer.parseInt(discount.getCodeAmount()) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
	 // check còn hạn sử dụng
	@Override
    public boolean isCodeValidTime(String disCode) {
        try {
            Discount discount = findByDisCode(disCode);
            if (discount != null) {
                java.sql.Date now = new java.sql.Date(System.currentTimeMillis());
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");

                java.util.Date startDate = sdf.parse(discount.getStartTime());
                java.util.Date endDate = sdf.parse(discount.getEndTime());

                return !now.before(startDate) && !now.after(endDate);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
	 @Override
	    public boolean addUserDiscount(int userId, int discountId) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction trans = em.getTransaction();

	        try {
	            trans.begin();

	            em.createNativeQuery("INSERT INTO user_discount (user_id, discount_id) VALUES (:userId, :discountId)")
	              .setParameter("userId", userId)
	              .setParameter("discountId", discountId)
	              .executeUpdate();

	            trans.commit();
	            return true;
	        } catch (Exception e) {
	            e.printStackTrace();
	            if (trans.isActive()) trans.rollback();
	            return false;
	        } finally {
	            em.close();
	        }
	    }

	    @Override
	    public boolean addDiscountCourse(int courseId, int discountId) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction trans = em.getTransaction();

	        try {
	            trans.begin();

	            em.createNativeQuery("INSERT INTO discount_course (course_id, discount_id) VALUES (:courseId, :discountId)")
	              .setParameter("courseId", courseId)
	              .setParameter("discountId", discountId)
	              .executeUpdate();

	            trans.commit();
	            return true;
	        } catch (Exception e) {
	            e.printStackTrace();
	            if (trans.isActive()) trans.rollback();
	            return false;
	        } finally {
	            em.close();
	        }
	    }
	    @Override
	    public boolean updateDiscountCourse(int courseId, int newDiscountId) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction trans = em.getTransaction();

	        try {
	            trans.begin();

	            // Kiểm tra discount_id hiện tại của course
	            String checkSql = "SELECT COUNT(*) FROM discount_course WHERE course_id = :courseId AND discount_id = :discountId";
	            Number count = (Number) em.createNativeQuery(checkSql)
	                .setParameter("courseId", courseId)
	                .setParameter("discountId", newDiscountId)
	                .getSingleResult();

	            // Nếu đã có discount_id giống rồi thì thôi
	            if (count.intValue() > 0) {
	                trans.commit();
	                return true;
	            }

	            // Nếu khác thì mới update
	            String sql = "UPDATE discount_course SET discount_id = :discountId WHERE course_id = :courseId";

	            int updatedRows = em.createNativeQuery(sql)
	                .setParameter("discountId", newDiscountId)
	                .setParameter("courseId", courseId)
	                .executeUpdate();

	            trans.commit();

	            return updatedRows > 0;
	        } catch (Exception e) {
	            e.printStackTrace();
	            if (trans.isActive()) trans.rollback();
	            return false;
	        } finally {
	            em.close();
	        }
	    }


	    @Override
	    public boolean updateUserDiscount(int userId, int discountId) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction trans = em.getTransaction();

	        try {
	            trans.begin();

	            // Kiểm tra xem bản ghi đã tồn tại và discount_id có giống chưa
	            String checkSql = "SELECT COUNT(*) FROM user_discount WHERE user_id = :userId AND discount_id = :discountId";
	            Number count = (Number) em.createNativeQuery(checkSql)
	                .setParameter("userId", userId)
	                .setParameter("discountId", discountId)
	                .getSingleResult();

	            // Nếu đã tồn tại bản ghi y hệt rồi thì không cần insert/update
	            if (count.intValue() > 0) {
	                trans.commit();
	                return true;
	            }

	            // Nếu chưa có hoặc khác discount_id thì insert/update
	            String insertSql = "INSERT INTO user_discount (user_id, discount_id) " +
	                               "VALUES (:userId, :discountId) " +
	                               "ON DUPLICATE KEY UPDATE discount_id = VALUES(discount_id)";

	            em.createNativeQuery(insertSql)
	                .setParameter("userId", userId)
	                .setParameter("discountId", discountId)
	                .executeUpdate();

	            trans.commit();
	            return true;
	        } catch (Exception e) {
	            e.printStackTrace();
	            if (trans.isActive()) trans.rollback();
	            return false;
	        } finally {
	            em.close();
	        }
	    }



	    @Override
	    public String getCodeAmountByDiscountId(String discountId) {
	        EntityManager em = JPAConfig.getEntityManager();

	        try {
	            String codeAmount = (String) em.createQuery(
	                    "SELECT d.codeAmount FROM Discount d WHERE d.id = :discountId"
	                )
	                .setParameter("discountId", discountId)
	                .getSingleResult();

	            return codeAmount;
	        } catch (Exception e) {
	            e.printStackTrace();
	            return null;
	        } finally {
	            em.close();
	        }
	    }

	    @Override
	    public String getCodeAmountByDisCode(String disCode) {
	        EntityManager em = JPAConfig.getEntityManager();

	        try {
	            String codeAmount = em.createQuery(
	                    "SELECT d.codeAmount FROM Discount d WHERE d.disCode = :disCode", String.class)
	                .setParameter("disCode", disCode)
	                .getSingleResult();

	            return codeAmount;
	        } catch (Exception e) {
	            e.printStackTrace();
	            return null;
	        } finally {
	            em.close();
	        }
	    }


	    @Override
	    public boolean updateCodeAmountByDiscountId(int discountId, String newCodeAmount) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction trans = em.getTransaction();

	        try {
	            trans.begin();

	            em.createQuery(
	                    "UPDATE Discount d SET d.codeAmount = :newCodeAmount WHERE d.id = :discountId"
	                )
	                .setParameter("newCodeAmount", newCodeAmount)
	                .setParameter("discountId", discountId)
	                .executeUpdate();

	            trans.commit();
	            return true;
	        } catch (Exception e) {
	            e.printStackTrace();
	            if (trans.isActive()) trans.rollback();
	            return false;
	        } finally {
	            em.close();
	        }
	    }

	    @Override
	    public int countUsersByDiscountId(int discountId) {
	        EntityManager em = JPAConfig.getEntityManager();
	        try {
	            String jpql = "SELECT COUNT(u.id) FROM Discount d JOIN d.usedByUsers u WHERE d.id = :discountId";
	            Long count = em.createQuery(jpql, Long.class)
	                           .setParameter("discountId", discountId)
	                           .getSingleResult();
	            return count.intValue();  // Ép Long về int
	        } catch (Exception e) {
	            e.printStackTrace();
	            return 0;
	        } finally {
	            em.close();
	        }
	    }
	    @Override
	    public boolean deleteUserDiscount(int userId, int discountId) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction trans = em.getTransaction();
	        try {
	            trans.begin();
	            String sql = "DELETE FROM user_discount WHERE user_id = :userId AND discount_id = :discountId";
	            em.createNativeQuery(sql)
	              .setParameter("userId", userId)
	              .setParameter("discountId", discountId)
	              .executeUpdate();
	            trans.commit();
	            return true;
	        } catch (Exception e) {
	            e.printStackTrace();
	            if (trans.isActive()) trans.rollback();
	            return false;
	        } finally {
	            em.close();
	        }
	    }
	    @Override
		public List<Discount> findByIdUser(int id) {
			EntityManager enma = JPAConfig.getEntityManager();
		    try {
		        String jpql = "SELECT DISTINCT d FROM Discount d JOIN FETCH d.appliedCourses c WHERE c.teacher.id = :teacherId";
		        TypedQuery<Discount> query = enma.createQuery(jpql, Discount.class);
		        query.setParameter("teacherId", id);
		        return query.getResultList();
		    } finally {
		        enma.close();
		    }
		}
	    @Override
		public boolean insert(Discount discount) {
			EntityManager em = JPAConfig.getEntityManager();
		    EntityTransaction trans = em.getTransaction();

		    try {
		        trans.begin();
		        em.merge(discount);
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
	    @Override
		public Discount findById(int id) {
			EntityManager em = JPAConfig.getEntityManager();
		    EntityTransaction trans = em.getTransaction();
		    try {
		        trans.begin();
		        Discount discount = em.find(Discount.class, id);
		        trans.commit();
		        return discount;
		    } catch (Exception e) {
		        if (trans.isActive()) {
		            trans.rollback();
		        }
		        e.printStackTrace();
		        return null;
		    } finally {
		        em.close();
		    }
		}
	    @Override
		public boolean update(Discount discount) {
			EntityManager em = JPAConfig.getEntityManager();
		    EntityTransaction transaction = em.getTransaction();

		    try {
		        transaction.begin();
		        em.merge(discount);
		        transaction.commit();
		        return true;
		    } catch (Exception e) {
		        if (transaction.isActive()) {
		            transaction.rollback();
		        }
		        e.printStackTrace();
				return false;
		    } finally {
		        em.close();
		    }
		}
	    @Override
	    public boolean isDiscountApplicableForCourse(int courseId, int discountId) {
	        EntityManager em = JPAConfig.getEntityManager();
	        try {
	            String sql = "SELECT COUNT(*) FROM discount_course WHERE course_id = :courseId AND discount_id = :discountId";
	            Number count = (Number) em.createNativeQuery(sql)
	                    .setParameter("courseId", courseId)
	                    .setParameter("discountId", discountId)
	                    .getSingleResult();
	            return count.intValue() > 0;
	        } catch (Exception e) {
	            e.printStackTrace();
	            return false;
	        } finally {
	            em.close();
	        }
	    }


}
