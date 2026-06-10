// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "open_file_ios",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(name: "open-file-ios", targets: ["open_file_ios"])
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework")
  ],
  targets: [
    .target(
      name: "open_file_ios",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework")
      ],
      path: "Sources/open_file_ios",
      cSettings: [
        .headerSearchPath("include/open_file_ios")
      ]
    )
  ]
)