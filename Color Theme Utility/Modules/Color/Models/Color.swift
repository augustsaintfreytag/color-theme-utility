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
	
	/// The red color component value.
	let red: ColorValue
	
	/// The green color component value.
	let green: ColorValue
	
	/// The blue color component value.
	let blue: ColorValue
	
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

extension Color {
	
	private typealias StringIndexRange = ClosedRange<String.Index>
	
	/// The highest encodable hexadecimal value per color component.
	/// Calculated as `Float(16 ^ 2 - 1)`.
	private static var maxHexadecimalValue: Float { 255 }
	
	private static func hexadecimalString(for value: ColorValue) -> String {
		let standardizedValue = Int(value * Self.maxHexadecimalValue)
		return String(standardizedValue, radix: 16, uppercase: true)
	}
	
	private static func colorValue(fromHexadecimalString string: String) -> ColorValue {
		let standardizedValue = Int(string, radix: 16)!
		return Float(standardizedValue) / maxHexadecimalValue
	}
	
	private static func hexadecimalColorComponents(for string: String) -> (red: String, green: String, blue: String)? {
		guard let string = standardizedHexadecimalString(from: string) else {
			return nil
		}
		
		let stringSequences = string.split(intoSubsequencesOfLength: 2).remapped
		let (red, green, blue) = (stringSequences[0], stringSequences[1], stringSequences[2])
		
		return (red, green, blue)
	}
	
	/// Returns a format-validated and standardized expression of a hexadecimal
	/// color string, always outputting a sequence of six characters or `nil` if the
	/// string does not have an acceptable structure.
	///
	/// Can convert a prefixed string of format `"#2AB1AF"` to `"2AB1AF"`.
	private static func standardizedHexadecimalString(from string: String) -> String? {
		if string.count == 7 {
			return String(string.suffix(6))
		}
		
		if string.count == 6 {
			return string
		}
		
		return nil
	}
	
	// MARK: String Representation
	
	/// The hexadecimal description of the represented color.
	var hexadecimalString: String {
		let redComponent = Self.hexadecimalString(for: red)
		let greenComponent = Self.hexadecimalString(for: green)
		let blueComponent = Self.hexadecimalString(for: blue)
		
		return "#\(redComponent)\(greenComponent)\(blueComponent)"
	}
	
	// MARK: Init
	
	init?(fromHexadecimalString string: String) {
		guard let (redComponent, greenComponent, blueComponent) = Self.hexadecimalColorComponents(for: string) else {
			return nil
		}
		
		self.red = Self.colorValue(fromHexadecimalString: redComponent)
		self.green = Self.colorValue(fromHexadecimalString: greenComponent)
		self.blue = Self.colorValue(fromHexadecimalString: blueComponent)
	}
	
}