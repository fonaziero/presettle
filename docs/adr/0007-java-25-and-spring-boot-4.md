# ADR 0007: Java 25 and Spring Boot 4

- Status: Accepted
- Date: 2026-09-29

## Context
The project starts in late 2026. Java 25 (September 2025) is the latest LTS; Java 21 is the previous one.

## Decision
Use Java 25 and Spring Boot 4.

## Rationale
The service runs as a separate Docker container, so adopters do not need Java 25 installed on their
own systems; the usual compatibility argument for an older LTS carries little weight here. Starting
on the newest LTS keeps the project current for longer.

## Consequences
- **Week 1 check:** confirm that Spring Modulith, springdoc-openapi and Testcontainers have releases
  compatible with Spring Boot 4 before writing feature code. If any does not, revisit this ADR.

## Compatibility check (2026-09-29)
Result: all libraries have Spring Boot 4 compatible releases; the decision stands. Target: Spring Boot
4.1.1 (Spring Framework 7.0.9, Spring Security 7.1.1). Sources: Maven Central metadata, the Spring Boot
4.1.1 BOM and each project's POM.

| Library | Version | Evidence |
|---|---|---|
| Spring Modulith | 2.1.1 | Built against Spring Boot 4.1.1 |
| springdoc-openapi | 3.1.1 | Parent is `spring-boot-starter-parent` 4.1.0 |
| Testcontainers | 2.0.5 | Managed by the Spring Boot 4.1.1 BOM |
| Flyway | 12.4.0 | Managed by the Spring Boot BOM (do not override) |
| PostgreSQL JDBC driver | 42.7.13 | Managed by the Spring Boot BOM |
| Jackson | 3.1.5 | Managed by the Spring Boot BOM |
| Jakarta XML Binding (JAXB) | 4.0.5 (API), 4.0.9 (runtime) | Managed by the Spring Boot BOM |

Notes for the build:
- Flyway needs `spring-boot-starter-flyway` (Spring Boot 4 is split into modules) plus
  `flyway-database-postgresql`.
- Testcontainers 2 renamed its modules, e.g. `org.testcontainers:testcontainers-postgresql`.
- Jackson 3 uses the `tools.jackson` package instead of `com.fasterxml.jackson`.
