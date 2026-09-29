# ADR 0005: Modular monolith with Spring Modulith

- Status: Accepted
- Date: 2026-09-29

## Context
The backend has a few clear responsibilities — ingestion, rule evaluation, analyst review — but a
small team and small deployments.

## Decision
Build one Spring Boot application split into modules (`ingestion`, `rules`, `review`), with
boundaries verified by Spring Modulith.

## Alternatives considered
- **Microservices:** operational overhead (multiple deployments, network calls, distributed
  transactions) with no benefit at this scale.

## Consequences
- One container to run; simple for adopters.
- Module boundaries are enforced by tests, so a module could be extracted later if needed.
