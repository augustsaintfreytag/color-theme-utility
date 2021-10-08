//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 03/10/2021.
//

import Foundation

/// Bidirectional parser and description provider for `Color` values in Float RGBA representation.
public protocol FloatRGBAColorParser {
	
	typealias ColorValue = Color.ColorValue
	typealias RGBColorComponents = (red: ColorValue, green: ColorValue, blue: ColorValue)
	typealias RGBColorStringComponents = (red: String, green: String, blue: String)
	
}

extension FloatRGBAColorParser {
	
	// MARK: Input Computation
	
	static func rgbComponents(fromFloatRGBAString string: String) -> RGBColorComponents? {
		guard let (redComponent, greenComponent, blueComponent) = colorStringComponents(fromFloatRGBAString: string) else {
			return nil
		}
		
		guard
			let red = colorValue(fromFloatRGBAString: redComponent),
			let green = colorValue(fromFloatRGBAString: greenComponent),
			let blue = colorValue(fromFloatRGBAString: blueComponent)
		else {
			return nil
		}
		
		return (red, green, blue)
	}
	
	private static func colorStringComponents(fromFloatRGBAString string: String) -> RGBColorStringComponents? {
		let components = string.split(separator: " ").mapped
		
		guard components.count == 4 else {
			return nil
		}
		
		return (components[0], components[1], components[2])
	}
	
	private static func colorValue(fromFloatRGBAString string: String) -> ColorValue? {
		guard let value = ColorValue(string), value >= 0, value <= 1 else {
			return nil
		}
		
		return value
	}
	
	// MARK: Output Computation
	
	static func floatRGBAString(from components: RGBColorComponents) -> String {
		let (red, green, blue) = components
		let redComponent = floatRGBAStringComponent(for: red)
		let greenComponent = floatRGBAStringComponent(for: green)
		let blueComponent = floatRGBAStringComponent(for: blue)
		
		return "\(redComponent) \(greenComponent) \(blueComponent) 1"
	}
	
	private static func floatRGBAStringComponent(for value: ColorValue) -> String {
		return String(value)
	}
	
}
