package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.Answer;
import vn.iotstar.entity.Course;
import vn.iotstar.entity.CourseDetail;
import vn.iotstar.entity.CourseType;
import vn.iotstar.entity.Lesson;
import vn.iotstar.entity.OrderItem;
import vn.iotstar.entity.Question;
import vn.iotstar.entity.Quiz;
import vn.iotstar.entity.Section;
import vn.iotstar.entity.User;
import java.util.Map;
import vn.iotstar.entity.Review;
import vn.iotstar.entity.LessonProgress;
import vn.iotstar.entity.Discussion;
import vn.iotstar.entity.CourseProgress;

public interface ICourseService {
	List<Object[]> getBestSellingCourses(int limit);

	List<Object[]> getTodaySaleCourses(int limit);

	List<Object[]> getLatestCourses(int limit);

	List<Object[]> getLatestCoursesWithDiscount(int limit);

	public List<CourseType> listCourseType();
	
	public boolean saveCoure (Course course);
	
	public CourseType findByIDCourseType (int id);
	
	public Course findByIdCourse(int id);
	
	public int maxCourseId();
	
	public boolean saveCourseDetail (CourseDetail courseDetail);
	
	public boolean updateCourse (Course course);
	
	public int maxCourseDetailId();
	
	public CourseDetail findByIdCourseDetail (int id);
	
	public boolean updateCourseDetail (CourseDetail courseDetail);

	public boolean saveSection (Section section);

	public int maxSectionId();

	public Section findByIdSection(int id);

	public boolean saveLesson (Lesson lesson);

	public boolean saveQuiz (Quiz quiz);

	public int maxQuizId();

	public Quiz findByIdQuiz(int id);

	public boolean saveQuestion (Question question);

	public int maxQuestionId();

	public Question findByIdQuestion(int id);

	public boolean saveAnswer (Answer answer);

	public boolean updateSection (Section section);

	public Lesson findByIdLesson (int id);

	public boolean updateLesson (Lesson lesson);

	public boolean updateQuiz (Quiz quiz);

	public boolean deleteSection (int id) throws Exception;

	public boolean deleteLesson (int id) throws Exception;

	public boolean deleteQuiz (int id) throws Exception;
	
	List<Course> findByIdTeacher (User user);

	List<Course> findAllCourse ();
	
	List<Course> getAllCourses();

	public List<Lesson> getAllLessons();

	public List<Course> filterCoursesByRatingAndCourse(List<OrderItem> orderItems, double ratingThreshold);

	public double calculateAverageRating(Course course);

	public List<Course> filterCoursesByRating(double ratingThreshold);
	
	public List<Course> getCoursesByUserId(int userId);
	
	public Course getCourseById(int Id);

	public int getMaxCourseId();

	void addCourse(Course course);
	
	List<Object[]> getSectionLessonCourse(int courseId);

	List<Object[]> getRatingDestribution(int courseId);

	List<Map> getInfoTeacher(int userId);

	List<Map> getCommentsAndReplys(int courseId);

	List<Map> getReviews(int courseId);

	public void markLessonAsCompleted(LessonProgress lessonProgress);

	public void saveDiscussion(Discussion discussion);

	public void saveReview(Review review);

	public void saveCourseProgress(CourseProgress courseProgress);

	public boolean checkUserProgressExists(int userId, int courseId);

	public boolean checkLessonProgressExists(int courseProgressID, int lessonId);

	public boolean checkUserRating(int userId, int courseId);

	public boolean checkLessonProgress(int courseProgessId);

	public Integer getTotalLessonInCourse(int courseId);

	public Integer getCurrentLessonFromUserId(int courseProgessId);

	public String getAvatarURL(int userId);

	public void saveReplyDiscussion(Discussion discussion);

	public double getAverageRating(int courseId);

	public String getOverviewSection(int courseId);

	public Integer getCourseProgressId(int courseId, int userId);
	
	public void addCourseType(CourseType courseType);

	public List<CourseType> getAllCourseTypes(); 

	public boolean updateCourseType(CourseType courseType);

	public CourseType getCourseTypeById(int id);

}

