//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 30/09/2021.
//

import Foundation

protocol ColorModeler: ColorFormatDetector {}

extension ColorModeler {
	
	/// Detectes the format of the given color string and creates a `Color` model for supported types.
	func color(fromAutodetectedColorString string: String) -> Color? {
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