FROM gradle:8-jdk17 AS builder
COPY . /server
WORKDIR /server

# 配置 Gradle 使用阿里云镜像
RUN mkdir -p /root/.gradle && \
    echo "allprojects { repositories { maven { url 'https://maven.aliyun.com/repository/public' }; maven { url 'https://maven.aliyun.com/repository/central' }; mavenCentral(); maven { url 'https://jitpack.io' }; maven('https://maven.tryformation.com/releases') { content { includeGroup('com.jillesvangurp') } } } }" > /root/.gradle/init.gradle

RUN gradle --no-daemon installDist

FROM eclipse-temurin:17.0.10_7-jdk
COPY --from=builder /server/build/install/auto-novel-server /server
ENV LANG C.UTF-8
CMD ["/server/bin/auto-novel-server"]
