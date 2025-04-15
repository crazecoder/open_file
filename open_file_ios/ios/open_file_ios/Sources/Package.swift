// swift-tools-version: 5.9

// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import PackageDescription

let package = Package(
  name: "open_file_ios",
  platforms: [
    .iOS("12.0")
  ],
  products: [
    .library(name: "open-file-ios", targets: ["open_file_ios"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "open_file_ios",
      dependencies: [],
//       exclude: ["include/open_file_ios-umbrella.h", "include/OpenFilePlugin.modulemap"],
      resources: [
        // TODO: If your plugin requires a privacy manifest
        // (e.g. if it uses any required reason APIs), update the PrivacyInfo.xcprivacy file
        // to describe your plugin's privacy impact, and then uncomment this line.
        // For more information, see:
        // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
        // .process("PrivacyInfo.xcprivacy"),

        // TODO: If you have other resources that need to be bundled with your plugin, refer to
        // the following instructions to add them:
        // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
      ],
      cSettings: [
        .headerSearchPath("include/open_file_ios")
      ]
    )
  ]
)