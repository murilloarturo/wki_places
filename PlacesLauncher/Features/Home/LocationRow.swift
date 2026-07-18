import SwiftUI

struct LocationRow: View {
    let location: PlaceLocation

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppPalette.blue)
                .frame(width: 36, height: 36)
                .background(AppPalette.softBlue, in: RoundedRectangle(cornerRadius: 8))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(location.displayName)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(AppPalette.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(location.formattedCoordinates)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            Image(systemName: "arrow.up.forward")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(location.displayName), coordinates \(location.formattedCoordinates)")
        .accessibilityHint("Opens this location in Wikipedia Places")
    }
}

