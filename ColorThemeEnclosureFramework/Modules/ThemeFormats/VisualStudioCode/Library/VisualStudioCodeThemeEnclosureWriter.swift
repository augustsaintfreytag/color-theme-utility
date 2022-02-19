//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 16/02/2022.
//

import Foundation
import ColorThemeModelingFramework
import ColorThemeCodingFramework

public protocol VisualStudioCodeThemeEnclosureWriter: ThemeCoercionProvider, ThemeEncoder {}

extension VisualStudioCodeThemeEnclosureWriter {
	
	private static var vendorIdentifier: String { "color-theme-utility" }
	private static var publisherName: String { "Color Theme Utility" }
	
	private static var defaultThemeName: String { "Theme" }
	private static var defaultThemeVersion: String { "1.0.0" }
	private static var defaultBannerColor: Color { Color(red: 0.235, green: 0.270, blue: 0.341) }
	
	private typealias PackageManifest = VisualStudioCodePackageManifest
	private typealias GalleryBanner = VisualStudioCodePackageManifest.GalleryBanner
	private typealias Contributions = VisualStudioCodePackageManifest.Contributions
	private typealias Metadata = VisualStudioCodePackageManifest.Metadata
	private typealias UserInterfaceTheme = VisualStudioCodeUserInterfaceTheme
	
	// MARK: Enclosure Write
	
	public static func writeEnclosedTheme(_ theme: VisualStudioCodeTheme, to path: URL, properties: ThemeEnclosureProperties? = nil) throws {
		let (name, description) = themeProperties(for: theme, from: properties)
		
		let packageName = themePackageName(name)
		let packageManifest = themePackageManifest(for: theme, properties: properties)
		let readmeFileContents = readmeTextForVisualStudioCodeTheme(name: name, description: description)
		
		do {
			let fileManager = FileManager.default
			
			let packagePath = path.appendingPathComponent(packageName, isDirectory: true)
			try fileManager.createDirectory(at: packagePath, withIntermediateDirectories: true)
			
			let packageManifestPath = packagePath.appendingPathComponent("package.json")
			try encodedPackageManifest(for: packageManifest).write(to: packageManifestPath)
			
			let readmeFilePath = packagePath.appendingPathComponent("README.md")
			try readmeFileContents.write(to: readmeFilePath, atomically: false, encoding: .utf8)
			
			let packageThemeDirectoryPath = packagePath.appendingPathComponent("themes", isDirectory: true)
			try fileManager.createDirectory(at: packageThemeDirectoryPath, withIntermediateDirectories: true)
			
			let encodedThemePath = packageThemeDirectoryPath.appendingPathComponent("theme.json")
			let encodedTheme = try encodedThemeData(theme, as: .json)
			try encodedTheme.write(to: encodedThemePath)
		} catch {
			throw ThemeModelingError(kind: .invalidDestination, description: "Can not write enclosed theme package to destination directory '\(path.description)'. \(error.localizedDescription)")
		}
	}
	
	// MARK: Name Processing
	
	private static func themePackageName(_ name: String) -> String {
		return "\(vendorIdentifier).\(normalizedThemeName(name))-\(defaultThemeVersion)"
	}
	
	private static func normalizedThemeName(_ name: String) -> String {
		return name.lowercased().replacingOccurrences(of: " ", with: "-")
	}
	
	// MARK: Package Manifest
	
	private static func themePackageManifest(for theme: VisualStudioCodeTheme, properties: ThemeEnclosureProperties? = nil) -> PackageManifest {
		let (name, description) = themeProperties(for: theme, from: properties)
		
		return PackageManifest(
			version: "1.0.0",
			preview: true,
			name: normalizedThemeName(name),
			displayName: name,
			description: description ?? "",
			license: "UNLICENSED",
			categories: ["Themes"],
			keywords: ["theme", "color-theme", "color-theme-utility"],
			engines: ["vscode": "^1.13.0"],
			galleryBanner: GalleryBanner(color: defaultBannerColor.hexadecimalString, theme: .dark),
			contributes: ["themes": [
				[
					"label": theme.name,
					"uiTheme": userInterfaceTheme(for: theme.type).rawValue,
					"path": "./themes/theme.json"
				]
			]],
			metadata: Metadata(
				id: UUID(),
				publisherId: nil,
				publisherDisplayName: publisherName,
				preRelease: true,
				installedTimestamp: nil
			)
		)
	}
	
	private static func encodedPackageManifest(for manifest: PackageManifest) -> Data {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted]
		
		return try! encoder.encode(manifest)
	}
	
	// MARK: Utility
	
	private static func userInterfaceTheme(for appearance: VisualStudioCodeThemeAppearance) -> UserInterfaceTheme {
		switch appearance {
		case .dark:
			return .dark
		case .light:
			return .light
		}
	}
	
	private static func themeProperties(for theme: VisualStudioCodeTheme, from properties: ThemeEnclosureProperties?) -> (name: String, description: String?) {
		return (properties?.name ?? defaultThemeName, properties?.description)
	}
	
}

public struct VisualStudioCodePackageManifest {
	
	public let version: String
	public let preview: Bool
	public let name: String
	public let displayName: String
	public let description: String
	public let license: String
	public let categories: [String]
	public let keywords: [String]
	public let engines: [String: String]
	public let galleryBanner: GalleryBanner
	public let contributes: Contributions
	public let metadata: Metadata
	
	public struct GalleryBanner: Codable {
		public typealias Appearance = VisualStudioCodeThemeAppearance
		
		public let color: String
		public let theme: Appearance
	}
	
	public typealias Contribution = [String: String]
	public typealias Contributions = [String: [Contribution]]
	
	public struct Metadata: Codable {
		public let id: UUID?
		public let publisherId: UUID?
		public let publisherDisplayName: String
		public let preRelease: Bool?
		public let installedTimestamp: Int?
	}
	
}

extension VisualStudioCodePackageManifest: Codable {
	
	public enum CodingKeys: String, CaseIterable, CodingKey {
		case version
		case preview
		case name
		case displayName
		case description
		case license
		case categories
		case keywords
		case engines
		case galleryBanner
		case contributes
		case metadata = "__metadata"
	}
	
}

public enum VisualStudioCodeUserInterfaceTheme: String, Codable {
	case light = "vs"
	case dark = "vs-dark"
	case highContrast = "hc-black"
}
