import Foundation

enum SuggestionTone: CaseIterable, Hashable, Sendable {
    case cyan
    case magenta
    case yellow
    case mint
}

struct SuggestedPlace: Identifiable, Equatable, Hashable, Sendable {
    let title: String
    let subtitle: String
    let location: PlaceLocation
    let symbol: String
    let tone: SuggestionTone

    var id: String { title }
}

enum SuggestionCatalog {
    static let places: [SuggestedPlace] = [
        SuggestedPlace(
            title: L10n.Suggestions.ApplePark.title,
            subtitle: L10n.Suggestions.ApplePark.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.ApplePark.title, latitude: 37.33489, longitude: -122.00899),
            symbol: "apple.logo",
            tone: .cyan
        ),
        SuggestedPlace(
            title: L10n.Suggestions.Area51.title,
            subtitle: L10n.Suggestions.Area51.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.Area51.title, latitude: 37.23500, longitude: -115.81111),
            symbol: "sparkles",
            tone: .magenta
        ),
        SuggestedPlace(
            title: L10n.Suggestions.Cern.title,
            subtitle: L10n.Suggestions.Cern.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.Cern.title, latitude: 46.23300, longitude: 6.05580),
            symbol: "atom",
            tone: .yellow
        ),
        SuggestedPlace(
            title: L10n.Suggestions.RapaNui.title,
            subtitle: L10n.Suggestions.RapaNui.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.RapaNui.title, latitude: -27.11272, longitude: -109.34969),
            symbol: "face.smiling.inverse",
            tone: .mint
        ),
        SuggestedPlace(
            title: L10n.Suggestions.Svalbard.title,
            subtitle: L10n.Suggestions.Svalbard.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.Svalbard.locationName, latitude: 78.23583, longitude: 15.49194),
            symbol: "leaf.fill",
            tone: .cyan
        ),
        SuggestedPlace(
            title: L10n.Suggestions.PointNemo.title,
            subtitle: L10n.Suggestions.PointNemo.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.PointNemo.title, latitude: -48.87630, longitude: -123.39330),
            symbol: "water.waves",
            tone: .magenta
        ),
        SuggestedPlace(
            title: L10n.Suggestions.NullIsland.title,
            subtitle: L10n.Suggestions.NullIsland.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.NullIsland.title, latitude: 0, longitude: 0),
            symbol: "scope",
            tone: .yellow
        ),
        SuggestedPlace(
            title: L10n.Suggestions.BermudaTriangle.title,
            subtitle: L10n.Suggestions.BermudaTriangle.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.BermudaTriangle.title, latitude: 25, longitude: -71),
            symbol: "triangle.fill",
            tone: .mint
        ),
        SuggestedPlace(
            title: L10n.Suggestions.Darvaza.title,
            subtitle: L10n.Suggestions.Darvaza.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.Darvaza.locationName, latitude: 40.25250, longitude: 58.43960),
            symbol: "flame.fill",
            tone: .magenta
        )
    ]
}

protocol RandomIndexGenerating {
    func nextIndex(upperBound: Int) -> Int
}

struct SystemRandomIndexGenerator: RandomIndexGenerating {
    func nextIndex(upperBound: Int) -> Int {
        Int.random(in: 0..<upperBound)
    }
}

struct SuggestionPicker {
    private let random: any RandomIndexGenerating

    init(random: any RandomIndexGenerating = SystemRandomIndexGenerator()) {
        self.random = random
    }

    func surprise(from suggestions: [SuggestedPlace]) -> SuggestedPlace? {
        guard !suggestions.isEmpty else { return nil }
        let index = random.nextIndex(upperBound: suggestions.count)
        guard suggestions.indices.contains(index) else { return nil }
        return suggestions[index]
    }
}
