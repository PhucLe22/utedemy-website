package vn.iotstar.controller.Teacher;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Answer;
import vn.iotstar.entity.Course;
import vn.iotstar.entity.User;
import vn.iotstar.entity.CourseDetail;
import vn.iotstar.entity.CourseType;
import vn.iotstar.entity.Lesson;
import vn.iotstar.entity.Question;
import vn.iotstar.entity.Quiz;
import vn.iotstar.entity.Section;
import vn.iotstar.impl.service.CourseService;
import vn.iotstar.service.ICourseService;
import vn.iotstar.utils.Constant;

@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024, // 1 MB
	    maxFileSize = 1024 * 1024 * 10,  // 10 MB
	    maxRequestSize = 1024 * 1024 * 15 // 15 MB
	)
@WebServlet(urlPatterns = {"/teacher/editSection","/teacher/editLesson","/teacher/editTarget","/teacher/updateTarget","/teacher/updateCourse","/teacher/editBasicInformation","/teacher/updateBasicInformation",
		"/teacher/updateSection","/teacher/deleteSection","/teacher/updateLesson","/teacher/deleteLesson","/teacher/editQuiz", 
		"/teacher/updateQuiz", "/teacher/deleteQuiz","/teacher/edit"})
public class UpdateCourseController extends HttpServlet{

