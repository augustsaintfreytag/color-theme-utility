//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 06/10/2021.
//

import Foundation
import Rainbow
import ColorThemeFramework

extension String {
	
	func colored(with color: ColorThemeFramework.Color) -> String {
		return self.hex(color.hexadecimalString, to: .bit24)
	}
	
	func coloredBackground(with color: ColorThemeFramework.Color) -> String {
		return self.onHex(color.hexadecimalString, to: .bit24)
	}
	
}
