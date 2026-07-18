import Foundation
import XCTest
@testable import PlacesLauncher

@MainActor
final class LocationFeedViewModelTests: XCTestCase {
    func testLoadMovesThroughLoadingToLoaded() async {
        let locations = [PlaceLocation(name: "Mumbai", latitude: 19.0821978, longitude: 72.7411)]
        let viewModel = LocationFeedViewModel(
            client: DelayedFeedClient(result: .success(locations), nanoseconds: 20_000_000)
        )

        let task = Task { await viewModel.load() }
        await Task.yield()

        XCTAssertEqual(viewModel.state, .loading)
        await task.value
        XCTAssertEqual(viewModel.state, .loaded(locations))
    }

    func testLoadExposesReadableFailureAndRetryCanRecoverWithNewClientState() async {
        let viewModel = LocationFeedViewModel(
            client: DelayedFeedClient(result: .failure(TestFeedError.offline), nanoseconds: 0)
        )

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .failed("The network is offline."))
    }

    func testLoadIfNeededDoesNotReplaceExistingResults() async {
        let location = PlaceLocation(name: "Amsterdam", latitude: 52.35, longitude: 4.83)
        let viewModel = LocationFeedViewModel(
            client: DelayedFeedClient(result: .success([location]), nanoseconds: 0)
        )

        await viewModel.load()
        await viewModel.loadIfNeeded()

        XCTAssertEqual(viewModel.state, .loaded([location]))
    }
}

private struct DelayedFeedClient: LocationFeedClient {
    let result: Result<[PlaceLocation], Error>
    let nanoseconds: UInt64

    func fetchLocations() async throws -> [PlaceLocation] {
        if nanoseconds > 0 {
            try await Task.sleep(nanoseconds: nanoseconds)
        }
        return try result.get()
    }
}

private enum TestFeedError: LocalizedError {
    case offline

    var errorDescription: String? {
        "The network is offline."
    }
}

