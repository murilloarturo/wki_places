@MainActor
struct AppContainer {
    let wikipediaOpener: any WikipediaOpening

    private let fetchLocationsUseCase: any FetchLocationsUseCase
    private let searchLocationUseCase: any SearchLocationUseCase
    private let confirmCustomLocationUseCase: any ConfirmCustomLocationUseCase

    init(
        httpClient: any HTTPClient = JSONHTTPClient(),
        locationSearcher: any LocationSearching = MapKitLocationSearcher(),
        wikipediaOpener: (any WikipediaOpening)? = nil
    ) {
        self.wikipediaOpener = wikipediaOpener ?? WikipediaLauncher()
        fetchLocationsUseCase = DefaultFetchLocationsUseCase(httpClient: httpClient)
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
}
