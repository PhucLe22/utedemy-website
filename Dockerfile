FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY utedemyProject/pom.xml .
RUN mvn dependency:go-offline -B
COPY utedemyProject/ .
RUN mvn clean package -DskipTests

FROM tomcat:10.1-jdk17
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/utedemyProject-1.0.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
