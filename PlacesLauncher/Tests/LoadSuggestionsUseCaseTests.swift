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
        let provider = StubSuggestionCatalogProvider(result: .success(dto))
        let mapper = StubSuggestionCatalogMapper(result: .success(expected))
        let useCase = DefaultLoadSuggestionsUseCase(provider: provider, mapper: mapper)

        let suggestions = try await useCase.execute()

        XCTAssertEqual(suggestions, expected)
        XCTAssertEqual(provider.callCount, 1)
        XCTAssertEqual(mapper.receivedDTOs, [dto])
    }

    func testPropagatesProviderFailureWithoutMapping() async {
        let provider = StubSuggestionCatalogProvider(
            result: .failure(LocalSuggestionCatalogProviderError.decodingFailed)
        )
        let mapper = StubSuggestionCatalogMapper(result: .success([]))
        let useCase = DefaultLoadSuggestionsUseCase(provider: provider, mapper: mapper)

        do {
            _ = try await useCase.execute()
            XCTFail("Expected the provider error")
        } catch {
            XCTAssertEqual(
                error as? LocalSuggestionCatalogProviderError,
                .decodingFailed
            )
            XCTAssertTrue(mapper.receivedDTOs.isEmpty)
        }
    }
}

private final class StubSuggestionCatalogProvider: SuggestionCatalogProviding {
    let result: Result<SuggestionCatalogDTO, Error>
    private(set) var callCount = 0

    init(result: Result<SuggestionCatalogDTO, Error>) {
        self.result = result
    }

    func fetchCatalog() async throws -> SuggestionCatalogDTO {
        callCount += 1
        return try result.get()
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
