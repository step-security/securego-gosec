[![StepSecurity Maintained Action](https://raw.githubusercontent.com/step-security/maintained-actions-assets/main/assets/maintained-action-banner.png)](https://docs.stepsecurity.io/actions/stepsecurity-maintained-actions)


# gosec - Go Security Checker

- [GitHub Action](#github-action)

## Features

- **Pattern-based rules** for detecting common security issues
  in Go code
- **SSA-based analyzers** for type conversions, slice bounds,
  and crypto issues
- **Taint analysis** for tracking data flow from user input to
  dangerous functions (SQL injection, command injection, path
  traversal, SSRF, XSS, log injection, SMTP injection, SSTI,
  unsafe deserialization, open redirect)

## License

Licensed under the Apache License, Version 2.0 (the "License").
You may not use this file except in compliance with the License.
You may obtain a copy of the License
[here](http://www.apache.org/licenses/LICENSE-2.0).


## Installation

### GitHub Action

You can run `gosec` as a GitHub action as follows:

Use the versioned tag with `@v2` which is pinned to the
latest stable release. This will provide a stable behavior.

```yaml
name: Run Gosec
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
jobs:
  tests:
    runs-on: ubuntu-latest
    env:
      GO111MODULE: on
    steps:
      - name: Checkout Source
        uses: actions/checkout@v7
      - name: Run Gosec Security Scanner
        uses: step-security/securego-gosec@v2
        with:
          args: ./...
```

#### Scanning Projects with Private Modules

If your project imports private Go modules, you need to
configure authentication so that `gosec` can fetch the
dependencies. Set the following environment variables in
your workflow:

- `GOPRIVATE`: A comma-separated list of module path prefixes
  that should be considered private
  (e.g., `github.com/your-org/*`).
- `GITHUB_AUTHENTICATION_TOKEN`: A GitHub token with read
  access to your private repositories.

```yaml
name: Run Gosec
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
jobs:
  tests:
    runs-on: ubuntu-latest
    env:
      GO111MODULE: on
      GOPRIVATE: github.com/your-org/*
      GITHUB_AUTHENTICATION_TOKEN: ${{ secrets.PRIVATE_REPO_TOKEN }}
    steps:
      - name: Checkout Source
        uses: actions/checkout@v7
      - name: Run Gosec Security Scanner
        uses: step-security/securego-gosec@v2
        with:
          args: ./...
```

### Integrating with code scanning

You can [integrate third-party code analysis tools](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/integrating-with-code-scanning)
with GitHub code scanning by uploading data as SARIF files.

The workflow shows an example of running the `gosec` as a step
in a GitHub action workflow which outputs the `results.sarif`
file. The workflow then uploads the `results.sarif` file to
GitHub using the `upload-sarif` action.

```yaml
name: "Security Scan"

# Run workflow each time code is pushed to your repository and on a schedule.
# The scheduled workflow runs every at 00:00 on Sunday UTC time.
on:
  push:
  schedule:
  - cron: '0 0 * * 0'

jobs:
  tests:
    runs-on: ubuntu-latest
    env:
      GO111MODULE: on
    steps:
      - name: Checkout Source
        uses: actions/checkout@v7
      - name: Run Gosec Security Scanner
        uses: step-security/securego-gosec@v2
        with:
          # we let the report trigger content trigger a failure using the GitHub Security features.
          args: '-no-fail -fmt sarif -out results.sarif ./...'
      - name: Upload SARIF file
        uses: github/codeql-action/upload-sarif@v4
        with:
          # Path to SARIF file relative to the root of the repository
          sarif_file: results.sarif
```

### Exit codes

- `0`: scan finished without unsuppressed findings/errors
- `1`: at least one unsuppressed finding or processing error
- Use `-no-fail` to always return `0`

## Usage

Gosec can be configured to only run a subset of rules, to
exclude certain file paths, and produce reports in different
formats. By default all rules will be run against the supplied
input files. To recursively scan from the current directory you
can supply `./...` as the input argument.

### Available rules

gosec includes rules across these categories:

- `G1xx`: general secure coding issues (for example hardcoded
  credentials, unsafe usage, HTTP hardening, cookie security)
- `G2xx`: injection risks in query/template/command
  construction
- `G3xx`: file and path handling risks (permissions, traversal,
  temp files, archive extraction)
- `G4xx`: crypto and TLS weaknesses
- `G5xx`: blocklisted imports
- `G6xx`: Go-specific correctness/security checks (for example
  range aliasing and slice bounds)
- `G7xx`: taint analysis rules (SQL injection, command
  injection, path traversal, SSRF, XSS, log, SMTP injection,
  SSTI, unsafe deserialization, and open redirect)

For the full list, rule descriptions, and per-rule
configuration, see [RULES.md](RULES.md).

### Retired rules

- G105: Audit the use of math/big.Int.Exp -
  [CVE is fixed](https://github.com/golang/go/issues/15184)
- G307: Deferring a method which returns an error - causing
  more inconvenience than fixing a security issue, despite the
  details from this
  [blog post](https://www.joeshaw.org/dont-defer-close-on-writable-files/)

### CWE Mapping

Every issue detected by `gosec` is mapped to a
[CWE (Common Weakness Enumeration)](http://cwe.mitre.org/data/index.html)
which describes in more generic terms the vulnerability.

#### Rule Configuration

Some rules accept configuration flags as well; these flags are
documented in
[RULES.md](https://github.com/step-security/securego-gosec/blob/main/RULES.md).
