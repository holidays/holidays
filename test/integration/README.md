# Integration tests

True gem integration tests that verify how the gem's components work together
(loader, calculator, observed-date logic, sub-region inheritance, caching, etc.)
using **local fixture YAMLs**. Integration-only fixtures live in
`test/integration/data/`. Fixtures shared with other test categories live in
`test/data/`.

## Purpose

These tests pin specific inputs (the fixture YAMLs) and assert specific outputs,
so they verify gem behavior independently of whatever the upstream definitions
repo currently ships. They do not break when upstream definitions change.

## Integration tests vs. unit tests

Unit tests live alongside the code they cover and verify a single file or
class in isolation. They are the right place for testing the internals of one
specific component (e.g. a date calculator, a custom method validator) with
mocks and minimal setup.

Integration tests in this directory are the opposite: they wire multiple gem
components together and verify that they cooperate correctly across the full
parse → calculate → return pipeline. If you are testing one file's internal
behavior, write a unit test. If you are testing how several pieces of the gem
behave together against a known input, write an integration test here.

## What belongs here

- Tests that exercise gem internals end-to-end (parsing, calculation, output)
  using controlled inputs from `test/integration/data/` (or `test/data/` for
  fixtures shared with other test categories).
- Tests for custom-method evaluation, year-range handling, informal flag
  filtering, observed-date shifting, sub-region inheritance, etc., using fixtures.

## What does NOT belong here

- Any test that loads or asserts against real definitions in `/definitions`.
  Those belong in `e2e/`.
- Pure structural checks that don't assert specific behavior. Those belong in
  `smoke/`.
- Tests of a single file or class in isolation. Those are unit tests and belong
  next to the code they cover.

The advantage of fixture-based tests: a definitions change cannot break them.
If you find yourself writing a test that needs to load `:ca` or `:us` directly,
ask whether the same behavior could be tested with a small fixture YAML, and
if so, write the fixture instead.
