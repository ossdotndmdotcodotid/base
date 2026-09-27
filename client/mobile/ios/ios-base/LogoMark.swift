import SwiftUI

struct LogoMark: View {
    var diameter: CGFloat = 168
    var showArc: Bool = true
    var interactive: Bool = true

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var spinning = false
    @State private var breathing = false
    @State private var pressed = false
    @State private var dragDegrees: Double = 0
    @State private var dragAnchor: Double = 0

    private let artworkRatio: CGFloat = 148.0 / 168.0

    var body: some View {
        ZStack {
            if showArc {
                arc
            }
            Image("NdmLogo")
                .resizable()
                .interpolation(.high)
                .frame(width: diameter * artworkRatio, height: diameter * artworkRatio)
        }
        .frame(width: diameter, height: diameter)
        .scaleEffect(breathing ? 1 + Motion.breatheScaleGain : 1)
        .animation(reduceMotion ? nil : Motion.breathe, value: breathing)
        .scaleEffect(pressed ? Motion.pressScale : 1)
        .animation(Motion.pressSpring, value: pressed)
        .contentShape(Rectangle())
        .gesture(drag, including: interactive ? .all : .none)
        .onAppear(perform: startIdle)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("PT Next Day Market logo"))
        .accessibilityAddTraits(.isImage)
    }

    private var arc: some View {
        Circle()
            .trim(from: 0, to: Motion.arcSweepDegrees / 360)
            .stroke(Palette.lime, style: StrokeStyle(lineWidth: Motion.arcStrokeWidth, lineCap: .round))
            .frame(width: diameter - Motion.arcStrokeWidth * 2, height: diameter - Motion.arcStrokeWidth * 2)
            .opacity(breathing ? Motion.arcAlphaCeiling : Motion.arcAlphaFloor)
            .animation(reduceMotion ? nil : Motion.breathe, value: breathing)
            .rotationEffect(.degrees(-90 + Motion.arcRestBias))
            .rotationEffect(.degrees(spinning ? 360 : 0))
            .animation(reduceMotion ? nil : Motion.arcSpin, value: spinning)
            .rotationEffect(.degrees(dragDegrees))
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if !pressed {
                    pressed = true
                }
                dragDegrees = dragAnchor + Double(value.translation.width) * Motion.dragDegreesPerPoint
            }
            .onEnded { value in
                pressed = false
                let settled = dragAnchor + Double(value.translation.width) * Motion.dragDegreesPerPoint
                let projected = dragAnchor + Double(value.predictedEndTranslation.width) * Motion.dragDegreesPerPoint
                dragAnchor = settled
                dragDegrees = settled
                let carry = (projected - settled) * Motion.flingRetention
                if carry != 0 {
                    withAnimation(Motion.fling) {
                        dragDegrees = settled + carry
                    }
                    dragAnchor = settled + carry
                }
            }
    }

    private func startIdle() {
        guard !reduceMotion else { return }
        spinning = true
        breathing = true
    }
}
