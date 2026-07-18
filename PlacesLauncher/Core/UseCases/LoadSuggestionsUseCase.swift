protocol LoadSuggestionsUseCase {
    func execute() async throws -> [SuggestedPlace]
}

struct DefaultLoadSuggestionsUseCase: LoadSuggestionsUseCase {
    private let provider: any SuggestionCatalogProviding
    private let mapper: any SuggestionCatalogMapping

    init(
        provider: any SuggestionCatalogProviding,
        mapper: any SuggestionCatalogMapping = SuggestionCatalogMapper()
    ) {
        self.provider = provider
        self.mapper = mapper
    }

    func execute() async throws -> [SuggestedPlace] {
        let dto = try await provider.fetchCatalog()
        return try mapper.map(dto)
    }
}
