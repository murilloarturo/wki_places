import Foundation
import Observation

enum LocationFeedState: Equatable {
    case idle
    case loading
    case loaded([PlaceLocation])
    case failed(String)
}

@MainActor
@Observable
final class LocationFeedViewModel {
    private(set) var state: LocationFeedState = .idle

    private let fetchLocationsUseCase: any FetchLocationsUseCase

    init(fetchLocationsUseCase: any FetchLocationsUseCase) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
    }

    func load() async {
        state = .loading
        do {
            let locations = try await fetchLocationsUseCase.execute()
            try Task.checkCancellation()
            state = .loaded(locations)
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
