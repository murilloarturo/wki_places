import XCTest
@testable import PlacesLauncher

final class SuggestionPickerTests: XCTestCase {
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

