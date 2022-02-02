//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 06/10/2021.
//

import Foundation
import Rainbow
import ColorThemeModelingFramework

extension String {
	
	private typealias FrameworkColor = ColorThemeModelingFramework.Color
	private typealias FrameworkColorValue = ColorThemeModelingFramework.Color.ColorValue
	
	func colored(with color: ColorThemeModelingFramework.Color) -> String {
		return self.bit24(integerRGB(from: color))
	}
	
	func coloredBackground(with color: ColorThemeModelingFramework.Color) -> String {
		return self.onBit24(integerRGB(from: color))
	}
	
	private func integerRGB(from color: FrameworkColor) -> RGB {
		return (
			unsignedColorComponent(from: color.red),
			unsignedColorComponent(from: color.green),
			unsignedColorComponent(from: color.blue)
		)
	}
	
	private func unsignedColorComponent(from value: FrameworkColorValue) -> UInt8 {
		return UInt8(value * 255)
	}
	
}
