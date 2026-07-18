import XCTest
@testable import PlacesLauncher

final class SuggestionPickerTests: XCTestCase {
    func testBundledCatalogContainsTwentyNineUniqueValidPlaces() async throws {
        let useCase = DefaultLoadSuggestionsUseCase(
            provider: DefaultLocationsProvider(bundle: .main),
            mapper: SuggestionCatalogMapper(
                localizer: BundleStringLocalizer(bundle: .main)
            )
        )

        let places = try await useCase.execute()

        XCTAssertEqual(places.count, 29)
        XCTAssertEqual(Set(places.map(\.id)).count, places.count)
        for place in places {
            XCTAssertNoThrow(
                try CoordinateValidator.validate(
                    latitude: place.location.latitude,
                    longitude: place.location.longitude
                )
            )
        }
    }

    func testUsesInjectedIndexForDeterministicSurprise() {
        let suggestions = (0..<3).map(makeSuggestion)
        let picker = SuggestionPicker(random: FixedIndexGenerator(index: 1))

        XCTAssertEqual(picker.surprise(from: suggestions), suggestions[1])
    }

    func testReturnsNilForEmptySuggestions() {
        let picker = SuggestionPicker(random: FixedIndexGenerator(index: 0))
        XCTAssertNil(picker.surprise(from: []))
    }

    func testRejectsOutOfBoundsGeneratorValue() {
        let picker = SuggestionPicker(random: FixedIndexGenerator(index: 99))
        XCTAssertNil(picker.surprise(from: [makeSuggestion(0)]))
    }

    private func makeSuggestion(_ index: Int) -> SuggestedPlace {
        SuggestedPlace(
            id: "suggestion-\(index)",
            title: "Suggestion \(index)",
            subtitle: "Subtitle \(index)",
            location: PlaceLocation(
                name: "Suggestion \(index)",
                latitude: Double(index),
                longitude: Double(index)
            ),
            symbol: "star.fill",
            tone: .cyan
        )
    }
}

private struct FixedIndexGenerator: RandomIndexGenerating {
    let index: Int

    func nextIndex(upperBound: Int) -> Int {
        index
    }
}
