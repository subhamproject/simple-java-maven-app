## This will be used as BASE image
FROM ubuntu:latest AS base
# install needed packages
RUN apt-get update
RUN apt-get install -y python vim openjdk-8-jdk
RUN apt-get autoremove
RUN apt-get clean
#Add jenkins user
RUN useradd -s /bin/bash -m -d /var/lib/jenkins -p `perl -e 'print crypt("jenkins","password"),"\n"'` jenkins
RUN chown jenkins:jenkins /var/lib/jenkins
USER jenkins

## This image will be used to install dependency packages to compile and test
FROM ubuntu:latest AS dependency
#Install Maven
RUN apt-get update
RUN apt-get install -y git curl telnet python vim sudo unzip openjdk-8-jdk
WORKDIR /var/lib/jenkins
RUN curl -Os https://archive.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
RUN tar xfz apache-maven-3.5.2-bin.tar.gz
ENV M2_HOME="/var/lib/jenkins/apache-maven-3.5.2"
ENV PATH="${PATH}:${M2_HOME}/bin"


## This Image will be used to run maven build and test cases ##
FROM dependency AS test
COPY . .
RUN mvn package

##This image will be derived  from BASE image production ready ,With minimal packages ##
FROM base
USER root
# install needed packages
COPY --from=test /var/lib/jenkins/target/my-app-1.0-SNAPSHOT.jar /tmp
EXPOSE 8080
CMD ["java", "-jar", "/tmp/my-app-1.0-SNAPSHOT.jar"]
