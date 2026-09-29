# ADR 0004: Velocity state in PostgreSQL, serialized per account with advisory locks

- Status: Accepted
- Date: 2026-09-29

## Context
The velocity rule counts (and sums) recent payments from the same debtor account. If two screenings
for the same account run in parallel, both can read the old count and both pass — a classic
check-then-act race that a fraudster could exploit with simultaneous payments.

## Decision
- Keep velocity state in PostgreSQL by querying stored screenings; no Redis in v1.
- Each screening runs in one transaction that first takes a transaction-scoped advisory lock keyed by
  the debtor account: `pg_advisory_xact_lock(hashtextextended(<account key>, 0))`.
- Within that transaction: count/sum recent payments, evaluate rules, insert the new screening, commit.
  The lock is released at commit, so the next screening for the same account sees the new row.
- The account key is normalized (debtor agent + account identifier) so the same account always maps
  to the same lock.

## Alternatives considered
- **`SELECT ... FOR UPDATE` on a per-account counter table:** works, but adds a state table that must
  be kept consistent with the screenings.
- **`SERIALIZABLE` isolation:** Postgres detects the conflict, but callers must retry, which makes
  latency unpredictable under load.
- **Redis:** one more component to run, unnecessary at small-institution volumes.

## Consequences
- Only screenings for the *same* account are serialized; different accounts proceed in parallel.
- **Hash collisions:** advisory locks take a number, so the account key is hashed to 64 bits. Two
  different accounts can, very rarely, map to the same number. The only effect is that they wait for
  each other for a few milliseconds; rule results stay correct, because counts are still computed per
  real account, not per hash.
- Lock hold time must stay short: no external calls inside the screening transaction.
- Tested by firing N concurrent screenings for the same account and asserting the rule fires exactly
  at the configured limit.
