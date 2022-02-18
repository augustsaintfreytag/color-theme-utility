//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModelingFramework
import ColorThemeCodingFramework

protocol ThemeConversionCommand: CommandFragment,
								 ArgumentTransformingCommand,
								 XcodeThemeModeler,
								 ThemeEncoder {}

extension ThemeConversionCommand {
	
	func convertTheme() throws {
		// Take existing theme file as input.
		// Auto-detect existing theme kind.
		// Convert theme to intermediate (if supported).
		// Convert intermediate to target theme.
		
		// Take existing intermediate theme file as input.
		// Convert intermediate to target theme.
		
		guard case .theme(let outputThemeFormat) = outputFormat, outputThemeFormat == .xcode else {
			throw ArgumentError(description: "Output format '\(outputFormat?.description ?? "<None>")' not supported. Supported formats: 'xcode'.")
		}
		
		guard let intermediateTheme = try inputThemeFileFromArguments() as? IntermediateTheme else {
			throw ArgumentError(description: "Supplied theme is not an intermediate theme. Only intermediate themes can be converted in this version.")
		}
		
		let xcodeTheme = try Self.xcodeTheme(from: intermediateTheme)
		print(try Self.encodedTheme(xcodeTheme, as: .plist))
	}
	
}
