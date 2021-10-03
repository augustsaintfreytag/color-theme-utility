//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 03/10/2021.
//

import Foundation

/// Bidirectional parser and description provider for `Color` values in hexadecimal representation.
protocol HexadecimalColorParser {
	
	typealias ColorValue = Color.ColorValue
	typealias ColorValueComponents = (red: ColorValue, green: ColorValue, blue: ColorValue)
	typealias ColorStringComponents = (red: String, green: String, blue: String)
	
}

extension HexadecimalColorParser {
	
	// MARK: Value Conversion
	
	/// The highest encodable hexadecimal value per color component.
	/// Calculated as `Float(16 ^ 2 - 1)`.
	private static var maxHexadecimalValue: Float { 255 }
	
	static func hexadecimalStringComponent(for value: ColorValue) -> String {
		let standardizedValue = Int(value * Self.maxHexadecimalValue)
		return String(standardizedValue, radix: 16, uppercase: true)
	}
	
	static func colorValue(fromHexadecimalString string: String) -> ColorValue {
		let standardizedValue = Int(string, radix: 16)!
		return Float(standardizedValue) / maxHexadecimalValue
	}
	
	// MARK: Input Computation
	
	static func colorComponentsFromHexadecimalString(for string: String) -> (red: String, green: String, blue: String)? {
		guard let string = standardizedHexadecimalString(from: string) else {
			return nil
		}
		
		let stringSequences = string.split(intoSubsequencesOfLength: 2).mapped
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
	
	// MARK: Output Computation
	
	/// Return a hexadecimal string from the given color components.
	static func hexadecimalString(from components: (red: ColorValue, green: ColorValue, blue: ColorValue)) -> String {
		let (red, green, blue) = components
		let redComponent = Self.hexadecimalStringComponent(for: red)
		let greenComponent = Self.hexadecimalStringComponent(for: green)
		let blueComponent = Self.hexadecimalStringComponent(for: blue)
		
		return "#\(redComponent)\(greenComponent)\(blueComponent)"
	}
	
}
