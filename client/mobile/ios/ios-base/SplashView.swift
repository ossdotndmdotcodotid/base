import SwiftUI

struct SplashView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var revealed = false
    @State private var swept = false

    private let markDiameter: CGFloat = 184
    private let ringDiameter: CGFloat = 224
    private let ringWidth: CGFloat = 4

    var body: some View {
        ZStack {
            Palette.amoledBlack.ignoresSafeArea()
            ZStack {
                Circle()
                    .stroke(Palette.bone.opacity(0.12), lineWidth: ringWidth)
                    .frame(width: ringDiameter, height: ringDiameter)
                Circle()
                    .trim(from: 0, to: swept ? 1 : 0)
                    .stroke(Palette.lime, style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: ringDiameter, height: ringDiameter)
                    .animation(reduceMotion ? nil : Motion.fastOutSlowIn(Motion.splashRingSeconds), value: swept)
                LogoMark(diameter: markDiameter, showArc: false, interactive: false)
            }
            .opacity(revealed ? 1 : 0)
            .scaleEffect(revealed ? 1 : 0.92)
            .animation(reduceMotion ? nil : Motion.fastOutSlowIn(Motion.splashRevealSeconds), value: revealed)
        }
        .onAppear {
            revealed = true
            swept = true
        }
    }
}
