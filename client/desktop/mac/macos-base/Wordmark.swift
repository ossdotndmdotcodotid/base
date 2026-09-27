import SwiftUI
import Foundation

struct Wordmark: View {
    var displaySize: CGFloat
    var revealed: Bool
    var reduceMotion: Bool

    @Environment(\.legibilityWeight) private var legibility
    @State private var underline: Double = 0
    @State private var underlineTask: Task<Void, Never>?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            eyebrow
            displayBlock
                .padding(.top, Typography.displayLineShift(size: displaySize))
                .overlay(alignment: .bottomLeading) { underlineRule }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture(perform: drawUnderline)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("PT Next Day Market"))
        .accessibilityAddTraits(.isHeader)
    }

    private var eyebrow: some View {
        Text("PT")
            .font(Typography.eyebrowFont(size: Typography.eyebrowBaseSize, legibility: legibility))
            .tracking(Typography.eyebrowBaseTracking)
            .foregroundStyle(Palette.lime)
            .opacity(revealed ? 1 : 0)
            .offset(y: revealed ? 0 : 10)
            .animation(revealAnimation(Motion.eyebrowReveal), value: revealed)
    }

    private var displayBlock: some View {
        VStack(alignment: .leading, spacing: Typography.displayLineShift(size: displaySize)) {
            displayLine("Next Day")
            displayLine("Market")
        }
        .opacity(revealed ? 1 : 0)
        .offset(y: revealed ? 0 : 16)
        .animation(revealAnimation(Motion.displayReveal), value: revealed)
    }

    private func displayLine(_ text: String) -> some View {
        Text(text)
            .font(Typography.displayFont(size: displaySize))
            .tracking(Typography.displayTracking(size: displaySize))
            .foregroundStyle(Palette.bone)
            .lineLimit(1)
            .minimumScaleFactor(0.62)
    }

    private var underlineRule: some View {
        Rectangle()
            .fill(Palette.lime)
            .frame(width: underlineWidth, height: Motion.underlineWeight)
            .offset(y: Motion.underlineOffset)
    }

    private var underlineWidth: CGFloat {
        CGFloat(underline) * (displaySize * 4.4)
    }

    private func revealAnimation(_ animation: Animation) -> Animation? {
        reduceMotion ? nil : animation
    }

    private func drawUnderline() {
        underlineTask?.cancel()
        underlineTask = Task { @MainActor in
            await animateUnderline(to: 1, over: Motion.underlineGrowSeconds)
            try? await Task.sleep(for: .seconds(Motion.underlineHoldSeconds))
            guard !Task.isCancelled else { return }
            await animateUnderline(to: 0, over: Motion.underlineRetractSeconds)
        }
    }

    private func animateUnderline(to value: Double, over duration: Double) async {
        withAnimation(Motion.fastOutSlowIn(duration)) { underline = value }
        try? await Task.sleep(for: .seconds(duration))
    }
}
