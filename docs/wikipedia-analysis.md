# Wikipedia iOS deep-link analysis

## Source snapshot

- Upstream: https://github.com/wikimedia/wikipedia-ios
- Imported commit: `48dce0d0ed06c118e8fff07dbc0cbdcb8c317176`
- Imported as `wikipedia-ios/` without upstream `.git` metadata.
- Upstream `README.md`, `LICENSE.txt`, security policy, code of conduct, and in-app license sources are preserved.

## Existing architecture

The app is a UIKit application with a scene-based lifecycle. `SceneDelegate` owns external URL entry and forwards supported URLs as `NSUserActivity` instances to `WMFAppViewController`.

### URL routing

1. `SceneDelegate.openURLContexts(_:)` receives both cold- and warm-launch custom URLs.
2. It removes the existing analytics `source` query item when present.
3. `NSUserActivity.wmf_activity(forWikipediaScheme:)` maps the `wikipedia://` host to an activity type. The `places` host already mapped to `.places` before this assignment.
4. `WMFAppViewController.processUserActivity(_:animated:completion:)` consumes the activity immediately or stores it in `unprocessedUserActivity` until the UI and migration state are ready.

The production, staging, experimental, and local Info plists already register the `wikipedia` URL scheme. No plist or dependency-management changes were needed.

### Tab routing

`WMFAppViewController` is a `UITabBarController`. `WMFAppTabType.places` has raw index `1`. The existing `.places` activity path dismisses modals, selects that index, and pops the Places navigation controller to its root.

### Places and location flow

`PlacesViewController` owns the map, a `LocationManager`, the active `PlaceSearch`, and the nearby-article search service. On a normal appearance it requests or monitors current-location access. A location callback pans the map once through `panMapToNextLocationUpdate`, then starts the default article search for the resulting region.

The existing `zoomAndPanMapView(toLocation:)` method is the narrow integration point for a caller-supplied location because it applies the same 10 km map region and default Places search used by current-location navigation.

## Implementation

`PlacesDeepLink` is a Foundation-only parser. A valid override requires:

- scheme `wikipedia` or the already-supported `wikipedia-official`;
- host `places`;
- exactly one `lat` value;
- exactly one longitude value named either `lon` or `long`;
- finite numeric values;
- latitude in `-90...90` and longitude in `-180...180`.

Duplicate, missing, malformed, non-finite, or out-of-range coordinates do not create an override. The existing Places activity still handles those URLs, so `wikipedia://places` and invalid coordinate links retain the normal current-location behavior.

For a valid link, `SceneDelegate` stores the parsed coordinate in the routed `NSUserActivity`. `WMFAppViewController` gives that coordinate to `PlacesViewController` before selecting the Places tab. Places then:

- suppresses the automatic current-location recenter;
- avoids prompting for location access solely for this external destination;
- switches to map mode;
- clears the prior Places search;
- pans and searches with the existing region/search methods.

The recenter button clears the external override and returns to the existing current-location flow. A later plain `wikipedia://places` activity also clears the override.

## Tests

Focused tests cover:

- `lon` parsing;
- the `long` alias;
- inclusive coordinate boundaries;
- missing and malformed values;
- non-finite and out-of-range values;
- duplicate/ambiguous query items;
- wrong schemes and hosts;
- the `PlacesDeepLink` to `NSUserActivity` handoff.

Run them with Xcode 26.4:

```sh
cd /Users/arturo/Developer/wki_places_wikipedia/wikipedia-ios
./scripts/setup_bundle_id ci
xcodebuild test \
  -project Wikipedia.xcodeproj \
  -scheme Wikipedia \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.4' \
  -derivedDataPath /tmp/wki_places_wikipedia_derived \
  -only-testing:WikipediaUnitTests/PlacesDeepLinkTests \
  CODE_SIGNING_ALLOWED=NO
```

The imported snapshot intentionally has no nested `.git` directory, so `scripts/setup_bundle_id ci` is the relevant non-interactive bootstrap helper. In a normal standalone upstream clone, follow upstream `README.md` and run `./scripts/setup`; that full script also installs a hook into the clone's `.git` directory.

Build the normal Debug app with:

```sh
xcodebuild build \
  -project Wikipedia.xcodeproj \
  -scheme Wikipedia \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.4' \
  -derivedDataPath /tmp/wki_places_wikipedia_debug
```

Keep the default local simulator signing enabled for the runnable app. Wikipedia uses an app-group container during startup, so an artifact built with `CODE_SIGNING_ALLOWED=NO` is suitable for focused unit tests but not for launch or deep-link verification.

## Manual simulator test

After the Debug build:

```sh
xcrun simctl boot 'iPhone 17 Pro'
xcrun simctl install booted \
  /tmp/wki_places_wikipedia_debug/Build/Products/Debug-iphonesimulator/Wikipedia.app
xcrun simctl openurl booted \
  'wikipedia://places?lat=37.3349&lon=-122.0090'
```

Tap **Open** in the iOS confirmation. On a fresh install, tap **Skip** in Wikipedia's standard onboarding; the pending link then selects Places and centers near Apple Park rather than the simulator's current location. Repeat with the alias:

```sh
xcrun simctl openurl booted \
  'wikipedia://places?lat=51.5007&long=-0.1246'
```

It should center near the Palace of Westminster. Finally, verify normal fallback behavior:

```sh
xcrun simctl openurl booted 'wikipedia://places'
xcrun simctl openurl booted 'wikipedia://places?lat=999&lon=invalid'
```

Both fallback links should open Places without applying an external coordinate override.

## Local verification result

- Toolchain: Xcode 26.4 (`17E192`).
- Project parsing and Swift package resolution: passed.
- Foundation-only parser typecheck: passed.
- Focused unit tests: 8 passed, 0 failed.
- Locally signed Debug simulator build: passed after generating `OpenSourceDebug.xcconfig` with the upstream helper.
- `simctl install`: passed.
- End-to-end Places launcher handoff: passed. The test accepted the iOS confirmation, handled first-run onboarding, selected the Places tab, and verified the Amsterdam map result.
- Existing upstream Swift-concurrency, deprecation, Objective-C protocol, and missing-SwiftLint warnings remain; no new dependency or lint configuration was introduced.
