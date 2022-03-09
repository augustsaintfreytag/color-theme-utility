//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 17/02/2022.
//

import Foundation
import ColorThemeModeling
import ColorThemeCoding

public typealias ThemeEnclosureProperties = (name: String?, description: String?)

public protocol ThemeEnclosureWriter: VisualStudioCodeThemeEnclosureWriter {}

extension ThemeEnclosureWriter {
	
	public static func writeTheme(_ theme: Theme, to path: URL, properties: ThemeEnclosureProperties? = nil) throws {
		switch theme {
		case let intermediateTheme as IntermediateTheme:
			try writeUnenclosedTheme(intermediateTheme, to: path, properties: properties)
		case let xcodeTheme as XcodeTheme:
			try writeUnenclosedTheme(xcodeTheme, to: path, properties: properties)
		case let textMateTheme as TextMateTheme:
			try writeUnenclosedTheme(textMateTheme, to: path, properties: properties)
		case let visualStudioCodeTheme as VisualStudioCodeTheme:
			try writeEnclosedTheme(visualStudioCodeTheme, to: path, properties: properties)
		default:
			throw ThemeCodingError(description: "Generated theme data with format '\(theme.format)' can not be output.")
		}
	}
	
	private static func writeUnenclosedTheme<CodableTheme: Theme & Encodable>(_ theme: CodableTheme, to outputDirectoryPath: URL, properties: ThemeEnclosureProperties? = nil) throws {
		let encoding = defaultEncoding(for: theme)
		let encodedTheme = try encodedTheme(theme, as: encoding)
		
		let fileName = fileName(for: theme, name: properties?.name)
		let filePath = outputDirectoryPath.appendingPathComponent(fileName)
		
		try encodedTheme.write(to: filePath, atomically: false, encoding: .utf8)
	}
	
	private static func fileName(for theme: Theme, name: String?) -> String {
		let themeName = sanitizedThemeName(name ?? defaultThemeName)
		
		guard let fileEnding = defaultFileEnding(for: theme) else {
			return themeName
		}
		
		return "\(themeName).\(fileEnding)"
	}
	
}
