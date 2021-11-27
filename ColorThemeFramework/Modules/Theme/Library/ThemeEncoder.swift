//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 25/10/2021.
//

import Foundation

/// Functionality to encode a given theme into data that matches its format.
public protocol ThemeEncoder {}

extension ThemeEncoder {

	// MARK: Data String from Theme

	public static func encodedTheme<CodableTheme: Theme & Encodable>(_ theme: CodableTheme, with encoding: ThemeEncoding) throws -> String {
		let encodedThemeData = try encodedThemeData(theme, with: encoding)

		guard let encodedTheme = String(data: encodedThemeData, encoding: .utf8) else {
			throw ThemeCodingError(description: "Could not prepare encoded theme data for output.")
		}

		return encodedTheme
	}

	// MARK: Data from Theme

	private static func encodedThemeData<CodableTheme: Theme & Encodable>(_ theme: CodableTheme, with encoding: ThemeEncoding) throws -> Data {
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

}
