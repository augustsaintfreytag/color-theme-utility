//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 03/10/2021.
//

import Foundation

/// Bidirectional parser and description provider for `Color` values in Float RGBA representation.
public protocol FloatRGBAColorParser {
	
	typealias ColorValue = Color.ColorValue
	typealias ColorValueComponents = (red: ColorValue, green: ColorValue, blue: ColorValue)
	typealias ColorStringComponents = (red: String, green: String, blue: String)
	
}

extension FloatRGBAColorParser {
	
	// MARK: Input Computation
	
	static func rgbComponents(fromFloatRGBAString string: String) -> ColorValueComponents? {
		guard let (redComponent, greenComponent, blueComponent) = Self.colorStringComponents(fromFloatRGBAString: string) else {
			return nil
		}
		
		guard
			let red = Self.colorValue(fromFloatRGBAString: redComponent),
			let green = Self.colorValue(fromFloatRGBAString: greenComponent),
			let blue = Self.colorValue(fromFloatRGBAString: blueComponent)
		else {
			return nil
		}
		
		return (red, green, blue)
	}
	
	private static func colorStringComponents(fromFloatRGBAString string: String) -> ColorStringComponents? {
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
	
	static func floatRGBAString(from components: ColorValueComponents) -> String {
		let (red, green, blue) = components
		let redComponent = Self.floatRGBAStringComponent(for: red)
		let greenComponent = Self.floatRGBAStringComponent(for: green)
		let blueComponent = Self.floatRGBAStringComponent(for: blue)
		
		return "\(redComponent) \(greenComponent) \(blueComponent) 1"
	}
	
	private static func floatRGBAStringComponent(for value: ColorValue) -> String {
		return String(value)
	}
	
}
