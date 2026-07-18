import Foundation

protocol StringLocalizing {
    func string(forKey key: String) -> String
}

struct BundleStringLocalizer: StringLocalizing {
    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func string(forKey key: String) -> String {
        bundle.localizedString(forKey: key, value: nil, table: "Localizable")
    }
}

protocol SuggestionCatalogMapping {
    func map(_ dto: SuggestionCatalogDTO) throws -> [SuggestedPlace]
}

enum SuggestionCatalogMappingError: Error, Equatable {
    case unsupportedTone(String)
}

struct SuggestionCatalogMapper: SuggestionCatalogMapping {
    private let localizer: any StringLocalizing

    init(localizer: any StringLocalizing = BundleStringLocalizer()) {
        self.localizer = localizer
    }

    func map(_ dto: SuggestionCatalogDTO) throws -> [SuggestedPlace] {
        try dto.suggestions.map { suggestion in
            try CoordinateValidator.validate(
                latitude: suggestion.latitude,
                longitude: suggestion.longitude
            )
            guard let tone = SuggestionTone(rawValue: suggestion.tone) else {
                throw SuggestionCatalogMappingError.unsupportedTone(suggestion.tone)
            }

            let title = localizer.string(forKey: suggestion.titleKey)
            let locationName = suggestion.locationNameKey.map(localizer.string(forKey:))

            return SuggestedPlace(
                id: suggestion.id,
                title: title,
                subtitle: localizer.string(forKey: suggestion.subtitleKey),
                location: PlaceLocation(
                    name: locationName ?? title,
                    latitude: suggestion.latitude,
                    longitude: suggestion.longitude
                ),
                symbol: suggestion.symbol,
                tone: tone
            )
        }
    }
}
