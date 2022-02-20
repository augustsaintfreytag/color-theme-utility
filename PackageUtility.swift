// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ColorThemeUtility",
	platforms: [
		.macOS(.v11)
	],
	products: [
		.executable(name: "ColorThemeUtility", targets: ["ColorThemeUtility"]),
		.library(name: "ColorThemeModeling", targets: ["ColorThemeModeling"]),
		.library(name: "ColorThemeCoding", targets: ["ColorThemeCoding"]),
		.library(name: "ColorThemeEnclosure", targets: ["ColorThemeEnclosure"])
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
				.target(name: "ColorThemeModeling"),
				.target(name: "ColorThemeCoding"),
				.target(name: "ColorThemeEnclosure")
			],
			path: "ColorThemeUtility"
		),
		.target(
			name: "ColorThemeModeling",
			dependencies: [],
			path: "ColorThemeModeling"
		),
		.target(
			name: "ColorThemeCoding",
			dependencies: [
				.target(name: "ColorThemeModeling")
			],
			path: "ColorThemeCoding"
		),
		.target(
			name: "ColorThemeEnclosure",
			dependencies: [],
			path: "ColorThemeEnclosure"
		)
	]
)
