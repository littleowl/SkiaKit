// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import Foundation
import PackageDescription

var linkerSettings: [LinkerSetting] = [
	.linkedLibrary("skia_skiakit"),
	.unsafeFlags([
		"-L/usr/local/lib",
	])
]
#if os(Linux) || os(macOS)
linkerSettings.append(contentsOf: [
	.linkedLibrary("freetype"),
    .linkedLibrary("fontconfig"),
    .linkedLibrary("z")
])
#endif

#if os(macOS)
linkerSettings.append(.linkedLibrary("c++"))
#endif

let package = Package(
    name: "SkiaKit",
    platforms: [
	.macOS(.v10_15),
	.iOS(.v13),
	.tvOS(.v13),
    ],    
    products: [
        .library(name: "CSkia", targets: ["CSkia"]),
        .library(name: "SkiaKit", targets: ["SkiaKit"]),
		.executable(name: "Samples", targets: ["Samples"])
    ],
    targets: [
		.target (
			name: "SkiaKit", 
			dependencies: ["CSkia"]
			/*cSettings: [
							.headerSearchPath("Shared/Headers"),
							.headerSearchPath("SkiaKit/Apple", .when (platforms: [.macOS,.tvOS, .iOS])),
							.headerSearchPath("SkiaKit/macOS", .when (platforms: [.macOS])),
							.headerSearchPath("SkiaKit/iOS", .when (platforms: [.iOS])),
							.headerSearchPath("SkiaKit/tvOS", .when (platforms: [.tvOS])),
					.headerSearchPath("include")],
					linkerSettings: linkFlags*/
		),
		.target (
			name: "CSkia",
			cSettings: [
				.headerSearchPath("include"),
				.define("MODULE_MAP", to: "include/module.modulemap"),
			],
			linkerSettings: linkerSettings
			/*,
			path: "skiasharp",
			sources: ["dummy.m"],
			cSettings: [
							.headerSearchPath("../Shared/Headers"),
							.headerSearchPath("../SkiaKit/macOS", .when (platforms: [.macOS])),
					.headerSearchPath("include")]*/
		),
		.target(
			name: "Samples",
			dependencies: ["CSkia", "SkiaKit"],
			path: "Samples/Gallery",
			sources: ["main.swift", "2DPathSample.swift"]
		),
    ]
)

