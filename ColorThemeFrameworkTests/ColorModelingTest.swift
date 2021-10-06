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
			(bit8(42, 177, 175), percentages(49, 61, 42)),
			(bit8(215, 20, 127), percentages(90, 82, 46))
		]
		
		for (rgbComponents, hslComponents) in data {
			let (red, green, blue) = rgbComponents
			let (hue, lightness, saturation) = hslComponents
			let color = Color(red: red, green: green, blue: blue)
			
			let formedHSL = color.hsl
			XCTAssertEqual(hue, roundedValue(formedHSL.hue))
			XCTAssertEqual(lightness, roundedValue(formedHSL.lightness))
			XCTAssertEqual(saturation, roundedValue(formedHSL.saturation))
		}
	}
	
	func testColorFromHSL() {
		let data: [(rgb: ColorValueComponents, hsl: ColorValueComponents)] = [
			(bit8(42, 177, 175), percentages(49, 61, 42)),
			(bit8(215, 20, 127), percentages(90, 82, 46))
		]
		
		for (rgbComponents, hslComponents) in data {
			let (red, green, blue) = rgbComponents
			let (hue, lightness, saturation) = hslComponents
			let color = Color(hue: hue, saturation: saturation, lightness: lightness)
			
			let formedRGB = color.rgb
			XCTAssertEqual(red, roundedValue(formedRGB.red))
			XCTAssertEqual(green, roundedValue(formedRGB.green))
			XCTAssertEqual(blue, roundedValue(formedRGB.blue))
		}
	}
	
	// MARK: Utility
	
	private func randomRGBValue() -> ColorValue {
		return ColorValue.random(in: 0 ... 1)
	}
	
	private func roundedValue(_ value: ColorValue) -> ColorValue {
		return round(value * 100) / 100
	}
	
	private func bit8(_ value: ColorValue) -> ColorValue {
		return value / 255
	}

	private func bit8(_ a: ColorValue, _ b: ColorValue, _ c: ColorValue) -> (ColorValue, ColorValue, ColorValue) {
		return (bit8(a), bit8(b), bit8(c))
	}
	
	private func percentage(_ value: ColorValue) -> ColorValue {
		return value / 100
	}
	
	private func percentages(_ a: ColorValue, _ b: ColorValue, _ c: ColorValue) -> (ColorValue, ColorValue, ColorValue) {
		return (percentage(a), percentage(b), percentage(c))
	}
	
}
