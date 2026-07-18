protocol FetchLocationsUseCase {
    func execute() async throws -> [PlaceLocation]
}

struct DefaultFetchLocationsUseCase: FetchLocationsUseCase {
    private let provider: any LocationsProviding
    private let mapper: any LocationFeedMapping

    init(
        provider: any LocationsProviding,
        mapper: any LocationFeedMapping = LocationFeedMapper()
    ) {
        self.provider = provider
        self.mapper = mapper
    }

    func execute() async throws -> [PlaceLocation] {
        let dto = try await provider.fetchFeed()
        return mapper.map(dto)
    }
}
