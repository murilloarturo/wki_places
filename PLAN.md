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
- Use exactly two active feature worktrees: one for Wikipedia and one for the Places app.
- The Places worktree starts with design; launcher implementation is blocked until Arturo approves the design direction.
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

## Deliverable 1: Places Product and UI Design

Branch:

```text
codex/places-launcher-app
```

Worktree:

```text
/Users/arturo/Developer/wki_places_places
```

Purpose:

- Define the Places launcher experience before implementation in the same branch that will later contain the app.
- Use a polished Apple-style visual language for the normal app experience.
- Give the visible Suggestions experience a distinct retro game-map style.
- Restore the normal Apple-style appearance when the user leaves Suggestions.

Design scope:

- Main SwiftUI screen layout.
- Location list treatment.
- Apple Maps custom-location selection flow.
- Loading, empty, error, and validation states.
- Accessibility labels/hints strategy.
- A visible Suggestions section with fun destinations; no hidden codes are required.

Initial Suggestions candidates:

- Apple Park, Cupertino (`37.334887, -122.008996`).
- Area 51, Nevada (`37.2350, -115.8111`).
- CERN, near Geneva (`46.2330, 6.0557`).
- Rapa Nui / Easter Island (`-27.1170, -109.3670`).
- Svalbard Global Seed Vault (`78.235729, 15.491244`).
- Point Nemo (`-48.8767, -123.3933`).
- Null Island (`0, 0`).
- Bermuda Triangle (`25, -71`).
- Darvaza gas crater (`40.2525, 58.4393`).
- A "Surprise me" action that chooses from the curated set.

The final set should favor coordinates with useful nearby Wikipedia results. Coordinates and display copy will be verified before they are shipped as app data.

Output:

- Design notes in `docs/design.md`.
- Screens/flow description in the README or a linked doc.
- Optional lightweight wireframe asset if helpful.

Acceptance:

- Arturo approves the design direction before implementation starts.
- Approval covers both the default Apple-style screen and the temporary retro Suggestions mode.

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
/Users/arturo/Developer/wki_places_places
```

Purpose:

- Build the assignment's SwiftUI test app.
- Fetch remote locations.
- Open Wikipedia using the new Places deep link.
- Include custom coordinate entry.
- Include the approved design personality and easter eggs.

Implementation gate:

- Do not start this deliverable until Arturo approves Deliverable 1.

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
7. Generate the Wikipedia Places deep link.
8. Open Wikipedia through `UIApplication.open`.
9. Implement the visible Suggestions section and its retro game-map presentation.
10. Restore the normal presentation when navigating back from Suggestions.
11. Add unit tests for decoding, state handling, suggestion selection, and URL generation.
12. As the final app phase, add custom location selection with Apple Maps:
    - Present a map with a location search text field.
    - Geocode typed place names and move the map to the result.
    - Allow the user to drag/pan the map and choose the map-center coordinate.
    - Provide a clear Confirm button that opens Wikipedia at the selected coordinate.
    - Add validation, error, cancellation, VoiceOver, and Dynamic Type behavior.
    - Keep geocoding and selection state behind testable protocols/models, with unit tests for confirmation and error paths.

Validation:

- Launcher builds locally.
- Remote feed loads.
- Tapping a fetched location opens Wikipedia.
- Searching for a custom place moves Apple Maps to the resolved location.
- Dragging the map allows a coordinate to be selected and confirmed.
- Confirming a custom map location opens Wikipedia at that coordinate.
- Invalid or unresolved custom searches show a clear UI state.
- Accessibility labels/hints are present for key controls.
- Unit tests pass.

Output:

- Branch pushed to GitHub.
- Summary of app structure and test coverage.
- Manual test instructions for Arturo.

## Deliverable 4: README, Cross-App Testing, and Merge Gate

Purpose:

- Test the completed Wikipedia and launcher branches together while they remain in their separate worktrees.
- Prepare reviewer-facing documentation.
- Stop before merging into `main`.

Phases:

1. Finish and push both feature branches.
2. Install/run Wikipedia from the Wikipedia worktree.
3. Install/run Places from the Places worktree against the same Simulator.
4. Exercise feed locations, Suggestions, and Apple Maps custom-location selection end to end.
5. Draft the relevant setup and testing notes in each feature branch.
6. Confirm license/attribution notes for the copied Wikipedia source.
7. Ask Arturo to test both apps before any feature branch is merged.
8. After Arturo approves, agree on merge order and resolve any integration conflicts.
9. Complete the root `README.md` as part of the approved integration work.

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

- Do not merge either feature branch into `main` automatically.
- Do not create a third integration worktree unless Arturo later asks for one.
- Arturo tests both apps first and explicitly approves the merge.
- Only perform a merge when Arturo asks for it, using the order agreed at that point.

## Final Validation Checklist

- Wikipedia app builds locally.
- Places launcher app builds locally.
- Fetched locations appear in the launcher.
- Tapping a fetched location opens Wikipedia to Places at that coordinate.
- A searched or map-selected custom location opens Wikipedia to Places at that coordinate.
- Invalid or unresolved custom location searches are handled clearly.
- Suggestions switch to the retro game-map style and Back restores the normal style.
- Normal Wikipedia Places behavior still works when opened without coordinates.
- Unit tests pass where practical.
- README is complete enough for a reviewer to clone and run the assignment.
- All final branches are pushed to GitHub.
- Arturo has tested both apps before any merge to `main`.
