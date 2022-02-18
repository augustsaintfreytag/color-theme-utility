//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModelingFramework
import ColorThemeCodingFramework
import ColorThemeEnclosureFramework

protocol ThemeGeneratorCommand: ThemeDescriptionCommand, ThemeEnclosureWriter {}

extension ThemeGeneratorCommand {
	
	/// Generates a theme from an input sequence of colors.
	///
	/// Internally generates an intermediate theme model first and
	/// converts to other requested formats if specified.
	func generateTheme() throws {
		if humanReadable {
			try generateAndPrintThemeAsHumanReadable()
			return
		}
		
		if outputDirectory != nil {
			try generateAndWriteTheme()
			return
		}
		
		try generateAndPrintThemeAsData()
	}
	
	private func generateThemeContents() throws -> Theme {
		let inputColors = try inputColorSequenceFromArguments()
		let intermediateTheme = try Self.theme(from: inputColors, cascade: !disablePaletteTransform)
		let outputFormat = outputFormat ?? .theme(format: .intermediate)
		
		guard case .theme(let themeFormat) = outputFormat else {
			throw ArgumentError(description: "Supplied output format must be a theme format.")
		}
		
		return try Self.coercedTheme(intermediateTheme, to: themeFormat)
	}
	
	private func generateAndPrintThemeAsHumanReadable() throws {
		let outputTheme = try generateThemeContents()
		try describeTheme(outputTheme)
	}
	
	private func generateAndPrintThemeAsData() throws {
		let outputTheme = try generateThemeContents()
		
		switch outputTheme {
		case let intermediateTheme as IntermediateTheme:
			print(try Self.encodedTheme(intermediateTheme))
		case let xcodeTheme as XcodeTheme:
			print(try Self.encodedTheme(xcodeTheme))
		case let textMateTheme as TextMateTheme:
			print(try Self.encodedTheme(textMateTheme))
		case let visualStudioCodeTheme as VisualStudioCodeTheme:
			print(try Self.encodedTheme(visualStudioCodeTheme))
		default:
			throw ImplementationError(description: "Generated theme data with format '\(outputTheme.typeFormat)' can not be output.")
		}
	}
	
	private func generateAndWriteTheme() throws {
		guard let outputDirectory = outputDirectory else {
			throw ArgumentError(description: "Missing or invalid directory output path for generated theme.")
		}
		
		let outputTheme = try generateThemeContents()
		let outputPath = URL(fileURLWithPath: outputDirectory, isDirectory: true)
		
		try Self.writeTheme(outputTheme, to: outputPath)
	}
	
}
