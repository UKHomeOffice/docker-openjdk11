FROM quay.io/ukhomeofficedigital/centos-base:v0.7.0 AS stage

ENV JAVA_VERSION "11.0.11+9"

RUN export JAVA_VERSION_PATH=${JAVA_VERSION/+/%2B} && \
    export JAVA_VERSION_FILE=${JAVA_VERSION/+/_} && \
    curl -LO https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-${JAVA_VERSION_PATH}/OpenJDK11U-jdk_x64_linux_hotspot_${JAVA_VERSION_FILE}.tar.gz && \
    curl -Lo sha256.txt https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-${JAVA_VERSION_PATH}/OpenJDK11U-jdk_x64_linux_hotspot_${JAVA_VERSION_FILE}.tar.gz.sha256.txt && \
    sha256sum -c sha256.txt && \
    tar xzf OpenJDK11U-jdk_x64_linux_hotspot_${JAVA_VERSION_FILE}.tar.gz && \
    mv jdk-${JAVA_VERSION} /usr/local/java && \
    chown -R root:root /usr/local/java

# Security patches etc. managed centrally
# =======================================
FROM quay.io/ukhomeofficedigital/centos-base:v0.7.0

# Set correct environment variables.
ENV HOME /root

COPY --from=stage /usr/local/java /usr/local/java

ENV JAVA_HOME /usr/local/java
ENV PATH $PATH:$JAVA_HOME/bin
