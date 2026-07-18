import Foundation
import XCTest
@testable import PlacesLauncher

@MainActor
final class LocationFeedViewModelTests: XCTestCase {
    func testLoadMovesThroughLoadingToLoaded() async {
        let locations = [PlaceLocation(name: "Mumbai", latitude: 19.0821978, longitude: 72.7411)]
        let viewModel = LocationFeedViewModel(
            client: DelayedHTTPClient(
                result: .success(LocationFeedResponse(locations: locations)),
                nanoseconds: 20_000_000
            )
        )

        let task = Task { await viewModel.load() }
        await Task.yield()

        XCTAssertEqual(viewModel.state, .loading)
        await task.value
        XCTAssertEqual(viewModel.state, .loaded(locations))
    }

    func testLoadExposesReadableFailureAndRetryCanRecoverWithNewClientState() async {
        let viewModel = LocationFeedViewModel(
            client: DelayedHTTPClient(result: .failure(TestFeedError.offline), nanoseconds: 0)
        )

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .failed("The network is offline."))
    }

    func testEachLoadRequestsLocationsFromClient() async {
        let first = PlaceLocation(name: "Amsterdam", latitude: 52.35, longitude: 4.83)
        let second = PlaceLocation(name: "London", latitude: 51.5285582, longitude: -0.241679)
        let client = SequencedHTTPClient(responses: [
            LocationFeedResponse(locations: [first]),
            LocationFeedResponse(locations: [second])
        ])
        let viewModel = LocationFeedViewModel(client: client)

        await viewModel.load()
        XCTAssertEqual(viewModel.state, .loaded([first]))

        await viewModel.load()
        XCTAssertEqual(viewModel.state, .loaded([second]))
        XCTAssertEqual(client.callCount, 2)
    }
}

private final class SequencedHTTPClient: HTTPClient {
    private var responses: [LocationFeedResponse]
    private(set) var callCount = 0

    init(responses: [LocationFeedResponse]) {
        self.responses = responses
    }

    func fetch<Value: Codable>(
        _ type: Value.Type,
        from endpoint: HTTPEndpoint
    ) async throws -> Value {
        let response = responses[callCount]
        callCount += 1
        return response as! Value
    }
}

private struct DelayedHTTPClient: HTTPClient {
    let result: Result<LocationFeedResponse, Error>
    let nanoseconds: UInt64

    func fetch<Value: Codable>(
        _ type: Value.Type,
        from endpoint: HTTPEndpoint
    ) async throws -> Value {
        if nanoseconds > 0 {
            try await Task.sleep(nanoseconds: nanoseconds)
        }
        return try result.get() as! Value
    }
}

private enum TestFeedError: LocalizedError {
    case offline

    var errorDescription: String? {
        "The network is offline."
    }
}
