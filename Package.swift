// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "OverlayNotify",
    platforms: [.macOS(.v12)],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "OverlayNotify",
            dependencies: []
        )
    ]
)