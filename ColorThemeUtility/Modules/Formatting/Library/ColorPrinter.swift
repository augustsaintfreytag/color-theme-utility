//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModeling

protocol ColorPrinter {}

extension ColorPrinter {
	
	static var colorBlock: String { "████████" }
	
	static func printColor(_ color: Color, description: String? = nil) {
		let colorDescription = colorBlock.colored(with: color)
		
		guard let key = description else {
			print(colorDescription)
			return
		}
		
		print(colorDescription + " " + key)
	}
	
}
