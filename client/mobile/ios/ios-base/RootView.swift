import SwiftUI

struct RootView: View {
    @State private var showSplash = true
    @State private var splashAlpha: Double = 1

    var body: some View {
        ZStack {
            Palette.amoledBlack.ignoresSafeArea()
            if showSplash {
                SplashView()
                    .opacity(splashAlpha)
            } else {
                HomeView()
            }
        }
        .task(launch)
    }

    private func launch() async {
        try? await Task.sleep(nanoseconds: RootView.nanoseconds(Motion.splashHoldSeconds))
        withAnimation(Motion.fastOutSlowIn(Motion.splashFadeOutSeconds)) {
            splashAlpha = 0
        }
        try? await Task.sleep(nanoseconds: RootView.nanoseconds(Motion.splashFadeOutSeconds))
        showSplash = false
    }

    private static func nanoseconds(_ seconds: Double) -> UInt64 {
        UInt64(seconds * 1_000_000_000)
    }
}
