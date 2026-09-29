# ADR 0002: Screen outbound payments only in v1

- Status: Accepted
- Date: 2026-09-29

## Context
Fraud can be detected on both sides of a payment: when the institution's customer sends money
(outbound) or receives it (inbound).

## Decision
v1 screens outbound payments only.

## Rationale
The v1 rules — velocity per debtor account and new payee — are naturally payer-side signals.
Supporting both directions would roughly double the rule and test surface.

## Consequences
- Inbound screening goes on the public roadmap. It addresses a real problem: money-mule accounts
  receiving proceeds from authorized push payment scams, a pattern well known from Brazil's Pix.
- The domain model should keep the payment direction explicit so inbound can be added without
  reshaping the schema.
