import XCTest
@testable import PlacesLauncher

final class LocalSuggestionCatalogProviderTests: XCTestCase {
    func testLoadsAndDecodesBundledJSON() async throws {
        let provider = LocalSuggestionCatalogProvider(
            bundle: Bundle(for: LocalSuggestionCatalogProviderTests.self)
        )

        let catalog = try await provider.fetchCatalog()

        XCTAssertEqual(catalog.suggestions, [
            SuggestionDTO(
                id: "test-place",
                titleKey: "test.title",
                subtitleKey: "test.subtitle",
                locationNameKey: nil,
                latitude: 1.25,
                longitude: 2.5,
                symbol: "star.fill",
                tone: "cyan"
            )
        ])
    }

    func testMissingResourceProducesClearError() async {
        let provider = LocalSuggestionCatalogProvider(
            bundle: Bundle(for: LocalSuggestionCatalogProviderTests.self),
            resourceName: "missing-suggestions"
        )

        do {
            _ = try await provider.fetchCatalog()
            XCTFail("Expected a missing resource error")
        } catch {
            XCTAssertEqual(
                error as? LocalSuggestionCatalogProviderError,
                .missingResource("missing-suggestions")
            )
        }
    }
}
