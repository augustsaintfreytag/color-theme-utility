// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ColorThemeUtility",
	platforms: [
		.macOS(.v11)
	],
	products: [
		.executable(name: "ColorThemeUtility", targets: ["ColorThemeUtility"])
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1"),
		.package(url: "https://github.com/onevcat/rainbow", from: "4.0.0"),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.executableTarget(
			name: "ColorThemeUtility",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "Rainbow", package: "rainbow"),
				.target(name: "ColorThemeModelingFramework"),
				.target(name: "ColorThemeCodingFramework"),
				.target(name: "ColorThemeEnclosureFramework")
			],
			path: "ColorThemeUtility"
		),
		.target(
			name: "ColorThemeModelingFramework",
			dependencies: [],
			path: "ColorThemeModelingFramework"
		),
		.target(
			name: "ColorThemeCodingFramework",
			dependencies: [
				.target(name: "ColorThemeModelingFramework")
			],
			path: "ColorThemeCodingFramework"
		),
		.target(
			name: "ColorThemeEnclosureFramework",
			dependencies: [],
			path: "ColorThemeEnclosureFramework",
			resources: [
				.process("Resources/theme-thumbnail-r.jpeg")
			]
		)
	]
)
