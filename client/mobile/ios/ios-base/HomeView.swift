import SwiftUI

struct HomeView: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var markIn = false
    @State private var eyebrowIn = false
    @State private var displayIn = false
    @State private var ruleIn = false
    @State private var versionIn = false

    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                composition(Composition(width: proxy.size.width, variant: variant))
                    .frame(minHeight: proxy.size.height)
            }
        }
        .background(Palette.amoledBlack.ignoresSafeArea())
        .onAppear(perform: runReveal)
    }

    private var variant: CompositionVariant {
        if verticalSizeClass == .compact {
            return .split
        }
        if dynamicTypeSize.isAccessibilitySize {
            return .compact
        }
        return .monument
    }

    @ViewBuilder
    private func composition(_ layout: Composition) -> some View {
        switch layout.variant {
        case .split:
            splitComposition(layout)
        case .monument, .compact:
            stackedComposition(layout)
        }
    }

    private func stackedComposition(_ layout: Composition) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.clear.frame(height: layout.topGap)
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                mark(layout)
            }
            Color.clear.frame(height: layout.markToTypeGap)
            typeBlock(layout)
            Spacer(minLength: 96)
            FootStrip(ruleIn: ruleIn, versionIn: versionIn, replay: replay)
            Color.clear.frame(height: 24)
        }
        .padding(.horizontal, Composition.margin)
        .frame(maxWidth: layout.measure + Composition.margin * 2, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func splitComposition(_ layout: Composition) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 0)
            HStack(alignment: .center, spacing: 24) {
                typeBlock(layout)
                Spacer(minLength: 0)
                mark(layout)
            }
            Spacer(minLength: 0)
            FootStrip(ruleIn: ruleIn, versionIn: versionIn, replay: replay)
        }
        .padding(.horizontal, Composition.margin)
        .frame(maxWidth: layout.measure + Composition.margin * 2, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func mark(_ layout: Composition) -> some View {
        LogoMark(diameter: layout.markDiameter)
            .opacity(markIn ? 1 : 0)
            .scaleEffect(markIn ? 1 : 0.88)
            .offset(y: markIn ? 0 : 22)
    }

    private func typeBlock(_ layout: Composition) -> some View {
        TypeBlock(
            displayBase: layout.displayBase,
            eyebrowShift: layout.eyebrowShift,
            eyebrowIn: eyebrowIn,
            displayIn: displayIn
        )
    }

    private func runReveal() {
        guard !reduceMotion else {
            markIn = true
            eyebrowIn = true
            displayIn = true
            ruleIn = true
            versionIn = true
            return
        }
        withAnimation(Motion.fastOutSlowIn(Motion.homeRevealSeconds * 0.55)) { markIn = true }
        withAnimation(Motion.fastOutSlowIn(0.299).delay(0.314)) { eyebrowIn = true }
        withAnimation(Motion.fastOutSlowIn(0.480).delay(0.500)) { displayIn = true }
        withAnimation(Motion.fastOutSlowIn(0.372).delay(0.608)) { ruleIn = true }
        withAnimation(Motion.fastOutSlowIn(0.274).delay(0.706)) { versionIn = true }
    }

    private func replay() {
        withAnimation(nil) {
            markIn = false
            eyebrowIn = false
            displayIn = false
            ruleIn = false
            versionIn = false
        }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 60_000_000)
            runReveal()
        }
    }
}

enum CompositionVariant {
    case monument
    case split
    case compact
}

struct Composition {
    static let margin: CGFloat = 32
    static let measureCap: CGFloat = 480

    let width: CGFloat
    let variant: CompositionVariant

    var measure: CGFloat {
        min(max(width - Composition.margin * 2, 0), Composition.measureCap)
    }

    var markDiameter: CGFloat {
        variant == .compact ? 112 : 168
    }

    var displayBase: CGFloat {
        variant == .compact ? 40 : 60
    }

    var topGap: CGFloat {
        switch variant {
        case .monument: return 56
        case .split: return 0
        case .compact: return 40
        }
    }

    var markToTypeGap: CGFloat {
        switch variant {
        case .monument: return 52
        case .split: return 0
        case .compact: return 32
        }
    }

    var eyebrowShift: CGFloat {
        variant == .compact ? -5 : -8
    }
}
