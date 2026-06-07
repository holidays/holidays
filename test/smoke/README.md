# Smoke tests

Structural-only checks across every region loaded from `/definitions`. These tests
verify that the gem can load and process all definitions without raising errors.
They make no assertions about specific holiday names, dates, or counts.

## Purpose

These tests are run from the upstream `holidays/definitions` repo's CI as the
downstream check. The contract is narrow on purpose: a definitions change should
only fail this suite if it actually breaks the gem's ability to load or process
definitions, never because of intentional content changes (renaming a holiday,
adding a region, shifting a date, etc.).

## What belongs here

- Tests that exercise the gem's API surface (`Holidays.on`, `Holidays.between`,
  flags like `:observed` and `:informal`) across all regions and assert only
  that nothing raises.
- Tests that verify the *shape* of return values (e.g. `available_regions` is
  an Array of Symbols).
- Cross-region invariants that hold regardless of content (e.g. `:any` count is
  ≥ each individual region's count).

## What does NOT belong here

- Any assertion about a specific holiday name, date, or count.
- Any check that depends on the contents of a particular region's YAML.

If a check would fail when someone legitimately renames "Labour Day" to
"Labor Day" in `ca.yaml`, it does not belong in `smoke/`. It belongs in `e2e/`.
