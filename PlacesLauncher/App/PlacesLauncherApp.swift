import SwiftUI

@main
struct PlacesLauncherApp: App {
    @StateObject private var feedViewModel: LocationFeedViewModel

    init() {
        _feedViewModel = StateObject(
            wrappedValue: LocationFeedViewModel(client: URLSessionLocationFeedClient())
        )
    }

    var body: some Scene {
        WindowGroup {
            PlacesHomeView(
                viewModel: feedViewModel,
                wikipediaOpener: WikipediaLauncher()
            )
            .tint(AppPalette.blue)
        }
    }
}

enum AppPalette {
    static let blue = Color(red: 0.06, green: 0.42, blue: 0.95)
    static let softBlue = Color(red: 0.90, green: 0.95, blue: 1.00)
    static let ink = Color(red: 0.07, green: 0.08, blue: 0.10)
    static let secondaryInk = Color(red: 0.36, green: 0.38, blue: 0.42)
    static let surface = Color(uiColor: .secondarySystemGroupedBackground)
}

