//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 05/11/2021.
//

import Foundation

/// Functionality to detect the format of themes from their encoded forms (raw data)
/// via heuristics known about supported types.
public protocol ThemeFormatDetector {}

extension ThemeFormatDetector {
	
	/// Auto-detects the representative format of the given encoded theme data.
	public func themeFormat(for encodedThemeData: Data) -> ThemeFormat? {
		guard let dataString = String(data: encodedThemeData, encoding: .utf8) else {
			return nil
		}
		
		if dataString.contains(IntermediateTheme.defaultFormat) {
			return .intermediate
		}
		
		if dataString.contains("DVTFontAndColorVersion") {
			return .xcode
		}
		
		return nil
	}
	
}
