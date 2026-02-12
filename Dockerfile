FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY utedemyProject/pom.xml .
RUN mvn dependency:go-offline -B
COPY utedemyProject/ .
RUN mvn clean package -DskipTests

FROM tomcat:10.1-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml
RUN sed -i 's/address="localhost"/address="0.0.0.0"/' /usr/local/tomcat/conf/server.xml
COPY --from=build /app/target/utedemyProject-1.0.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
