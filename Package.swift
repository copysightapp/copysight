// swift-tools-version: 5.10
import PackageDescription

let package = Package(
  name: "CopySight",
  platforms: [.macOS(.v14)],
  products: [
    .executable(name: "CopySight", targets: ["CopySight"]),
    .executable(name: "copysight", targets: ["CopySightCLI"]),
  ],
  targets: [
    .target(name: "CopySightCore"),
    .executableTarget(name: "CopySight", dependencies: ["CopySightCore"]),
    .executableTarget(name: "CopySightCLI", dependencies: ["CopySightCore"]),
    .testTarget(name: "CopySightTests", dependencies: ["CopySight", "CopySightCore"]),
  ]
)
