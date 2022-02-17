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
	
	private static var vendorName: String { "color-theme-utility" }
	
	private static var defaultThemeVersion: String { "1.0.0" }
	private static var defaultBannerColor: Color { Color(red: 0.235, green: 0.270, blue: 0.341) }
	
	private typealias PackageManifest = VisualStudioCodePackageManifest
	private typealias GalleryBanner = VisualStudioCodePackageManifest.GalleryBanner
	private typealias Contributions = VisualStudioCodePackageManifest.Contributions
	private typealias Metadata = VisualStudioCodePackageManifest.Metadata
	private typealias UserInterfaceTheme = VisualStudioCodeUserInterfaceTheme
	
	public static func writeEnclosedTheme(_ theme: VisualStudioCodeTheme, to path: URL) throws {
		let packageName = themePackageName(theme.name)
		let packageManifest = themePackageManifest(for: theme)
		let readmeFileContents = readmeTextForVisualStudioCodeTheme(name: theme.name, description: nil)
		
		do {
			let fileManager = FileManager.default
			
			let packagePath = path.appendingPathComponent(packageName, isDirectory: true)
			try fileManager.createDirectory(at: packagePath, withIntermediateDirectories: false)
			
			let packageManifestPath = packagePath.appendingPathComponent("package.json")
			try encodedPackageManifest(for: packageManifest).write(to: packageManifestPath)
			
			let readmeFilePath = packagePath.appendingPathComponent("README.md")
			try readmeFileContents.write(to: readmeFilePath, atomically: false, encoding: .utf8)
			
			let packageThemeDirectoryPath = packagePath.appendingPathComponent("themes", isDirectory: true)
			try fileManager.createDirectory(at: packageThemeDirectoryPath, withIntermediateDirectories: false)
			
			let encodedThemePath = packageThemeDirectoryPath.appendingPathComponent("theme.json")
			let encodedTheme = try encodedThemeData(theme, as: .json)
			try encodedTheme.write(to: encodedThemePath)
		} catch {
			throw ThemeModelingError(kind: .invalidDestination, description: "Can not write enclosed theme package to destination directory '\(path.description)'. \(error.localizedDescription)")
		}
	}
	
	private static func themePackageName(_ name: String) -> String {
		return "\(vendorName).\(normalizedThemeName(name))-\(defaultThemeVersion)"
	}
	
	private static func normalizedThemeName(_ name: String) -> String {
		return name.lowercased().replacingOccurrences(of: " ", with: "-")
	}
	
	private static func themePackageManifest(for theme: VisualStudioCodeTheme) -> PackageManifest {
		PackageManifest(
			version: "1.0.0",
			preview: true,
			name: theme.name,
			displayName: theme.name,
			description: defaultThemeDescription,
			license: "UNLICENSED",
			categories: ["Themes"],
			keywords: ["theme", "color-theme", "color-theme-utility"],
			engines: ["vscode": "^1.13.0"],
			galleryBanner: GalleryBanner(color: defaultBannerColor.hexadecimalString, theme: .dark),
			contributes: ["themes": [
				[
					"label": theme.name,
					"uiTheme": userInterfaceTheme(for: theme.type).rawValue,
					"path": "./theme/theme.json"
				]
			]],
			metadata: Metadata(
				id: UUID(),
				publisherId: nil,
				publisherDisplayName: "Color Theme Utility",
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
	
	private static var defaultThemeDescription: String {
		"This theme package was generated with the Color Theme Utility, a project by August Saint Freytag (https://augustfreytag.com)."
	}
	
	private static func userInterfaceTheme(for appearance: VisualStudioCodeThemeAppearance) -> UserInterfaceTheme {
		switch appearance {
		case .dark:
			return .dark
		case .light:
			return .light
		}
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
	
	public enum CodingKeys: String, CodingKey {
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
