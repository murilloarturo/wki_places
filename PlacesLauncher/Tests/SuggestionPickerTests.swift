import XCTest
@testable import PlacesLauncher

final class SuggestionPickerTests: XCTestCase {
    func testCatalogContainsTwentyNineUniqueValidPlaces() {
        let places = SuggestionCatalog.places

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
        let suggestions = Array(SuggestionCatalog.places.prefix(3))
        let picker = SuggestionPicker(random: FixedIndexGenerator(index: 1))

        XCTAssertEqual(picker.surprise(from: suggestions), suggestions[1])
    }

    func testReturnsNilForEmptySuggestions() {
        let picker = SuggestionPicker(random: FixedIndexGenerator(index: 0))
        XCTAssertNil(picker.surprise(from: []))
    }

    func testRejectsOutOfBoundsGeneratorValue() {
        let picker = SuggestionPicker(random: FixedIndexGenerator(index: 99))
        XCTAssertNil(picker.surprise(from: SuggestionCatalog.places))
    }
}

private struct FixedIndexGenerator: RandomIndexGenerating {
    let index: Int

    func nextIndex(upperBound: Int) -> Int {
        index
    }
}
