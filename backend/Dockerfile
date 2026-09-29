# Build stage: compile and package with the Maven Wrapper
FROM eclipse-temurin:25-jdk AS build
WORKDIR /workspace
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN ./mvnw -B dependency:go-offline
COPY src/ src/
RUN ./mvnw -B package -DskipTests

# Runtime stage: JRE only, non-root user
FROM eclipse-temurin:25-jre
RUN useradd --system --no-create-home presettle
USER presettle
WORKDIR /app
COPY --from=build /workspace/target/presettle-*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
