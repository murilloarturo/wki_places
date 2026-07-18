import SwiftUI

struct SuggestionsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let wikipediaOpener: any WikipediaOpening
    private let suggestions: [SuggestedPlace]
    private let picker: SuggestionPicker

    @State private var alertMessage: String?
    @State private var isVisible = false

    init(
        wikipediaOpener: any WikipediaOpening,
        suggestions: [SuggestedPlace] = SuggestionCatalog.places,
        picker: SuggestionPicker = SuggestionPicker()
    ) {
        self.wikipediaOpener = wikipediaOpener
        self.suggestions = suggestions
        self.picker = picker
    }

    var body: some View {
        ZStack {
            RetroGridBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    retroHeader
                    surpriseButton
                    destinationGrid
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
            "MISSION FAILED",
            isPresented: Binding(
                get: { alertMessage != nil },
                set: { if !$0 { alertMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage ?? "Wikipedia could not be opened.")
        }
    }

    private var retroHeader: some View {
        VStack(alignment: .leading, spacing: 18) {
            Button {
                dismiss()
            } label: {
                Label("BACK", systemImage: "chevron.left")
                    .font(.subheadline.weight(.black))
                    .foregroundStyle(Color.cyan)
                    .frame(minHeight: 44)
            }
            .buttonStyle(.plain)
            .accessibilityHint("Returns to Places with the standard appearance")

            VStack(alignment: .leading, spacing: 8) {
                Text("SELECT A LEVEL")
                    .font(.system(.largeTitle, design: .monospaced, weight: .black))
                    .foregroundStyle(Color.yellow)
                Text("CURIOUS COORDINATES // 09")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.cyan)
            }
            .accessibilityElement(children: .combine)
        }
        .padding(.top, 8)
    }

    private var surpriseButton: some View {
        Button {
            guard let suggestion = picker.surprise(from: suggestions) else {
                alertMessage = "No destinations are available."
                return
            }
            openInWikipedia(suggestion.location)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "dice.fill")
                    .font(.title2)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text("SURPRISE ME")
                        .font(.headline.weight(.black))
                    Text("RANDOM DESTINATION")
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
        .accessibilityHint("Opens one of the unusual places at random")
    }

    private var destinationGrid: some View {
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
                    Text("GO")
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
            "\(suggestion.title), \(suggestion.subtitle), coordinates \(suggestion.location.formattedCoordinates)"
        )
        .accessibilityHint("Opens this location in Wikipedia Places")
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

