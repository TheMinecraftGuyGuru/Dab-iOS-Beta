// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DabIOS",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(name: "DabIOSApp", targets: ["App"])
    ],
    targets: [
        .executableTarget(
            name: "App",
            path: "Sources/App"
        ),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"],
            path: "Tests/AppTests"
        )
    ]
)
