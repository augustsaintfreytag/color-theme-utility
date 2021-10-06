//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 29/09/2021.
//

import Foundation

/// Detection capabilities to return an appropriate `ColorFormat` for any given input string.
///
/// Supports the following formats:
/// - FloatRGBA (Xcode/Plist): `0.290196 0.290196 0.968627 1`
/// - Hexadecimal: `#2ABB14` or `2ABB14`
///
public protocol ColorFormatDetector {}

extension ColorFormatDetector {
	
	/// Checks the given string and returns its likely color format.
	public func colorFormat(for string: String) -> ColorFormat? {
		if string.split(separator: " ").count == 4 {
			return .floatRGBA
		}
		
		if string.first == "#", string.count == 7 {
			return .hexadecimal
		}
		
		if string.count == 6 {
			return .hexadecimal
		}
		
		return nil
	}
	
}
