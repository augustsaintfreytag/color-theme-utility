//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 25/10/2021.
//

import Foundation
import ColorThemeModeling

/// Functionality to encode a given theme into data that matches its format.
public protocol ThemeEncoder {}

extension ThemeEncoder {

	// MARK: Data String from Theme

	public static func encodedTheme<CodableTheme: Theme & Encodable>(_ theme: CodableTheme, as encoding: ThemeEncoding? = nil) throws -> String {
		let encodedThemeData = try encodedThemeData(theme, as: encoding)

		guard let encodedTheme = String(data: encodedThemeData, encoding: .utf8) else {
			throw ThemeCodingError(description: "Could not prepare encoded theme data for output.")
		}

		return encodedTheme
	}

	// MARK: Data from Theme

	public static func encodedThemeData<CodableTheme: Theme & Encodable>(_ theme: CodableTheme, as encoding: ThemeEncoding? = nil) throws -> Data {
		let encoding = encoding ?? defaultEncoding(for: theme)
		
		do {
			switch encoding {
			case .json:
				let encoder = JSONEncoder()
				encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
				return try encoder.encode(theme)
			case .plist:
				let encoder = PropertyListEncoder()
				encoder.outputFormat = .xml
				return try encoder.encode(theme)
			}
		} catch {
			throw ThemeCodingError(description: "Could not encode theme to '\(encoding.rawValue)'. \(error.localizedDescription)")
		}
	}
	
	public static func defaultFileEnding(for theme: Theme) -> String? {
		switch theme.format {
		case .intermediate:
			return "intertheme"
		case .xcode:
			return "xccolortheme"
		case .textmate:
			return "tmtheme"
		case .vscode:
			return nil
		}
	}
	
	public static func defaultEncoding(for theme: Theme) -> ThemeEncoding {
		switch theme.format {
		case .intermediate:
			return .json
		case .xcode:
			return .plist
		case .textmate:
			return .plist
		case .vscode:
			return .json
		}
	}

}
