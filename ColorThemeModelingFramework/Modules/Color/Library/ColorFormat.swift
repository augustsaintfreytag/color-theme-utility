//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 29/09/2021.
//

import Foundation

/// General format of an encoded color string.
public enum ColorFormat: String, CaseIterable, Codable {
	
	case floatRGBA = "floatrgba"
	case hexadecimal = "hex"
	
}

extension ColorFormat: CustomStringConvertible {
	
	public var description: String {
		switch self {
		case .floatRGBA:
			return "Float RGBA"
		case .hexadecimal:
			return "Hexadecimal"
		}
	}
	
}
