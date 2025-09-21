import Foundation
import AppKit
import SwiftUI

// MARK: - NotificationView

struct NotificationView: View {
    let message: String
    let duration: TimeInterval
    @State private var opacity: Double = 1.0

    var body: some View {
        Text(message)
            .font(.system(size: 24, weight: .bold))
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .opacity(opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation(.easeOut(duration: 1.0)) {
                        opacity = 0.0
                    }
                }
            }
    }
}

// MARK: - NotificationWindow

class NotificationWindow {
    private var window: NSWindow?

    func show(message: String, duration: TimeInterval = 2.0) {
        let view = NotificationView(message: message, duration: duration)
        let hosting = NSHostingView(rootView: view)

        let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 800, height: 600)
        let windowSize = CGSize(width: 300, height: 80)

        let window = NSWindow(
            contentRect: CGRect(
                x: (screenSize.width - windowSize.width) / 2,
                y: (screenSize.height - windowSize.height) / 2,
                width: windowSize.width,
                height: windowSize.height
            ),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.contentView = hosting
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .popUpMenu
        window.hasShadow = true
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .transient]
        window.alphaValue = 1.0
        window.makeKeyAndOrderFront(nil)

        self.window = window

        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 1.0) {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.5
                self.window?.animator().alphaValue = 0.0
            }, completionHandler: {
                self.window?.orderOut(nil)
                self.window = nil
            })
        }
    }
}

// MARK: - CLI Entry Point

var message = "Hello!"
var duration: TimeInterval = 2.0

let args = CommandLine.arguments
if let messageIndex = args.firstIndex(of: "--message"), args.count > messageIndex + 1 {
    message = args[messageIndex + 1]
}
if let durationIndex = args.firstIndex(of: "--duration"), args.count > durationIndex + 1 {
    if let parsed = Double(args[durationIndex + 1]) {
        duration = parsed
    }
}

let notifier = NotificationWindow()
notifier.show(message: message, duration: duration)
RunLoop.main.run(until: Date().addingTimeInterval(duration))