	private static final long serialVersionUID = 1L;
	public ICourseService courseService = new CourseService();
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String url = req.getRequestURI();
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		HttpSession session = req.getSession();
		if (url.contains("/teacher/editSection")) 
		{
			int sectionId = Integer.parseInt(req.getParameter("sectionId"));
			Section section = courseService.findByIdSection(sectionId);
			System.out.println ("Tiều đề: " + section.getTitle());
			resp.setContentType("application/json");
		    resp.getWriter().write("{\"title\": \"" + section.getTitle() + "\"}");
		}
		else if (url.contains("/teacher/editLesson")) 
		{
			int lessonId = Integer.parseInt(req.getParameter("lessonId"));
			System.out.println ("id lesson: " + lessonId);
			Lesson lesson = courseService.findByIdLesson(lessonId);
			resp.setContentType("application/json");
			System.out.println (lesson.getTitle() + " " + lesson.getVideoUrl());
			String json = "{"
				    + "\"title\": \"" + escapeJson(lesson.getTitle()) + "\","
				    + "\"videoUrl\": \"" + escapeJson(lesson.getVideoUrl()) + "\","
				    + "\"description\": \"" + escapeJson(lesson.getDescription()) + "\","
				    + "\"isFreeLesson\": \"" + escapeJson(String.valueOf(lesson.getIsFreeLesson())) + "\""
				    + "}";

				resp.getWriter().write(json);
		}
		else if (url.contains("/teacher/editQuiz")) {
		    resp.setContentType("application/json");
		    resp.setCharacterEncoding("UTF-8");

		    int quizId = Integer.parseInt(req.getParameter("quizId"));
		    Quiz quiz = courseService.findByIdQuiz(quizId);

		    if (quiz != null) {
		        JsonObject quizJson = new JsonObject();
		        quizJson.addProperty("id", quiz.getId());
		        quizJson.addProperty("title", quiz.getTitle());
		        quizJson.addProperty("description", quiz.getDescription());
		        quizJson.addProperty("duration", quiz.getDuration());

		        JsonArray questionsArray = new JsonArray();
		        for (Question q : quiz.getQuestions()) {
		            JsonObject qJson = new JsonObject();
		            qJson.addProperty("description", q.getDescription());
		            qJson.addProperty("score", q.getScore());

		            JsonArray answersArray = new JsonArray();
		            for (Answer a : q.getAnswers()) {
		                JsonObject aJson = new JsonObject();
		                aJson.addProperty("content", a.getContent());
		                aJson.addProperty("isCorrect", a.isCorrect());
		                answersArray.add(aJson);
		            }

		            qJson.add("answers", answersArray);
		            questionsArray.add(qJson);
		        }

		        quizJson.add("questions", questionsArray);
		        resp.getWriter().write(quizJson.toString());
		    } else {
		        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
		        resp.getWriter().write("{\"error\":\"Quiz not found\"}");
		    }
		}
		else if (url.contains("/teacher/editBasicInformation"))
		{
			User user = (User) session.getAttribute("account");
			if (user == null) {
				resp.sendRedirect(req.getContextPath() + "/login");
				return;
			}
			String idCourseStr = req.getParameter("id");
			if (idCourseStr == null || idCourseStr.isEmpty()) {
				resp.sendRedirect(req.getContextPath() + "/teacher/course");
				return;
			}
			int idCourse = Integer.parseInt(idCourseStr);
			Course course = courseService.findByIdCourse(idCourse);
			session.setAttribute("courseSession1", course);
			//Course course = (Course)session.getAttribute("courseSession");
			System.out.println ("Ten khoa học: " + course.getCourseName());
			CourseType courseType = courseService.findByIDCourseType(course.getCourseType().getId());
			List<CourseType> listCourseType = courseService.listCourseType();
			req.setAttribute("listCourseType", listCourseType);
			req.setAttribute("course", course);
			req.setAttribute("courseType", courseType);
			req.getRequestDispatcher("/views/teacher/editBasicInformation.jsp").forward(req, resp);
		}
		else if (url.contains("/teacher/editTarget")) 
		{
			Course course = (Course)session.getAttribute("courseSession1");
			CourseDetail courseDetail = courseService.findByIdCourseDetail(course.getCourseDetail().getId());
			courseDetail.getCourseLearner();
			courseDetail.getLearnerAchievements();
			req.setAttribute("course", course);
			req.setAttribute("learner", courseDetail.getCourseLearner());
			req.setAttribute("target", courseDetail.getLearnerAchievements());
			req.getRequestDispatcher("/views/teacher/editTarget.jsp").forward(req, resp);
		}
		else if (url.contains("/teacher/edit")) 
		{
			Course course = (Course)session.getAttribute("courseSession1");
			if (course != null) {
			    System.out.println("📘 Course: " + course.getCourseName());
			    for (Section section : course.getSections()) {
			        System.out.println("  📂 Section: " + section.getTitle());
			        for (Lesson lesson : section.getLessons()) {
			            System.out.println("    🎓 Lesson: " + lesson.getTitle());
			            System.out.println("        📹 Video URL: " + lesson.getVideoUrl());
			        }
			        for (Quiz quiz : section.getQuizs()) {
			            System.out.println("    ❓ Quiz: " + quiz.getTitle());
			            for (Question question : quiz.getQuestions()) {
			                System.out.println("      🔸 Question: " + question.getDescription());
			                for (Answer answer : question.getAnswers()) {
			                    System.out.println("        ➡️ Answer: " + answer.getContent() + " (Correct: " + answer.isCorrect() + ")");
			                }
			            }
			        }
			    }
			} else {
			    System.out.println("❌ Course not found.");
			}
			req.setAttribute("course", course);
			session.setAttribute("courseSession", course);
			req.getRequestDispatcher("/views/teacher/edit.jsp").forward(req, resp);
		}
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String url = req.getRequestURI();
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		HttpSession session = req.getSession();
		if (url.contains("/teacher/updateSection")) 
		{
			resp.setContentType("application/json");
			String sectionTitle = req.getParameter("sectionTitle");
			String sectionId = req.getParameter("sectionId");

			PrintWriter out = resp.getWriter();
			System.out.println ("id: " + sectionId + " title: " + sectionTitle);

			int sectionIdInt = 0;

			if (sectionId != null && !sectionId.isEmpty()) {
			    try {
			    	sectionIdInt = Integer.parseInt(sectionId);
			    } catch (NumberFormatException e) {
			        e.printStackTrace();
			    }
			}

			try {
				Section section = courseService.findByIdSection(sectionIdInt);
				section.setTitle(sectionTitle);
				boolean checkSection = courseService.updateSection(section);
	        	if (checkSection) {
	        		System.out.println("Lưu thành công");
	        		// Gộp tất cả thông tin trả về vào một object JSON duy nhất
	                String json = "{"
	                            + "\"sectionId\": " + section.getId() + ","
	                            + "\"title\": \"" + section.getTitle() + "\","
	                            + "\"status\": \"success\","
	                            + "\"message\": \"Đã thêm phần học: " + sectionTitle + "\""
	                            + "}";
	                resp.getWriter().write(json);
	        	}
	        } catch (Exception e) {
	            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	            out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
	        } finally {
	            out.flush();
	        }
		}
		if (url.contains("/teacher/updateLesson")) 
		{
			req.setCharacterEncoding("UTF-8");
	        resp.setContentType("application/json");
	        resp.setCharacterEncoding("UTF-8");

	        PrintWriter out = resp.getWriter();

			String title = req.getParameter("title");
			String description = req.getParameter("description");
			boolean isFreeLesson = Boolean.parseBoolean(req.getParameter("isFreeLesson"));
			String videoUrl = req.getParameter("videoUrl");
			String lessonId = req.getParameter("lessonId");


			int lessonIdInt = 0;

			if (lessonId != null && !lessonId.isEmpty()) {
			    try {
			    	lessonIdInt = Integer.parseInt(lessonId);
			    } catch (NumberFormatException e) {
			        e.printStackTrace();
			    }
			}

			try {
				Lesson lesson = courseService.findByIdLesson(lessonIdInt);
				lesson.setDescription(description);
				lesson.setTitle(title);
				lesson.setVideoUrl(videoUrl);
				lesson.setIsFreeLesson(isFreeLesson);
				boolean checkLesson = courseService.updateLesson(lesson);
	        	if (checkLesson) {
	                String json = "{"
	                            + "\"lessonId\": " + lesson.getId() + ","
	                            + "\"title\": \"" + lesson.getTitle() + "\","
	                            + "\"description\": \"" + lesson.getTitle() + "\","
	                            + "\"video\": \"" + lesson.getTitle() + "\","
	                            + "\"isFreeLesson\": \"" + lesson.getIsFreeLesson() + "\","
	                            + "\"status\": \"success\","
	                            + "\"message\": \"Đã thêm phần học: " + title + "\""
	                            + "}";
	                resp.getWriter().write(json);
	        	}
	        } catch (Exception e) {
	            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	            out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
	        } finally {
	            out.flush();
	        }
		}
		if (url.contains("/teacher/updateQuiz")) 
		{
			BufferedReader reader = req.getReader();
		    String json = reader.lines().collect(Collectors.joining());

		    ObjectMapper mapper = new ObjectMapper();
		    Quiz quiz = mapper.readValue(json, Quiz.class);

		    boolean test = courseService.updateQuiz(quiz);
		    if (test) {
		        resp.setContentType("application/json");
		        resp.getWriter().write("{\"success\": true, \"quizId\": " + quiz.getId() + "}");
		    }
		}
		if (url.contains("/teacher/deleteSection")) 
		{
			int sectionId = Integer.parseInt(req.getParameter("sectionId"));
			boolean check;
			try {
				check = courseService.deleteSection(sectionId);
				if (check) {
					resp.setStatus(HttpServletResponse.SC_OK);
			    } else {
			        resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			    }
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
		if (url.contains("/teacher/deleteLesson")) 
		{
			int lessonId = Integer.parseInt(req.getParameter("lessonId"));
			boolean check;
			try {
				check = courseService.deleteLesson(lessonId);
				if (check) {
					resp.setStatus(HttpServletResponse.SC_OK);
			    } else {
			        resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			    }
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
		if (url.contains("/teacher/deleteQuiz")) 
		{
			int quizId = Integer.parseInt(req.getParameter("quizId"));
			boolean check;
			try {
				check = courseService.deleteQuiz(quizId);
				if (check) {
					resp.setStatus(HttpServletResponse.SC_OK);
			    } else {
			        resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			    }
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if (url.contains("/teacher/updateBasicInformation")) 
		{
			// Set response type
	        resp.setContentType("application/json");

	        try {
	        	String courseTitle = req.getParameter("courseTitle");
	            String shortDescription = req.getParameter("shortDescription");
	            String courseTypeId = req.getParameter("courseTypeId");
	            String coursePrice = req.getParameter("coursePrice");
	            String courseIntroduction = req.getParameter("courseIntroduction");
	            String videoLink = req.getParameter("videoLink");
	            // Get course ID from session

	            Course course = (Course)session.getAttribute("courseSession1");
	            course.setCourseName(courseTitle);
	            int coursePriceInt = 0;

				if (coursePrice != null && !coursePrice.isEmpty()) {
				    try {
				    	coursePriceInt = Integer.parseInt(coursePrice);
				    } catch (NumberFormatException e) {
				        e.printStackTrace();
				    }
				}
				course.setCoursePrice(coursePriceInt);

				int courseTypeIdInt = 0;

				if (courseTypeId != null && !courseTypeId.isEmpty()) {
				    try {
				        courseTypeIdInt = Integer.parseInt(courseTypeId);
				    } catch (NumberFormatException e) {
				        e.printStackTrace();
				    }
				}
				CourseType courseType = courseService.findByIDCourseType(courseTypeIdInt);
				course.setCourseType(courseType);

	            CourseDetail courseDetail = courseService.findByIdCourseDetail(course.getCourseDetail().getId());
	            courseDetail.setDescription(shortDescription);
	            courseDetail.setCourseIntroduction(courseIntroduction);
	            courseDetail.setCourseVideo(videoLink);

	            String fname = "";
				String uploadPath = Constant.DIR;
				File uploadDir = new File(uploadPath);
				if (!uploadDir.exists())
					uploadDir.mkdir();
				
				if (req.getPart("courseImage") != null && req.getPart("courseImage").getSize() > 0) {
					try {
						Part part = req.getPart("courseImage");
						if (part.getSize() > 0) {
							String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
							int index = filename.lastIndexOf(".");
							System.out.println (filename);
							String ext = filename.substring(index + 1);
							fname = System.currentTimeMillis() + "." + ext;

							part.write(uploadPath + "/" + fname);

							courseDetail.setCourseImage(fname);
						} else {
							courseDetail.setCourseImage("avatar.png");
						}
					} catch (FileNotFoundException e) {
						e.printStackTrace();
					}
					
				}
				
				
				boolean check = courseService.updateCourseDetail(courseDetail);
				if (check) {
					boolean checkUpdate = courseService.updateCourse(course);
					if (checkUpdate) {
						resp.setContentType("application/json");
					    resp.setCharacterEncoding("UTF-8");

					    JsonObject responseObj = new JsonObject();
					    responseObj.addProperty("success", true);

					    PrintWriter out = resp.getWriter();
					    out.print(responseObj.toString());
					    out.flush();
					}
					else {
						resp.setContentType("application/json");
					    resp.setCharacterEncoding("UTF-8");

					    JsonObject responseObj = new JsonObject();
					    responseObj.addProperty("success", false);
					    responseObj.addProperty("message", "Lỗi khi cập nhật khóa học");

					    PrintWriter out = resp.getWriter();
					    out.print(responseObj.toString());
					    out.flush();
					}
				}
				else {
					resp.setContentType("application/json");
				    resp.setCharacterEncoding("UTF-8");

				    JsonObject responseObj = new JsonObject();
				    responseObj.addProperty("success", false);
				    responseObj.addProperty("message", "Lỗi khi lưu thông tin căn bản");

				    PrintWriter out = resp.getWriter();
				    out.print(responseObj.toString());
				    out.flush();
				}

	        } catch (Exception e) {
	            // Log the error
	            e.printStackTrace();
	        }
		}
		if (url.contains("/teacher/updateTarget")) 
		{
			// Đọc dữ liệu JSON từ request
	        StringBuilder buffer = new StringBuilder();
	        BufferedReader reader = req.getReader();
	        String line;
	        while ((line = reader.readLine()) != null) {
	            buffer.append(line);
	        }

	        String data = buffer.toString();

	        // Parse JSON
	        Gson gson = new Gson();
	        JsonObject jsonObject = gson.fromJson(data, JsonObject.class);

	        try {
	            // Xử lý dữ liệu mục tiêu
	            JsonArray objectivesArray = jsonObject.getAsJsonArray("objectives");
	            List<String> objectives = new ArrayList<>();
	            String target = "";
	            for (JsonElement element : objectivesArray) {
	                objectives.add(element.getAsString());
	                target = target + element.getAsString() + ", ";
	                System.out.println ("Mục tiêu: " + element.getAsString());
	            }

	            // Lấy đối tượng và lời chào
	            String courseLearner = jsonObject.get("targetAudience").getAsString();

	            Course course = (Course)session.getAttribute("courseSession1");
				CourseDetail courseDetail = courseService.findByIdCourseDetail(course.getCourseDetail().getId());
	            courseDetail.setCourseLearner(courseLearner);
	            courseDetail.setLearnerAchievements(target);
	            boolean check = courseService.updateCourseDetail(courseDetail);
	            if (check) {
	            	resp.setContentType("application/json");
				    resp.setCharacterEncoding("UTF-8");

				    JsonObject responseObj = new JsonObject();
				    responseObj.addProperty("success", true);

				    PrintWriter out = resp.getWriter();
				    out.print(responseObj.toString());
	            }else {
	            	resp.setContentType("application/json");
				    resp.setCharacterEncoding("UTF-8");

				    JsonObject responseObj = new JsonObject();
				    responseObj.addProperty("success", false);
				    responseObj.addProperty("message", "Lỗi khi lưu dữ liệu");

				    PrintWriter out = resp.getWriter();
				    out.print(responseObj.toString());
				    out.flush();
	            }

	        } catch (Exception e) {
	            e.printStackTrace();

	            // Trả về lỗi
	            resp.setContentType("application/json");
	            resp.setCharacterEncoding("UTF-8");

	            JsonObject responseObj = new JsonObject();
	            responseObj.addProperty("success", false);
	            responseObj.addProperty("message", "Lỗi: " + e.getMessage());

	            resp.getWriter().write(gson.toJson(responseObj));
	        }
		}
	}

	private String escapeJson(String value) {
	    if (value == null) return "";
	    return value.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
	}

}