import SwiftUI

struct TypeBlock: View {
    let displayBase: CGFloat
    let eyebrowShift: CGFloat
    let eyebrowIn: Bool
    let displayIn: Bool

    @Environment(\.legibilityWeight) private var legibility
    @ScaledMetric(relativeTo: .largeTitle) private var displayScale: CGFloat = 1
    @ScaledMetric(relativeTo: .footnote) private var eyebrowScale: CGFloat = 1

    private var displaySize: CGFloat { displayBase * displayScale }
    private var eyebrowSize: CGFloat { Typography.eyebrowBaseSize * eyebrowScale }

    var body: some View {
        VStack(spacing: 0) {
            Text("PT")
                .font(Typography.eyebrowFont(size: eyebrowSize, legibility: legibility))
                .tracking(Typography.eyebrowBaseTracking * eyebrowScale)
                .opacity(eyebrowIn ? 1 : 0)
                .offset(y: eyebrowIn ? 0 : 10)
                .foregroundStyle(Palette.lime)

            displayBlock
                .padding(.top, eyebrowShift)
        }
        .frame(maxWidth: .infinity)
    }

    private var displayBlock: some View {
        VStack(spacing: Typography.displayLineShift(scaledSize: displaySize)) {
            Text("Next Day")
                .font(Typography.displayFont(size: displaySize))
                .tracking(Typography.displayBaseTracking * displayScale)
            Text("Market")
                .font(Typography.displayFont(size: displaySize))
                .tracking(Typography.displayBaseTracking * displayScale)
        }
        .foregroundStyle(Palette.bone)
        .multilineTextAlignment(.center)
        .lineLimit(1)
        .minimumScaleFactor(0.85)
        .dynamicTypeSize(.large ... .xxxLarge)
        .opacity(displayIn ? 1 : 0)
        .offset(y: displayIn ? 0 : 16)
    }
}
