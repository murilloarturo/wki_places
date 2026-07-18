import XCTest
@testable import PlacesLauncher

final class LoadSuggestionsUseCaseTests: XCTestCase {
    func testLoadsCatalogFromProviderAndReturnsMappedSuggestions() async throws {
        let dto = SuggestionCatalogDTO(suggestions: [])
        let expected = [
            SuggestedPlace(
                id: "mapped",
                title: "Mapped",
                subtitle: "Mapped subtitle",
                location: PlaceLocation(name: "Mapped", latitude: 1, longitude: 2),
                symbol: "star.fill",
                tone: .cyan
            )
        ]
        let provider = StubLocationsProvider(catalogResult: .success(dto))
        let mapper = StubSuggestionCatalogMapper(result: .success(expected))
        let useCase = DefaultLoadSuggestionsUseCase(provider: provider, mapper: mapper)

        let suggestions = try await useCase.execute()

        XCTAssertEqual(suggestions, expected)
        XCTAssertEqual(provider.catalogCallCount, 1)
        XCTAssertEqual(provider.feedCallCount, 0)
        XCTAssertEqual(mapper.receivedDTOs, [dto])
    }

    func testPropagatesProviderFailureWithoutMapping() async {
        let provider = StubLocationsProvider(
            catalogResult: .failure(LocationsProviderError.decodingFailed)
        )
        let mapper = StubSuggestionCatalogMapper(result: .success([]))
        let useCase = DefaultLoadSuggestionsUseCase(provider: provider, mapper: mapper)

        do {
            _ = try await useCase.execute()
            XCTFail("Expected the provider error")
        } catch {
            XCTAssertEqual(
                error as? LocationsProviderError,
                .decodingFailed
            )
            XCTAssertTrue(mapper.receivedDTOs.isEmpty)
        }
    }
}

private final class StubSuggestionCatalogMapper: SuggestionCatalogMapping {
    let result: Result<[SuggestedPlace], Error>
    private(set) var receivedDTOs: [SuggestionCatalogDTO] = []

    init(result: Result<[SuggestedPlace], Error>) {
        self.result = result
    }

    func map(_ dto: SuggestionCatalogDTO) throws -> [SuggestedPlace] {
        receivedDTOs.append(dto)
        return try result.get()
    }
}
