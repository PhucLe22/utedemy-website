package vn.iotstar.dao;


import vn.iotstar.entity.Answer;
import java.util.List;
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
import vn.iotstar.entity.CourseProgress;
import vn.iotstar.entity.Discussion;
import vn.iotstar.entity.LessonProgress;
import vn.iotstar.entity.Review;

public interface ICourseDao {
	
	public List<CourseType> listCourseType();
	
	public boolean saveCoure (Course course);
	
	public CourseType findByIDCourseType (int id);
	
	public Course findByIdCourse(int id);
	
	public int maxCourseId();
	
	public boolean saveCourseDetail (CourseDetail courseDetail);
	
	public boolean updateCourse (Course course);
	
	public int maxCourseDetailId();
	
	public CourseDetail findByIdCourseDetail (int id);

	List<Object[]> findBestSellingCourseDetails(int limit);

	List<Object[]> findTodaySaleCourses(int limit);

	List<Object[]> findLatestCourseDetails(int limit);

	List<Object[]> findLatestCourseDetailsWithDiscount(int limit);
	
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
	
	public List<Course> getAllCourses();

	public List<Lesson> getAllLessons();

	public List<Course> filterCoursesByRatingAndCourse(List<OrderItem> orderItems, double ratingThreshold);

	double calculateAverageRating(Course course);

	public List<Course> filterCoursesByRating(double ratingThreshold);
	
	public List<Course> getCoursesByUserId(int userId);
	
	public int getMaxCourseId();
	
	public void addCourse(Course course);
	
	public Course getCourseById(int Id);
	
	List<Object[]> findSectionLessonCourse(int courseId);

	public List<Map> findCommentsAndReplys(int courseID);

	public List<Map> findReviews(int courseID);

	public void markLessonAsCompleted(LessonProgress lessonProgress);

	public void insertReview(Review review);

	public void insertDiscussion(Discussion discussion);

	public void insertReplyDiscussion(Discussion discussion);

	public void saveCourseProgress(CourseProgress courseProgress);

	public double findAverageRating(int courseID);

	public List<Object[]> findRatingDestribution(int courseID);

	public List<Map> findInfoTeacher(int courseId);

	public String findOverviewSection(int courseId);

	public Integer findCourseProgressId(int courseId, int userId);

	public Integer findTotalLessonInCourse(int courseId);

	public Integer findCurrentLessonFromUserId(int courseProgessId);

	public String findAvatarURL(int userId);
	
	public boolean checkUserProgressExists (int userId, int courseId);

	public boolean checkLessonProgressExists (int courseProgressID, int lessonId);

	public boolean checkLessonProgress(int courseProgressID);

	public boolean checkUserRating(int userId, int courseId);
	
	public void addCourseType(CourseType courseType);

	public List<CourseType> getAllCourseTypes(); 

	public boolean updateCourseType(CourseType courseType);

	public CourseType getCourseTypeById(int id);

	
}
