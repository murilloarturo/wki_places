import SwiftUI

struct FeedLoadingView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 0) {
            loadingHeader

            Divider()
                .padding(.leading, 68)

            ForEach(0..<3, id: \.self) { index in
                skeletonRow(index: index)

                if index < 2 {
                    Divider()
                        .padding(.leading, 68)
                }
            }
        }
        .overlay {
            if !reduceMotion {
                shimmer
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
        }
        .clipped()
        .onAppear {
            guard !reduceMotion else { return }
            isAnimating = true
        }
        .onDisappear {
            isAnimating = false
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Feed.loading)
    }

    private var loadingHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "location.north.fill")
                .font(.body.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(AppPalette.blue, in: RoundedRectangle(cornerRadius: 8))
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    reduceMotion
                        ? nil
                        : .linear(duration: 1.8).repeatForever(autoreverses: false),
                    value: isAnimating
                )

            Text(L10n.Feed.loading)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppPalette.secondaryInk)

            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 60)
    }

    private func skeletonRow(index: Int) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(AppPalette.softBlue)
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: "mappin")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(AppPalette.blue.opacity(0.45))
                }

            VStack(alignment: .leading, spacing: 7) {
                Capsule()
                    .fill(Color(uiColor: .systemFill))
                    .frame(width: index == 1 ? 152 : 116, height: 10)

                Capsule()
                    .fill(Color(uiColor: .quaternarySystemFill))
                    .frame(width: index == 2 ? 96 : 128, height: 8)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 64)
    }

    private var shimmer: some View {
        GeometryReader { proxy in
            LinearGradient(
                colors: [.clear, .white.opacity(0.7), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: 82)
            .rotationEffect(.degrees(12))
            .offset(x: isAnimating ? proxy.size.width + 82 : -82)
            .animation(
                .linear(duration: 1.25).repeatForever(autoreverses: false),
                value: isAnimating
            )
        }
    }
}
