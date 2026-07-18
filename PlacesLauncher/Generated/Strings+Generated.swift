// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Common {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "common.cancel", fallback: "Cancel")
    /// OK
    internal static let ok = L10n.tr("Localizable", "common.ok", fallback: "OK")
  }
  internal enum Coordinate {
    internal enum Error {
      /// Latitude must be between -90 and 90.
      internal static let latitude = L10n.tr("Localizable", "coordinate.error.latitude", fallback: "Latitude must be between -90 and 90.")
      /// Longitude must be between -180 and 180.
      internal static let longitude = L10n.tr("Localizable", "coordinate.error.longitude", fallback: "Longitude must be between -180 and 180.")
      /// The selected coordinate is not valid.
      internal static let nonFinite = L10n.tr("Localizable", "coordinate.error.non_finite", fallback: "The selected coordinate is not valid.")
    }
  }
  internal enum Custom {
    /// Dropped Pin
    internal static let droppedPin = L10n.tr("Localizable", "custom.dropped_pin", fallback: "Dropped Pin")
    /// Dropped pin
    internal static let droppedPinName = L10n.tr("Localizable", "custom.dropped_pin_name", fallback: "Dropped pin")
    /// Move the map to select
    internal static let moveMapToSelect = L10n.tr("Localizable", "custom.move_map_to_select", fallback: "Move the map to select")
    /// Open in Wikipedia
    internal static let openWikipedia = L10n.tr("Localizable", "custom.open_wikipedia", fallback: "Open in Wikipedia")
    /// search result
    internal static let searchResult = L10n.tr("Localizable", "custom.search_result", fallback: "search result")
    /// Choose on Map
    internal static let title = L10n.tr("Localizable", "custom.title", fallback: "Choose on Map")
    internal enum Accessibility {
      /// Clear search
      internal static let clearSearch = L10n.tr("Localizable", "custom.accessibility.clear_search", fallback: "Clear search")
      /// Confirms this coordinate and opens Wikipedia Places
      internal static let confirmHint = L10n.tr("Localizable", "custom.accessibility.confirm_hint", fallback: "Confirms this coordinate and opens Wikipedia Places")
      /// Map moved to %@
      internal static func mapMoved(_ p1: Any) -> String {
        return L10n.tr("Localizable", "custom.accessibility.map_moved", String(describing: p1), fallback: "Map moved to %@")
      }
      /// Selection pin
      internal static let pinLabel = L10n.tr("Localizable", "custom.accessibility.pin_label", fallback: "Selection pin")
      /// The coordinate at the center of the map will be selected
      internal static let pinValue = L10n.tr("Localizable", "custom.accessibility.pin_value", fallback: "The coordinate at the center of the map will be selected")
      /// Search
      internal static let search = L10n.tr("Localizable", "custom.accessibility.search", fallback: "Search")
      /// Enter a city, landmark, or address
      internal static let searchHint = L10n.tr("Localizable", "custom.accessibility.search_hint", fallback: "Enter a city, landmark, or address")
      /// Searching Apple Maps
      internal static let searching = L10n.tr("Localizable", "custom.accessibility.searching", fallback: "Searching Apple Maps")
      /// Selected %@, coordinates %@
      internal static func selected(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "custom.accessibility.selected", String(describing: p1), String(describing: p2), fallback: "Selected %@, coordinates %@")
      }
    }
    internal enum Error {
      /// Move the map or search for a place before confirming.
      internal static let noSelection = L10n.tr("Localizable", "custom.error.no_selection", fallback: "Move the map or search for a place before confirming.")
    }
    internal enum Search {
      /// Search for a place
      internal static let placeholder = L10n.tr("Localizable", "custom.search.placeholder", fallback: "Search for a place")
    }
  }
  internal enum Feed {
    /// Loading locations...
    internal static let loading = L10n.tr("Localizable", "feed.loading", fallback: "Loading locations...")
    /// Try Again
    internal static let retry = L10n.tr("Localizable", "feed.retry", fallback: "Try Again")
    /// FROM THE FEED
    internal static let title = L10n.tr("Localizable", "feed.title", fallback: "FROM THE FEED")
    internal enum Empty {
      /// The feed is currently empty.
      internal static let description = L10n.tr("Localizable", "feed.empty.description", fallback: "The feed is currently empty.")
      /// No Locations
      internal static let title = L10n.tr("Localizable", "feed.empty.title", fallback: "No Locations")
    }
    internal enum Error {
      /// The locations could not be read.
      internal static let decoding = L10n.tr("Localizable", "feed.error.decoding", fallback: "The locations could not be read.")
      /// The locations could not be loaded.
      internal static let fallback = L10n.tr("Localizable", "feed.error.fallback", fallback: "The locations could not be loaded.")
      /// The locations service returned status %d.
      internal static func httpStatus(_ p1: Int) -> String {
        return L10n.tr("Localizable", "feed.error.http_status", p1, fallback: "The locations service returned status %d.")
      }
      /// The locations service returned an invalid response.
      internal static let invalidResponse = L10n.tr("Localizable", "feed.error.invalid_response", fallback: "The locations service returned an invalid response.")
      /// Locations Unavailable
      internal static let title = L10n.tr("Localizable", "feed.error.title", fallback: "Locations Unavailable")
    }
  }
  internal enum Home {
    /// Where should Wikipedia take you?
    internal static let subtitle = L10n.tr("Localizable", "home.subtitle", fallback: "Where should Wikipedia take you?")
    /// Places
    internal static let title = L10n.tr("Localizable", "home.title", fallback: "Places")
    internal enum Bonus {
      /// Opens the retro suggestions map
      internal static let accessibilityHint = L10n.tr("Localizable", "home.bonus.accessibility_hint", fallback: "Opens the retro suggestions map")
      /// BONUS MAP
      internal static let eyebrow = L10n.tr("Localizable", "home.bonus.eyebrow", fallback: "BONUS MAP")
      /// 9 curious destinations
      internal static let subtitle = L10n.tr("Localizable", "home.bonus.subtitle", fallback: "9 curious destinations")
      /// Explore unusual places
      internal static let title = L10n.tr("Localizable", "home.bonus.title", fallback: "Explore unusual places")
    }
    internal enum ChooseMap {
      /// Search for a place or choose a coordinate on Apple Maps
      internal static let accessibilityHint = L10n.tr("Localizable", "home.choose_map.accessibility_hint", fallback: "Search for a place or choose a coordinate on Apple Maps")
      /// Search or drop a pin
      internal static let subtitle = L10n.tr("Localizable", "home.choose_map.subtitle", fallback: "Search or drop a pin")
      /// Choose on Map
      internal static let title = L10n.tr("Localizable", "home.choose_map.title", fallback: "Choose on Map")
    }
  }
  internal enum Location {
    /// Unnamed location
    internal static let unnamed = L10n.tr("Localizable", "location.unnamed", fallback: "Unnamed location")
    internal enum Accessibility {
      /// %@, coordinates %@
      internal static func label(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "location.accessibility.label", String(describing: p1), String(describing: p2), fallback: "%@, coordinates %@")
      }
      /// Opens this location in Wikipedia Places
      internal static let openHint = L10n.tr("Localizable", "location.accessibility.open_hint", fallback: "Opens this location in Wikipedia Places")
    }
  }
  internal enum Search {
    internal enum Error {
      /// Enter a place to search for.
      internal static let empty = L10n.tr("Localizable", "search.error.empty", fallback: "Enter a place to search for.")
      /// No matching place was found. Try a more specific search.
      internal static let noResults = L10n.tr("Localizable", "search.error.no_results", fallback: "No matching place was found. Try a more specific search.")
      /// Apple Maps search is unavailable right now.
      internal static let unavailable = L10n.tr("Localizable", "search.error.unavailable", fallback: "Apple Maps search is unavailable right now.")
    }
  }
  internal enum Suggestions {
    /// BACK
    internal static let back = L10n.tr("Localizable", "suggestions.back", fallback: "BACK")
    /// CURIOUS COORDINATES // 09
    internal static let coordinateCount = L10n.tr("Localizable", "suggestions.coordinate_count", fallback: "CURIOUS COORDINATES // 09")
    /// GO
    internal static let go = L10n.tr("Localizable", "suggestions.go", fallback: "GO")
    /// RANDOM DESTINATION
    internal static let randomDestination = L10n.tr("Localizable", "suggestions.random_destination", fallback: "RANDOM DESTINATION")
    /// SELECT A LEVEL
    internal static let selectLevel = L10n.tr("Localizable", "suggestions.select_level", fallback: "SELECT A LEVEL")
    /// SURPRISE ME
    internal static let surprise = L10n.tr("Localizable", "suggestions.surprise", fallback: "SURPRISE ME")
    internal enum Accessibility {
      /// Returns to Places with the standard appearance
      internal static let backHint = L10n.tr("Localizable", "suggestions.accessibility.back_hint", fallback: "Returns to Places with the standard appearance")
      /// Opens one of the unusual places at random
      internal static let surpriseHint = L10n.tr("Localizable", "suggestions.accessibility.surprise_hint", fallback: "Opens one of the unusual places at random")
      /// %@, %@, coordinates %@
      internal static func tile(_ p1: Any, _ p2: Any, _ p3: Any) -> String {
        return L10n.tr("Localizable", "suggestions.accessibility.tile", String(describing: p1), String(describing: p2), String(describing: p3), fallback: "%@, %@, coordinates %@")
      }
    }
    internal enum ApplePark {
      /// Cupertino's spaceship campus
      internal static let subtitle = L10n.tr("Localizable", "suggestions.apple_park.subtitle", fallback: "Cupertino's spaceship campus")
      /// Apple Park
      internal static let title = L10n.tr("Localizable", "suggestions.apple_park.title", fallback: "Apple Park")
    }
    internal enum Area51 {
      /// Restricted desert airfield
      internal static let subtitle = L10n.tr("Localizable", "suggestions.area_51.subtitle", fallback: "Restricted desert airfield")
      /// Area 51
      internal static let title = L10n.tr("Localizable", "suggestions.area_51.title", fallback: "Area 51")
    }
    internal enum BermudaTriangle {
      /// North Atlantic mystery zone
      internal static let subtitle = L10n.tr("Localizable", "suggestions.bermuda_triangle.subtitle", fallback: "North Atlantic mystery zone")
      /// Bermuda Triangle
      internal static let title = L10n.tr("Localizable", "suggestions.bermuda_triangle.title", fallback: "Bermuda Triangle")
    }
    internal enum Cern {
      /// Large Hadron Collider
      internal static let subtitle = L10n.tr("Localizable", "suggestions.cern.subtitle", fallback: "Large Hadron Collider")
      /// CERN
      internal static let title = L10n.tr("Localizable", "suggestions.cern.title", fallback: "CERN")
    }
    internal enum Darvaza {
      /// Darvaza gas crater
      internal static let locationName = L10n.tr("Localizable", "suggestions.darvaza.location_name", fallback: "Darvaza gas crater")
      /// The Door to Hell
      internal static let subtitle = L10n.tr("Localizable", "suggestions.darvaza.subtitle", fallback: "The Door to Hell")
      /// Darvaza Crater
      internal static let title = L10n.tr("Localizable", "suggestions.darvaza.title", fallback: "Darvaza Crater")
    }
    internal enum Error {
      /// No destinations are available.
      internal static let empty = L10n.tr("Localizable", "suggestions.error.empty", fallback: "No destinations are available.")
      /// Wikipedia could not be opened.
      internal static let fallback = L10n.tr("Localizable", "suggestions.error.fallback", fallback: "Wikipedia could not be opened.")
      /// MISSION FAILED
      internal static let title = L10n.tr("Localizable", "suggestions.error.title", fallback: "MISSION FAILED")
    }
    internal enum NullIsland {
      /// Where zero meets zero
      internal static let subtitle = L10n.tr("Localizable", "suggestions.null_island.subtitle", fallback: "Where zero meets zero")
      /// Null Island
      internal static let title = L10n.tr("Localizable", "suggestions.null_island.title", fallback: "Null Island")
    }
    internal enum PointNemo {
      /// Oceanic pole of inaccessibility
      internal static let subtitle = L10n.tr("Localizable", "suggestions.point_nemo.subtitle", fallback: "Oceanic pole of inaccessibility")
      /// Point Nemo
      internal static let title = L10n.tr("Localizable", "suggestions.point_nemo.title", fallback: "Point Nemo")
    }
    internal enum RapaNui {
      /// Island of the moai
      internal static let subtitle = L10n.tr("Localizable", "suggestions.rapa_nui.subtitle", fallback: "Island of the moai")
      /// Rapa Nui
      internal static let title = L10n.tr("Localizable", "suggestions.rapa_nui.title", fallback: "Rapa Nui")
    }
    internal enum Svalbard {
      /// Svalbard Global Seed Vault
      internal static let locationName = L10n.tr("Localizable", "suggestions.svalbard.location_name", fallback: "Svalbard Global Seed Vault")
      /// Arctic crop time capsule
      internal static let subtitle = L10n.tr("Localizable", "suggestions.svalbard.subtitle", fallback: "Arctic crop time capsule")
      /// Svalbard Seed Vault
      internal static let title = L10n.tr("Localizable", "suggestions.svalbard.title", fallback: "Svalbard Seed Vault")
    }
  }
  internal enum Wikipedia {
    internal enum Error {
      /// Wikipedia could not be opened. Make sure the assignment build is installed.
      internal static let couldNotOpen = L10n.tr("Localizable", "wikipedia.error.could_not_open", fallback: "Wikipedia could not be opened. Make sure the assignment build is installed.")
      /// Please try again.
      internal static let fallback = L10n.tr("Localizable", "wikipedia.error.fallback", fallback: "Please try again.")
      /// That coordinate cannot be opened.
      internal static let invalidCoordinate = L10n.tr("Localizable", "wikipedia.error.invalid_coordinate", fallback: "That coordinate cannot be opened.")
      /// Couldn't Open Wikipedia
      internal static let title = L10n.tr("Localizable", "wikipedia.error.title", fallback: "Couldn't Open Wikipedia")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
