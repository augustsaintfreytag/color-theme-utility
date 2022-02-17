//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 16/02/2022.
//

import Foundation
import ColorThemeModelingFramework

// TODO: Consider `README.md` file to be included with theme packages.

public protocol VisualStudioCodeThemeEnclosureProvider: ThemeCoercionProvider {}

public extension VisualStudioCodeThemeEnclosureProvider {
	
	private static var vendorName: String { "color-theme-utility" }
	
	private static var defaultThemeVersion: String { "1.0.0" }
	private static var defaultBannerColor: Color { Color(red: 0.235, green: 0.270, blue: 0.341) }
	
	private typealias PackageManifest = VisualStudioCodePackageManifest
	private typealias GalleryBanner = VisualStudioCodePackageManifest.GalleryBanner
	private typealias Contributions = VisualStudioCodePackageManifest.Contributions
	private typealias Metadata = VisualStudioCodePackageManifest.Metadata
	private typealias UserInterfaceTheme = VisualStudioCodeUserInterfaceTheme
	
	public static func writeThemeEnclosure(for theme: VisualStudioCodeTheme, to path: URL) throws {
		let packageName = themePackageName(name: theme.name)
		let packageManifest = themePackageManifest(for: theme)
		let readmeFileContents = readmeTextForVisualStudioCodeTheme(name: theme.name, description: nil)
		
		// …
	}
	
	private static func themePackageName(name: String) -> String {
		return "\(vendorName).\(name)-\(defaultThemeVersion)"
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
				"label": theme.name,
				"uiTheme": userInterfaceTheme(for: theme.type).rawValue,
				"path": "./theme/theme.json"
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
	
	public struct GalleryBanner {
		public typealias Appearance = VisualStudioCodeThemeAppearance
		
		public let color: String
		public let theme: Appearance
	}
	
	public typealias Contribution = [String: String]
	public typealias Contributions = [String: [Contribution]]
	
	public struct Metadata {
		public let id: UUID?
		public let publisherId: UUID?
		public let publisherDisplayName: String
		public let preRelease: Bool?
		public let installedTimestamp: Int?
	}
	
}

extension VisualStudioCodePackageManifest: Codable {
	
	public enum CodingKeys: CodingKey {
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
