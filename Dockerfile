# Dockerfile for sample service using emmbedded tomcat server

FROM centos:centos7

RUN yum install -y \
    java-1.11.0-openjdk \
    java-1.11.0-openjdk-devel \
    wget tar iproute git

RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
RUN sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
RUN yum install -y apache-maven
ENV JAVA_HOME /etc/alternatives/jre
RUN git clone https://github.com/debugroom/mynavi-sample-aws-ecs.git /var/local/sample-aws-ecs
RUN mvn install -f /var/local/sample-aws-ecs/pom.xml

RUN cp /etc/localtime /etc/localtime.org
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

EXPOSE 8080

CMD java -jar -Dspring.profiles.active=production /var/local/sample-aws-ecs/backend-for-frontend/target/sample-aws-ecs-backend-for-frontend-0.0.1-SNAPSHOT.jar
