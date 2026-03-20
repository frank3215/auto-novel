FROM gradle:8-jdk17 AS builder
COPY . /server
WORKDIR /server

# 在 build.gradle.kts 中添加阿里云镜像
RUN sed -i '17i\    maven { url = uri("https://maven.aliyun.com/repository/public") }\n    maven { url = uri("https://maven.aliyun.com/repository/central") }' build.gradle.kts

RUN gradle --no-daemon installDist

FROM eclipse-temurin:17.0.10_7-jdk
COPY --from=builder /server/build/install/auto-novel-server /server
ENV LANG C.UTF-8
CMD ["/server/bin/auto-novel-server"]
