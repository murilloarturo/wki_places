import XCTest
@testable import PlacesLauncher

final class SuggestionCatalogMapperTests: XCTestCase {
    func testMapsLocalizedDTOIntoDomainSuggestion() throws {
        let mapper = SuggestionCatalogMapper(
            localizer: StubStringLocalizer(strings: [
                "place.title": "Seed Vault",
                "place.subtitle": "Arctic archive",
                "place.location": "Svalbard Global Seed Vault"
            ])
        )
        let dto = SuggestionCatalogDTO(suggestions: [
            SuggestionDTO(
                id: "seed-vault",
                titleKey: "place.title",
                subtitleKey: "place.subtitle",
                locationNameKey: "place.location",
                latitude: 78.23583,
                longitude: 15.49194,
                symbol: "leaf.fill",
                tone: "mint"
            )
        ])

        let suggestions = try mapper.map(dto)

        XCTAssertEqual(suggestions, [
            SuggestedPlace(
                id: "seed-vault",
                title: "Seed Vault",
                subtitle: "Arctic archive",
                location: PlaceLocation(
                    name: "Svalbard Global Seed Vault",
                    latitude: 78.23583,
                    longitude: 15.49194
                ),
                symbol: "leaf.fill",
                tone: .mint
            )
        ])
    }

    func testRejectsUnsupportedTone() {
        let mapper = SuggestionCatalogMapper(localizer: StubStringLocalizer(strings: [:]))
        let dto = SuggestionCatalogDTO(suggestions: [
            SuggestionDTO(
                id: "unknown",
                titleKey: "title",
                subtitleKey: "subtitle",
                locationNameKey: nil,
                latitude: 0,
                longitude: 0,
                symbol: "questionmark",
                tone: "ultraviolet"
            )
        ])

        XCTAssertThrowsError(try mapper.map(dto)) { error in
            XCTAssertEqual(
                error as? SuggestionCatalogMappingError,
                .unsupportedTone("ultraviolet")
            )
        }
    }
}

private struct StubStringLocalizer: StringLocalizing {
    let strings: [String: String]

    func string(forKey key: String) -> String {
        strings[key] ?? key
    }
}
