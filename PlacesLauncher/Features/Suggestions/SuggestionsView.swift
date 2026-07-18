import SwiftUI

struct SuggestionsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let viewModel: SuggestionsViewModel
    let wikipediaOpener: any WikipediaOpening
    private let picker: SuggestionPicker

    @State private var alertMessage: String?
    @State private var isVisible = false

    init(
        viewModel: SuggestionsViewModel,
        wikipediaOpener: any WikipediaOpening,
        picker: SuggestionPicker = SuggestionPicker()
    ) {
        self.viewModel = viewModel
        self.wikipediaOpener = wikipediaOpener
        self.picker = picker
    }

    var body: some View {
        ZStack {
            RetroGridBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    backButton
                    stateContent
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 36)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 10)
            }
        }
        .fontDesign(.monospaced)
        .foregroundStyle(.white)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadIfNeeded()
        }
        .onAppear {
            if reduceMotion {
                isVisible = true
            } else {
                withAnimation(.easeOut(duration: 0.24)) {
                    isVisible = true
                }
            }
        }
        .alert(
            L10n.Suggestions.Error.title,
            isPresented: Binding(
                get: { alertMessage != nil },
                set: { if !$0 { alertMessage = nil } }
            )
        ) {
            Button(L10n.Common.ok, role: .cancel) {}
        } message: {
            Text(alertMessage ?? L10n.Suggestions.Error.fallback)
        }
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Label(L10n.Suggestions.back, systemImage: "chevron.left")
                .font(.subheadline.weight(.black))
                .foregroundStyle(Color.cyan)
                .frame(minHeight: 44)
        }
        .buttonStyle(.plain)
        .accessibilityHint(L10n.Suggestions.Accessibility.backHint)
        .padding(.top, 8)
    }

    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingState
        case let .loaded(suggestions) where suggestions.isEmpty:
            emptyState
        case let .loaded(suggestions):
            loadedContent(suggestions)
        case let .failed(message):
            errorState(message)
        }
    }

    private func loadedContent(_ suggestions: [SuggestedPlace]) -> some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.Suggestions.pickDestination)
                    .font(.system(.largeTitle, design: .monospaced, weight: .black))
                    .foregroundStyle(Color.yellow)
                Text(L10n.Suggestions.coordinateCount(suggestions.count))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.cyan)
            }
            .accessibilityElement(children: .combine)

            surpriseButton(suggestions)
            destinationGrid(suggestions)
        }
    }

    private var loadingState: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
                .tint(.cyan)
            Text(L10n.Suggestions.loading)
                .font(.caption.weight(.black))
                .foregroundStyle(Color.cyan)
        }
        .frame(maxWidth: .infinity, minHeight: 260)
        .accessibilityElement(children: .combine)
    }

    private var emptyState: some View {
        retroMessage(
            L10n.Suggestions.Error.empty,
            symbol: "questionmark.folder.fill"
        )
    }

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 18) {
            retroMessage(message, symbol: "exclamationmark.triangle.fill")
            Button {
                Task { await viewModel.load() }
            } label: {
                Label(L10n.Suggestions.retry, systemImage: "arrow.clockwise")
                    .font(.headline.weight(.black))
                    .frame(minHeight: 44)
            }
            .buttonStyle(.borderedProminent)
            .tint(.yellow)
            .foregroundStyle(.black)
        }
    }

    private func retroMessage(_ message: String, symbol: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(Color.pink)
                .accessibilityHidden(true)
            Text(message)
                .font(.headline.weight(.black))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 190)
        .accessibilityElement(children: .combine)
    }

    private func surpriseButton(_ suggestions: [SuggestedPlace]) -> some View {
        Button {
            guard let suggestion = picker.surprise(from: suggestions) else {
                alertMessage = L10n.Suggestions.Error.empty
                return
            }
            openInWikipedia(suggestion.location)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "dice.fill")
                    .font(.title2)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.Suggestions.surprise)
                        .font(.headline.weight(.black))
                    Text(L10n.Suggestions.randomDestination)
                        .font(.caption2.weight(.bold))
                        .opacity(0.7)
                }
                Spacer()
                Image(systemName: "play.fill")
                    .accessibilityHidden(true)
            }
            .foregroundStyle(Color.black)
            .padding(15)
            .background(Color.yellow, in: RoundedRectangle(cornerRadius: 6))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityHint(L10n.Suggestions.Accessibility.surpriseHint)
    }

    private func destinationGrid(_ suggestions: [SuggestedPlace]) -> some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 250 : 160),
                    spacing: 12
                )
            ],
            spacing: 12
        ) {
            ForEach(suggestions) { suggestion in
                suggestionTile(suggestion)
            }
        }
    }

    private func suggestionTile(_ suggestion: SuggestedPlace) -> some View {
        Button {
            openInWikipedia(suggestion.location)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: suggestion.symbol)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(color(for: suggestion.tone))
                        .accessibilityHidden(true)
                    Spacer()
                    Text(L10n.Suggestions.go)
                        .font(.caption2.weight(.black))
                        .foregroundStyle(color(for: suggestion.tone))
                }

                Text(suggestion.title.uppercased())
                    .font(.subheadline.weight(.black))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                Text(suggestion.subtitle.uppercased())
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(Color.white.opacity(0.62))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                Text(suggestion.location.formattedCoordinates)
                    .font(.caption2.monospacedDigit().weight(.bold))
                    .foregroundStyle(color(for: suggestion.tone))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 164, alignment: .topLeading)
            .background(Color.black.opacity(0.64), in: RoundedRectangle(cornerRadius: 6))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(color(for: suggestion.tone).opacity(0.72), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            L10n.Suggestions.Accessibility.tile(
                suggestion.title,
                suggestion.subtitle,
                suggestion.location.formattedCoordinates
            )
        )
        .accessibilityHint(L10n.Location.Accessibility.openHint)
    }

    private func color(for tone: SuggestionTone) -> Color {
        switch tone {
        case .cyan: return .cyan
        case .magenta: return .pink
        case .yellow: return .yellow
        case .mint: return .mint
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
