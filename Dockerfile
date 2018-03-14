FROM maven:3.5.0-jdk-8
COPY ./target/my-app-1.0-SNAPSHOT.jar /tmp/my-app-1.0-SNAPSHOT.jar
CMD ["java", "-jar", "/tmp/my-app-1.0-SNAPSHOT.jar"]
