import SwiftUI

enum Motion {
    static let arcSweepDegrees: Double = 52
    static let arcStrokeWidth: CGFloat = 2
    static let arcRestBias: Double = 6.88
    static let arcAlphaFloor: Double = 0.58
    static let arcAlphaCeiling: Double = 0.95
    static let arcSpinSeconds: Double = 18
    static let breatheSeconds: Double = 3.2
    static let breatheScaleGain: CGFloat = 0.012
    static let pressScale: CGFloat = 0.94
    static let dragActivationDistance: CGFloat = 10
    static let dragDegreesPerPoint: Double = 0.4
    static let flingSeconds: Double = 1.1
    static let flingRetention: Double = 0.5
    static let driftPoints: CGFloat = 1.5
    static let driftSeconds: Double = 5.4
    static let splashRevealSeconds: Double = 0.62
    static let splashRingSeconds: Double = 1.4
    static let splashHoldSeconds: Double = 1.4
    static let splashFadeOutSeconds: Double = 0.3
    static let homeFadeInSeconds: Double = 0.38
    static let homeRevealSeconds: Double = 0.98
    static let underlineGrowSeconds: Double = 0.42
    static let underlineHoldSeconds: Double = 0.9
    static let underlineRetractSeconds: Double = 0.32

    static let pressSpring = Animation.spring(response: 0.322, dampingFraction: 0.55)
    static let arcSpin = Animation.linear(duration: arcSpinSeconds).repeatForever(autoreverses: false)
    static let breathe = Animation.easeInOut(duration: breatheSeconds).repeatForever(autoreverses: true)
    static let drift = Animation.easeInOut(duration: driftSeconds).repeatForever(autoreverses: true)
    static let fling = Animation.easeOut(duration: flingSeconds)

    static func fastOutSlowIn(_ duration: Double) -> Animation {
        .timingCurve(0.4, 0.0, 0.2, 1.0, duration: duration)
    }
}
