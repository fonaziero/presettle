# ADR 0001: Synchronous HTTP screening API

- Status: Accepted
- Date: 2026-09-29

## Context
Instant payments settle in seconds and are hard to recover afterwards, so the fraud check must run
before settlement and answer within milliseconds. Target adopters are small institutions with limited
engineering capacity.

## Decision
Expose screening as a synchronous HTTP endpoint (`POST /v1/screenings`) that receives a `pacs.008`
message and returns the decision in the same response.

## Alternatives considered
- **Queue consumer (e.g. Kafka, MQ):** decouples systems, but forces adopters to run a broker and
  correlate asynchronous responses — too heavy for the target audience and the v1 budget.

## Consequences
- Easy to adopt, test with `curl` and demonstrate.
- The service sits on the payment's critical path, so latency must be measured and published
  (see the benchmark in [SCOPE](../SCOPE.md)).
- A queue-based mode can be added later without changing the rule engine.
