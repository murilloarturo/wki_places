import Foundation

enum LocationFeedState: Equatable {
    case idle
    case loading
    case loaded([PlaceLocation])
    case failed(String)
}

@MainActor
final class LocationFeedViewModel: ObservableObject {
    @Published private(set) var state: LocationFeedState = .idle

    private let client: any HTTPClient
    private let endpoint: HTTPEndpoint

    init(
        client: any HTTPClient,
        endpoint: HTTPEndpoint = LocationFeedEndpoint.assignment
    ) {
        self.client = client
        self.endpoint = endpoint
    }

    func load() async {
        state = .loading
        do {
            let response = try await client.fetch(LocationFeedResponse.self, from: endpoint)
            try Task.checkCancellation()
            state = .loaded(response.locations)
        } catch is CancellationError {
            return
        } catch {
            state = .failed(
                (error as? LocalizedError)?.errorDescription
                    ?? L10n.Feed.Error.fallback
            )
        }
    }
}
