# ADR 0006: Dashboard authentication with configured users

- Status: Accepted
- Date: 2026-09-29

## Context
The analyst dashboard shows payment data and records decisions, so it must require login. Every
decision must be attributable to an analyst for the audit trail.

## Decision
Use Spring Security with users defined in configuration, no roles in v1.

## Alternatives considered
- **No authentication:** unacceptable for a tool handling payment data, even in a demo.
- **Keycloak / OIDC:** the right long-term answer, but adds a heavy component to the v1 setup.

## Consequences
- Analyst identity is recorded with every decision.
- SSO and role-based access go on the roadmap.
