# ADR 0010: Parse pacs.008 with JAXB classes generated from the XSD, validating on input

- Status: Accepted
- Date: 2026-09-29

## Context
The screening API receives a `pacs.008.001.08` message and the rules need about ten of its fields
([SCOPE](../SCOPE.md)). The parser sits on the payment's critical path
([ADR 0001](0001-synchronous-http-screening-api.md)) and receives XML from outside, so it must be
correct and safe against XML attacks. The code should be familiar to outside contributors.

Payment systems such as FedNow publish their rules as ISO 20022 *usage guidelines* on Swift
MyStandards. We checked whether those guidelines only restrict the base message, because that decides
whether validating against the public base schema could reject compliant messages:
- MyStandards usage guidelines are defined as restrictions of a base message: removed elements, made
  mandatory, reduced multiplicity, narrowed datatypes, fixed values and text rules.
- A public MyStandards-generated guideline for the same message (Payments Canada Real-Time Rail,
  `pacs.008.001.08`) states "This Usage Guideline restricts the pacs.008.001.08 message", lists
  **Extensions: n.a.**, and its changed datatypes are narrowings (e.g. amounts limited to 2 decimals).
- FedNow's own guideline is available only to registered MyStandards users, so it was not inspected
  directly. The FedNow readiness guide confirms that every FedNow message is sent with a Business
  Application Header (`head.001`).

Conclusion: a message that follows a usage guideline is also valid against the base schema, so
validating against the base XSD rejects malformed input without rejecting compliant messages.

## Decision
- **Generated model:** Java classes are generated at build time from the official
  `pacs.008.001.08.xsd` with `org.jvnet.jaxb:jaxb-maven-plugin` 4.0.16. It uses XJC 4.0.9, the same
  Jakarta XML Binding version the Spring Boot BOM manages for the runtime. Generated code is not
  committed.
- **Isolation:** the generated classes live in `io.github.fonaziero.presettle.ingestion.pacs008`, which
  Spring Modulith treats as internal to the `ingestion` module
  ([ADR 0005](0005-modular-monolith.md)). The parser converts them into Presettle's own domain object
  right away; no other module sees a JAXB type.
- **Schema source:** the XSD is committed byte-for-byte as published by iso20022.org, with its source
  and SHA-256 checksum recorded next to it.
- **Input:** v1 accepts only the `Document` element in the
  `urn:iso:std:iso:20022:tech:xsd:pacs.008.001.08` namespace. The Business Application Header
  (`AppHdr`) envelope goes on the roadmap.
- **Validation:** every message is validated against the XSD before conversion. Invalid messages are
  rejected with an error describing the violation.
- **Secure XML processing:** DTDs are rejected and external entities and schemas are never resolved,
  to prevent XML External Entity (XXE) attacks. This is the first behavior covered by tests.
- **Reuse:** the `JAXBContext` and the compiled `Schema` are created once and shared, since they are
  thread-safe. A new `Unmarshaller` is created per message, since it is not.

## Alternatives considered
- **StAX (streaming API in the JDK):** fastest, with no dependency, and reads only the needed fields.
  But element paths are tracked by hand (the same `Nm` and `Id` elements appear under debtor, creditor
  and agents), and it does not validate anything by itself.
- **Prowide ISO 20022 (`pw-iso20022`):** ready-made models for every message, but a 57 MB jar for a
  single message, it brings its own JAXB implementation alongside the one Spring Boot manages, and its
  advanced validation is a paid product.

## Consequences
- The compiler catches wrong element paths, and schema validation rejects malformed messages at the
  entrance, before any rule runs.
- Build adds a code generation step; navigation through generated classes is verbose, which the
  conversion to the domain object contains in one place.
- Supporting another message version means adding its XSD and generating it into its own package.
- Base schema validation does not enforce a payment system's own usage guideline or ISO 20022
  cross-element rules. This matches the "FedNow-oriented, not certified" disclaimer.
- Because FedNow sends every message with an `AppHdr`, in v1 the calling system must send only the
  `Document` to Presettle.
- The conclusion about usage guidelines should be confirmed against FedNow's guideline on the
  MyStandards Readiness Portal when someone with access can do it.
- Parsing and validation time is part of the latency benchmark in [SCOPE](../SCOPE.md).
