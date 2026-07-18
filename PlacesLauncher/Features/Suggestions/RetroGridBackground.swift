import SwiftUI

struct RetroGridBackground: View {
    var body: some View {
        Canvas { context, size in
            var path = Path()
            let spacing: CGFloat = 28

            stride(from: CGFloat.zero, through: size.width, by: spacing).forEach { x in
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }
            stride(from: CGFloat.zero, through: size.height, by: spacing).forEach { y in
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }

            context.stroke(path, with: .color(.cyan.opacity(0.09)), lineWidth: 1)
        }
        .background(Color(red: 0.035, green: 0.045, blue: 0.065))
        .accessibilityHidden(true)
        .ignoresSafeArea()
    }
}

