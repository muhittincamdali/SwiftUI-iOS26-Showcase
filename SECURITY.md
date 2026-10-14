# Security Policy

## Supported versions

Security fixes are made on the `main` branch.

## Reporting a vulnerability

Please do not open a public issue for a security problem. Email muhittincamdali@gmail.com
instead.

Include the affected file or API, steps to reproduce, and what an attacker could do with it.

## Scope

This package contains demo screens. The parts that handle untrusted input are:

- `WebAddress`, which decides what the web view demo loads. It accepts only `http` and `https`
  URLs with a host and without user credentials.
- The web view demo itself, which shows whatever page the entered address returns.
- The Foundation Models demo, which sends the text you type to the on-device language model.
