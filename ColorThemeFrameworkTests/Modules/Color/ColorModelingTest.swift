//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 05/10/2021.
//

import XCTest
@testable import ColorThemeFramework

class ColorModelingTest: XCTestCase, ColorConversionTestProvider {
	
	typealias ColorValue = Color.ColorValue
	typealias ColorValueComponents = (red: ColorValue, green: ColorValue, blue: ColorValue)
	
	// MARK: RGB (Base)
	
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
	
	// MARK: Hexadecimal
	
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
	
	// MARK: HSL
	
	private var hslColorTestData: [(rgb: ColorValueComponents, hsl: ColorValueComponents)] {
		[
			(bit8(0, 0, 0), (0, 0, 0)),						// Black
			(bit8(127, 127, 127), (0, 0, 0.498)),			// 50% Gray
			(bit8(255, 0, 0), (0, 1, 0.5)),					// Red
			(bit8(255, 255, 255), (0, 0, 1)),				// White
			(bit8(42, 177, 175), (0.497, 0.616, 0.429)),	// Theme 01
			(bit8(215, 20, 127), (0.908, 0.830, 0.461))		// Theme 02
		]
	}
	
	func testHSLFromColor() {
		for (rgbComponents, hslComponents) in hslColorTestData {
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
		for (rgbComponents, hslComponents) in hslColorTestData {
			let (red, green, blue) = rgbComponents
			let (hue, saturation, lightness) = hslComponents
			let color = Color(hue: hue, saturation: saturation, lightness: lightness)
			
			let formedRGB = color.rgb
			assertValuesEqual(red, formedRGB.red)
			assertValuesEqual(green, formedRGB.green)
			assertValuesEqual(blue, formedRGB.blue)
		}
	}
	
	// MARK: Random Value
	
	private func randomRGBValue() -> ColorValue {
		return ColorValue.random(in: 0 ... 1)
	}
	
}
