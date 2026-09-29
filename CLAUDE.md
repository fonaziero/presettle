# Project context

## About me
- Victor, Full Stack Developer (~5 years), Brazil.
- Main stack: Angular, TypeScript, Java / Spring Boot, Node.js. Also Docker, Nginx, CI/CD, Linux VPS setup.
- Relevant background: worked on Bradesco's Pix (Brazil's instant payment system) at Capgemini, building
  Angular micro-frontends, BFF layers and Spring Boot microservices. Never include confidential details
  from that project in this repo.
- I work full time, so this project moves at roughly 5-8 hours per week. Prefer small, shippable steps.

## Goal of this project
An open-source tool to help smaller financial institutions (credit unions, community banks) adopt
instant payments (e.g. the US FedNow Service) safely, focused on **pre-settlement fraud checks**.
Instant payments settle in seconds and losses are hard to recover, so checks must run before settlement.

This is a portfolio / impact project: code quality, documentation in English, and real adoption
(users, stars, external contributors) matter more than feature count.

## Scope and architecture
- v1 scope, disclaimers, roadmap and plan: [docs/SCOPE.md](docs/SCOPE.md).
- Architecture decisions: [docs/adr/](docs/adr/). Propose a new ADR before changing an accepted decision.
- Stack: Java 25, Spring Boot 4 (modular monolith with Spring Modulith), PostgreSQL + Flyway,
  Angular, Docker Compose. Sample/synthetic data only, no real customer data.

## How I want to work with you (Claude Code)
- I am the author: explain design choices, let me make the decisions, and help me learn rather than
  generating everything at once.
- Start by helping me define the v1 scope and architecture before writing code.
- Write clear README and docs in English; keep commits small and meaningful.