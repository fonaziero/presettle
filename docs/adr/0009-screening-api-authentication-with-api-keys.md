# ADR 0009: Screening API authentication with API keys

- Status: Accepted
- Date: 2026-09-29

## Context
The screening API (`POST /v1/screenings`) is called by the institution's payment system, not by a
person, and it handles payment data, so it must not accept anonymous calls. Each screening should also
record which client sent it, for the audit trail. [ADR 0006](0006-dashboard-authentication.md) covers
only the analyst dashboard. Target adopters have limited engineering capacity, so client setup must
stay simple.

## Decision
- Clients authenticate with an API key sent in the `X-API-Key` request header.
- Keys are defined in configuration, each with a client id. Configuration holds only the SHA-256 hash
  of each key, never the key itself. Keys are long random values, so a fast hash is enough.
- Several keys can be active at once, so a key can be rotated without downtime.
- Keys are compared in constant time and are never logged. A missing or unknown key gets `401`.
- The client id is stored with every screening.
- The screening API and the dashboard use separate Spring Security filter chains, so each keeps its
  own authentication method.

## Alternatives considered
- **OAuth2 client credentials:** the standard for service-to-service calls, but it requires the
  adopter to run or integrate an authorization server. On the roadmap.
- **Mutual TLS (mTLS):** strong and common between financial systems, but certificate issuance and
  rotation are heavy for a v1 setup. On the roadmap.
- **No authentication on a private network:** relies entirely on network controls; unacceptable for
  payment data.

## Consequences
- Easy to adopt and to test with `curl`.
- An API key is a bearer secret: anyone who holds it can call the API. It must only travel over TLS,
  which v1 expects to be terminated by a reverse proxy in front of the service; the README must say so.
- Adding or revoking a key requires a configuration change and a restart, like the rules
  ([ADR 0003](0003-rules-configured-in-yaml.md)).
- The authentication code should sit behind Spring Security so OAuth2 or mTLS can be added later
  without touching the screening logic.
