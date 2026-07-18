import Foundation

protocol LocationsProviding {
    func fetchFeed() async throws -> LocationFeedDTO
    func fetchCatalog() async throws -> SuggestionCatalogDTO
}

enum LocationsProviderError: Error, Equatable {
    case missingResource(String)
    case decodingFailed
}

struct DefaultLocationsProvider: LocationsProviding {
    private let httpClient: any HTTPClient
    private let feedEndpoint: HTTPEndpoint
    private let bundle: Bundle
    private let catalogResourceName: String
    private let decoder: JSONDecoder

    init(
        httpClient: any HTTPClient = JSONHTTPClient(),
        feedEndpoint: HTTPEndpoint = LocationFeedEndpoint.assignment,
        bundle: Bundle = .main,
        catalogResourceName: String = "suggestions",
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.httpClient = httpClient
        self.feedEndpoint = feedEndpoint
        self.bundle = bundle
        self.catalogResourceName = catalogResourceName
        self.decoder = decoder
    }

    func fetchFeed() async throws -> LocationFeedDTO {
        try await httpClient.fetch(LocationFeedDTO.self, from: feedEndpoint)
    }

    func fetchCatalog() async throws -> SuggestionCatalogDTO {
        guard let url = bundle.url(
            forResource: catalogResourceName,
            withExtension: "json"
        ) else {
            throw LocationsProviderError.missingResource(catalogResourceName)
        }

        let data = try Data(contentsOf: url)
        do {
            return try decoder.decode(SuggestionCatalogDTO.self, from: data)
        } catch {
            throw LocationsProviderError.decodingFailed
        }
    }
}
