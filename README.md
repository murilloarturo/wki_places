# Places Launcher

SwiftUI companion app for the Wikipedia iOS deep-link assignment. This app loads the assignment location feed, opens Wikipedia directly in Places at a selected coordinate, offers a retro collection of unusual destinations, and lets the user search or pan an Apple map to choose a custom location.

## Status

Implementation branch: `codex/places-launcher-app`. This branch is intentionally separate from the Wikipedia deep-link implementation and must not be merged until both apps have been tested together and Arturo approves the merge.

## Requirements

- macOS with Xcode 26.4 or a compatible Xcode release
- iOS 17+ simulator or device
- XcodeGen 2.45+
- The modified Wikipedia iOS app installed with support for `wikipedia://places?lat=<latitude>&lon=<longitude>`

## Generate and Run

```sh
cd PlacesLauncher
/opt/homebrew/bin/xcodegen generate
open PlacesLauncher.xcodeproj
```

Select the `PlacesLauncher` scheme and run on an iOS 17+ device or simulator. The generated Xcode project is ignored because `project.yml` is the source of truth.

## Build and Test

```sh
cd PlacesLauncher
xcodebuild -project PlacesLauncher.xcodeproj -scheme PlacesLauncher -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
xcodebuild -project PlacesLauncher.xcodeproj -scheme PlacesLauncher -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test
```

## Behavior

- Home fetches `locations.json` with Swift Concurrency and handles loading, success, empty, failure, and retry states.
- Location names are optional. Unnamed feed entries display as `Unnamed location` with their coordinates.
- A location opens `wikipedia://places?lat=...&lon=...`.
- Suggestions switches the entire screen to a retro game-map treatment and includes a deterministic-testable Surprise Me action.
- Choose on Map supports Apple Maps search, map panning with a fixed center pin, confirmation, cancellation, and visible errors.

## Structure

```text
PlacesLauncher/
├── App/
├── Core/
├── Features/
├── Tests/
└── project.yml
```

## Configuration

No secrets or environment variables are required. The public assignment feed URL is defined by `LocationFeedEndpoint.assignment`.

## License

No license has been selected for this assignment repository.

