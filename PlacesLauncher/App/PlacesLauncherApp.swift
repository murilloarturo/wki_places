import FactoryKit
import SwiftUI

@main
struct PlacesLauncherApp: App {
    @State private var feedViewModel: LocationFeedViewModel
    @State private var suggestionsViewModel: SuggestionsViewModel
    private let wikipediaOpener: any WikipediaOpening

    init() {
        _feedViewModel = State(
            initialValue: LocationFeedViewModel.make()
        )
        _suggestionsViewModel = State(
            initialValue: SuggestionsViewModel.make()
        )
        wikipediaOpener = Container.shared.wikipediaOpener()
    }

    var body: some Scene {
        WindowGroup {
            PlacesHomeView(
                viewModel: feedViewModel,
                suggestionsViewModel: suggestionsViewModel,
                wikipediaOpener: wikipediaOpener
            )
            .tint(AppPalette.blue)
        }
    }
}
