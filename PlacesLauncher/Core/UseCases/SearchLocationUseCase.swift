import Foundation

protocol SearchLocationUseCase {
    func execute(query: String) async throws -> PlaceSearchResult
}

struct DefaultSearchLocationUseCase: SearchLocationUseCase {
    private let locationSearcher: any LocationSearching

    init(locationSearcher: any LocationSearching) {
        self.locationSearcher = locationSearcher
    }

    func execute(query: String) async throws -> PlaceSearchResult {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            throw LocationSearchError.emptyQuery
        }
        return try await locationSearcher.search(query: trimmedQuery)
    }
}
