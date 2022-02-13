//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModelingFramework
import ColorThemeCodingFramework

protocol ThemeDescriptionCommand: CommandFragment,
								  ArgumentTransformingCommand,
								  TableFormatter,
								  ThemePropertyEnumerator {}

extension ThemeDescriptionCommand {
	
	/// Parses the given theme file and prints its contents in a readable format.
	///
	/// Options to visualize and present a theme:
	///   - `theme.formattedEncodedDebugDescription`
	///   - `theme.<key>.enumerated()`
	///
	func describeTheme() throws {
		let theme: Theme = try inputThemeFileFromArguments()
		
		switch theme {
		case let intermediateTheme as IntermediateTheme:
			describeIntermediateTheme(intermediateTheme)
		case let xcodeTheme as XcodeTheme:
			describeXcodeTheme(xcodeTheme)
		case let textMateTheme as TextMateTheme:
			describeTextMateTheme(textMateTheme)
		default:
			throw ArgumentError(description: "Supplied theme is not in a describable supported format.")
		}
	}
	
	func describeIntermediateTheme<ThemeType: Theme & CustomPropertyEnumerable>(_ theme: ThemeType) {
		let rows = enumeratedPropertyDescriptions(from: theme.enumerated())
		Self.tabulateAndPrintLines(rows)
	}
	
	func describeXcodeTheme(_ theme: XcodeTheme) {
		var rows: [[String]] = []
		
		rows.append(contentsOf: enumeratedPropertyDescriptions(from: theme.enumerated()))
		rows.append(contentsOf: enumeratedPropertyDescriptions(from: theme.dvtSourceTextSyntaxColors.enumerated(), childrenOf: "dvtSourceTextSyntaxColors"))
		rows.append(contentsOf: enumeratedPropertyDescriptions(from: theme.dvtSourceTextSyntaxFonts.enumerated(), childrenOf: "dvtSourceTextSyntaxColors"))
		
		Self.tabulateAndPrintLines(rows)
	}
	
	func describeTextMateTheme(_ theme: TextMateTheme) {
		var rows: [[String]] = []
		
		rows.append(["uuid", "[UUID]", theme.uuid])
		rows.append(["name", "[String]", theme.name])
		
		guard let masterSetting = theme.settings.first else {
			Self.tabulateAndPrintLines(rows)
			return
		}
		
		rows.append(Self.dividerRow)
		rows.append(contentsOf: enumeratedPropertyDescriptions(from: masterSetting.settings.enumerated()))
		
		for setting in theme.settings {
			rows.append(Self.dividerRow)
			
			if let name = setting.name {
				rows.append(["name", "[String]", name])
			}
			
			rows.append(["scope", "[String]", setting.scope ?? ""])
			
			let settingValues = setting.settings.enumerated().filter { (property: String, value: CustomStringConvertible) in
				return !value.description.isEmpty
			}
			
			rows.append(contentsOf: enumeratedPropertyDescriptions(from: settingValues))
		}
		
		Self.tabulateAndPrintLines(rows)
	}
	
}
