//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 07/10/2021.
//

import XCTest
import ColorThemeFramework

class ColorHSLConversionTest: XCTestCase, ColorConversionTestProvider {

	// MARK: Data
	
	private var hslColorTestData: [(rgb: ColorValueComponents, hsl: ColorValueComponents)] {
		[
			(bit8(0, 0, 0), (0, 0, 0)),						// Black
			(bit8(127, 127, 127), (0, 0, 0.498)),			// 50% Gray
			(bit8(255, 0, 0), (0, 1, 0.5)),					// Red
			(bit8(255, 255, 255), (0, 0, 1)),				// White
			(bit8(1, 1, 1), (0, 0, 0.004)),					// Almost Black
			(bit8(254, 254, 254), (0, 0, 0.996)),			// Almost White
			(bit8(42, 177, 175), (0.497, 0.616, 0.429)),	// Theme 01
			(bit8(215, 20, 127), (0.908, 0.830, 0.461))		// Theme 02
		]
	}
	
	// MARK: Cases
	
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
	
	func testColorHSLRoundtrip() {
		let (initialRed, initialGreen, initialBlue) = bit8(90, 92, 141)
		var (red, green, blue) = (initialRed, initialGreen, initialBlue)
		
		for _ in 0 ..< 25 {
			let color = Color(red: red, green: green, blue: blue)
			let (hue, saturation, lightness) = color.hsl
			let reconvertedColor = Color(hue: hue, saturation: saturation, lightness: lightness)
			
			defer {
				(red, green, blue) = reconvertedColor.rgb
			}
			
			assertValuesEqual(initialRed, reconvertedColor.red)
			assertValuesEqual(initialGreen, reconvertedColor.green)
			assertValuesEqual(initialBlue, reconvertedColor.blue)
		}
	}

}
