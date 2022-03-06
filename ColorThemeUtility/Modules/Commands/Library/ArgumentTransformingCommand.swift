//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 13/02/2022.
//

import Foundation
import ColorThemeModeling
import ColorThemeCoding

protocol ArgumentTransformingCommand: ThemeDecoder, ColorModeler {
	
	var linesFromStdin: String? { get }
	var lineFromStdin: String? { get }
	
	var inputColors: [String]? { get }
	var inputThemeFile: String? { get }
	var inputColorsFromStdin: Bool { get }
	var inputThemeContentsFromStdin: Bool { get }
	
}

extension ArgumentTransformingCommand {
	
	// MARK: Transformations
	
	static func stringSequenceFromArgument(_ string: String) -> [String] {
		return string.split(separator: ",").map { substring in
			return String(substring).trimmingCharacters(in: .whitespaces)
		}
	}
	
	// MARK: Colors
	
	/// Determines and returns a viable color sequence from command arguments.
	/// Input is read from `stdin` if flag `inputColorsFromStdin` is set and uses
	/// directly supplied data otherwise.
	///
	/// Note that a *color sequence* is defined as an ordered collection of exactly 10 colors.
	func inputColorSequenceFromArguments() throws -> [Color] {
		if inputColorsFromStdin {
			let colorDescriptions = Self.stringSequenceFromArgument(linesFromStdin ?? "")
			let colors = colorSequence(from: colorDescriptions)
			
			guard colors.count == 10 else {
				throw ArgumentError(description: "Color sequence from stdin not viable. Command requires exactly ten (10) colors.")
			}
			
			return colors
		} else {
			let colors = colorSequence(from: inputColors ?? [])
			
			guard colors.count == 10 else {
				throw ArgumentError(description: "Supplied color sequence not viable. Command requires exactly ten (10) colors.")
			}
			
			return colors
		}
	}
	
	private func colorSequence(from descriptions: [String]) -> [Color] {
		return descriptions.compactMap { description in Self.color(fromAutodetectedColorString: description) }
	}
	
	
	// MARK: Themes
	
	/// Determines and returns a viable decoded theme from file path or contents from
	/// command arguments. Input is read from `stdin` if flag `inputColorsFromStdin` is
	/// set and uses directly supplied data otherwise.
	func inputThemeFileFromArguments() throws -> Theme {
		if inputThemeContentsFromStdin {
			// Stdin Mode
			guard let inputFileContents = linesFromStdin, let inputData = inputFileContents.data(using: .utf8) else {
				throw ArgumentError(description: "Could not read input theme file contents from stdin.")
			}
			
			return try Self.decodedTheme(from: inputData)
		} else {
			// Path by Argument Mode
			guard let inputFilePath = inputThemeFile else {
				throw ArgumentError(description: "Missing input file path for theme to be described.")
			}
			
			return try Self.decodedTheme(from: inputFilePath)
		}
	}
	
}
