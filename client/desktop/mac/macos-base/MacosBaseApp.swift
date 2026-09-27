import SwiftUI
import AppKit

@main
struct MacosBaseApp: App {
    @NSApplicationDelegateAdaptor(AppearanceDelegate.self) private var appearanceDelegate
    @State private var model = StageModel()

    var body: some Scene {
        Window("PT Next Day Market", id: "main") {
            StageView(model: model)
                .id(model.revealToken)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Toggle("Ambient Motion", systemImage: "circle.dashed", isOn: model.ambientBinding)
                            .help(model.ambientEnabled
                                ? "Stop the brand arc from animating"
                                : "Animate the brand arc")
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button("Replay Reveal", systemImage: "arrow.counterclockwise") {
                            model.replay()
                        }
                        .help("Replay the entrance")
                    }
                }
        }
        .defaultSize(width: Stage.defaultSize.width, height: Stage.defaultSize.height)
        .defaultPosition(.center)
        .windowResizability(.contentMinSize)
        .windowToolbarStyle(.unified(showsTitle: true))
        .commands {
            StageCommands(model: model)
        }
    }
}

@MainActor
final class AppearanceDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.appearance = NSAppearance(named: .darkAqua)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

struct StageCommands: Commands {
    var model: StageModel

    var body: some Commands {
        CommandGroup(after: .toolbar) {
            Button("Replay Reveal") {
                model.replay()
            }
            .keyboardShortcut("r", modifiers: .command)

            Divider()

            Button(model.ambientEnabled ? "Turn Off Ambient Motion" : "Turn On Ambient Motion") {
                model.setAmbientEnabled(!model.ambientEnabled)
            }
            .keyboardShortcut("m", modifiers: [.command, .shift])
        }
    }
}
