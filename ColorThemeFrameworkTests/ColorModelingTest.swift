//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 05/10/2021.
//

import XCTest
@testable import ColorThemeFramework

class ColorModelingTest: XCTestCase {
	
	typealias ColorValue = Color.ColorValue
	typealias ColorValueComponents = (red: ColorValue, green: ColorValue, blue: ColorValue)
	
	
	func testColorModelingFromRGB() {
		let color = Color(red: 1, green: 1, blue: 1)
		
		XCTAssertEqual(color.red, 1)
		XCTAssertEqual(color.green, 1)
		XCTAssertEqual(color.blue, 1)
	}
	
	func testColorModelingFromRandomRGB() {
		for _ in 0 ..< 25 {
			let (red, green, blue) = (randomRGBValue(), randomRGBValue(), randomRGBValue())
			let color = Color(red: red, green: green, blue: blue)
			
			XCTAssertEqual(color.red, red)
			XCTAssertEqual(color.green, green)
			XCTAssertEqual(color.blue, blue)
		}
	}
	
	func testHexadecimalFromColor() {
		let data: [(rgb: ColorValueComponents, hex: String)] = [
			((0, 0, 0), "#000000"),
			((1, 0, 0), "#FF0000"),
			((0, 1, 0), "#00FF00"),
			((1, 1, 1), "#FFFFFF"),
			(bit8(42, 177, 175), "#2AB1AF"),
			(bit8(215, 20, 127), "#D7147F")
		]
		
		for (components, hexadecimalString) in data {
			let (red, green, blue) = components
			let color = Color(red: red, green: green, blue: blue)
			
			XCTAssertEqual(color.hexadecimalString, hexadecimalString)
		}
	}
	
	func testColorFromHexadecimal() {
		// TODO: Write test.
	}
	
	func testHSLFromColor() {
		let data: [(rgb: ColorValueComponents, hsl: ColorValueComponents)] = [
			(bit8(42, 177, 175), (0.497, 0.616, 0.429)),
			(bit8(215, 20, 127), (0.908, 0.830, 0.461))
		]
		
		for (rgbComponents, hslComponents) in data {
			let (red, green, blue) = rgbComponents
			let (hue, saturation, lightness) = hslComponents
			let color = Color(red: red, green: green, blue: blue)
			
			let formedHSL = color.hsl
			assertValuesEqual(hue, formedHSL.hue)
			assertValuesEqual(lightness, formedHSL.lightness)
			assertValuesEqual(saturation, formedHSL.saturation)
		}
	}
	
	func testColorFromHSL() {
		let data: [(rgb: ColorValueComponents, hsl: ColorValueComponents)] = [
			(bit8(42, 177, 175), (0.497, 0.616, 0.429)),
			(bit8(215, 20, 127), (0.908, 0.830, 0.461))
		]
		
		for (rgbComponents, hslComponents) in data {
			let (red, green, blue) = rgbComponents
			let (hue, saturation, lightness) = hslComponents
			let color = Color(hue: hue, saturation: saturation, lightness: lightness)
			
			let formedRGB = color.rgb
			assertValuesEqual(red, formedRGB.red)
			assertValuesEqual(green, formedRGB.green)
			assertValuesEqual(blue, formedRGB.blue)
		}
	}
	
	// MARK: Asserts
	
	private func assertValuesEqual(_ lhs: ColorValue, _ rhs: ColorValue) {
		let roundedLhs = roundedValue(lhs)
		let roundedRhs = roundedValue(rhs)
		
		XCTAssertTrue(valuesAreEqual(roundedLhs, roundedRhs), "Values not equal, \(roundedLhs) and \(roundedRhs) (rounded)")
	}
	
	// MARK: Random Value
	
	private func randomRGBValue() -> ColorValue {
		return ColorValue.random(in: 0 ... 1)
	}
	
	// MARK: Value Comparison
	
	private func valuesAreEqual(_ lhs: ColorValue, _ rhs: ColorValue) -> Bool {
		let delta = abs(lhs - rhs)
		return delta <= 0.01
	}
	
	private func roundedValue(_ value: ColorValue) -> ColorValue {
		return round(value * 1000) / 1000
	}
	
	// MARK: Value Expansion
	
	private func bit8(_ value: ColorValue) -> ColorValue {
		return value / 255
	}

	private func bit8(_ a: ColorValue, _ b: ColorValue, _ c: ColorValue) -> (ColorValue, ColorValue, ColorValue) {
		return (bit8(a), bit8(b), bit8(c))
	}
	
}
