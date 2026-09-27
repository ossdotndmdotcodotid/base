import SwiftUI

struct FootStrip: View {
    let ruleIn: Bool
    let versionIn: Bool
    let replay: () -> Void

    @Environment(\.legibilityWeight) private var legibility
    @ScaledMetric(relativeTo: .caption) private var microScale: CGFloat = 1

    private let tickLength: CGFloat = 54

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            rule
            Color.clear.frame(height: 20)
            HStack(spacing: 0) {
                version
                Spacer(minLength: 12)
                ControlSurface(label: "SHARE", replay: replay)
                    .opacity(versionIn ? 1 : 0)
            }
            .frame(minHeight: 44)
        }
    }

    private var rule: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Palette.bone.opacity(0.55))
                .frame(width: tickLength, height: 1)
            Rectangle()
                .fill(Palette.bone.opacity(0.30))
                .frame(height: 1)
        }
        .opacity(ruleIn ? 1 : 0)
        .scaleEffect(x: ruleIn ? 1 : 0, y: 1, anchor: .center)
    }

    private var version: some View {
        Text(versionLabel)
            .font(Typography.microFont(size: Typography.microBaseSize * microScale, legibility: legibility))
            .tracking(Typography.microBaseTracking * microScale)
            .opacity(versionIn ? 1 : 0)
            .foregroundStyle(Palette.bone.opacity(0.85))
            .accessibilityLabel(Text(versionSpokenLabel))
    }

    private var versionLabel: String {
        "V" + (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
    }

    private var versionSpokenLabel: String {
        let value = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        return value.isEmpty ? "Version unknown" : "Version " + value
    }
}
