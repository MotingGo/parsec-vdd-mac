// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "parsec-vdd",
    platforms: [.macOS(.v12)],
    targets: [
        .executableTarget(
            name: "parsec-vdd",
            path: "Sources/parsec-vdd",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include"),
            ],
            linkerSettings: [
                .linkedFramework("CoreGraphics"),
            ]
        ),
    ]
)
