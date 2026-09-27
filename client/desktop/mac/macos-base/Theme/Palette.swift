import SwiftUI

enum Palette {
    static let amoledBlack = Color(red: 0.0, green: 0.0, blue: 0.0)
    static let ink = Color(red: 0.08235, green: 0.09020, blue: 0.11373)
    static let bone = Color(red: 0.96863, green: 0.96078, blue: 0.94510)
    static let lime = Color(red: 0.54118, green: 0.69804, blue: 0.22353)

    static let spine = Palette.bone.opacity(0.14)
    static let datum = Palette.bone.opacity(0.24)
    static let spineStrong = Palette.bone.opacity(0.30)
    static let datumStrong = Palette.bone.opacity(0.46)
    static let version = Palette.bone.opacity(0.85)
}
