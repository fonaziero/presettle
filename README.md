# Presettle

Open-source pre-settlement fraud screening for instant payments, built for smaller financial
institutions such as credit unions and community banks.

Instant payments settle in seconds and are hard to recover afterwards, so fraud checks must run
**before** settlement. Presettle screens ISO 20022 `pacs.008` credit transfers against configurable
rules and returns `ALLOW`, `REVIEW` or `BLOCK`, with an analyst dashboard for the payments held for review.

> **Status: early development.** Nothing is usable yet. See the [v1 scope](docs/SCOPE.md) for what is
> coming and the [architecture decisions](docs/adr/) for how it is built.

## Disclaimers
- **FedNow-oriented, not certified.** FedNow's own ISO 20022 specifications are available only to
  participants (via MyStandards). Presettle uses the public `pacs.008.001.08` schema and makes no
  claim of FedNow conformance.
- **Decision support, not compliance.** Presettle supports fraud decisions; it does not replace an
  institution's compliance program.
- **Synthetic data only.** Never load real customer data into the demo.

## Running locally
Requirements: Docker. To build without Docker, Java 25.

```sh
docker compose up --build
```

- Health check: http://localhost:8080/actuator/health
- API docs (Swagger UI): http://localhost:8080/swagger-ui.html

Backend build and tests (needs Docker for Testcontainers):

```sh
cd backend
./mvnw verify
```

## License
[Apache License 2.0](LICENSE)
