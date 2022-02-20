//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 06/11/2021.
//

import Foundation
import ArgumentParser
import ColorThemeModeling

enum OutputFormat {
	
	case theme(format: ThemeFormat)
	case color(format: ColorFormat)
	case colorCollection(format: ColorCollectionFormat)
	
}

extension OutputFormat: CustomStringConvertible {
	
	var description: String {
		switch self {
		case .theme(let themeFormat):
			return themeFormat.rawValue
		case .color(let colorFormat):
			return colorFormat.rawValue
		case .colorCollection(let colorCollectionFormat):
			return colorCollectionFormat.rawValue
		}
	}
	
	static var allCasesHelpDescription: String {
		let descriptions = ThemeFormat.allValueStrings + ColorFormat.allValueStrings
		return joinedCasesHelpDescriptions(descriptions)
	}
	
}

extension OutputFormat: ExpressibleByArgument {
	
	init?(argument: String) {
		if let themeFormat = ThemeFormat(rawValue: argument) {
			self = .theme(format: themeFormat)
			return
		}
		
		if let colorFormat = ColorFormat(rawValue: argument) {
			self = .color(format: colorFormat)
			return
		}

		if let colorCollectionFormat = ColorCollectionFormat(rawValue: argument) {
			self = .colorCollection(format: colorCollectionFormat)
			return
		}
		
		return nil
	}
	
}
