# ADR 0003: Rules configured in YAML

- Status: Accepted
- Date: 2026-09-29

## Context
Rule thresholds and actions must be configurable per institution. Building a rule-editing UI would
cost roughly 10 hours, a large share of the v1 budget.

## Decision
Rules are configured in a YAML file loaded at startup.

## Alternatives considered
- **Database + editing UI:** friendlier for analysts, but expensive now and requires versioning and
  audit of rule changes.

## Consequences
- Rule changes are versionable and reviewable in Git.
- Changing rules requires a restart (or a reload endpoint later).
- A rule-editing UI stays on the roadmap; the rule model should not depend on where it is loaded from.
