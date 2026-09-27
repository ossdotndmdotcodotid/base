import SwiftUI
import AppKit
import Foundation

enum AmbientMotionPreference {
    static let key = "ambientMotionEnabled"
    static let defaultValue = true
}

struct MotionSignals: Equatable {
    var appActive: Bool
    var windowVisible: Bool
    var lowPower: Bool
}

struct MotionGate {
    var reduceMotion: Bool
    var userEnabled: Bool
    var signals: MotionSignals

    var paused: Bool {
        reduceMotion || !userEnabled || !signals.appActive || !signals.windowVisible || signals.lowPower
    }
}

struct MotionProbe: NSViewRepresentable {
    @Binding var signals: MotionSignals

    func makeNSView(context: Context) -> ProbeView {
        let view = ProbeView()
        view.emit = { signals = $0 }
        return view
    }

    func updateNSView(_ nsView: ProbeView, context: Context) {
        nsView.emit = { signals = $0 }
    }

    static func dismantleNSView(_ nsView: ProbeView, coordinator: ()) {
        nsView.stopObserving()
    }

    final class ProbeView: NSView {
        var emit: ((MotionSignals) -> Void)?

        private var observing = false

        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            guard let window else {
                if observing { stopObserving() }
                return
            }
            guard !observing else { return }
            observing = true
            let center = NotificationCenter.default
            center.addObserver(self, selector: #selector(signalsChanged), name: NSApplication.didBecomeActiveNotification, object: nil)
            center.addObserver(self, selector: #selector(signalsChanged), name: NSApplication.didResignActiveNotification, object: nil)
            center.addObserver(self, selector: #selector(signalsChanged), name: Notification.Name.NSProcessInfoPowerStateDidChange, object: nil)
            center.addObserver(self, selector: #selector(signalsChanged), name: NSWindow.didChangeOcclusionStateNotification, object: window)
            center.addObserver(self, selector: #selector(signalsChanged), name: NSWindow.didMiniaturizeNotification, object: window)
            center.addObserver(self, selector: #selector(signalsChanged), name: NSWindow.didDeminiaturizeNotification, object: window)
            Task { @MainActor [weak self] in self?.signalsChanged() }
        }

        @objc private func signalsChanged() {
            let visible = window.map { $0.occlusionState.contains(.visible) && !$0.isMiniaturized } ?? false
            emit?(MotionSignals(
                appActive: NSApplication.shared.isActive,
                windowVisible: visible,
                lowPower: ProcessInfo.processInfo.isLowPowerModeEnabled
            ))
        }

        func stopObserving() {
            NotificationCenter.default.removeObserver(self)
            observing = false
        }
    }
}
