@MainActor
struct AppContainer {
    let wikipediaOpener: any WikipediaOpening

    private let fetchLocationsUseCase: any FetchLocationsUseCase
    private let loadSuggestionsUseCase: any LoadSuggestionsUseCase
    private let searchLocationUseCase: any SearchLocationUseCase
    private let confirmCustomLocationUseCase: any ConfirmCustomLocationUseCase

    init(
        httpClient: any HTTPClient = JSONHTTPClient(),
        suggestionProvider: any SuggestionCatalogProviding = LocalSuggestionCatalogProvider(),
        locationSearcher: any LocationSearching = MapKitLocationSearcher(),
        wikipediaOpener: (any WikipediaOpening)? = nil
    ) {
        self.wikipediaOpener = wikipediaOpener ?? WikipediaLauncher()
        fetchLocationsUseCase = DefaultFetchLocationsUseCase(httpClient: httpClient)
        loadSuggestionsUseCase = DefaultLoadSuggestionsUseCase(
            provider: suggestionProvider
        )
        searchLocationUseCase = DefaultSearchLocationUseCase(
            locationSearcher: locationSearcher
        )
        confirmCustomLocationUseCase = DefaultConfirmCustomLocationUseCase()
    }

    func makeLocationFeedViewModel() -> LocationFeedViewModel {
        LocationFeedViewModel(fetchLocationsUseCase: fetchLocationsUseCase)
    }

    func makeCustomLocationViewModel() -> CustomLocationViewModel {
        CustomLocationViewModel(
            searchLocationUseCase: searchLocationUseCase,
            confirmCustomLocationUseCase: confirmCustomLocationUseCase
        )
    }

    func makeSuggestionsViewModel() -> SuggestionsViewModel {
        SuggestionsViewModel(loadSuggestionsUseCase: loadSuggestionsUseCase)
    }
}
