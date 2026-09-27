import SwiftUI

enum Typography {
    static let displayBaseSize: CGFloat = 60
    static let displayBaseTracking: CGFloat = -2.25
    static let displayBaseWeight: Font.Weight = .black
    static let displayLineBoxRatio: CGFloat = 0.1933

    static let eyebrowBaseSize: CGFloat = 13
    static let eyebrowBaseTracking: CGFloat = 4
    static let eyebrowBaseWeight: Font.Weight = .bold

    static let microBaseSize: CGFloat = 12
    static let microBaseTracking: CGFloat = 2.2
    static let microBaseWeight: Font.Weight = .medium

    static func scaledTracking(base: CGFloat, baseSize: CGFloat, scaledSize: CGFloat) -> CGFloat {
        base * (scaledSize / baseSize)
    }

    static func displayFont(size: CGFloat) -> Font {
        .system(size: size, weight: displayBaseWeight, design: .default)
    }

    static func eyebrowFont(size: CGFloat, legibility: LegibilityWeight?) -> Font {
        let weight: Font.Weight = legibility == .bold ? .heavy : eyebrowBaseWeight
        return .system(size: size, weight: weight, design: .default)
    }

    static func microFont(size: CGFloat, legibility: LegibilityWeight?) -> Font {
        let weight: Font.Weight = legibility == .bold ? .semibold : microBaseWeight
        return .system(size: size, weight: weight, design: .monospaced)
    }

    static func displayLineShift(scaledSize: CGFloat) -> CGFloat {
        -(scaledSize * displayLineBoxRatio)
    }
}
