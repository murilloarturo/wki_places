import FactoryKit

extension Container {
    var httpClient: Factory<any HTTPClient> {
        self { JSONHTTPClient() }
    }

    var locationsProvider: Factory<any LocationsProviding> {
        self {
            DefaultLocationsProvider(httpClient: self.httpClient())
        }
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
            DefaultFetchLocationsUseCase(provider: self.locationsProvider())
        }
    }

    var loadSuggestionsUseCase: Factory<any LoadSuggestionsUseCase> {
        self {
            DefaultLoadSuggestionsUseCase(
                provider: self.locationsProvider()
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
