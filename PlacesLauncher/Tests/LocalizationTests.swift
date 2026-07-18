import XCTest
@testable import PlacesLauncher

final class LocalizationTests: XCTestCase {
    func testSpanishCatalogContainsEveryEnglishKey() throws {
        let english = try catalog(language: "en")
        let spanish = try catalog(language: "es")

        XCTAssertEqual(Set(spanish.keys), Set(english.keys))
    }

    func testGeneratedAccessorsResolveSourceStrings() {
        XCTAssertEqual(L10n.Home.title, "Places")
        XCTAssertEqual(L10n.Feed.Error.httpStatus(503), "The locations service returned status 503.")
    }

    private func catalog(language: String) throws -> [String: String] {
        let url = try XCTUnwrap(
            Bundle.main.url(
                forResource: "Localizable",
                withExtension: "strings",
                subdirectory: nil,
                localization: language
            )
        )
        let data = try Data(contentsOf: url)
        return try XCTUnwrap(
            PropertyListSerialization.propertyList(from: data, format: nil) as? [String: String]
        )
    }
}
