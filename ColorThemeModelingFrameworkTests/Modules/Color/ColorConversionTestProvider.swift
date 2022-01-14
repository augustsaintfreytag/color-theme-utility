//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 07/10/2021.
//

import XCTest
import ColorThemeModelingFramework

protocol ColorConversionTestProvider {
	
	typealias ColorValue = Color.ColorValue
	typealias ColorValueComponents = (red: ColorValue, green: ColorValue, blue: ColorValue)
	
}

// MARK: Assertion & Comparison

extension ColorConversionTestProvider {
	
	func assertValuesEqual(_ lhs: ColorValue, _ rhs: ColorValue) {
		let roundedLhs = roundedValue(lhs)
		let roundedRhs = roundedValue(rhs)
		
		XCTAssertTrue(valuesAreEqual(roundedLhs, roundedRhs), "Values not equal, \(roundedLhs) and \(roundedRhs) (rounded)")
	}
	
	private func valuesAreEqual(_ lhs: ColorValue, _ rhs: ColorValue) -> Bool {
		let delta = abs(lhs - rhs)
		return delta <= 0.01
	}
	
	private func roundedValue(_ value: ColorValue) -> ColorValue {
		return round(value * 1000) / 1000
	}
	
}

// MARK: Value Expansion

extension ColorConversionTestProvider {
	
	func bit8(_ value: ColorValue) -> ColorValue {
		return value / 255
	}
	
	func bit8(_ a: ColorValue, _ b: ColorValue, _ c: ColorValue) -> (ColorValue, ColorValue, ColorValue) {
		return (bit8(a), bit8(b), bit8(c))
	}
	
}
