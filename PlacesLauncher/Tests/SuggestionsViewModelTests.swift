import XCTest
@testable import PlacesLauncher

@MainActor
final class SuggestionsViewModelTests: XCTestCase {
    func testLoadMovesThroughLoadingToLoaded() async {
        let suggestions = [makeSuggestion(id: "area-51")]
        let viewModel = SuggestionsViewModel(
            loadSuggestionsUseCase: DelayedLoadSuggestionsUseCase(
                result: .success(suggestions),
                nanoseconds: 20_000_000
            )
        )

        let task = Task { await viewModel.load() }
        await Task.yield()

        XCTAssertEqual(viewModel.state, .loading)
        await task.value
        XCTAssertEqual(viewModel.state, .loaded(suggestions))
    }

    func testLoadIfNeededOnlyLoadsIdleStateOnce() async {
        let useCase = CountingLoadSuggestionsUseCase(result: .success([]))
        let viewModel = SuggestionsViewModel(loadSuggestionsUseCase: useCase)

        await viewModel.loadIfNeeded()
        await viewModel.loadIfNeeded()

        XCTAssertEqual(viewModel.state, .loaded([]))
        XCTAssertEqual(useCase.callCount, 1)
    }

    func testFailureCanRetryWithFreshUseCaseResult() async {
        let expected = [makeSuggestion(id: "apple-park")]
        let useCase = SequencedLoadSuggestionsUseCase(results: [
            .failure(TestSuggestionsError.unavailable),
            .success(expected)
        ])
        let viewModel = SuggestionsViewModel(loadSuggestionsUseCase: useCase)

        await viewModel.load()
        XCTAssertEqual(viewModel.state, .failed(L10n.Suggestions.Error.catalog))

        await viewModel.load()
        XCTAssertEqual(viewModel.state, .loaded(expected))
    }

    func testCancellationReturnsToIdleSoAnotherScreenCanLoad() async {
        let viewModel = SuggestionsViewModel(
            loadSuggestionsUseCase: DelayedLoadSuggestionsUseCase(
                result: .success([]),
                nanoseconds: 1_000_000_000
            )
        )
        let task = Task { await viewModel.load() }
        await Task.yield()

        task.cancel()
        await task.value

        XCTAssertEqual(viewModel.state, .idle)
    }

    private func makeSuggestion(id: String) -> SuggestedPlace {
        SuggestedPlace(
            id: id,
            title: id,
            subtitle: "Subtitle",
            location: PlaceLocation(name: id, latitude: 1, longitude: 2),
            symbol: "star.fill",
            tone: .cyan
        )
    }
}

private final class CountingLoadSuggestionsUseCase: LoadSuggestionsUseCase {
    let result: Result<[SuggestedPlace], Error>
    private(set) var callCount = 0

    init(result: Result<[SuggestedPlace], Error>) {
        self.result = result
    }

    func execute() async throws -> [SuggestedPlace] {
        callCount += 1
        return try result.get()
    }
}

private final class SequencedLoadSuggestionsUseCase: LoadSuggestionsUseCase {
    private var results: [Result<[SuggestedPlace], Error>]

    init(results: [Result<[SuggestedPlace], Error>]) {
        self.results = results
    }

    func execute() async throws -> [SuggestedPlace] {
        try results.removeFirst().get()
    }
}

private struct DelayedLoadSuggestionsUseCase: LoadSuggestionsUseCase {
    let result: Result<[SuggestedPlace], Error>
    let nanoseconds: UInt64

    func execute() async throws -> [SuggestedPlace] {
        try await Task.sleep(nanoseconds: nanoseconds)
        return try result.get()
    }
}

private enum TestSuggestionsError: Error {
    case unavailable
}
