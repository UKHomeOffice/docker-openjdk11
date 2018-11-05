FROM quay.io/ukhomeofficedigital/centos-base:latest AS stage

ENV JAVA_VERSION 11.0.1

RUN curl -LO https://download.java.net/java/GA/jdk11/13/GPL/openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz
RUN echo $(curl -L https://download.java.net/java/GA/jdk11/13/GPL/openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz.sha256) openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz > checksum.txt
RUN sha256sum -c checksum.txt
RUN tar xzf openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz
RUN mv jdk-${JAVA_VERSION} /usr/local/java

# Security patches etc. managed centrally
# =======================================
FROM quay.io/ukhomeofficedigital/centos-base:latest

# Install Open Java 11
# ===================

# Set correct environment variables.
ENV	HOME /root
ENV	LANG en_US.UTF-8
ENV	LC_ALL en_US.UTF-8

COPY --from=stage /usr/local/java /usr/local/java

ENV JAVA_HOME /usr/local/java
ENV PATH $PATH:$JAVA_HOME/bin
