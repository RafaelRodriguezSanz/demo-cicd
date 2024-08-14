FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY target/api-1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
EXPOSE 8443
ENTRYPOINT ["java", "-jar", "app.jar"]
