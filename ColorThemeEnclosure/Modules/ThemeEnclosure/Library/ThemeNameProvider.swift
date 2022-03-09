//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 06/03/2022.
//

import Foundation

public protocol ThemeNameProvider {}

extension ThemeNameProvider {

	public static var defaultThemeName: String { "Theme" }
	
	public static var defaultThemeVersion: String { "1.0.0" }

	public static func sanitizedThemeName(_ name: String) -> String {
		return try! name
			.removingMatches(matching: "[^0-9a-zA-Z #&@()+_,;.\\-\u{00c0}-\u{017f}]")
			.replacingMatches(matching: "\\s+", with: " ")
			.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	public static func normalizedThemeName(_ name: String) -> String {
		return try! name
			.lowercased()
			.replacingMatches(matching: "\\s+", with: "-")
			.removingMatches(matching: "[^a-zA-Z0-9-]")
	}

}
