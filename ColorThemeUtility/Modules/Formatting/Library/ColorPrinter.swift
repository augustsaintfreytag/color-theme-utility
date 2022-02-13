//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation

protocol ColorPrinter {}

extension ColorPrinter {
	
	var colorBlock: String { "████████" }
	
	func printColor(_ color: Color, description: String? = nil) {
		let colorDescription = colorBlock.colored(with: color)
		
		guard let key = description else {
			print(colorDescription)
			return
		}
		
		print(colorDescription + " " + key)
	}
	
}
