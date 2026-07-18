# Wikipedia Places Assignment Plan

## Goal

Create a public GitHub repository containing a local copy of the Wikipedia iOS app plus a SwiftUI test app. The Wikipedia app will support a new deep link that opens the Places tab at coordinates supplied by another app instead of using the current device location.

## Repository Strategy

- Use this repository as the single delivery artifact: `murilloarturo/wki_places`.
- Import the upstream Wikipedia iOS source into this repo instead of using a fork.
- Preserve upstream attribution and license files from `wikimedia/wikipedia-ios`.
- Keep assignment-specific notes in this repo so reviewers can clone one project and follow one README.
- Use git locally for all work and push meaningful commits to GitHub.

## Proposed Structure

```text
wki_places/
├── PLAN.md
├── README.md
├── wikipedia-ios/
│   └── upstream Wikipedia iOS app source
└── PlacesLauncher/
    └── SwiftUI test app
```

The exact structure may be adjusted after inspecting the Wikipedia project files. If adding the launcher as a second target inside the Wikipedia Xcode project is simpler for reviewer testing, prefer that over a separate Xcode project.

## Deep Link Design

Use a URL format like:

```text
wikipedia://places?lat=52.3547498&lon=4.8339215
```

Implementation requirements:

- Parse `lat` and `lon`/`long` query parameters.
- Validate that latitude is between `-90...90` and longitude is between `-180...180`.
- Route launch/open events to the Places tab.
- Pass the coordinate into the Places screen as an override location.
- Preserve existing behavior when the deep link is absent or invalid.

## Work Phases

### 1. Import and Baseline

- Download or clone `https://github.com/wikimedia/wikipedia-ios`.
- Copy the source into this repository.
- Run the upstream setup instructions from the repo root, expected to be `./scripts/setup`.
- Open/build the Wikipedia app in Xcode before making changes.
- Commit the clean upstream import separately from assignment changes.

### 2. Inspect Existing Deep Linking and Places Flow

- Locate URL scheme registration and app delegate/scene delegate routing.
- Identify the current tab selection mechanism.
- Find the Places tab entry point and how it requests current location.
- Identify the smallest extension point for injecting a coordinate.

### 3. Implement Wikipedia Deep Link Support

- Add a focused parser/model for the new Places coordinate deep link.
- Add tests for accepted, rejected, and edge-case URLs.
- Update app routing so the URL opens the Places tab.
- Add a coordinate override path to Places without breaking normal location behavior.
- Manually test with Simulator using `xcrun simctl openurl`.

### 4. Build the SwiftUI Places Launcher

- Create a simple SwiftUI app in the same repository.
- Fetch locations from:

```text
https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json
```

- Decode the JSON with `Codable`.
- Use Swift Concurrency with `async/await` for networking.
- Display a list of fetched locations.
- Handle unnamed locations by displaying formatted coordinates.
- On tap, open the Wikipedia deep link.
- Add fields for a custom latitude and longitude.
- Validate custom input before opening Wikipedia.
- Include basic loading, error, and retry states.
- Add accessibility labels/hints for rows, input fields, and the open action.

### 5. Tests

- Unit test Wikipedia deep-link parsing.
- Unit test launcher JSON decoding, including unnamed locations.
- Unit test launcher URL generation.
- Unit test custom coordinate validation.
- Run relevant Xcode test targets before final delivery.

### 6. README and Reviewer Notes

- Explain the assignment and repository layout.
- Document setup prerequisites.
- Explain how to build/run the modified Wikipedia app.
- Explain how to build/run the SwiftUI launcher app.
- Document the deep link format with examples.
- Include test commands or Xcode test instructions.
- Mention Swift Concurrency and Accessibility choices.
- Add troubleshooting notes for URL scheme conflicts or simulator setup.

## Validation Checklist

- Wikipedia app builds locally.
- Launcher app builds locally.
- Fetched locations appear in the launcher list.
- Tapping each location opens Wikipedia to Places at that coordinate.
- Custom coordinates open Wikipedia to Places at that coordinate.
- Invalid custom coordinates are rejected in the launcher.
- Normal Wikipedia Places behavior still works when opened without coordinates.
- Unit tests pass.
- README is complete enough for a reviewer to clone and run the assignment.

## Delivery

- Push the final code to the public repository.
- Share the public GitHub link:

```text
https://github.com/murilloarturo/wki_places
```
