package vn.iotstar.impl.dao;

import jakarta.persistence.EntityManager;
import vn.iotstar.dao.ICourseDetailDAO;
import vn.iotstar.entity.Course;
import vn.iotstar.entity.CourseDetail;
import vn.iotstar.entity.CourseProgress;
import vn.iotstar.entity.CourseType;
import vn.iotstar.entity.Section;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Hibernate;
import vn.iotstar.configs.JPAConfig;

public class CourseDetailDAO implements ICourseDetailDAO {

    @Override
    public CourseDetail findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            CourseDetail courseDetail = em.find(CourseDetail.class, id);
            if (courseDetail != null && courseDetail.getCourse() != null) {
                // Tải trước collection review
                Hibernate.initialize(courseDetail.getCourse().getReview());
                
                // Tải trước collection sections
                Hibernate.initialize(courseDetail.getCourse().getSections());
                
                // Tải trước các collection lessons và quizs trong từng section
                for (Section section : courseDetail.getCourse().getSections()) {
                    Hibernate.initialize(section.getLessons());
                    Hibernate.initialize(section.getQuizs());
                }
            }
            return courseDetail;
        } finally {
            em.close();
        }
    }
    @Override
    public CourseDetail findByCourseId(int courseId) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            Course course = em.find(Course.class, courseId);
            if (course != null) {
                // Initialize lazy collections while session is open
                course.getReview().size();
                if (course.getTeacher() != null) {
                    course.getTeacher().getFullname();
                }
                return course.getCourseDetail();
            }
            return null;
        } finally {
            em.close();
        }
    }

    @Override
	public List<CourseProgress> getAllCourseProgress() {
		EntityManager em = JPAConfig.getEntityManager();
		List<CourseProgress> c = new ArrayList<>();
		try {
			String sql = "SELECT c FROM CourseProgress c";
			c = em.createQuery(sql, CourseProgress.class).getResultList();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (em != null && em.isOpen()) {
				em.close(); // Ensuring session is closed after use
			}
		}
		return c;
	}
    @Override
	public List<CourseType> getAllCourseTypes() {
		EntityManager em = JPAConfig.getEntityManager();
		List<CourseType> courseTypes = new ArrayList<>();
		try {
			// Truy vấn tất cả CourseTypes từ cơ sở dữ liệu
			courseTypes = em.createQuery("SELECT c FROM CourseType c", CourseType.class).getResultList();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (em != null && em.isOpen()) {
				em.close();
			}
		}
		return courseTypes;
	}

	@Override
	public CourseType getCourseTypeById(int id) {
		EntityManager em = JPAConfig.getEntityManager();
		CourseType courseType = null;
		try {
			courseType = em.find(CourseType.class, id); // Lấy 1 đối tượng CourseType theo khóa chính
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