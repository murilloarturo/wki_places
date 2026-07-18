import FactoryKit

extension Container {
    var httpClient: Factory<any HTTPClient> {
        self { JSONHTTPClient() }
    }

    var suggestionCatalogProvider: Factory<any SuggestionCatalogProviding> {
        self { LocalSuggestionCatalogProvider() }
    }

    var locationSearcher: Factory<any LocationSearching> {
        self { MapKitLocationSearcher() }
    }

    @MainActor
    var wikipediaOpener: Factory<any WikipediaOpening> {
        self { WikipediaLauncher() }
    }

    var fetchLocationsUseCase: Factory<any FetchLocationsUseCase> {
        self {
            DefaultFetchLocationsUseCase(httpClient: self.httpClient())
        }
    }

    var loadSuggestionsUseCase: Factory<any LoadSuggestionsUseCase> {
        self {
            DefaultLoadSuggestionsUseCase(
                provider: self.suggestionCatalogProvider()
            )
        }
    }

    var searchLocationUseCase: Factory<any SearchLocationUseCase> {
        self {
            DefaultSearchLocationUseCase(
                locationSearcher: self.locationSearcher()
            )
        }
    }

    var confirmCustomLocationUseCase: Factory<any ConfirmCustomLocationUseCase> {
        self { DefaultConfirmCustomLocationUseCase() }
    }
}
