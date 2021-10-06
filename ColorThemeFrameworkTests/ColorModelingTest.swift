//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 05/10/2021.
//

import XCTest
@testable import ColorThemeFramework

class ColorModelingTest: XCTestCase {
	
	func testColorModelingFromRGB() {
		let color = Color(red: 1.0, green: 1.0, blue: 1.0)
		
		XCTAssertEqual(color.red, 1.0)
		XCTAssertEqual(color.green, 1.0)
		XCTAssertEqual(color.blue, 1.0)
	}
	
}
