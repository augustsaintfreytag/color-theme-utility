//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 27/09/2021.
//

import Foundation

/// A color value, internally represented as single-precision RGB components.
public struct Color: Codable {
	
	/// The type used to internally represent a color value.
	public typealias ColorValue = Float
	
	// MARK: Properties
	
	/// The red color component value.
	public let red: ColorValue
	
	/// The green color component value.
	public let green: ColorValue
	
	/// The blue color component value.
	public let blue: ColorValue
	
	// MARK: Init
	
	public init(red: ColorValue, green: ColorValue, blue: ColorValue) {
		self.red = Self.limit(red)
		self.green = Self.limit(green)
		self.blue = Self.limit(blue)
	}
	
	// MARK: Convenience Properties
	
	public var rgb: (red: ColorValue, green: ColorValue, blue: ColorValue) {
		return (red, green, blue)
	}
	
	// MARK: Utility
	
	private static func limit(_ value: ColorValue) -> ColorValue {
		return max(0, min(1, value))
	}
	
}

// MARK: Defaults

extension Color {
	
	static var white: Color {
		return Color(red: 1, green: 1, blue: 1)
	}
	
	static var black: Color {
		return Color(red: 0, green: 0, blue: 0)
	}
	
	static var red: Color {
		return Color(red: 1, green: 0, blue: 0)
	}
	
	static var green: Color {
		return Color(red: 0, green: 1, blue: 0)
	}
	
	static var blue: Color {
		return Color(red: 0, green: 0, blue: 1)
	}
	
}

// MARK: Comparable

extension Color: Comparable {

	public static func < (lhs: Color, rhs: Color) -> Bool {
		let lhsValue = lhs.hsl.hue / 360
		let rhsValue = rhs.hsl.hue / 360
		
		return lhsValue < rhsValue
	}

}

// MARK: Description

extension Color: CustomStringConvertible {
	
	public var description: String {
		return "Red: \(red), Green: \(green), Blue: \(blue)"
	}
	
}

// MARK: HSL

extension Color: HSLColorConverter {
	
	public var hsl: HSLColorComponents {
		return Self.hslComponents(for: rgb)
	}
	
	public var hsp: ColorValue {
		return sqrt(0.299 * pow(red, 2) + 0.587 * pow(green, 2) + 0.114 * pow(blue, 2))
	}
	
	// MARK: Init
	
	public init(hue: ColorValue, saturation: ColorValue, lightness: ColorValue) {
		let (red, green, blue) = Self.rgbComponents(from: (hue, saturation, lightness))
		
		self.red = red
		self.green = green
		self.blue = blue
	}
	
}

// MARK: Hexadecimal

extension Color: HexadecimalColorParser {
	
	/// The hexadecimal description of the represented color.
	public var hexadecimalString: String {
		Self.hexadecimalString(from: rgb)
	}
	
	// MARK: Init
	
	public init?(fromHexadecimalString string: String) {
		guard let (red, green, blue) = Self.rgbComponents(fromHexadecimalString: string) else {
			return nil
		}
		
		self.red = red
		self.green = green
		self.blue = blue
	}
	
}

// MARK: Float RGBA

extension Color: FloatRGBAColorParser {
	
	public var floatRGBAString: String {
		Self.floatRGBAString(from: rgb)
	}
	
	// MARK: Init
	
	public init?(fromFloatRGBAString string: String) {
		guard let (red, green, blue) = Self.rgbComponents(fromFloatRGBAString: string) else {
			return nil
		}
		
		self.red = red
		self.green = green
		self.blue = blue
	}
	
}

