//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModeling

protocol ColorConversionCommand: CommandFragment, ColorModeler {}

extension ColorConversionCommand {
	
	func convertColor() throws {
		guard let inputColorString = inputColors?.first, let inputColor = Self.color(fromAutodetectedColorString: inputColorString) else {
			throw ArgumentError(description: "Missing input color or given input has invalid or unsupported format.")
		}
		
		guard case .color(let outputColorFormat) = outputFormat else {
			throw ArgumentError(description: "Missing output color format for color conversion.")
		}
		
		switch outputColorFormat {
		case .floatRGBA:
			print(inputColor.floatRGBAString)
		case .hexadecimal:
			print(inputColor.hexadecimalString)
		}
	}
	
}
