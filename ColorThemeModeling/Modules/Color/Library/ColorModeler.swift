//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 30/09/2021.
//

import Foundation

/// Functionality to create `Color` models from strings.
public protocol ColorModeler: ColorFormatDetector {}

extension ColorModeler {
	
	/// Detects the format of the given color string and creates a `Color` model for supported types.
	public static func color(fromAutodetectedColorString string: String) -> Color? {
		guard let format = colorFormat(for: string) else {
			return nil
		}
		
		return color(from: string, format: format)
	}
	
	/// Creates and returns a `Color` from the given string, assuming the provided color format.
	public static func color(from string: String, format: ColorFormat) -> Color? {
		switch format {
		case .floatRGBA:
			return Color(fromFloatRGBAString: string)
		case .hexadecimal:
			return Color(fromHexadecimalString: string)
		}
	}
	
}
