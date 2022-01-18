//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 07/10/2021.
//

import XCTest
import ColorThemeModelingFramework

class ColorHexadecimalConversionTest: XCTestCase, ColorConversionTestProvider {

	// MARK: Data
	
	private var hexadecimalColorTestData: [(rgb: ColorValueComponents, hex: String)] {
		[
			((0, 0, 0), "#000000"),
			((1, 0, 0), "#FF0000"),
			((0, 1, 0), "#00FF00"),
			((1, 1, 1), "#FFFFFF"),
			(bit8(42, 177, 175), "#2AB1AF"),
			(bit8(215, 20, 127), "#D7147F")
		]
	}
	
	// MARK: Cases
	
	func testHexadecimalFromColor() {
		for (components, hexadecimalString) in hexadecimalColorTestData {
			let (red, green, blue) = components
			let color = Color(red: red, green: green, blue: blue)
			
			XCTAssertEqual(color.hexadecimalString, hexadecimalString)
		}
	}
	
	func testColorFromHexadecimal() {
		for (components, hexadecimalString) in hexadecimalColorTestData {
			guard let color = Color(fromHexadecimalString: hexadecimalString) else {
				XCTFail("Expected color from string '\(hexadecimalString)', nil returned.")
				return
			}
			
			assertValuesEqual(components.red, color.red)
			assertValuesEqual(components.green, color.green)
			assertValuesEqual(components.blue, color.blue)
		}
	}

}
