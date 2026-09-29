# ADR 0008: Data access with Spring's JdbcClient

- Status: Accepted
- Date: 2026-09-29

## Context
The velocity rule depends on a precise sequence of SQL statements inside one transaction: take an
advisory lock for the debtor account, count and sum recent payments, insert the new screening, commit
([ADR 0004](0004-velocity-state-in-postgres-with-advisory-locks.md)). The correctness of that rule
depends on each statement running exactly when and in the order the code says. The schema is small
(screenings, rule hits, analyst decisions, audit trail) and managed by Flyway.

## Decision
Access PostgreSQL with Spring Framework's `JdbcClient` and handwritten SQL. Transactions are managed
with Spring's `@Transactional`; schema changes stay in Flyway migrations. No ORM.

## Alternatives considered
- **JPA / Hibernate:** the persistence context decides when SQL is flushed, which makes the order of
  the lock, the reads and the insert harder to see and to guarantee. Native queries would be needed for
  the advisory lock anyway, and the entity model adds little for a handful of tables.
- **Spring Data JDBC:** simple and without a persistence context, but the queries that matter
  (velocity window, review queue, history search) would be custom SQL anyway. Can be added later for
  plain CRUD if it pays off.
- **jOOQ:** type-safe SQL, but adds a code-generation step and more tooling for contributors.

## Consequences
- Every statement in the screening transaction is visible in the code, which makes the concurrency
  argument of ADR 0004 reviewable.
- Row mapping is written by hand (e.g. mapping rows to Java records); more code than an ORM.
- SQL errors surface only at runtime, so data access code is tested against a real PostgreSQL with
  Testcontainers, not an in-memory database.
- Each module owns its tables and SQL; modules do not query each other's tables
  ([ADR 0005](0005-modular-monolith.md)).
