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
	
	private static func hexadecimalColorComponentIndexRanges(for string: String) -> (red: StringIndexRange, green: StringIndexRange, blue: StringIndexRange)? {
		guard string.count == 7 else {
			return nil
		}
		
		let redRange = string.index(string.startIndex, offsetBy: 1) ... string.index(string.startIndex, offsetBy: 2)
		let greenRange = string.index(redRange.upperBound, offsetBy: 1) ... string.index(redRange.upperBound, offsetBy: 2)
		let blueRange = string.index(greenRange.upperBound, offsetBy: 1) ... string.index(greenRange.upperBound, offsetBy: 2)
		
		return (redRange, greenRange, blueRange)
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
		guard let ranges = Self.hexadecimalColorComponentIndexRanges(for: string) else {
			return nil
		}
		
		let redComponent = String(string[ranges.red])
		let greenComponent = String(string[ranges.green])
		let blueComponent = String(string[ranges.blue])
		
		red = Self.colorValue(fromHexadecimalString: redComponent)
		green = Self.colorValue(fromHexadecimalString: greenComponent)
		blue = Self.colorValue(fromHexadecimalString: blueComponent)
	}
	
}
