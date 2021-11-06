//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 06/11/2021.
//

import Foundation
import ArgumentParser
import ColorThemeFramework

enum OutputFormat {
	
	case theme(format: ThemeFormat)
	case color(format: ColorFormat)
	
}

extension OutputFormat: CustomStringConvertible {
	
	var description: String {
		switch self {
		case .theme(let themeFormat):
			return themeFormat.rawValue
		case .color(let colorFormat):
			return colorFormat.rawValue
		}
	}
	
	static var allCasesHelpDescription: String {
		let descriptions = ThemeFormat.allValueStrings + ColorFormat.allValueStrings
		return joinedCasesHelpDescriptions(descriptions)
	}
	
}

extension OutputFormat: ExpressibleByArgument {
	
	init?(argument: String) {
		if let themeFormat = ThemeFormat(argument: argument) {
			self = .theme(format: themeFormat)
		}
		
		if let colorFormat = ColorFormat(argument: argument) {
			self = .color(format: colorFormat)
		}
		
		return nil
	}
	
}
