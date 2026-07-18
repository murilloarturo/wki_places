@testable import PlacesLauncher

final class StubLocationsProvider: LocationsProviding {
    let feedResult: Result<LocationFeedDTO, Error>
    let catalogResult: Result<SuggestionCatalogDTO, Error>
    private(set) var feedCallCount = 0
    private(set) var catalogCallCount = 0

    init(
        feedResult: Result<LocationFeedDTO, Error> = .success(
            LocationFeedDTO(locations: [])
        ),
        catalogResult: Result<SuggestionCatalogDTO, Error> = .success(
            SuggestionCatalogDTO(suggestions: [])
        )
    ) {
        self.feedResult = feedResult
        self.catalogResult = catalogResult
    }

    func fetchFeed() async throws -> LocationFeedDTO {
        feedCallCount += 1
        return try feedResult.get()
    }

    func fetchCatalog() async throws -> SuggestionCatalogDTO {
        catalogCallCount += 1
        return try catalogResult.get()
    }
}
