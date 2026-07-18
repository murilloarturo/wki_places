# Wikipedia Places Assignment Plan

## Goal

Create a public GitHub repository containing a local copy of the Wikipedia iOS app plus a SwiftUI Places launcher app. The launcher will open Wikipedia through a new deep link so Wikipedia starts directly on the Places tab at caller-supplied coordinates instead of the current device location.

Public repo:

```text
https://github.com/murilloarturo/wki_places
```

## Operating Rules

- Keep the assignment in one repository.
- Work locally with git and push branches to GitHub.
- Separate major work into deliverables and isolated worktrees.
- Do not merge feature branches into `main` without Arturo's explicit approval.
- When in doubt, pause and ask Arturo before choosing a risky direction.
- After the Wikipedia and Places launcher streams are ready, stop and ask Arturo to test both apps before any merge.

## Proposed Repository Layout

```text
wki_places/
├── PLAN.md
├── README.md
├── wikipedia-ios/
│   └── local copy of upstream Wikipedia iOS app
└── PlacesLauncher/
    └── SwiftUI launcher/test app
```

The exact Xcode layout may change after inspecting the Wikipedia project. If adding the launcher as a second app target inside the same workspace is cleaner for reviewers, prefer that over forcing a separate project.

## Deliverable 1: Product and UI Design

Branch:

```text
codex/design-direction
```

Worktree:

```text
/Users/arturo/Developer/wki_places_design
```

Purpose:

- Define the Places launcher experience before implementation.
- Keep the app simple enough for an assignment but polished enough to feel intentional.
- Create a playful screen concept that still demonstrates the core requirement clearly.

Design scope:

- Main SwiftUI screen layout.
- Location list treatment.
- Custom coordinate entry flow.
- Loading, empty, error, and validation states.
- Accessibility labels/hints strategy.
- Small fun details and easter eggs that do not distract from the assignment.

Possible playful touches:

- A curated "fun jumps" section with locations such as Area 51, Null Island, CERN, the Bermuda Triangle, or other memorable coordinates.
- A Konami-code-style hidden action that reveals bonus locations or random "adventure" suggestions.
- A "surprise me" location button.
- Copy that feels light and clever while still being professional.

Output:

- Design notes in `docs/design.md`.
- Screens/flow description in the README or a linked doc.
- Optional lightweight wireframe asset if helpful.

Acceptance:

- Arturo approves the design direction before implementation starts.

## Deliverable 2: Wikipedia Deep Link Support

Branch:

```text
codex/wikipedia-places-deeplink
```

Worktree:

```text
/Users/arturo/Developer/wki_places_wikipedia
```

Purpose:

- Import and modify the Wikipedia iOS app source.
- Add a new deep link that opens the Places tab at supplied coordinates.
- Keep changes focused and compatible with normal Wikipedia behavior.

Deep link proposal:

```text
wikipedia://places?lat=52.3547498&lon=4.8339215
```

Also accept:

```text
wikipedia://places?lat=52.3547498&long=4.8339215
```

Phases:

1. Import the upstream Wikipedia iOS source into `wikipedia-ios/`.
2. Inspect the project structure, build setup, URL routing, tab routing, and Places location flow.
3. Document findings in `docs/wikipedia-analysis.md`.
4. Add a focused parser/model for Places coordinate links.
5. Route valid links to the Places tab.
6. Inject the supplied coordinate into Places as an override.
7. Preserve existing current-location behavior for normal launches.
8. Add unit tests around URL parsing and invalid-coordinate handling.
9. Manually test with Simulator using `xcrun simctl openurl`.

Validation:

- Wikipedia builds locally.
- Existing app launch behavior still works.
- A valid Places coordinate link opens the Places tab.
- Invalid links are ignored safely or handled predictably.
- Tests for the new parser pass.

Output:

- Branch pushed to GitHub.
- Summary of modified files.
- Manual test instructions for Arturo.

## Deliverable 3: SwiftUI Places Launcher App

Branch:

```text
codex/places-launcher-app
```

Worktree:

```text
/Users/arturo/Developer/wki_places_launcher
```

Purpose:

- Build the assignment's SwiftUI test app.
- Fetch remote locations.
- Open Wikipedia using the new Places deep link.
- Include custom coordinate entry.
- Include the approved design personality and easter eggs.

Required feed:

```text
https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json
```

Phases:

1. Create the launcher app structure.
2. Add `Codable` models for the locations feed.
3. Fetch locations with Swift Concurrency using `async/await`.
4. Display loading, success, error, and retry states.
5. Show fetched locations in an accessible list.
6. Handle unnamed locations with coordinate-based display names.
7. Add custom latitude/longitude entry and validation.
8. Generate the Wikipedia Places deep link.
9. Open Wikipedia through `UIApplication.open`.
10. Add approved easter eggs and fun suggested locations.
11. Add unit tests for decoding, validation, and URL generation.

Validation:

- Launcher builds locally.
- Remote feed loads.
- Tapping a fetched location opens Wikipedia.
- Custom coordinates open Wikipedia.
- Invalid custom input is blocked with a clear UI state.
- Accessibility labels/hints are present for key controls.
- Unit tests pass.

Output:

- Branch pushed to GitHub.
- Summary of app structure and test coverage.
- Manual test instructions for Arturo.

## Deliverable 4: Integration, README, and Test Gate

Branch:

```text
codex/integration-readme
```

Worktree:

```text
/Users/arturo/Developer/wki_places_integration
```

Purpose:

- Bring the completed Wikipedia and launcher branches together only after both are ready.
- Prepare reviewer-facing documentation.
- Stop before merging into `main`.

Phases:

1. Create an integration branch from latest `main`.
2. Bring in the completed Wikipedia and launcher work for integration testing.
3. Resolve conflicts if any.
4. Write or update `README.md`.
5. Add final setup, run, test, and troubleshooting instructions.
6. Confirm license/attribution notes for the copied Wikipedia source.
7. Push the integration branch.
8. Ask Arturo to test both apps.

README must include:

- Assignment summary.
- Repository layout.
- Xcode and setup prerequisites.
- How to run the modified Wikipedia app.
- How to run the SwiftUI Places launcher app.
- The supported deep link format.
- How to run tests.
- Notes on Swift Concurrency.
- Notes on Accessibility.
- Easter egg notes only if they help testing, otherwise keep them discoverable.

Merge rule:

- Do not merge `codex/integration-readme` into `main`.
- Arturo tests first.
- Arturo explicitly approves the merge.
- Only then perform the merge if Arturo asks for it.

## Final Validation Checklist

- Wikipedia app builds locally.
- Places launcher app builds locally.
- Fetched locations appear in the launcher.
- Tapping a fetched location opens Wikipedia to Places at that coordinate.
- Custom coordinates open Wikipedia to Places at that coordinate.
- Invalid custom coordinates are rejected in the launcher.
- Normal Wikipedia Places behavior still works when opened without coordinates.
- Unit tests pass where practical.
- README is complete enough for a reviewer to clone and run the assignment.
- All final branches are pushed to GitHub.
- Arturo has tested both apps before any merge to `main`.
