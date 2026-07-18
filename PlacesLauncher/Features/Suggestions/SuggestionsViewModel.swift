import Observation

enum SuggestionsState: Equatable {
    case idle
    case loading
    case loaded([SuggestedPlace])
    case failed(String)
}

@MainActor
@Observable
final class SuggestionsViewModel {
    private(set) var state: SuggestionsState = .idle

    private let loadSuggestionsUseCase: any LoadSuggestionsUseCase

    init(loadSuggestionsUseCase: any LoadSuggestionsUseCase) {
        self.loadSuggestionsUseCase = loadSuggestionsUseCase
    }

    func loadIfNeeded() async {
        guard state == .idle else { return }
        await load()
    }

    func load() async {
        state = .loading
        do {
            let suggestions = try await loadSuggestionsUseCase.execute()
            try Task.checkCancellation()
            state = .loaded(suggestions)
        } catch is CancellationError {
            state = .idle
            return
        } catch {
            state = .failed(L10n.Suggestions.Error.catalog)
        }
    }
}
