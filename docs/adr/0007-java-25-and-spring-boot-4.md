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
