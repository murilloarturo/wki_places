# Places Launcher

SwiftUI companion app for the Wikipedia iOS deep-link assignment. This app loads the assignment location feed, opens Wikipedia directly in Places at a selected coordinate, offers a retro collection of unusual destinations, and lets the user search or pan an Apple map to choose a custom location.

## Status

Implementation branch: `codex/places-launcher-app`. This branch is intentionally separate from the Wikipedia deep-link implementation and must not be merged until both apps have been tested together and Arturo approves the merge.

## Requirements

- macOS with Xcode 26.4 or a compatible Xcode release
- iOS 17+ simulator or device
- XcodeGen 2.45+
- SwiftGen 6.6+
- The locally signed modified Wikipedia iOS app installed with support for `wikipedia://places?lat=<latitude>&lon=<longitude>`

## Generate and Run

```sh
brew install xcodegen swiftgen
cd PlacesLauncher
./scripts/generate-localizations.sh
xcodegen generate
open PlacesLauncher.xcodeproj
```

Select the `PlacesLauncher` scheme and run on an iOS 17+ device or simulator. The generated Xcode project is ignored because `project.yml` is the source of truth. Xcode also runs the SwiftGen script before builds when the source strings change. The build script resolves SwiftGen from the shell or the standard Apple Silicon and Intel Homebrew locations.

## Architecture

The app uses feature-based MVVM with a protocol-oriented use-case boundary:

- SwiftUI views own presentation and navigation.
- `@MainActor` view models use the iOS 17 `@Observable` macro and depend only on use-case protocols.
- Concrete use cases own HTTP and MapKit service references.
- Codable DTOs and explicit mappers keep transport fields out of domain models.
- `AppContainer` assembles dependencies without global singletons.

## Localization

English and Spanish are supported. English `Localizable.strings` is SwiftGen's source catalog, and the generated `L10n` enum is used throughout views, accessibility labels, errors, and destination content.

```sh
cd PlacesLauncher
./scripts/generate-localizations.sh
```

Add new keys to both files under `Resources`, regenerate `Generated/Strings+Generated.swift`, and commit the source catalogs together with the generated code.

## Build and Test

```sh
cd PlacesLauncher
xcodebuild -project PlacesLauncher.xcodeproj -scheme PlacesLauncher -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
xcodebuild -project PlacesLauncher.xcodeproj -scheme PlacesLauncher -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test
```

The UI suite includes an end-to-end Wikipedia handoff test. It accepts the iOS external-app confirmation, skips first-run Wikipedia onboarding when present, and verifies the Places tab. The test skips when the assignment Wikipedia build is not installed on the selected simulator.

## Behavior

- Home fetches `locations.json` on every screen entry with Swift Concurrency and handles animated loading, success, empty, failure, and retry states.
- Location names are optional. Unnamed feed entries display as `Unnamed location` with their coordinates.
- A location opens `wikipedia://places?lat=...&lon=...`.
- Suggestions switches the entire screen to a retro game-map treatment and includes a deterministic-testable Surprise Me action.
- Choose on Map supports Apple Maps search, map panning with a fixed center pin, confirmation, and visible errors.

## Structure

```text
PlacesLauncher/
├── App/
├── Core/
│   ├── DTOs/
│   ├── Mappers/
│   ├── Models/
│   ├── Services/
│   └── UseCases/
├── Features/
├── Generated/
├── Resources/
├── scripts/
├── Tests/
├── swiftgen.yml
└── project.yml
```

## Configuration

No secrets or environment variables are required. The public assignment feed URL is defined by `LocationFeedEndpoint.assignment`. Home executes `FetchLocationsUseCase` on every entry. `JSONHTTPClient` uses `URLSession.shared` with `.reloadIgnoringLocalCacheData`, so each load requests the feed without using locally cached response data.

## License

No license has been selected for this assignment repository.
