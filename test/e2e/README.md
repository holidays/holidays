# End-to-end tests

End-user behavioral checks against the **real upstream definitions** in
`/definitions`. These tests load actual region data and assert specific
holiday names, dates, counts, and observed-date behavior, the kinds of
expectations a consumer of the gem would care about.

## Purpose

These tests verify that the full pipeline, from upstream YAML through
generation through gem processing to the public API, produces the results
an end user expects for real-world regions. They complement fixture-based
integration tests by catching content regressions in the gem's interaction
with real definitions.

## E2E tests vs. integration vs. smoke

- **Smoke** (`test/smoke/`): only asserts nothing crashes. Run from the
  upstream `holidays/definitions` CI.
- **Integration** (`test/integration/`): verifies gem-wide behavior using
  controlled fixture YAMLs. Stable across definitions changes.
- **E2E** (this directory): verifies end-user-perceived behavior using real
  upstream definitions. Expected to break when upstream definitions change,
  on purpose.

## Important

These tests are tightly coupled to the contents of `/definitions`. When you
update the definitions submodule and an upstream change shifts a holiday name,
date, or count, the corresponding e2e test must be updated to match. That is
working as intended: the test is the gem's record of what end users see, so
updating it is part of accepting the upstream change.

This directory is **not** run by the upstream `holidays/definitions` CI. Doing
so would create a dependency loop where the definitions repo cannot ship a
legitimate content change without also updating tests in this repo first.

## What belongs here

- Tests that assert specific holidays exist on specific dates for specific
  regions using real definitions (e.g. `:ca` returns "Labour Day" on Sept 1, 2008).
- Tests of observed-date behavior against real region rules.
- Tests of sub-region inheritance, wildcards (`:ca_`), `:any`, and cross-region
  conflicts using real data.
- Region-count or holiday-count assertions for specific year/region combinations.

## What does NOT belong here

- Tests that don't depend on real definitions content. Those belong in
  `integration/` (with fixtures) or `smoke/` (structural only).
- Tests of a single file or class in isolation. Those are unit tests and
  belong next to the code they cover.
