# springboot-sti
FROM openshift/base-centos7
MAINTAINER Axel Urban <axel.urban.ext@hemesworld.com> 

# Install build tools on top of base image
# Java Oracle jdk 8


#RUN echo "proxy=http://195.68.199.245:8080" >> /etc/yum.conf
RUN echo "proxy=http://webproxy.int.hlg.de:8080" >> /etc/yum.conf
RUN echo "proxy_username=UrbanAxe" >> /etc/yum.conf
RUN echo "proxy_password=UDSLinux15" >> /etc/yum.conf

RUN sed -i s/https/http/g /etc/yum.repos.d/epel.repo
RUN sed -i s/https/http/g /etc/yum.repos.d/CentOS-Base.repo


RUN yum install -y --enablerepo=centosplus \
    wget apache-maven && \
    yum clean all -y 
ADD jdk-8u92-linux-x64.rpm /tmp/
RUN rpm -ivh /tmp/jdk-8u92-linux-x64.rpm && \ 
    rm -f /tmp/*.rpm && \
    mkdir -p /opt/openshift && \
    mkdir -p /opt/app-root/source && chmod -R a+rwX /opt/app-root/source && \
    mkdir -p /opt/s2i/destination && chmod -R a+rwX /opt/s2i/destination && \
    mkdir -p /opt/app-root/src && chmod -R a+rwX /opt/app-root/src

ADD apache-maven-3.3.9-bin.tar.gz /opt/ 
RUN chmod -R 777 /opt/apache-maven-3.3.9

LABEL io.k8s.description="Platform for running Spring Boot applications" \
      io.k8s.display-name="Spring Boot" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="springboot"

# TODO (optional): Copy the builder files into /opt/openshift
# COPY ./<builder_folder>/ /opt/openshift/
# COPY Additional files,configurations that we want to ship by default, like a default setting.xml

LABEL io.openshift.s2i.scripts-url=image:///usr/local/sti
COPY ./.sti/bin/ /usr/local/sti

RUN chown -R 1001:1001 /opt/openshift

# This default user is created in the openshift/base-centos7 image
USER 1001

# Set the default port for applications built using this image
EXPOSE 8080

# Set the default CMD for the image
#CMD ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/opt/openshift/app.jar"]
CMD ["usage"]
