package vn.iotstar.impl.dao;


import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.ICourseDao;
import vn.iotstar.entity.Course;
import vn.iotstar.entity.CourseDetail;
import vn.iotstar.entity.CourseType;
import vn.iotstar.entity.Lesson;
import vn.iotstar.entity.OrderItem;
import vn.iotstar.entity.Question;
import vn.iotstar.entity.Quiz;
import vn.iotstar.entity.Review;
import vn.iotstar.entity.Section;
import vn.iotstar.entity.Answer;
import vn.iotstar.entity.User;
import java.util.Map;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.NoResultException;
import vn.iotstar.entity.Discussion;
import vn.iotstar.entity.CourseProgress;
import vn.iotstar.entity.LessonProgress;
import vn.iotstar.entity.Review;

public class CourseDao implements ICourseDao {

	private EntityManager entityManager;

	public List<Object[]> findBestSellingCourseDetails(int limit) {
	    EntityManager em = JPAConfig.getEntityManager();
	    try {
	    	String jpql = "SELECT c.courseName, t.fullname, AVG(CAST(r.rate AS double)), c.coursePrice, cd.courseImage, c.id\r\n"
	    			+ "FROM OrderItem o\r\n"
	    			+ "JOIN o.course c\r\n"
	    			+ "JOIN c.teacher t\r\n"
	    			+ "LEFT JOIN c.review r\r\n"
	    			+ "JOIN c.courseDetail cd\r\n"
	    			+ "GROUP BY c.id, c.courseName, t.fullname, c.coursePrice, cd.courseImage\r\n"
	    			+ "ORDER BY COUNT(o.id) DESC";

	        TypedQuery<Object[]> query = em.createQuery(jpql, Object[].class);
	        query.setMaxResults(limit);
	        return query.getResultList();
	    } finally {
	        em.close();
	    }
	}



	@Override
	public List<Object[]> findLatestCourseDetails(int limit) {
	    EntityManager em = JPAConfig.getEntityManager();
	    try {
	        String jpql = "SELECT c.courseName, t.fullname, AVG(CAST(r.rate AS double)), c.coursePrice, cd.courseImage, c.id "
	                + "FROM Course c "
	                + "JOIN c.teacher t "
	                + "LEFT JOIN c.review r "
	                + "JOIN c.courseDetail cd "
	                + "GROUP BY c.id, c.courseName, t.fullname, c.coursePrice, cd.courseImage "
	                + "ORDER BY c.id DESC";
	        TypedQuery<Object[]> query = em.createQuery(jpql, Object[].class);
	        query.setMaxResults(limit);
	        return query.getResultList();
	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ArrayList<>();
	    } finally {
	        em.close();
	    }
	}

	@Override
	public List<Object[]> findLatestCourseDetailsWithDiscount(int limit) {
	    EntityManager em = JPAConfig.getEntityManager();
	    try {
	        // Trả về 7 cột giống format todaySaleCourses: name, teacher, rating, price, image, percentage(0), id
	        String jpql = "SELECT c.courseName, t.fullname, AVG(CAST(r.rate AS double)), c.coursePrice, cd.courseImage, 0, c.id "
	                + "FROM Course c "
	                + "JOIN c.teacher t "
	                + "LEFT JOIN c.review r "
	                + "JOIN c.courseDetail cd "
	                + "GROUP BY c.id, c.courseName, t.fullname, c.coursePrice, cd.courseImage "
	                + "ORDER BY c.id DESC";
	        TypedQuery<Object[]> query = em.createQuery(jpql, Object[].class);
	        query.setMaxResults(limit);
	        return query.getResultList();
	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ArrayList<>();
	    } finally {
	        em.close();
	    }
	}

