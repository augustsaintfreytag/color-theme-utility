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
			rows.append(contentsOf: enumeratedThemeSetting(setting))
		}
		
		Self.tabulateAndPrintLines(rows)
	}
	
	func describeVisualStudioCodeTheme(_ theme: VisualStudioCodeTheme) {
		var rows: [[String]] = []
		
		rows.append(["name", "[String]", theme.name])
		rows.append(["type", "[String]", theme.type.rawValue])
		
		rows.append(Self.dividerRow)
		rows.append(contentsOf: enumeratedPropertyDescriptions(from: theme.colors.map { pair in pair }))
		
		for tokenColors in theme.tokenColors {
			rows.append(Self.dividerRow)
			rows.append(contentsOf: enumeratedThemeSetting(tokenColors))
		}
		
		Self.tabulateAndPrintLines(rows)
	}
	
	// MARK: Theme Enumeration
	
	private func enumeratedThemeSetting(_ setting: TextMateThemeSetting) -> [[String]] {
		var rows: [[String]] = []
		
		if let name = setting.name {
			rows.append(["name", "[String]", name])
		}
		
		rows.append(["scope", "[String]", setting.scope ?? ""])
		rows.append(contentsOf: enumeratedSettings(setting.settings))
		
		return rows
	}
	
	private func enumeratedThemeSetting(_ setting: VisualStudioCodeThemeTokenColors) -> [[String]] {
		var rows: [[String]] = []
		
		rows.append(["name", "[String]", setting.name])
		rows.append(["scope", "[String]", Self.truncatedString(setting.scope.joined(separator: ", "))])
		rows.append(contentsOf: enumeratedSettings(setting.settings))
		
		return rows
	}
	
	private func enumeratedSettings(_ settings: TextMateThemeSettings) -> [[String]] {
		let elements = settings.enumerated().filter { (property: String, value: CustomStringConvertible) in
			return !value.description.isEmpty
		}
		
		return enumeratedPropertyDescriptions(from: elements)
	}
	
}
