//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModelingFramework
import ColorThemeCodingFramework

protocol ThemeGeneratorCommand: ThemeDescriptionCommand,
								ThemeEncoder,
								ThemeCoercionProvider {}

extension ThemeGeneratorCommand {
	
	/// Generates a theme from an input sequence of colors.
	///
	/// Internally generates an intermediate theme model first and
	/// converts to other requested formats if specified.
	func generateTheme() throws {
		let inputColors = try inputColorSequenceFromArguments()
		let intermediateTheme = try Self.theme(from: inputColors, cascade: !disablePaletteTransform)
		let outputFormat = outputFormat ?? .theme(format: .intermediate)
		
		guard case .theme(let themeFormat) = outputFormat else {
			throw ArgumentError(description: "Supplied output format must be a theme format.")
		}
		
		let outputTheme = try Self.coercedTheme(intermediateTheme, to: themeFormat)
		
		switch outputTheme {
		case let intermediateTheme as IntermediateTheme:
			if humanReadable {
				describeIntermediateTheme(intermediateTheme)
			} else {
				print(try Self.encodedTheme(intermediateTheme, with: .json))
			}
		case let xcodeTheme as XcodeTheme:
			if humanReadable {
				describeXcodeTheme(xcodeTheme)
			} else {
				print(try Self.encodedTheme(xcodeTheme, with: .plist))
			}
		case let textMateTheme as TextMateTheme:
			if humanReadable {
				describeTextMateTheme(textMateTheme)
			} else {
				print(try Self.encodedTheme(textMateTheme, with: .plist))
			}
		default:
			throw ImplementationError(description: "Generated output theme with format '\(outputFormat)' can not be described.")
		}
	}
	
}
