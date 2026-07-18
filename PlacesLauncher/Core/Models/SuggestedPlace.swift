enum SuggestionTone: String, CaseIterable, Hashable, Sendable {
    case cyan
    case magenta
    case yellow
    case mint
}

struct SuggestedPlace: Identifiable, Equatable, Hashable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let location: PlaceLocation
    let symbol: String
    let tone: SuggestionTone
}
