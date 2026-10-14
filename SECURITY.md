# Security policy

This repository follows the [shared security policy](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).
The short version is below, followed by what is in scope for this package.

## Supported versions

Security fixes are made on the `main` branch and go into the next release.

## Reporting a vulnerability

Please report vulnerabilities privately, not in a public issue, pull request or discussion.

1. **Preferred:** open the repository's **Security** tab and choose
   **Report a vulnerability** ([how private reporting works](https://docs.github.com/en/code-security/how-tos/report-and-fix-vulnerabilities/report-privately)).
2. **Or** email [muhittincamdali@gmail.com](mailto:muhittincamdali@gmail.com) with
   "Security" in the subject.

Include the affected file or API, the version (tag or commit), steps to reproduce, and what an
attacker could do with it. You get a reply within 7 days confirming that the report arrived.

## Scope

This package contains demo screens. The parts that handle untrusted input are:

- `WebAddress`, which decides what the web view demo loads. It accepts only `http` and `https`
  URLs with a host and without user credentials.
- The web view demo itself, which shows whatever page the entered address returns.
- The Foundation Models demo, which sends the text you type to the on-device language model.
