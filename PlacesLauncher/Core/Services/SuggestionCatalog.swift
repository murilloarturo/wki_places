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
            title: "Apple Park",
            subtitle: "Cupertino's spaceship campus",
            location: PlaceLocation(name: "Apple Park", latitude: 37.33489, longitude: -122.00899),
            symbol: "apple.logo",
            tone: .cyan
        ),
        SuggestedPlace(
            title: "Area 51",
            subtitle: "Restricted desert airfield",
            location: PlaceLocation(name: "Area 51", latitude: 37.23500, longitude: -115.81111),
            symbol: "sparkles",
            tone: .magenta
        ),
        SuggestedPlace(
            title: "CERN",
            subtitle: "Large Hadron Collider",
            location: PlaceLocation(name: "CERN", latitude: 46.23300, longitude: 6.05580),
            symbol: "atom",
            tone: .yellow
        ),
        SuggestedPlace(
            title: "Rapa Nui",
            subtitle: "Island of the moai",
            location: PlaceLocation(name: "Rapa Nui", latitude: -27.11272, longitude: -109.34969),
            symbol: "face.smiling.inverse",
            tone: .mint
        ),
        SuggestedPlace(
            title: "Svalbard Seed Vault",
            subtitle: "Arctic crop time capsule",
            location: PlaceLocation(name: "Svalbard Global Seed Vault", latitude: 78.23583, longitude: 15.49194),
            symbol: "leaf.fill",
            tone: .cyan
        ),
        SuggestedPlace(
            title: "Point Nemo",
            subtitle: "Oceanic pole of inaccessibility",
            location: PlaceLocation(name: "Point Nemo", latitude: -48.87630, longitude: -123.39330),
            symbol: "water.waves",
            tone: .magenta
        ),
        SuggestedPlace(
            title: "Null Island",
            subtitle: "Where zero meets zero",
            location: PlaceLocation(name: "Null Island", latitude: 0, longitude: 0),
            symbol: "scope",
            tone: .yellow
        ),
        SuggestedPlace(
            title: "Bermuda Triangle",
            subtitle: "North Atlantic mystery zone",
            location: PlaceLocation(name: "Bermuda Triangle", latitude: 25, longitude: -71),
            symbol: "triangle.fill",
            tone: .mint
        ),
        SuggestedPlace(
            title: "Darvaza Crater",
            subtitle: "The Door to Hell",
            location: PlaceLocation(name: "Darvaza gas crater", latitude: 40.25250, longitude: 58.43960),
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

