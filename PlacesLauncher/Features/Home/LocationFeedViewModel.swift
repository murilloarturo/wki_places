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

    private let client: any LocationFeedClient

    init(client: any LocationFeedClient) {
        self.client = client
    }

    func loadIfNeeded() async {
        guard state == .idle else { return }
        await load()
    }

    func load() async {
        state = .loading
        do {
            let locations = try await client.fetchLocations()
            try Task.checkCancellation()
            state = .loaded(locations)
        } catch is CancellationError {
            state = .idle
        } catch {
            state = .failed(
                (error as? LocalizedError)?.errorDescription
                    ?? "The locations could not be loaded."
            )
        }
    }
}

