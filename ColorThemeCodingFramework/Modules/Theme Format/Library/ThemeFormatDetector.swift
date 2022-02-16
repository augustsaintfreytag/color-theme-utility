//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 05/11/2021.
//

import Foundation
import ColorThemeModelingFramework

/// Functionality to detect the format of themes from their encoded forms (raw data)
/// via heuristics known about supported types.
public protocol ThemeFormatDetector {}

extension ThemeFormatDetector {
	
	/// Auto-detects the format of the given encoded theme data.
	///
	/// Tries to determine the encoded format by checking for heuristics,
	/// does not try to actually decode any data.
	public static func themeFormat(for encodedThemeData: Data) -> ThemeFormat? {
		guard let dataString = String(data: encodedThemeData, encoding: .utf8) else {
			return nil
		}
		
		if dataString.contains(IntermediateTheme.defaultFormat) {
			return .intermediate
		}
		
		if dataString.contains("DVTFontAndColorVersion") {
			return .xcode
		}
		
		if dataString.contains("<key>settings</key>") {
			return .textmate
		}
		
		if dataString.contains("editor.foreground") {
			return .vscode
		}
		
		return nil
	}
	
}
