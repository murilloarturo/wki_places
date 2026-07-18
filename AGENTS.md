# Places Launcher Agent Guide

## Purpose

This branch contains the SwiftUI test app for the Wikipedia Places deep-link assignment. It fetches a small remote location feed, opens the Wikipedia app at coordinates, offers playful curated suggestions, and supports choosing a custom coordinate with MapKit.

## Boundaries

- Work on the launcher only under `PlacesLauncher/` plus its branch documentation.
- Do not edit the separate Wikipedia worktree from this branch.
- Do not merge this branch into `main`; Arturo must test and explicitly approve first.
- Do not add a license without Arturo choosing one.

## Architecture

- `App/`: app entry point and shared styling.
- `Core/Models`: feed and coordinate value types.
- `Core/Networking`: async feed loading and decoding.
- `Core/Services`: Wikipedia URL/opening behavior and deterministic suggestion selection.
- `Features/`: SwiftUI screens and their observable state.
- `Tests/`: XCTest coverage and fixtures.

UI code may depend on Core. Core must not depend on feature views. Keep network, randomness, URL opening, and MapKit search behind protocols when behavior needs unit coverage.

## Commands

Run from `PlacesLauncher/`:

```sh
/opt/homebrew/bin/xcodegen generate
xcodebuild -project PlacesLauncher.xcodeproj -scheme PlacesLauncher -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
xcodebuild -project PlacesLauncher.xcodeproj -scheme PlacesLauncher -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test
```

If the named simulator is unavailable, inspect installed devices with SimLauncher and use an available iPhone runtime.

## Development Rules

- Target iOS 17 or newer and use native SwiftUI, MapKit, and Foundation APIs.
- Preserve Dynamic Type, VoiceOver labels, 44-point minimum targets, and reduced-motion behavior.
- Keep the Home and custom map flows in the native light visual system; the Suggestions screen owns the full retro palette and monospaced typography.
- Never commit `DerivedData`, user-specific Xcode state, or the generated `.xcodeproj`; regenerate it from `project.yml`.
- Check `git status` before editing and never revert unrelated changes.
- Before committing, regenerate the project, build, run all tests, and perform a simulator smoke test when feasible.
- `UITests/` contains accessibility-driven navigation smoke tests for the approved screens; keep them independent of the separately installed Wikipedia app.
