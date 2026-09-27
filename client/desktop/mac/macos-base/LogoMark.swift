import SwiftUI
import Foundation

struct LogoMark: View {
    var diameter: CGFloat
    var paused: Bool
    var onReplay: () -> Void

    @State private var pressed = false
    @State private var hovered = false
    @State private var spin: Double = 0
    @State private var spinAnchor: Double = 0

    private let artworkRatio: CGFloat = 148.0 / 168.0

    var body: some View {
        ZStack {
            arc
            Image("NdmLogo")
                .resizable()
                .interpolation(.high)
                .frame(width: diameter * artworkRatio, height: diameter * artworkRatio)
        }
        .frame(width: diameter, height: diameter)
        .scaleEffect(pressed ? Motion.pressScale : 1)
        .animation(Motion.pressSpring, value: pressed)
        .contentShape(Circle())
        .onHover { hovered = $0 }
        .gesture(drag)
        .focusable()
        .help("PT Next Day Market")
        .contextMenu {
            Button("Replay Reveal", action: onReplay)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("PT Next Day Market logo"))
        .accessibilityAddTraits(.isImage)
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: spin += 15
            case .decrement: spin -= 15
            default: break
            }
        }
    }

    private var arc: some View {
        TimelineView(.animation(minimumInterval: Motion.idleFrameInterval, paused: paused)) { context in
            arcShape(elapsed: context.date.timeIntervalSinceReferenceDate)
        }
    }

    private func arcShape(elapsed: Double) -> some View {
        let turns = elapsed.truncatingRemainder(dividingBy: Motion.arcSpinSeconds) / Motion.arcSpinSeconds
        let breath = (sin(elapsed * 2 * Double.pi / Motion.breatheSeconds) + 1) / 2
        let alpha = Motion.arcAlphaFloor + (Motion.arcAlphaCeiling - Motion.arcAlphaFloor) * breath
        return Circle()
            .trim(from: 0, to: Motion.arcSweepDegrees / 360)
            .stroke(Palette.lime.opacity(min(alpha + (hovered ? Motion.hoverArcBoost : 0), 1)), style: StrokeStyle(lineWidth: Motion.arcStrokeWidth, lineCap: .round))
            .frame(width: diameter - Motion.arcStrokeWidth * 2, height: diameter - Motion.arcStrokeWidth * 2)
            .rotationEffect(.degrees(-90 + Motion.arcRestBias + turns * 360 + spin))
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: Motion.dragActivationDistance)
            .onChanged { value in
                if !pressed { pressed = true }
                spin = spinAnchor + Double(value.translation.width) * Motion.dragDegreesPerPoint
            }
            .onEnded { value in
                pressed = false
                let settled = spinAnchor + Double(value.translation.width) * Motion.dragDegreesPerPoint
                let projected = spinAnchor + Double(value.predictedEndTranslation.width) * Motion.dragDegreesPerPoint
                spinAnchor = settled
                spin = settled
                let carry = (projected - settled) * Motion.flingRetention
                if carry != 0 {
                    withAnimation(Motion.fling) { spin = settled + carry }
                    spinAnchor = settled + carry
                }
            }
    }
}
