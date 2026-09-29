# v1 Scope

**Promise of v1:** with a single `docker compose up`, a small financial institution can watch ISO 20022
`pacs.008` payments being screened by configurable fraud rules, and an analyst can review the flagged ones
— all within five minutes.

Budget: ~40–60 hours (5–8 h/week over ~8 weeks). Target: publishable v1 by end of November 2026.
Quality, tests and documentation take priority over feature count.

## In scope

### 1. Synchronous screening API
- `POST /v1/screenings` accepts a `pacs.008.001.08` XML message (one credit transfer per request).
- Parses only the fields the rules need: `MsgId`, `EndToEndId`, amount and currency, debtor and
  creditor (name, account), debtor and creditor agents.
- Responds with a decision — `ALLOW`, `REVIEW` or `BLOCK` — plus the rules that fired and why.
- Screens **outbound** payments only (see [ADR 0002](adr/0002-outbound-screening-only.md)).
- API documented with OpenAPI / Swagger UI (springdoc).

### 2. Rules
| Rule | Fires when |
|---|---|
| Amount limit | Amount exceeds a configured threshold |
| Velocity | Count and/or sum of payments from the same debtor account exceeds a limit within a time window |
| New payee | First payment ever from this debtor account to this creditor account |
| Deny list | Debtor or creditor account/identifier exactly matches an entry on the list |

- Each rule has a configurable threshold and action (`REVIEW` or `BLOCK`), defined in YAML
  ([ADR 0003](adr/0003-rules-configured-in-yaml.md)).
- Final decision = most severe action among the rules that fired; `ALLOW` if none fired.
- Velocity is concurrency-safe: parallel screenings of the same account cannot slip past the count
  ([ADR 0004](adr/0004-velocity-state-in-postgres-with-advisory-locks.md)).

### 3. Persistence
- PostgreSQL with Flyway migrations.
- Stores screenings, rule hits, analyst decisions and an audit trail.

### 4. Analyst dashboard (Angular)
- Queue of payments in `REVIEW`.
- Detail view showing the reasons each rule fired.
- Approve / reject with a note.
- Basic searchable history.
- Login with users configured via Spring Security ([ADR 0006](adr/0006-dashboard-authentication.md)).

### 5. Synthetic data simulator
- Generates `pacs.008` messages with predefined fraud scenarios: velocity burst, deny-listed account,
  high-value payment to a new payee, plus normal traffic.
- Used for the demo and for automated tests. Synthetic data only; never real customer data.

### 6. Adoption package
- Docker Compose with demo data.
- README with a demo GIF, a published latency benchmark (p50/p99 at N screenings/s, hardware stated,
  reproducible script using k6 or Gatling) and the disclaimers below.
- Architecture overview and ADRs.
- `CONTRIBUTING.md`, issues labeled `good first issue`.
- GitHub Actions CI running the tests (JUnit + Testcontainers).
- Apache 2.0 license.

## Disclaimers (must appear in the README)
- **FedNow-oriented, not certified.** FedNow's own ISO 20022 specifications are available only to
  participants (via MyStandards). This project uses the public `pacs.008.001.08` schema and makes no
  claim of FedNow conformance.
- **Decision support, not compliance.** The tool supports fraud decisions; it does not replace an
  institution's compliance program.

## Out of scope for v1 (public roadmap)
- Inbound payment screening (e.g. detecting money-mule accounts receiving scam proceeds).
- Editing rules through the UI.
- ML or statistical scoring.
- Generating `pacs.002` status responses or connecting to real FedNow infrastructure.
- Sanctions screening (OFAC) and fuzzy name matching.
- Multi-tenancy, SSO, role-based access.
- Kafka or other queues, webhooks, case management, regulatory reporting (SAR), Helm/Kubernetes.

## Plan
| Week | Deliverable |
|---|---|
| 1 | Repo skeleton, CI, Docker Compose, ADRs; confirm library compatibility with Spring Boot 4 ([ADR 0007](adr/0007-java-25-and-spring-boot-4.md)) |
| 2–3 | `pacs.008` parser, rule engine, screening API, tests |
| 4 | Simulator and full persistence |
| 5–6 | Angular dashboard |
| 7 | Docs, demo GIF, benchmark, end-to-end tests |
| 8 | Buffer and launch |

## Architecture decisions
See [docs/adr](adr/).
