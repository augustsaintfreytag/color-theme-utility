//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 06/10/2021.
//

import Foundation
import Rainbow
import ColorThemeModelingFramework

extension String {
	
	func colored(with color: ColorThemeModelingFramework.Color) -> String {
		return self.bit24(integerRGB(from: color))
	}
	
	func coloredBackground(with color: ColorThemeModelingFramework.Color) -> String {
		return self.onBit24(integerRGB(from: color))
		
	}
	
	private func integerRGB(from color: ColorThemeModelingFramework.Color) -> RGB {
		return (
			UInt8(color.red * 255),
			UInt8(color.green * 255),
			UInt8(color.blue * 255)
		)
	}
	
}
