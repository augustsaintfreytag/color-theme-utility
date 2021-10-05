//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 27/09/2021.
//

import Foundation

/// A color value, internally represented as single-precision RGB components.
struct Color: Codable {
	
	/// The type used to internally represent a color value.
	typealias ColorValue = Float
	
	// MARK: Properties
	
	/// The red color component value.
	let red: ColorValue
	
	/// The green color component value.
	let green: ColorValue
	
	/// The blue color component value.
	let blue: ColorValue
	
	// MARK: Convenience Properties
	
	var rgb: (red: ColorValue, green: ColorValue, blue: ColorValue) {
		return (red, green, blue)
	}
	
}

// MARK: HSL

extension Color: HSLColorConverter {
	
	var hsl: HSLColorValueComponents {
		return Self.hslComponents(for: rgb)
	}
	
	var hsp: ColorValue {
		return sqrt(0.299 * pow(red, 2) + 0.587 * pow(green, 2) + 0.114 * pow(blue, 2))
	}
	
	var perception: ColorValue {
		return hsl.hue / 360
	}
	
}

// MARK: Defaults

extension Color {
	
	static var red: Color {
		return Color(red: 1.0, green: 0.0, blue: 0.0)
	}
	
	static var green: Color {
		return Color(red: 0.0, green: 1.0, blue: 0.0)
	}
	
	static var blue: Color {
		return Color(red: 0.0, green: 0.0, blue: 1.0)
	}
	
}

// MARK: Hexadecimal

extension Color: HexadecimalColorParser {
	
	/// The hexadecimal description of the represented color.
	var hexadecimalString: String {
		Self.hexadecimalString(from: rgb)
	}
	
	// MARK: Init
	
	init?(fromHexadecimalString string: String) {
		guard let (redComponent, greenComponent, blueComponent) = Self.colorComponentsFromHexadecimalString(for: string) else {
			return nil
		}
		
		self.red = Self.colorValue(fromHexadecimalString: redComponent)
		self.green = Self.colorValue(fromHexadecimalString: greenComponent)
		self.blue = Self.colorValue(fromHexadecimalString: blueComponent)
	}
	
}

// MARK: Float RGBA

extension Color: FloatRGBAColorParser {
	
	var floatRGBAString: String {
		Self.floatRGBAString(from: rgb)
	}
	
	// MARK: Init
	
	init?(fromFloatRGBAString string: String) {
		guard let (redComponent, greenComponent, blueComponent) = Self.colorComponentsFromFloatRGBAString(for: string) else {
			return nil
		}
		
		guard
			let redValue = Self.colorValue(fromFloatRGBAString: redComponent),
			let greenValue = Self.colorValue(fromFloatRGBAString: greenComponent),
			let blueValue = Self.colorValue(fromFloatRGBAString: blueComponent)
		else {
			return nil
		}
		
		self.red = redValue
		self.green = greenValue
		self.blue = blueValue
	}
	
}

