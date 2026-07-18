import SwiftUI

struct PlacesHomeView: View {
    @ObservedObject var viewModel: LocationFeedViewModel
    let wikipediaOpener: any WikipediaOpening

    @State private var alertMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 26) {
                    header
                    chooseOnMapLink
                    suggestionsLink
                    locationsSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .toolbar(.hidden, for: .navigationBar)
            .task {
                await viewModel.loadIfNeeded()
            }
            .alert(
                "Couldn’t Open Wikipedia",
                isPresented: Binding(
                    get: { alertMessage != nil },
                    set: { if !$0 { alertMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage ?? "Please try again.")
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Places")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(AppPalette.ink)

            Text("Where should Wikipedia take you?")
                .font(.subheadline)
                .foregroundStyle(AppPalette.secondaryInk)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 24)
        .accessibilityElement(children: .combine)
    }

    private var chooseOnMapLink: some View {
        NavigationLink {
            CustomLocationView(
                viewModel: CustomLocationViewModel(searcher: MapKitLocationSearcher()),
                wikipediaOpener: wikipediaOpener
            )
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "map.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(AppPalette.blue, in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 3) {
                    Text("Choose on Map")
                        .font(.headline)
                    Text("Search or drop a pin")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .foregroundStyle(AppPalette.ink)
            .padding(14)
            .background(AppPalette.surface, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Choose on Map")
        .accessibilityHint("Search for a place or choose a coordinate on Apple Maps")
    }

    private var suggestionsLink: some View {
        NavigationLink {
            SuggestionsView(wikipediaOpener: wikipediaOpener)
        } label: {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("BONUS MAP")
                        .font(.caption.monospaced().weight(.black))
                        .foregroundStyle(Color.cyan)
                    Text("Explore unusual places")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("9 curious destinations")
                        .font(.caption.monospaced())
                        .foregroundStyle(Color.white.opacity(0.68))
                }

                Spacer(minLength: 8)

                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.cyan.opacity(0.65), lineWidth: 1)
                    Image(systemName: "arcade.stick.console.fill")
                        .font(.title2)
                        .foregroundStyle(Color.yellow)
                }
                .frame(width: 58, height: 58)
                .accessibilityHidden(true)
            }
            .padding(16)
            .background(AppPalette.ink, in: RoundedRectangle(cornerRadius: 8))
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.cyan, .pink, .yellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 3)
                    .clipShape(.rect(bottomLeadingRadius: 8, bottomTrailingRadius: 8))
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Explore unusual places")
        .accessibilityHint("Opens the retro suggestions map")
    }

    private var locationsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("FROM THE FEED")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            Group {
                switch viewModel.state {
                case .idle, .loading:
                    loadingState
                case let .loaded(locations) where locations.isEmpty:
                    emptyState
                case let .loaded(locations):
                    loadedState(locations)
                case let .failed(message):
                    errorState(message)
                }
            }
            .background(AppPalette.surface, in: RoundedRectangle(cornerRadius: 8))
        }
    }

    private var loadingState: some View {
        HStack(spacing: 12) {
            ProgressView()
            Text("Loading locations…")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 88)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading locations")
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No Locations",
            systemImage: "map",
            description: Text("The feed is currently empty.")
        )
        .frame(minHeight: 150)
    }

    private func loadedState(_ locations: [PlaceLocation]) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(locations.enumerated()), id: \.element.id) { index, location in
                Button {
                    openInWikipedia(location)
                } label: {
                    LocationRow(location: location)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 14)

                if index < locations.count - 1 {
                    Divider()
                        .padding(.leading, 64)
                }
            }
        }
    }

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.exclamationmark")
                .font(.title2)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text("Locations Unavailable")
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                Task { await viewModel.load() }
            } label: {
                Label("Try Again", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, minHeight: 190)
        .padding()
        .accessibilityElement(children: .contain)
    }

    private func openInWikipedia(_ location: PlaceLocation) {
        Task {
            do {
                try await wikipediaOpener.open(location: location)
            } catch {
                alertMessage = error.localizedDescription
            }
        }
    }
}

