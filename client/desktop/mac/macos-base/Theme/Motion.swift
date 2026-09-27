import SwiftUI

enum Motion {
    static let arcSweepDegrees: Double = 52
    static let arcStrokeWidth: CGFloat = 2
    static let arcRestBias: Double = 6.88
    static let arcAlphaFloor: Double = 0.58
    static let arcAlphaCeiling: Double = 0.95
    static let arcSpinSeconds: Double = 18
    static let breatheSeconds: Double = 3.2
    static let idleFrameInterval: Double = 1.0 / 60.0

    static let revealSeconds: Double = 0.98
    static let markReveal = Motion.fastOutSlowIn(Motion.revealSeconds * 0.55)
    static let eyebrowReveal = Motion.fastOutSlowIn(Motion.revealSeconds * 0.44).delay(Motion.revealSeconds * 0.06)
    static let displayReveal = Motion.fastOutSlowIn(Motion.revealSeconds * 0.72).delay(Motion.revealSeconds * 0.28)
    static let ruleReveal = Motion.fastOutSlowIn(Motion.revealSeconds * 0.42).delay(Motion.revealSeconds * 0.28)
    static let versionReveal = Motion.fastOutSlowIn(Motion.revealSeconds * 0.28).delay(Motion.revealSeconds * 0.72)

    static let pressScale: CGFloat = 0.94
    static let hoverArcBoost: Double = 0.18
    static let dragActivationDistance: CGFloat = 10
    static let dragDegreesPerPoint: Double = 0.4
    static let flingSeconds: Double = 1.1
    static let flingRetention: Double = 0.5

    static let underlineGrowSeconds: Double = 0.42
    static let underlineHoldSeconds: Double = 0.9
    static let underlineRetractSeconds: Double = 0.32
    static let underlineOffset: CGFloat = 7
    static let underlineWeight: CGFloat = 2

    static let pressSpring = Animation.spring(response: 0.322, dampingFraction: 0.55)
    static let fling = Animation.easeOut(duration: Motion.flingSeconds)

    static func fastOutSlowIn(_ duration: Double) -> Animation {
        .timingCurve(0.4, 0.0, 0.2, 1.0, duration: duration)
    }
}
