//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModelingFramework

protocol ColorDescriptionCommand: CommandFragment, ColorModeler, ColorPrinter {}

extension ColorDescriptionCommand {
	
	func describeColor() throws {
		guard let inputColor = inputColors?.first else {
			throw ArgumentError(description: "No color string given, color format could not be determined.")
		}
		
		guard let inputColorFormat = Self.colorFormat(for: inputColor) else {
			throw ArgumentError(description: "Color format could not be determined.")
		}
		
		guard let color = Self.color(from: inputColor, format: inputColorFormat) else {
			throw ArgumentError(description: "Could not create color in detected format '\(inputColorFormat)'.")
		}
		
		if humanReadable {
			printColor(color, description: "Input '\(inputColor)' is \(inputColorFormat.description) ('\(inputColorFormat.rawValue)')")
		} else {
			print(inputColorFormat.rawValue)
		}
	}
	
}
