//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModelingFramework

protocol ColorConversionCommand: CommandFragment, ColorModeler {}

extension ColorConversionCommand {
	
	func convertColor() throws {
		let inputColorArgument = lineFromStdin ?? inputColors?.first
		
		guard let inputColorString = inputColorArgument, let inputColor = Self.color(fromAutodetectedColorString: inputColorString) else {
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
