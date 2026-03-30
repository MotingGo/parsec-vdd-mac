// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "parsec-vdd",
    platforms: [.macOS(.v12)],
    targets: [
        .systemLibrary(
            name: "CGVirtualDisplayPrivate",
            path: "Sources/CGVirtualDisplayPrivate"
        ),
        .executableTarget(
            name: "parsec-vdd",
            dependencies: ["CGVirtualDisplayPrivate"],
            path: "Sources/parsec-vdd",
            linkerSettings: [
                .linkedFramework("CoreGraphics"),
            ]
        ),
    ]
)
