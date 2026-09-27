import SwiftUI
import Observation
import Foundation

@MainActor
@Observable
final class StageModel {
    var revealToken = 0
    private(set) var ambientEnabled: Bool

    init() {
        ambientEnabled = UserDefaults.standard.object(forKey: AmbientMotionPreference.key) as? Bool
            ?? AmbientMotionPreference.defaultValue
    }

    var ambientBinding: Binding<Bool> {
        Binding(
            get: { self.ambientEnabled },
            set: { self.setAmbientEnabled($0) }
        )
    }

    func setAmbientEnabled(_ enabled: Bool) {
        ambientEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: AmbientMotionPreference.key)
    }

    func replay() {
        revealToken += 1
    }
}

struct Stage: Equatable {
    static let minSize = CGSize(width: 480, height: 360)
    static let defaultSize = CGSize(width: 1240, height: 800)
    static let quantum: CGFloat = 8

    let size: CGSize

    var quantisedWidth: CGFloat {
        (size.width / Stage.quantum).rounded(.down) * Stage.quantum
    }

    var margin: CGFloat {
        switch quantisedWidth {
        case ..<720: 24
        case ..<1120: 40
        case ..<1600: 64
        default: 96
        }
    }

    var displaySize: CGFloat {
        switch quantisedWidth {
        case ..<720: 36
        case ..<1120: 52
        case ..<1600: 72
        default: 88
        }
    }

    var markDiameter: CGFloat {
        let ideal: CGFloat = switch quantisedWidth {
        case ..<720: 112
        case ..<1120: 184
        default: 280
        }
        let widthCeiling = (quantisedWidth - margin * 2) * 0.34
        let heightCeiling = size.height * 0.46
        return min(ideal, widthCeiling, heightCeiling)
    }

    var spineX: CGFloat {
        margin + markDiameter / 2
    }

    var datumY: CGFloat {
        size.height / 2
    }

    var wordmarkX: CGFloat {
        margin + markDiameter + max(40, markDiameter * 0.2)
    }

    var measureWidth: CGFloat {
        max(size.width - margin - wordmarkX, 0)
    }
}

struct StageView: View {
    var model: StageModel

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.legibilityWeight) private var legibility

    @State private var revealed = false
    @State private var signals = MotionSignals(appActive: true, windowVisible: true, lowPower: false)

    var body: some View {
        GeometryReader { proxy in
            let stage = Stage(size: proxy.size)
            ZStack(alignment: .topLeading) {
                spineRule(stage)
                datumRule(stage)
                mark(stage)
                wordmark(stage)
                version(stage)
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
        }
        .frame(minWidth: Stage.minSize.width, minHeight: Stage.minSize.height)
        .background(Palette.amoledBlack.ignoresSafeArea())
        .background(MotionProbe(signals: $signals))
        .onAppear { revealed = true }
    }

    private var gate: MotionGate {
        MotionGate(reduceMotion: reduceMotion, userEnabled: model.ambientEnabled, signals: signals)
    }

    private func spineRule(_ stage: Stage) -> some View {
        Rectangle()
            .fill(contrast == .increased ? Palette.spineStrong : Palette.spine)
            .frame(width: 1, height: stage.size.height)
            .opacity(revealed ? 1 : 0)
            .animation(revealAnimation(Motion.ruleReveal), value: revealed)
            .offset(x: stage.spineX - 0.5, y: 0)
    }

    private func datumRule(_ stage: Stage) -> some View {
        Rectangle()
            .fill(contrast == .increased ? Palette.datumStrong : Palette.datum)
            .frame(width: max(stage.size.width - stage.margin * 2, 0), height: 1)
            .opacity(revealed ? 1 : 0)
            .animation(revealAnimation(Motion.ruleReveal), value: revealed)
            .offset(x: stage.margin, y: stage.datumY - 0.5)
    }

    private func mark(_ stage: Stage) -> some View {
        LogoMark(diameter: stage.markDiameter, paused: gate.paused, onReplay: model.replay)
            .opacity(revealed ? 1 : 0)
            .scaleEffect(revealed ? 1 : 0.88)
            .offset(y: revealed ? 0 : 22)
            .animation(revealAnimation(Motion.markReveal), value: revealed)
            .offset(x: stage.spineX - stage.markDiameter / 2, y: stage.datumY - stage.markDiameter / 2)
    }

    private func wordmark(_ stage: Stage) -> some View {
        Wordmark(displaySize: stage.displaySize, revealed: revealed, reduceMotion: reduceMotion)
            .background(Palette.amoledBlack)
            .frame(width: stage.measureWidth, height: stage.size.height, alignment: .leading)
            .offset(x: stage.wordmarkX, y: 0)
    }

    private func version(_ stage: Stage) -> some View {
        Text(versionLabel)
            .font(Typography.microFont(size: Typography.microBaseSize, legibility: legibility))
            .tracking(Typography.microBaseTracking)
            .foregroundStyle(Palette.version)
            .opacity(revealed ? 1 : 0)
            .animation(revealAnimation(Motion.versionReveal), value: revealed)
            .accessibilityLabel(Text(versionSpokenLabel))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Palette.amoledBlack)
            .frame(width: stage.measureWidth, height: stage.size.height, alignment: .trailing)
            .offset(x: stage.wordmarkX, y: 0)
    }

    private var versionLabel: String {
        "V" + (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
    }

    private var versionSpokenLabel: String {
        let value = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        return value.isEmpty ? "Version unknown" : "Version " + value
    }

    private func revealAnimation(_ animation: Animation) -> Animation? {
        reduceMotion ? nil : animation
    }
}
