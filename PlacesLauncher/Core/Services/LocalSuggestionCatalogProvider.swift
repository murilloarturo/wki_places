import Foundation

protocol SuggestionCatalogProviding {
    func fetchCatalog() async throws -> SuggestionCatalogDTO
}

enum LocalSuggestionCatalogProviderError: Error, Equatable {
    case missingResource(String)
    case decodingFailed
}

struct LocalSuggestionCatalogProvider: SuggestionCatalogProviding {
    private let bundle: Bundle
    private let resourceName: String
    private let decoder: JSONDecoder

    init(
        bundle: Bundle = .main,
        resourceName: String = "suggestions",
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.bundle = bundle
        self.resourceName = resourceName
        self.decoder = decoder
    }

    func fetchCatalog() async throws -> SuggestionCatalogDTO {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw LocalSuggestionCatalogProviderError.missingResource(resourceName)
        }

        let data = try Data(contentsOf: url)
        do {
            return try decoder.decode(SuggestionCatalogDTO.self, from: data)
        } catch {
            throw LocalSuggestionCatalogProviderError.decodingFailed
        }
    }
}
