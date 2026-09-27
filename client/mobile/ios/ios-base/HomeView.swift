import SwiftUI

struct HomeView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.legibilityWeight) private var legibility

    @ScaledMetric(relativeTo: .caption) private var microScale: CGFloat = 1

    @State private var markIn = false
    @State private var eyebrowIn = false
    @State private var displayIn = false
    @State private var versionIn = false

    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                stack(Composition(compact: dynamicTypeSize.isAccessibilitySize))
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height, alignment: .center)
            }
        }
        .background(Palette.amoledBlack.ignoresSafeArea())
        .onAppear(perform: runReveal)
    }

    private func stack(_ layout: Composition) -> some View {
        VStack(spacing: 0) {
            LogoMark(diameter: layout.markDiameter)
                .opacity(markIn ? 1 : 0)
                .scaleEffect(markIn ? 1 : 0.88)
                .offset(y: markIn ? 0 : 22)

            Color.clear.frame(height: layout.markToTypeGap)

            TypeBlock(
                displayBase: layout.displayBase,
                eyebrowShift: layout.eyebrowShift,
                eyebrowIn: eyebrowIn,
                displayIn: displayIn
            )

            Color.clear.frame(height: layout.typeToVersionGap)

            version
                .opacity(versionIn ? 1 : 0)
        }
        .frame(maxWidth: Composition.measureCap)
        .padding(.horizontal, Composition.margin)
    }

    private var version: some View {
        Text(versionLabel)
            .font(Typography.microFont(size: Typography.microBaseSize * microScale, legibility: legibility))
            .tracking(Typography.microBaseTracking * microScale)
            .foregroundStyle(Palette.bone.opacity(0.85))
            .accessibilityLabel(Text(versionSpokenLabel))
    }

    private var versionLabel: String {
        "V" + (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
    }

    private var versionSpokenLabel: String {
        let value = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        return value.isEmpty ? "Version unknown" : "Version " + value
    }

    private func runReveal() {
        guard !reduceMotion else {
            markIn = true
            eyebrowIn = true
            displayIn = true
            versionIn = true
            return
        }
        withAnimation(Motion.fastOutSlowIn(Motion.homeRevealSeconds * 0.55)) { markIn = true }
        withAnimation(Motion.fastOutSlowIn(0.299).delay(0.314)) { eyebrowIn = true }
        withAnimation(Motion.fastOutSlowIn(0.480).delay(0.500)) { displayIn = true }
        withAnimation(Motion.fastOutSlowIn(0.274).delay(0.706)) { versionIn = true }
    }
}

struct Composition {
    static let margin: CGFloat = 32
    static let measureCap: CGFloat = 480

    let compact: Bool

    var markDiameter: CGFloat { compact ? 112 : 168 }
    var displayBase: CGFloat { compact ? 40 : 60 }
    var markToTypeGap: CGFloat { compact ? 32 : 40 }
    var typeToVersionGap: CGFloat { compact ? 32 : 44 }
    var eyebrowShift: CGFloat { compact ? -5 : -8 }
}
