import SwiftUI

struct PlacesHomeView: View {
    @ObservedObject var viewModel: LocationFeedViewModel
    let wikipediaOpener: any WikipediaOpening

    @State private var alertMessage: String?
    @State private var feedTask: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 26) {
                    header
                    locationsSection
                    chooseOnMapLink
                    suggestionsLink
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                refreshFeed()
            }
            .onDisappear {
                feedTask?.cancel()
                feedTask = nil
            }
            .alert(
                L10n.Wikipedia.Error.title,
                isPresented: Binding(
                    get: { alertMessage != nil },
                    set: { if !$0 { alertMessage = nil } }
                )
            ) {
                Button(L10n.Common.ok, role: .cancel) {}
            } message: {
                Text(alertMessage ?? L10n.Wikipedia.Error.fallback)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(L10n.Home.title)
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(AppPalette.ink)

            Text(L10n.Home.subtitle)
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
                    Text(L10n.Home.ChooseMap.title)
                        .font(.headline)
                    Text(L10n.Home.ChooseMap.subtitle)
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
        .accessibilityLabel(L10n.Home.ChooseMap.title)
        .accessibilityHint(L10n.Home.ChooseMap.accessibilityHint)
    }

    private var suggestionsLink: some View {
        NavigationLink {
            SuggestionsView(wikipediaOpener: wikipediaOpener)
        } label: {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 7) {
                    Text(L10n.Home.Bonus.eyebrow)
                        .font(.caption.monospaced().weight(.black))
                        .foregroundStyle(Color.cyan)
                    Text(L10n.Home.Bonus.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(L10n.Home.Bonus.subtitle)
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
        .accessibilityLabel(L10n.Home.Bonus.title)
        .accessibilityHint(L10n.Home.Bonus.accessibilityHint)
    }

    private var locationsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L10n.Feed.title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            Group {
                switch viewModel.state {
                case .idle, .loading:
                    FeedLoadingView()
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

    private var emptyState: some View {
        ContentUnavailableView(
            L10n.Feed.Empty.title,
            systemImage: "map",
            description: Text(L10n.Feed.Empty.description)
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
            Text(L10n.Feed.Error.title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                refreshFeed()
            } label: {
                Label(L10n.Feed.retry, systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, minHeight: 190)
        .padding()
        .accessibilityElement(children: .contain)
    }

    private func refreshFeed() {
        feedTask?.cancel()
        feedTask = Task {
            await viewModel.load()
        }
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
