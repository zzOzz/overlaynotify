import Foundation
import AppKit
import SwiftUI

// MARK: - NotificationView

struct NotificationView: View {
    let message: String
    let duration: TimeInterval
    let fontSize: CGFloat
    @State private var opacity: Double = 1.0

    var body: some View {
        Text(message)
            .font(.system(size: fontSize, weight: .bold))
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
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
        let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 800, height: 600)
        let maxWindowHeight: CGFloat = screenSize.height * 0.5

        // Find the largest font size that fits
        var fontSize: CGFloat = 24
        var windowWidth: CGFloat = 300 // Initial guess for width
        let maxWindowWidth: CGFloat = screenSize.width * 0.8
        let minWindowWidth: CGFloat = 150

        // Determine optimal font size and initial width based on message content
        var optimalFontSize: CGFloat = 24
        var optimalWidth: CGFloat = 0

        // First pass: Find the largest font size that fits within a reasonable width
        for size in stride(from: 24, through: 10, by: -1) {
            let cgSize = CGFloat(size)
            let tempView = NotificationView(message: message, duration: duration, fontSize: cgSize)
            let tempHosting = NSHostingView(rootView: tempView)
            // Use a very large width to get the natural width of the text
            tempHosting.frame = NSRect(x: 0, y: 0, width: 10000, height: 1000)
            let fit = tempHosting.fittingSize
            if fit.width <= maxWindowWidth {
                optimalFontSize = cgSize
                optimalWidth = fit.width
                break
            }
        }

        // If no font size fits within maxWindowWidth, fall back to smallest font and max width
        if optimalWidth == 0 {
            optimalFontSize = 10
            let tempView = NotificationView(message: message, duration: duration, fontSize: optimalFontSize)
            let tempHosting = NSHostingView(rootView: tempView)
            tempHosting.frame = NSRect(x: 0, y: 0, width: 10000, height: 1000)
            optimalWidth = min(tempHosting.fittingSize.width, maxWindowWidth)
        }

        windowWidth = max(minWindowWidth, optimalWidth + 40) // Add padding for the window

        // Second pass: Determine the final height with the optimal font size and calculated width
        // var: CGFloat = 24
        var fittingHeight: CGFloat = .greatestFiniteMagnitude
        for size in stride(from: 24, through: 10, by: -1) {
            let cgSize = CGFloat(size)
            let tempView = NotificationView(message: message, duration: duration, fontSize: cgSize)
            let tempHosting = NSHostingView(rootView: tempView)
            tempHosting.frame = NSRect(x: 0, y: 0, width: windowWidth, height: 1000)
            let fit = tempHosting.fittingSize
            if fit.height <= maxWindowHeight {
                fontSize = cgSize
                fittingHeight = fit.height
                break
            }
        }
        if fittingHeight == .greatestFiniteMagnitude {
            // fallback to smallest font size
            let tempView = NotificationView(message: message, duration: duration, fontSize: 10)
            let tempHosting = NSHostingView(rootView: tempView)
            tempHosting.frame = NSRect(x: 0, y: 0, width: windowWidth, height: 1000)
            fittingHeight = tempHosting.fittingSize.height
        }
        let windowHeight = max(80, fittingHeight)
        let windowSize = CGSize(width: windowWidth, height: windowHeight)

        let view = NotificationView(message: message, duration: duration, fontSize: fontSize)
        let hosting = NSHostingView(rootView: view)

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

        // Ensure window is vertically centered after layout
        DispatchQueue.main.async {
            if let screen = window.screen ?? NSScreen.main {
                let screenFrame = screen.visibleFrame
                let newOriginY = screenFrame.origin.y + (screenFrame.height - window.frame.height) / 2
                let newOriginX = screenFrame.origin.x + (screenFrame.width - window.frame.width) / 2
                window.setFrameOrigin(NSPoint(x: newOriginX, y: newOriginY))
            }
        }

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

// MARK: - Stdin Handling

func isPipe() -> Bool {
    var fileInfo = stat()
    fstat(FileHandle.standardInput.fileDescriptor, &fileInfo)
    return (fileInfo.st_mode & S_IFMT) == S_IFIFO
}

func readStdin() -> String {
    var input = ""
    while let line = readLine() {
        input += line + "\n"
    }
    // Trim trailing newline
    if input.hasSuffix("\n") {
        input.removeLast()
    }
    return input
}

// MARK: - Completion Script

func printCompletion(shell: String) {
    let commandName = "OverlayNotify"
    let options = ["--message", "--duration", "--completion"]

    switch shell.lowercased() {
    case "bash":
        print("""
        _\(commandName)_completion() {
            local cur prev opts
            COMPREPLY=()
            cur="${COMP_WORDS[COMP_CWORD]}"
            opts="\(options.joined(separator: " "))"

            if [[ ${cur} == -* ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
                return 0
            fi
        }
        complete -F _\(commandName)_completion \(commandName)
        """)

    case "zsh":
        print("""
        #compdef \(commandName)

        _arguments \\
            "\(options.map { "'\($0)'" }.joined(separator: " \\\n    "))"
        """)

    case "fish":
        for option in options {
            print("complete -c \(commandName) -l \(option.dropFirst(2)) -d \"\(option) option\"")
        }

    default:
        print("Unsupported shell: \(shell). Please use 'bash', 'zsh', or 'fish'.")
    }
}

// MARK: - CLI Entry Point

var message = "Hello!"
var duration: TimeInterval = 0.5

let args = CommandLine.arguments

if let completionIndex = args.firstIndex(of: "--completion"), args.count > completionIndex + 1 {
    let shell = args[completionIndex + 1]
    printCompletion(shell: shell)
    exit(0)
}

if let messageIndex = args.firstIndex(of: "--message"), args.count > messageIndex + 1 {
    message = args[messageIndex + 1]
} else if isPipe() {
    message = readStdin()
}

if let durationIndex = args.firstIndex(of: "--duration"), args.count > durationIndex + 1 {
    if let parsed = Double(args[durationIndex + 1]) {
        duration = parsed
    }
}

let notifier = NotificationWindow()
notifier.show(message: message, duration: duration)
RunLoop.main.run(until: Date().addingTimeInterval(duration))