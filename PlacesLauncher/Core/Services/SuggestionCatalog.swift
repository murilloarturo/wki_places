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
        ),
        SuggestedPlace(
            title: L10n.Suggestions.Socotra.title,
            subtitle: L10n.Suggestions.Socotra.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.Socotra.title, latitude: 12.51000, longitude: 53.92000),
            symbol: "tree.fill",
            tone: .cyan
        ),
        SuggestedPlace(
            title: L10n.Suggestions.SalarDeUyuni.title,
            subtitle: L10n.Suggestions.SalarDeUyuni.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.SalarDeUyuni.title, latitude: -20.33333, longitude: -67.70000),
            symbol: "hexagon.fill",
            tone: .yellow
        ),
        SuggestedPlace(
            title: L10n.Suggestions.ParisCatacombs.title,
            subtitle: L10n.Suggestions.ParisCatacombs.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.ParisCatacombs.title, latitude: 48.83389, longitude: 2.33222),
            symbol: "skull.fill",
            tone: .magenta
        ),
        SuggestedPlace(
            title: L10n.Suggestions.Hashima.title,
            subtitle: L10n.Suggestions.Hashima.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.Hashima.title, latitude: 32.62778, longitude: 129.73833),
            symbol: "building.2.fill",
            tone: .mint
        ),
        SuggestedPlace(
            title: L10n.Suggestions.AntelopeCanyon.title,
            subtitle: L10n.Suggestions.AntelopeCanyon.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.AntelopeCanyon.title, latitude: 36.86196, longitude: -111.37434),
            symbol: "camera.aperture",
            tone: .cyan
        ),
        SuggestedPlace(
            title: L10n.Suggestions.FlyGeyser.title,
            subtitle: L10n.Suggestions.FlyGeyser.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.FlyGeyser.title, latitude: 40.85944, longitude: -119.33194),
            symbol: "drop.fill",
            tone: .magenta
        ),
        SuggestedPlace(
            title: L10n.Suggestions.CrookedForest.title,
            subtitle: L10n.Suggestions.CrookedForest.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.CrookedForest.title, latitude: 53.21389, longitude: 14.47500),
            symbol: "tree.fill",
            tone: .mint
        ),
        SuggestedPlace(
            title: L10n.Suggestions.LakeHillier.title,
            subtitle: L10n.Suggestions.LakeHillier.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.LakeHillier.title, latitude: -34.09583, longitude: 123.20278),
            symbol: "water.waves",
            tone: .magenta
        ),
        SuggestedPlace(
            title: L10n.Suggestions.NazcaLines.title,
            subtitle: L10n.Suggestions.NazcaLines.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.NazcaLines.title, latitude: -14.69750, longitude: -75.13500),
            symbol: "scribble.variable",
            tone: .yellow
        ),
        SuggestedPlace(
            title: L10n.Suggestions.GreatBlueHole.title,
            subtitle: L10n.Suggestions.GreatBlueHole.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.GreatBlueHole.title, latitude: 17.31528, longitude: -87.53444),
            symbol: "circle.dashed",
            tone: .cyan
        ),
        SuggestedPlace(
            title: L10n.Suggestions.Pripyat.title,
            subtitle: L10n.Suggestions.Pripyat.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.Pripyat.title, latitude: 51.40472, longitude: 30.05694),
            symbol: "exclamationmark.triangle.fill",
            tone: .yellow
        ),
        SuggestedPlace(
            title: L10n.Suggestions.Aogashima.title,
            subtitle: L10n.Suggestions.Aogashima.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.Aogashima.title, latitude: 32.45700, longitude: 139.76700),
            symbol: "mountain.2.fill",
            tone: .mint
        ),
        SuggestedPlace(
            title: L10n.Suggestions.GiantsCauseway.title,
            subtitle: L10n.Suggestions.GiantsCauseway.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.GiantsCauseway.title, latitude: 55.24083, longitude: -6.51167),
            symbol: "square.3.layers.3d",
            tone: .cyan
        ),
        SuggestedPlace(
            title: L10n.Suggestions.Pamukkale.title,
            subtitle: L10n.Suggestions.Pamukkale.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.Pamukkale.title, latitude: 37.92389, longitude: 29.12333),
            symbol: "cloud.fill",
            tone: .mint
        ),
        SuggestedPlace(
            title: L10n.Suggestions.LencoisMaranhenses.title,
            subtitle: L10n.Suggestions.LencoisMaranhenses.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.LencoisMaranhenses.title, latitude: -2.48333, longitude: -43.13333),
            symbol: "wind",
            tone: .yellow
        ),
        SuggestedPlace(
            title: L10n.Suggestions.Waitomo.title,
            subtitle: L10n.Suggestions.Waitomo.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.Waitomo.title, latitude: -38.26080, longitude: 175.10360),
            symbol: "sparkle",
            tone: .cyan
        ),
        SuggestedPlace(
            title: L10n.Suggestions.ThorsWell.title,
            subtitle: L10n.Suggestions.ThorsWell.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.ThorsWell.title, latitude: 44.27843, longitude: -124.11351),
            symbol: "hurricane",
            tone: .magenta
        ),
        SuggestedPlace(
            title: L10n.Suggestions.MaunsellForts.title,
            subtitle: L10n.Suggestions.MaunsellForts.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.MaunsellForts.title, latitude: 51.89519, longitude: 1.48057),
            symbol: "shield.lefthalf.filled",
            tone: .yellow
        ),
        SuggestedPlace(
            title: L10n.Suggestions.MountRoraima.title,
            subtitle: L10n.Suggestions.MountRoraima.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.MountRoraima.title, latitude: 5.14333, longitude: -60.76250),
            symbol: "mountain.2.fill",
            tone: .mint
        ),
        SuggestedPlace(
            title: L10n.Suggestions.ZhangyeDanxia.title,
            subtitle: L10n.Suggestions.ZhangyeDanxia.subtitle,
            location: PlaceLocation(name: L10n.Suggestions.ZhangyeDanxia.title, latitude: 38.91944, longitude: 100.13333),
            symbol: "paintpalette.fill",
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
