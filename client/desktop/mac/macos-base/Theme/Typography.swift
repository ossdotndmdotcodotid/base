import SwiftUI

enum Typography {
    static let displayBaseSize: CGFloat = 72
    static let displayBaseTracking: CGFloat = -2.25
    static let displayBaseWeight: Font.Weight = .black
    static let displayLineBoxRatio: CGFloat = 0.1933

    static let eyebrowBaseSize: CGFloat = 13
    static let eyebrowBaseTracking: CGFloat = 4
    static let eyebrowBaseWeight: Font.Weight = .bold

    static let microBaseSize: CGFloat = 12
    static let microBaseTracking: CGFloat = 2.2
    static let microBaseWeight: Font.Weight = .medium

    static func displayFont(size: CGFloat) -> Font {
        .system(size: size, weight: displayBaseWeight, design: .default)
    }

    static func displayTracking(size: CGFloat) -> CGFloat {
        displayBaseTracking * (size / displayBaseSize)
    }

    static func displayLineShift(size: CGFloat) -> CGFloat {
        -(size * displayLineBoxRatio)
    }

    static func eyebrowFont(size: CGFloat, legibility: LegibilityWeight?) -> Font {
        .system(size: size, weight: legibility == .bold ? .heavy : eyebrowBaseWeight, design: .default)
    }

    static func microFont(size: CGFloat, legibility: LegibilityWeight?) -> Font {
        .system(size: size, weight: legibility == .bold ? .semibold : microBaseWeight, design: .monospaced)
    }
}
