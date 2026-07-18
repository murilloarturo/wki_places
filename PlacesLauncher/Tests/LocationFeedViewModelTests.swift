import Foundation
import XCTest
@testable import PlacesLauncher

@MainActor
final class LocationFeedViewModelTests: XCTestCase {
    func testLoadMovesThroughLoadingToLoaded() async {
        let locations = [PlaceLocation(name: "Mumbai", latitude: 19.0821978, longitude: 72.7411)]
        let viewModel = LocationFeedViewModel(
            fetchLocationsUseCase: DelayedFetchLocationsUseCase(
                result: .success(locations),
                nanoseconds: 20_000_000
            )
        )

        let task = Task { await viewModel.load() }
        await Task.yield()

        XCTAssertEqual(viewModel.state, .loading)
        await task.value
        XCTAssertEqual(viewModel.state, .loaded(locations))
    }

    func testLoadExposesReadableFailure() async {
        let viewModel = LocationFeedViewModel(
            fetchLocationsUseCase: DelayedFetchLocationsUseCase(
                result: .failure(TestFeedError.offline),
                nanoseconds: 0
            )
        )

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .failed("The network is offline."))
    }

    func testEachLoadExecutesFetchLocationsUseCase() async {
        let first = PlaceLocation(name: "Amsterdam", latitude: 52.35, longitude: 4.83)
        let second = PlaceLocation(name: "London", latitude: 51.5285582, longitude: -0.241679)
        let useCase = SequencedFetchLocationsUseCase(responses: [[first], [second]])
        let viewModel = LocationFeedViewModel(fetchLocationsUseCase: useCase)

        await viewModel.load()
        XCTAssertEqual(viewModel.state, .loaded([first]))

        await viewModel.load()
        XCTAssertEqual(viewModel.state, .loaded([second]))
        XCTAssertEqual(useCase.callCount, 2)
    }
}

private final class SequencedFetchLocationsUseCase: FetchLocationsUseCase {
    private var responses: [[PlaceLocation]]
    private(set) var callCount = 0

    init(responses: [[PlaceLocation]]) {
        self.responses = responses
    }

    func execute() async throws -> [PlaceLocation] {
        let response = responses[callCount]
        callCount += 1
        return response
    }
}

private struct DelayedFetchLocationsUseCase: FetchLocationsUseCase {
    let result: Result<[PlaceLocation], Error>
    let nanoseconds: UInt64

    func execute() async throws -> [PlaceLocation] {
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
