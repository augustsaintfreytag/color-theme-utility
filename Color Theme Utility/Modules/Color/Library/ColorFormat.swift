//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 29/09/2021.
//

import Foundation
import ArgumentParser

/// General format of an encoded color string.
enum ColorFormat: String, CaseIterable, ExpressibleByArgument {
	
	case floatRGBA = "floatrgba"
	case hexadecimal = "hex"
	
}

extension ColorFormat: CustomStringConvertible {
	
	var description: String {
		switch self {
		case .floatRGBA:
			return "Float RGBA"
		case .hexadecimal:
			return "Hexadecimal"
		}
	}
	
}
