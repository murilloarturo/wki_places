protocol FetchLocationsUseCase {
    func execute() async throws -> [PlaceLocation]
}

struct DefaultFetchLocationsUseCase: FetchLocationsUseCase {
    private let httpClient: any HTTPClient
    private let endpoint: HTTPEndpoint
    private let mapper: any LocationFeedMapping

    init(
        httpClient: any HTTPClient,
        endpoint: HTTPEndpoint = LocationFeedEndpoint.assignment,
        mapper: any LocationFeedMapping = LocationFeedMapper()
    ) {
        self.httpClient = httpClient
        self.endpoint = endpoint
        self.mapper = mapper
    }

    func execute() async throws -> [PlaceLocation] {
        let dto = try await httpClient.fetch(LocationFeedDTO.self, from: endpoint)
        return mapper.map(dto)
    }
}