	@Override
	public List<CourseType> listCourseType() {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    
	    try {
	        trans.begin();
	        String jpql = "SELECT c FROM CourseType c";
	        List<CourseType> courseTypes = em.createQuery(jpql, CourseType.class).getResultList();
	        trans.commit();
	        return courseTypes;
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
	public List<Object[]> findTodaySaleCourses(int limit) {
	    EntityManager em = JPAConfig.getEntityManager();
	    try {
	    	String jpql = "SELECT c.courseName, t.fullname, AVG(CAST(r.rate AS double)), c.coursePrice, cd.courseImage, v.percentage, c.id " +
	    			"FROM Course c " +
	    			"JOIN c.teacher t " +
	    			"LEFT JOIN c.review r " +
	    			"JOIN c.courseDetail cd " +
	    			"JOIN c.vouchers v " +
	    			"WHERE CURRENT_DATE BETWEEN v.dateSet AND v.dateEnd " +
	    			"GROUP BY c.id, c.courseName, t.fullname, c.coursePrice, cd.courseImage, v.percentage " +
	    			"ORDER BY v.percentage DESC";

	        TypedQuery<Object[]> query = em.createQuery(jpql, Object[].class);
	        query.setMaxResults(limit);
	        return query.getResultList();
	    } finally {
	        em.close();
	    }
	}

    @Override
	public boolean saveCoure(Course course) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    
	    try {
	        trans.begin();
	        em.merge(course);
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
	public CourseType findByIDCourseType(int id) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    try {
	        trans.begin();
	        CourseType courseType = em.find(CourseType.class, id);
	        trans.commit();
	        return courseType;
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

	/*@Override
	public Course findByIdCourse(int id) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    try {
	        trans.begin();
	        Course course = em.find(Course.class, id);
	        trans.commit();
	        return course;
	    } catch (Exception e) {
	        if (trans.isActive()) {
	            trans.rollback();
	        }
	        e.printStackTrace();
	        return null;
	    } finally {
	       // em.close();
	    }
	}*/
	@Override
	public Course findByIdCourse(int id) {
	    System.out.println("Get EntityManager");
	    EntityManager em = JPAConfig.getEntityManager();
	    System.out.println("Got EntityManager");
	    try {
	        System.out.println("Before find");
	        Course course = em.find(Course.class, id);
	        System.out.println("After find");
	        return course;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null;
	    } finally {
	        em.close();
	    }
	}



	@Override
	public int maxCourseId() {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    try {
	        trans.begin();
	        String jpql = "SELECT MAX(c.id) FROM Course c";
	        Query query = em.createQuery(jpql);
	        Integer maxId = (Integer) query.getSingleResult();
	        trans.commit();
	        return maxId != null ? maxId : 0;
	    } catch (Exception e) {
	        if (trans.isActive()) {
	            trans.rollback();
	        }
	        e.printStackTrace();
	        return 0;
	    } finally {
	        em.close();
	    }
	}

	@Override
	public boolean saveCourseDetail(CourseDetail courseDetail) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    
	    try {
	        trans.begin();
	        em.merge(courseDetail);
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
	public boolean updateCourse(Course course) {
		EntityManager enma = JPAConfig.getEntityManager();
	    EntityTransaction trans = enma.getTransaction();
	    try {
	        trans.begin();
	        
	        // Lấy các collection hiện tại để tránh xung đột
	        Course existingCourse = enma.find(Course.class, course.getId());
	        if (existingCourse != null) {
	            // Giữ nguyên các collection để tránh sửa đổi đồng thời
	            course.setSections(existingCourse.getSections());
	            course.setReview(existingCourse.getReview());
	            course.setFavoriteCourse(existingCourse.getFavoriteCourse());
	            course.setCart(existingCourse.getCart());
	            course.setVouchers(existingCourse.getVouchers());
	            course.setDiscounts(existingCourse.getDiscounts());
	        }
	        
	        // Sau đó merge
	        enma.merge(course);
	        trans.commit();
	        return true;
	    } catch (Exception e) {
	        if (trans.isActive()) {
	            trans.rollback();
	        }
	        e.printStackTrace();
	        return false;
	    } finally {
	        enma.close();
	    }
	}

	@Override
	public int maxCourseDetailId() {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    try {
	        trans.begin();
	        String jpql = "SELECT MAX(c.id) FROM CourseDetail c";
	        Query query = em.createQuery(jpql);
	        Integer maxId = (Integer) query.getSingleResult();
	        trans.commit();
	        return maxId != null ? maxId : 0;
	    } catch (Exception e) {
	        if (trans.isActive()) {
	            trans.rollback();
	        }
	        e.printStackTrace();
	        return 0;
	    } finally {
	        em.close();
	    }
	}

	@Override
	public CourseDetail findByIdCourseDetail(int id) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    try {
	        trans.begin();
	        CourseDetail courseDetail = em.find(CourseDetail.class, id);
	        trans.commit();
	        return courseDetail;
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
	public boolean updateCourseDetail(CourseDetail courseDetail) {
		EntityManager enma = JPAConfig.getEntityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			// gọi phuong thức để insert, update, delete
			enma.merge(courseDetail);
			trans.commit();
			return true;
		} catch (Exception e) {
			if (trans.isActive()) {
	            trans.rollback();
	        }
	        e.printStackTrace();
			return false;
		} finally {
			enma.close();
		}
	}
	@Override
	public boolean saveLesson(Lesson lesson) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    
	    try {
	        trans.begin();
	        em.persist(lesson);
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
	public Section findByIdSection(int id) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    try {
	        trans.begin();
	        Section section = em.find(Section.class, id);
	        trans.commit();
	        return section;
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
	public boolean saveQuiz(Quiz quiz) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    
	    try {
	        trans.begin();
	        em.persist(quiz);
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
	public int maxQuizId() {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    try {
	        trans.begin();
	        String jpql = "SELECT MAX(q.id) FROM Quiz q";
	        Query query = em.createQuery(jpql);
	        Integer maxId = (Integer) query.getSingleResult();
	        trans.commit();
	        return maxId != null ? maxId : 0;
	    } catch (Exception e) {
	        if (trans.isActive()) {
	            trans.rollback();
	        }
	        e.printStackTrace();
	        return 0;
	    } finally {
	        em.close();
	    }
	}
	
	@Override
	public Quiz findByIdQuiz(int id) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    try {
	        trans.begin();
	        Quiz quiz = em.find(Quiz.class, id);
	        trans.commit();
	        return quiz;
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
	public boolean saveQuestion(Question question) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();

	    try {
	        trans.begin();
	        em.persist(question);
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
	public int maxQuestionId() {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    try {
	        trans.begin();
	        String jpql = "SELECT MAX(q.id) FROM Question q";
	        Query query = em.createQuery(jpql);
	        Integer maxId = (Integer) query.getSingleResult();
	        trans.commit();
	        return maxId != null ? maxId : 0;
	    } catch (Exception e) {
	        if (trans.isActive()) {
	            trans.rollback();
	        }
	        e.printStackTrace();
	        return 0;
	    } finally {
	        em.close();
	    }
	}
	
	@Override
	public Question findByIdQuestion(int id) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    try {
	        trans.begin();
	        Question question = em.find(Question.class, id);
	        trans.commit();
	        return question;
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
	public boolean saveAnswer(Answer answer) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    
	    try {
	        trans.begin();
	        em.persist(answer);
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
	public boolean updateSection(Section section) {
		EntityManager enma = JPAConfig.getEntityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			// gọi phuong thức để insert, update, delete
			enma.merge(section);
			trans.commit();
			return true;
		} catch (Exception e) {
			if (trans.isActive()) {
	            trans.rollback();
	        }
	        e.printStackTrace();
			return false;
		} finally {
			enma.close();
		}
	}
	
	@Override
	public Lesson findByIdLesson(int id) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    try {
	        trans.begin();
	        Lesson lesson = em.find(Lesson.class, id);
	        trans.commit();
	        return lesson;
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
	public boolean updateLesson(Lesson lesson) {
		EntityManager enma = JPAConfig.getEntityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			// gọi phuong thức để insert, update, delete
			enma.merge(lesson);
			trans.commit();
			return true;
		} catch (Exception e) {
			if (trans.isActive()) {
	            trans.rollback();
	        }
	        e.printStackTrace();
			return false;
		} finally {
			enma.close();
		}
	}
	
	@Override
	public boolean updateQuiz(Quiz quiz) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction tx = em.getTransaction();
	    try {
	        tx.begin();

	        Quiz existing = em.find(Quiz.class, quiz.getId());
	        if (existing != null) {
	            existing.setTitle(quiz.getTitle());
	            existing.setDescription(quiz.getDescription());
	            existing.setDuration(quiz.getDuration());
	            existing.getQuestions().clear();
	            for (Question q : quiz.getQuestions()) {
	                q.setQuiz(existing);
	                
	                for (Answer a : q.getAnswers()) {
	                    a.setQuestion(q);
	                }
	                
	                existing.getQuestions().add(q);
	            }

	            em.merge(existing);
	        }
	        
	        tx.commit();
	        return true;
	    } catch (Exception e) {
	        tx.rollback();
	        throw new RuntimeException(e);
	        
	    } finally {
	        em.close();
	    }
	}
	
	@Override
	public boolean deleteSection(int id) throws Exception {
		EntityManager enma = JPAConfig.getEntityManager();
	    EntityTransaction trans = enma.getTransaction();
	    try {
	        trans.begin();
	        Section section = enma.find(Section.class, id);
	        if (section != null) {
	            enma.remove(section);
	            trans.commit();
	            return true;
	        } else {
	            trans.rollback();
	            return false;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        if (trans.isActive()) {
	            trans.rollback();
	        }
	        throw e; // hoặc return false;
	    } finally {
	        enma.close();
	    }
	}
	
	@Override
	public boolean deleteLesson(int id) throws Exception {
		EntityManager enma = JPAConfig.getEntityManager();
	    EntityTransaction trans = enma.getTransaction();
	    try {
	        trans.begin();
	        Lesson lesson = enma.find(Lesson.class, id);
	        if (lesson != null) {
	            enma.remove(lesson);
	            trans.commit();
	            return true;
	        } else {
	            trans.rollback();
	            return false;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        if (trans.isActive()) {
	            trans.rollback();
	        }
	        throw e;
	    } finally {
	        enma.close();
	    }
	}
	
	@Override
	public boolean deleteQuiz(int id) throws Exception {
		EntityManager enma = JPAConfig.getEntityManager();
	    EntityTransaction trans = enma.getTransaction();
	    try {
	        trans.begin();
	        Quiz quiz = enma.find(Quiz.class, id);
	        if (quiz != null) {
	            enma.remove(quiz);
	            trans.commit();
	            return true;
	        } else {
	            trans.rollback();
	            return false;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        if (trans.isActive()) {
	            trans.rollback();
	        }
	        throw e;
	    } finally {
	        enma.close();
	    }
	}
	
	@Override
	public int maxSectionId() {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    try {
	        trans.begin();
	        String jpql = "SELECT MAX(s.id) FROM Section s";
	        Query query = em.createQuery(jpql);
	        Integer maxId = (Integer) query.getSingleResult();
	        trans.commit();
	        return maxId != null ? maxId : 0;
	    } catch (Exception e) {
	        if (trans.isActive()) {
	            trans.rollback();
	        }
	        e.printStackTrace();
	        return 0;
	    } finally {
	        em.close();
	    }
	}
	
	@Override
	public boolean saveSection(Section section) {
		EntityManager em = JPAConfig.getEntityManager();
	    EntityTransaction trans = em.getTransaction();
	    
	    try {
	        trans.begin();
	        em.persist(section);
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
	public List<Course> findByIdTeacher(User user) {
		if (user == null) {
	        return Collections.emptyList();
	    }

	    EntityManager enma = JPAConfig.getEntityManager();
	    String jpql = "SELECT c FROM Course c WHERE c.teacher.id = :teacherId";
	    TypedQuery<Course> query = enma.createQuery(jpql, Course.class);
	    query.setParameter("teacherId", user.getId());
	    return query.getResultList();
	}
	@Override
	public List<Course> findAllCourse() {
		EntityManager enma = JPAConfig.getEntityManager();
		TypedQuery<Course> query = enma.createNamedQuery("Course.findAll", Course.class);
		return query.getResultList();
	}
	
	@Override
	public List<Course> getAllCourses() {
		EntityManager em = JPAConfig.getEntityManager();
		List<Course> Courses = new ArrayList<>();
		try {
			String sql = "SELECT c FROM Course c";
			Courses = em.createQuery(sql, Course.class).getResultList();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (em != null && em.isOpen()) {
				em.close(); // Ensuring session is closed after use
			}
		}
		return Courses;
	}
	
	@Override
	public List<Lesson> getAllLessons() {
		EntityManager em = JPAConfig.getEntityManager();
		List<Lesson> lessons = new ArrayList<>();
		try {
			// JPQL query to fetch all lessons
			String sql = "SELECT l FROM Lesson l";
			lessons = em.createQuery(sql, Lesson.class).getResultList();
		} catch (Exception e) {
			// Handle exceptions (consider logging instead of printing stack trace in
			// production)
			e.printStackTrace();
		} finally {
			// Ensure the EntityManager is closed after use
			if (em != null && em.isOpen()) {
				em.close();
			}
		}
		return lessons;
	}
	public List<Course> filterCoursesByRatingAndCourse(List<OrderItem> orderItems, double ratingThreshold) {
		EntityManager em = JPAConfig.getEntityManager();
		// Tạo truy vấn JPQL để lấy khóa học với rating >= ratingThreshold
		String query = "SELECT c FROM Course c " + "JOIN c.reviews r " + // JOIN với bảng Review để truy xuất điểm đánh
																			// giá
				"JOIN c.orderItems oi " + // JOIN với bảng OrderItem để kiểm tra khóa học có trong order
				"WHERE r.rating >= :ratingThreshold " + // Điều kiện lọc theo rating
				"AND oi.course.id = c.id"; // Điều kiện kiểm tra khóa học trong OrderItem

		TypedQuery<Course> typedQuery = em.createQuery(query, Course.class);
		typedQuery.setParameter("ratingThreshold", ratingThreshold);

		// Trả về danh sách các khóa học thỏa mãn điều kiện
		return typedQuery.getResultList();
	}

	// Phương thức tính rating trung bình của khóa học
	public double calculateAverageRating(Course course) {
		// Truyền vào course để lấy danh sách review
		Set<Review> reviews = course.getReview(); // Sử dụng getter của Review từ lớp Course
		if (reviews.isEmpty()) {
			return 0;
		}
		double totalRating = 0;
		for (Review review : reviews) {
			totalRating += review.getRate();
		}
		return totalRating / reviews.size();
	}
	// Phương thức lọc các khóa học theo rating
		public List<Course> filterCoursesByRating(double ratingThreshold) {
			EntityManager em = JPAConfig.getEntityManager();
			String query = "SELECT c FROM Course c JOIN c.review r WHERE r.rating >= :ratingThreshold";
			TypedQuery<Course> typedQuery = em.createQuery(query, Course.class);
			typedQuery.setParameter("ratingThreshold", ratingThreshold);

			return typedQuery.getResultList();
		}
		public List<Course> getCoursesByUserId(int userId) {
			EntityManager em =JPAConfig.getEntityManager();
			List<Course> courseResults = new ArrayList<>();
			try {
				String queryStr = "SELECT oi.course FROM OrderItem oi WHERE oi.order.user.id = :userId";
				TypedQuery<Course> query = em.createQuery(queryStr, Course.class);
				query.setParameter("userId", userId);
				courseResults = query.getResultList();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (em != null && em.isOpen())
					em.close();
			}
			return courseResults;
		}
		@Override
		public Course getCourseById(int Id) {
			EntityManager em = JPAConfig.getEntityManager();
			Course course = null;
			try {
				course = em.find(Course.class, Id); // Lấy 1 đối tượng theo khóa chính
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (em != null && em.isOpen()) {
					em.close();
				}
			}
			return course;
		}
		@Override
		public int getMaxCourseId() {
			EntityManager em = JPAConfig.getEntityManager();
			try {
				// Truy vấn lấy ID lớn nhất từ bảng Course
				String jpql = "SELECT MAX(c.id) FROM Course c";
				Integer maxId = (Integer) em.createQuery(jpql).getSingleResult();

				// Trả về maxId nếu có, nếu không trả về 0 (hoặc giá trị mặc định khác)
				return maxId != null ? maxId : 0;
			} catch (Exception e) {
				e.printStackTrace();
				return 0; // Trả về 0 nếu có lỗi xảy ra
			} finally {
				// Đảm bảo EntityManager được đóng
				if (em != null && em.isOpen()) {
					em.close();
				}
			}
		}
		@Override
		public void addCourse(Course course) {
			EntityManager em = JPAConfig.getEntityManager();
			EntityTransaction trans = em.getTransaction();

			try {
				if (course == null) {
					throw new IllegalArgumentException("Course cannot be null");
				}

				trans.begin();

				// Lấy CourseType từ DB thay vì chỉ set ID
				int courseTypeId = course.getCourseType().getId();
				CourseType courseType = em.find(CourseType.class, courseTypeId);
				if (courseType == null) {
					throw new IllegalArgumentException("CourseType not found with id: " + courseTypeId);
				}

				// Gắn courseType đã lấy vào course
				course.setCourseType(courseType);

				// Lưu course vào DB
				em.persist(course);

				// Commit transaction
				trans.commit();
			} catch (Exception e) {
				// Nếu transaction vẫn còn active, rollback
				if (trans.isActive()) {
					trans.rollback();
				}
				e.printStackTrace();
			} finally {
				if (em != null && em.isOpen()) {
					em.close(); // Đảm bảo đóng EntityManager
				}
			}
		}

		@Override
		public List<Object[]> findSectionLessonCourse(int courseId) {
		    EntityManager em = JPAConfig.getEntityManager();
		    try {
		    	String jpql = "SELECT s.title, l.title, l.videoUrl, l.description, l.numberItem, l.isFreeLesson "
		                + "FROM Lesson l "
		                + "JOIN l.section s "
		                + "JOIN s.course c "
		                + "WHERE c.id = :courseId";

		        TypedQuery<Object[]> query = em.createQuery(jpql, Object[].class);
		        query.setParameter("courseId", courseId);

		        return query.getResultList();
		    } finally {
		        em.close();
		    }
		}
		@Override
		public List<Map> findCommentsAndReplys(int courseID) {
		    EntityManager em = JPAConfig.getEntityManager();
		    try {
		        String jpql = "SELECT new map(" +
		                "d.id as id, " +
		                "d.askedBy.fullname as fullname, " +
		                "d.askedBy.avatarUrl as avatarUrl, " +
		                "d.content as content, " +
		                "d.askedAt as askedAt, " +
		                "d.parent.id as parentId, " + // ← sửa lại ở đây
		                "(SELECT COUNT(r) FROM Discussion r WHERE r.parent.id = d.id) as repliesCount" +
		            ") " +
		            "FROM Discussion d " +
		            "WHERE d.course.id = :courseId";

		        TypedQuery<Map> query = em.createQuery(jpql, Map.class);
		        query.setParameter("courseId", courseID);
		        return query.getResultList();
		    } finally {
		        em.close();
		    }
		}


		@Override
		public List<Map> findReviews(int courseID) {
		    EntityManager em = JPAConfig.getEntityManager();
		    try {
		        String jpql = "SELECT new map(\r\n"
		        		+ "    u.fullname as author,\r\n"
		        		+ "    u.avatarUrl as avatar,\r\n"
		        		+ "    r.rate as rating,\r\n"
		        		+ "    r.content as content\r\n"
		        		+ ")\r\n"
		        		+ "FROM Review r\r\n"
		        		+ "JOIN r.createdBy u\r\n"
		        		+ "WHERE r.course.id = :courseId\r\n"
		        		+ "ORDER BY r.createdAt DESC";

		        TypedQuery<Map> query = em.createQuery(jpql, Map.class);
		        query.setParameter("courseId", courseID);
		        return query.getResultList();
		    } finally {
		        em.close();
		    }
		}

		@Override
		public double findAverageRating(int courseID) {
		    EntityManager em = JPAConfig.getEntityManager();
		    try {
		        String jpql = "SELECT AVG(r.rate) FROM Review r WHERE r.course.id = :courseId";
		        TypedQuery<Double> query = em.createQuery(jpql, Double.class);
		        query.setParameter("courseId", courseID);
		        Double avg = query.getSingleResult();
		        return avg != null ? avg : 0.0;
		    } finally {
		        em.close();
		    }
		}

		@Override
		public List<Object[]> findRatingDestribution(int courseId) {
		    EntityManager em = JPAConfig.getEntityManager();
		    try {
		        String jpql = "SELECT r.rate, COUNT(r) FROM Review r WHERE r.course.id = :courseId GROUP BY r.rate";
		        TypedQuery<Object[]> query = em.createQuery(jpql, Object[].class);
		        query.setParameter("courseId", courseId);
		        return query.getResultList();
		    } finally {
		        em.close();
		    }
		}


		@Override
		public List<Map> findInfoTeacher(int courseId) {
		    EntityManager em = JPAConfig.getEntityManager();
		    try {
		        String jpql = "SELECT new map(" +
		                "    t.fullname as name, " +
		                "    t.socialUrl as url, " +
		                "    t.avatarUrl as avatar, " +
		                "    t.description as bio, " +
		                "    (SELECT AVG(r.rate) FROM Review r WHERE r.course.teacher.id = t.id) as rating, " +
		                "    (SELECT COUNT(r.id) FROM Review r WHERE r.course.teacher.id = t.id) as reviews, " +
		                "    (SELECT COUNT(oi.id) FROM OrderItem oi WHERE oi.course.teacher.id = t.id) as students, " +
		                "    (SELECT COUNT(c2.id) FROM Course c2 WHERE c2.teacher.id = t.id) as courses " +
		                ") " +
		                "FROM Course c " +
		                "JOIN c.teacher t " +
		                "WHERE c.id = :courseId";

		        TypedQuery<Map> query = em.createQuery(jpql, Map.class);
		        query.setParameter("courseId", courseId);
		        return query.getResultList();
		    } finally {
		        em.close();
		    }
		}

		@Override
	    public void insertDiscussion(Discussion discussion) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction tx = em.getTransaction();

	        try {
	            tx.begin();
	            em.persist(discussion);
	            tx.commit();
	        } catch (Exception e) {
	            if (tx.isActive()) tx.rollback();
	            e.printStackTrace();
	        } finally {
	            em.close();
	        }
	    }

		@Override
	    public void insertReview(Review review) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction tx = em.getTransaction();

	        try {
	            tx.begin();
	            em.persist(review);
	            tx.commit();
	        } catch (Exception e) {
	            if (tx.isActive()) tx.rollback();
	            e.printStackTrace();
	        } finally {
	            em.close();
	        }
	    }

		@Override
	    public void markLessonAsCompleted(LessonProgress lessonProgress) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction tx = em.getTransaction();

	        try {
	            tx.begin();
	            em.persist(lessonProgress);
	            tx.commit();
	        } catch (Exception e) {
	            if (tx.isActive()) tx.rollback();
	            e.printStackTrace();
	        } finally {
	            em.close();
	        }
	    }

		@Override
	    public void insertReplyDiscussion(Discussion discussion) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction tx = em.getTransaction();

	        try {
	            tx.begin();
	            em.persist(discussion);
	            tx.commit();
	        } catch (Exception e) {
	            if (tx.isActive()) tx.rollback();
	            e.printStackTrace();
	        } finally {
	            em.close();
	        }
	    }

		@Override
		public String findOverviewSection(int courseId) {
		    EntityManager em = JPAConfig.getEntityManager();
		    try {
		        String jpql = "SELECT c.courseDetail.description FROM Course c WHERE c.id = :courseId";
		        return em.createQuery(jpql, String.class)
		                 .setParameter("courseId", courseId)
		                 .getSingleResult();
		    } catch (NoResultException e) {
		        return null;
		    } catch (Exception e) {
		        e.printStackTrace();
		        return null;
		    } finally {
		        em.close();
		    }
		}

		@Override
		public String findAvatarURL(int userId) {
		    EntityManager em = JPAConfig.getEntityManager();
		    try {
		        String jpql = "SELECT u.avatarUrl FROM User u WHERE u.id = :userId";
		        return em.createQuery(jpql, String.class)
		                 .setParameter("userId", userId)
		                 .getSingleResult();
		    } catch (NoResultException e) {
		        return null;
		    } catch (Exception e) {
		        e.printStackTrace();
		        return null;
		    } finally {
		        em.close();
		    }
		}

		@Override
		public Integer findCourseProgressId(int courseId, int userId) {
		    EntityManager em = JPAConfig.getEntityManager();
		    try {
		        String jpql = "SELECT cp.id FROM CourseProgress cp " +
		                      "WHERE cp.course.id = :courseId AND cp.user.id = :userId";
		        return em.createQuery(jpql, Integer.class)
		                 .setParameter("courseId", courseId)
		                 .setParameter("userId", userId)
		                 .getSingleResult();
		    } catch (NoResultException e) {
		        return null;
		    } catch (Exception e) {
		        e.printStackTrace();
		        return null;
		    } finally {
		        em.close();
		    }
		}

		@Override
		public Integer findTotalLessonInCourse(int courseId) {
		    EntityManager em = JPAConfig.getEntityManager();
		    try {
		        String jpql = "SELECT COUNT(l) FROM Lesson l WHERE l.section.course.id = :courseId";
		        Long count = em.createQuery(jpql, Long.class)
		                       .setParameter("courseId", courseId)
		                       .getSingleResult();
		        return count.intValue();
		    } catch (Exception e) {
		        e.printStackTrace();
		        return 0;
		    } finally {
		        em.close();
		    }
		}

		@Override
		public Integer findCurrentLessonFromUserId(int courseProgressId) {
		    EntityManager em = JPAConfig.getEntityManager();
		    try {
		        String jpql = "SELECT COUNT(lp) FROM LessonProgress lp WHERE lp.courseProgress.id = :courseProgressId";
		        Long count = em.createQuery(jpql, Long.class)
		                       .setParameter("courseProgressId", courseProgressId)
		                       .getSingleResult();
		        return count.intValue();
		    } catch (Exception e) {
		        e.printStackTrace();
		        return 0;
		    } finally {
		        em.close();
		    }
		}
		public boolean checkUserProgressExists(int userId, int courseId) {
		    EntityManager em = null;
		    EntityTransaction trans = null;
		    try {
		        em = JPAConfig.getEntityManager();
		        trans = em.getTransaction();
		        trans.begin();
		        String jpql = "SELECT COUNT(cp) FROM CourseProgress cp " +
		                      "WHERE cp.user.id = :userId AND cp.course.id = :courseId";
		        Query query = em.createQuery(jpql);
		        query.setParameter("userId", userId);
		        query.setParameter("courseId", courseId);
		        Long count = (Long) query.getSingleResult();
		        trans.commit();
		        return count > 0;
		    } catch (Exception e) {
		        if (trans != null && trans.isActive()) {
		            trans.rollback();
		        }
		        e.printStackTrace();
		        return false;
		    } finally {
		        if (em != null) {
		            em.close();
		        }
		    }
		}

		public boolean checkLessonProgressExists(int courseProgressID, int lessonId) {
		    EntityManager em = null;
		    EntityTransaction trans = null;
		    try {
		        em = JPAConfig.getEntityManager();
		        trans = em.getTransaction();
		        trans.begin();

		        String jpql = "SELECT COUNT(lp) FROM LessonProgress lp " +
		                      "WHERE lp.lesson.id = :lessonId AND lp.courseProgress.id = :courseProgressID";
		        Query query = em.createQuery(jpql);
		        query.setParameter("lessonId", lessonId);
		        query.setParameter("courseProgressID", courseProgressID);

		        Long count = (Long) query.getSingleResult();
		        trans.commit();
		        return count > 0;
		    } catch (Exception e) {
		        if (trans != null && trans.isActive()) {
		            trans.rollback();
		        }
		        e.printStackTrace();
		        return false;
		    } finally {
		        if (em != null) {
		            em.close();
		        }
		    }
		}

		public boolean checkLessonProgress(int courseProgressID) {
		    EntityManager em = null;
		    EntityTransaction trans = null;
		    try {
		        em = JPAConfig.getEntityManager();
		        trans = em.getTransaction();
		        trans.begin();

		        String jpql = "SELECT COUNT(lp) FROM LessonProgress lp WHERE lp.courseProgress.id = :courseProgressID";
		        Query query = em.createQuery(jpql);
		        query.setParameter("courseProgressID", courseProgressID);

		        Long count = (Long) query.getSingleResult();
		        trans.commit();
		        return count > 0;
		    } catch (Exception e) {
		        if (trans != null && trans.isActive()) {
		            trans.rollback();
		        }
		        e.printStackTrace();
		        return false;
		    } finally {
		        if (em != null) {
		            em.close();
		        }
		    }
		}


		public boolean checkUserRating(int userId, int courseId) {
		    EntityManager em = null;
		    EntityTransaction trans = null;
		    try {
		        em = JPAConfig.getEntityManager();
		        trans = em.getTransaction();
		        trans.begin();

		        String jpql = "SELECT COUNT(r) FROM Review r " +
		                      "WHERE r.createdBy.id = :userId AND r.course.id = :courseId";
		        Query query = em.createQuery(jpql);
		        query.setParameter("userId", userId);
		        query.setParameter("courseId", courseId);

		        Long count = (Long) query.getSingleResult();
		        trans.commit();
		        return count > 0;
		    } catch (Exception e) {
		        if (trans != null && trans.isActive()) {
		            trans.rollback();
		        }
		        e.printStackTrace();
		        return false;
		    } finally {
		        if (em != null) {
		            em.close();
		        }
		    }
		}

	    public void saveCourseProgress(CourseProgress courseProgress) {
	        EntityManager em = JPAConfig.getEntityManager();
	        EntityTransaction tx = em.getTransaction();

	        try {
	            tx.begin();
	            em.persist(courseProgress);
	            tx.commit();
	        } catch (Exception e) {
	            if (tx.isActive()) tx.rollback();
	            e.printStackTrace();
	        } finally {
	            em.close();
	        }
	    }
	    
	    @Override
		public void addCourseType(CourseType courseType) {
		    EntityManager em = JPAConfig.getEntityManager();
		    EntityTransaction trans = em.getTransaction();

		    try {
		        if (courseType == null) {
		            throw new IllegalArgumentException("CourseType cannot be null");
		        }

		        trans.begin();

		        // Lưu courseType vào DB
		        em.persist(courseType);

		        // Commit transaction
		        trans.commit();
		    } catch (Exception e) {
		        if (trans.isActive()) {
		            trans.rollback();
		        }
		        e.printStackTrace();
		    } finally {
		        if (em != null && em.isOpen()) {
		            em.close(); // Đảm bảo đóng EntityManager
		        }
		    }
		}

		@Override
		public List<CourseType> getAllCourseTypes() {
		    EntityManager em = JPAConfig.getEntityManager();
		    List<CourseType> courseTypes = new ArrayList<>();

		    try {
		        String sql = "SELECT ct FROM CourseType ct";
		        courseTypes = em.createQuery(sql, CourseType.class).getResultList();
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        if (em != null && em.isOpen()) {
		            em.close(); // Đảm bảo đóng EntityManager
		        }
		    }

		    return courseTypes;
		}

		@Override
		public boolean updateCourseType(CourseType courseType) {
		    EntityManager enma = JPAConfig.getEntityManager();
		    EntityTransaction trans = enma.getTransaction();

		    try {
		        trans.begin();

		        // Kiểm tra xem có tồn tại không
		        CourseType existingType = enma.find(CourseType.class, courseType.getId());
		        if (existingType != null) {
		            existingType.setCourseTypeName(courseType.getCourseTypeName());
		            enma.merge(existingType);
		        } else {
		            return false; // Không tìm thấy
		        }

		        trans.commit();
		        return true;
		    } catch (Exception e) {
		        if (trans.isActive()) {
		            trans.rollback();
		        }
		        e.printStackTrace();
		        return false;
		    } finally {
		        enma.close();
		    }
		}

		@Override
		public CourseType getCourseTypeById(int id) {
		    EntityManager em = JPAConfig.getEntityManager();
		    CourseType courseType = null;
		    try {
		        courseType = em.find(CourseType.class, id); // Tìm theo khóa chính
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        if (em != null && em.isOpen()) {
		            em.close();
		        }
		    }
		    return courseType;
		}



}

