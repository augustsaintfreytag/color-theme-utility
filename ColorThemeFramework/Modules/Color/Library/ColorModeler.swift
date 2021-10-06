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
	public func color(fromAutodetectedColorString string: String) -> Color? {
		guard let format = colorFormat(for: string) else {
			return nil
		}
		
		switch format {
		case .floatRGBA:
			return Color(fromFloatRGBAString: string)
		case .hexadecimal:
			return Color(fromHexadecimalString: string)
		}
	}
	
}
