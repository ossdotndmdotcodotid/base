import SwiftUI

struct ControlSurface: View {
    let label: String
    let replay: () -> Void

    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                GlassShareControl(label: label)
            } else if #available(iOS 16.0, *) {
                FlatShareControl(label: label)
            } else {
                FlatActionControl(label: label, action: replay)
            }
        }
        .frame(minHeight: 44)
    }
}

struct ControlCapsule: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Capsule().fill(Palette.ink))
            .overlay(Capsule().stroke(Palette.bone.opacity(0.18), lineWidth: 1))
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(Motion.pressSpring, value: configuration.isPressed)
    }
}

struct ControlLabel: View {
    let text: String

    @Environment(\.legibilityWeight) private var legibility
    @ScaledMetric(relativeTo: .caption) private var microScale: CGFloat = 1

    var body: some View {
        Text(text)
            .font(Typography.microFont(size: Typography.microBaseSize * microScale, legibility: legibility))
            .tracking(Typography.microBaseTracking * microScale)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .foregroundStyle(Palette.bone)
    }
}

@available(iOS 26.0, *)
private struct GlassShareControl: View {
    let label: String

    var body: some View {
        ShareLink(item: ControlSurface.shareText) {
            ControlLabel(text: label)
        }
        .buttonStyle(.glass)
    }
}

@available(iOS 16.0, *)
private struct FlatShareControl: View {
    let label: String

    var body: some View {
        ShareLink(item: ControlSurface.shareText) {
            ControlLabel(text: label)
        }
        .buttonStyle(ControlCapsule())
    }
}

private struct FlatActionControl: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ControlLabel(text: label)
        }
        .buttonStyle(ControlCapsule())
    }
}

extension ControlSurface {
    static let shareText = "PT Next Day Market"
}
