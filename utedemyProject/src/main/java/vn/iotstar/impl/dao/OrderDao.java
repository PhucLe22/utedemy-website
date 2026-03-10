package vn.iotstar.impl.dao;


import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.IOrderDao;
import vn.iotstar.entity.Discount;
import vn.iotstar.entity.OrderItem;
import jakarta.persistence.TypedQuery;
import vn.iotstar.entity.Orders;
import vn.iotstar.entity.*;
import java.util.ArrayList;

public class OrderDao implements IOrderDao{
	  @Override
	   public boolean insertOrder(Orders order) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction trans = em.getTransaction();

	        try {
	            trans.begin();

	            em.persist(order); // Lưu order và cascade lưu luôn orderItems

	            trans.commit();
	            return true; // Thành công
	        } catch (Exception e) {
	            e.printStackTrace();
	            if (trans.isActive()) trans.rollback();
	            return false; // Lỗi
	        } finally {
	            em.close();
	        }
	    }
	  @Override
	    public Orders findProcessingOrderByUserId(int userId) {
	        EntityManager em = JPAConfig.getEntityManager();
	        try {
	            return em.createQuery("SELECT o FROM Orders o WHERE o.user.id = :userId AND o.orderStatus = 'PROCESSING'", Orders.class)
	                     .setParameter("userId", userId)
	                     .getResultStream()
	                     .findFirst()
	                     .orElse(null);
	        } catch (Exception e) {
	            e.printStackTrace();
	            return null;
	        } finally {
	            em.close();
	        }
	    }
	  @Override
	    public boolean insertOrUpdateOrder(Orders order) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction trans = em.getTransaction();

	        try {
	            trans.begin();

	            if (order.getId() == 0) {
	                em.persist(order); // mới
	            } else {
	                em.merge(order); // đã có
	            }

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
	    public boolean updateFinishedFee(int orderItemId, double finishedFee) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction trans = em.getTransaction();

	        try {
	            trans.begin();

	            // Tìm orderItem theo id
	            OrderItem orderItem = em.find(OrderItem.class, orderItemId);
	            if (orderItem != null) {
	                orderItem.setFinishedFee(finishedFee);  // Set fee mới
	                em.merge(orderItem); // Merge lại vào DB
	            }

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
	  public boolean updateOrderStatus(int orderId, String newStatus) {
	      EntityManager em = JPAConfig.getEntityManager();
	      EntityTransaction trans = em.getTransaction();

	      try {
	          trans.begin();

	          // Tìm order theo id
	          Orders order = em.find(Orders.class, orderId);
	          if (order != null) {
	              order.setOrderStatus(newStatus);  // Cập nhật status mới
	              em.merge(order);  // Merge lại
	          }

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
	  public boolean updateDiscountAndFinishedFee(int orderItemId, int discountId, double finishedFee) {
	      EntityManager em = JPAConfig.getEntityManager();
	      EntityTransaction trans = em.getTransaction();

	      try {
	          trans.begin();

	          // Tìm orderItem theo id
	          OrderItem orderItem = em.find(OrderItem.class, orderItemId);
	          if (orderItem != null) {
	              // Tìm discount theo id
	              Discount discount = em.find(Discount.class, discountId);
	              if (discount != null) {
	                  orderItem.setDiscount(discount);          // Cập nhật discount
	                  orderItem.setFinishedFee(finishedFee);    // Cập nhật finished fee
	                  em.merge(orderItem);                      // Merge lại vào DB
	              } else {
	                  System.out.println("Discount ID không tồn tại.");
	                  trans.rollback();
	                  return false;
	              }
	          } else {
	              System.out.println("OrderItem ID không tồn tại.");
	              trans.rollback();
	              return false;
	          }

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
	  public boolean removeDiscountFromOrderItem(int orderItemId) {
	      EntityManager em = JPAConfig.getEntityManager();
	      EntityTransaction trans = em.getTransaction();

	      try {
	          trans.begin();

	          // Tìm orderItem theo id
	          OrderItem orderItem = em.find(OrderItem.class, orderItemId);
	          if (orderItem != null) {
	              orderItem.setDiscount(null);  // Set discount về null
	              em.merge(orderItem);          // Cập nhật lại DB
	          } else {
	              System.out.println("OrderItem ID không tồn tại.");
	              trans.rollback();
	              return false;
	          }

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
	    public List<Orders> getOrdersByUserId(int userId) {
	        EntityManager em = JPAConfig.getEntityManager();
	        try {
	            TypedQuery<Orders> query = em.createQuery("SELECT o FROM Orders o WHERE o.user.id = :userId", Orders.class);
	            query.setParameter("userId", userId);
	            return query.getResultList();
	        } catch (Exception e) {
	            e.printStackTrace();
	            return null;
	        } finally {
	            em.close();
	        }
	    }
	  @Override
		public List<OrderItem> getAllOrderItems() {
			EntityManager em = JPAConfig.getEntityManager();
			List<OrderItem> orderItems = new ArrayList<>();
			try {
				String sql = "SELECT o FROM OrderItem o";
				orderItems = em.createQuery(sql, OrderItem.class).getResultList();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (em != null && em.isOpen()) {
					em.close(); // Ensuring session is closed after use
				}
			}
			return orderItems;
		}




}
