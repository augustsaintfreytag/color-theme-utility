//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 05/10/2021.
//

import XCTest
@testable import ColorThemeModelingFramework

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
	
	// MARK: Random Value
	
	private func randomRGBValue() -> ColorValue {
		return ColorValue.random(in: 0 ... 1)
	}
	
}
