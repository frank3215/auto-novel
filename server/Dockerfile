FROM gradle:8-jdk17 AS builder
COPY . /server
WORKDIR /server

# 配置 Gradle 使用阿里云镜像（Kotlin DSL）
RUN mkdir -p /root/.gradle && cat > /root/.gradle/init.gradle.kts << 'EOF'
allprojects {
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("https://maven.aliyun.com/repository/central") }
        mavenCentral()
        maven("https://jitpack.io")
        maven("https://maven.tryformation.com/releases") {
            content { includeGroup("com.jillesvangurp") }
        }
    }
}
EOF

RUN gradle --no-daemon --init-script /root/.gradle/init.gradle.kts installDist

FROM eclipse-temurin:17.0.10_7-jdk
COPY --from=builder /server/build/install/auto-novel-server /server
ENV LANG C.UTF-8
CMD ["/server/bin/auto-novel-server"]
