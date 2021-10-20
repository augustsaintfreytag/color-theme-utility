//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 18/09/2021.
//

import Foundation
import ColorThemeFramework
import ArgumentParser

@main
struct ColorThemeUtility: ParsableCommand {
	
	static let configuration = CommandConfiguration(
		helpNames: [.customShort("?"), .long]
	)
	
	// MARK: Arguments

	@Argument(help: "The main operation to perform. (options: TBD)", completion: .default)
	var mode: Mode
	
	@Option(name: [.customShort("c"), .customLong("color")], help: "The color or sequence of colors to use as input. (comma separated)", transform: stringSequenceFromArgument)
	var inputColors: [String]?
	
	@Option(name: [.customShort("s"), .customLong("skew")], help: "The lightness direction skew to use for palette generation. (options: lighter|darker)")
	var colorTransform: ColorTransform?
	
	@Option(name: [.customShort("n"), .customLong("number-of-colors")], help: "The number of colors created in palette generation (including provided base color).")
	var colorCount: Int?
	
	@Option(name: [.customShort("i"), .customLong("input")], help: "The theme file to use as input.")
	var inputFile: String?
	
	@Flag(name: [.customShort("h")], help: "Outputs data and models in a human-readable format. (default: false)")
	var humanReadable: Bool = false
	
	// MARK: Run
	
	func run() throws {
		switch mode {
		case .describe:
			try detectColorKind()
		case .print:
			try printColor()
		case .palette:
			try generatePalette()
		case .generate:
			try generateTheme()
		case .debug:
			try debugPrintTheme()
		}
	}

}

extension ColorThemeUtility: ColorFormatDetector, ColorModeler, ThemeImporter, HSLColorConverter, ColorExtrapolator, IntermediateThemeModeler {
	
	// MARK: Commands
	
	private func detectColorKind() throws {
		guard let inputColor = inputColors?.first else {
			throw ArgumentError(description: "No color string given, color format could not be determined.")
		}
		
		guard let inputColorFormat = colorFormat(for: inputColor) else {
			throw ArgumentError(description: "Color format could not be determined.")
		}
		
		if humanReadable {
			print("Color string '\(inputColor)' is \(inputColorFormat.description) (\(inputColorFormat.rawValue)).")
		} else {
			print(inputColorFormat.rawValue)
		}
	}
	
	private func printColor() throws {
		guard let inputColor = inputColors?.first, let color = color(fromAutodetectedColorString: inputColor) else {
			throw ArgumentError(description: "Missing input color or given string has invalid or unsupported format.")
		}
		
		printColor(color)
		print("HSL \(color.hsl)")
		
		let convertedHsl = Self.rgbComponents(from: color.hsl)
		print("HSL from RGB: \(convertedHsl)")
	}
	
	/// Parses the given theme file and prints its contents in a readable format.
	///
	/// Options to visualize and present a theme:
	///   - `theme.formattedEncodedDebugDescription`
	///   - `theme.<key>.enumerated()`
	///
	private func debugPrintTheme() throws {
		guard let inputFilePath = inputFile else {
			throw ArgumentError(description: "Missing input theme file path.")
		}
		
		guard let fileData = encodedDataFromFileContents(from: inputFilePath) else {
			throw ArgumentError(description: "Could not read supplied theme file.")
		}
		
		let decoder = PropertyListDecoder()
		guard let theme = try? decoder.decode(XcodeTheme.self, from: fileData) else {
			throw ThemeCodingError(description: "Could not decode supplied theme file as an Xcode theme model.")
		}
		
		let enumeratedColors = orderedEnumeratedColors(from: theme.dvtSourceTextSyntaxColors.enumerated())
		for (property, color) in enumeratedColors {
			printColor(color, description: property)
		}
	}
	
	private func generatePalette() throws {
		guard let inputColor = inputColors?.first, let color = color(fromAutodetectedColorString: inputColor) else {
			throw ArgumentError(description: "Missing or invalid input color, need base color to generate palette.")
		}
		
		let numberOfColors = colorCount ?? 3
		let transform: ColorTransform = colorTransform ?? .lighter
		let palette = Self.cascadingColorSequence(from: color, numberOfColors: numberOfColors, skewing: transform)
		
		for (index, paletteColor) in palette.enumerated() {
			printColor(paletteColor, description: "Palette color #\(index + 1) (\(paletteColor.description))")
		}
	}
	
	private func generateTheme() throws {
		guard let inputColors = inputColors?.compactMap({ string in color(fromAutodetectedColorString: string) }), !inputColors.isEmpty else {
			throw ArgumentError(description: "Missing input color sequence, need exactly nine (9) base colors to create theme.")
		}
		
		let theme = try Self.theme(from: inputColors)
		
		if humanReadable {
			let themeColors: IntermediateTheme.EnumeratedValues<Color> = theme.enumeratedSortedByValue()
			
			for (property, color) in themeColors {
				printColor(color, description: property)
			}
		} else {
			print(theme.formattedEncodedDescription!)
		}
	}
	
	// MARK: Utility
	
	private func orderedEnumeratedColors(from enumeratedColors: [(property: String, value: String)]) -> [(property: String, color: Color)] {
		return enumeratedColors.reduce(into: [(property: String, color: Color)]()) { collection, element in
			let (property, value) = element
			
			guard let color = color(fromAutodetectedColorString: value) else {
				return
			}
			
			collection.append((property, color))
		}.sorted { lhs, rhs in
			lhs.color < rhs.color
		}
	}
	
	private func printColor(_ color: Color, description: String? = nil) {
		let colorDescription = "████████".colored(with: color)
		
		guard let key = description else {
			print(colorDescription)
			return
		}
		
		print(colorDescription + " " + key)
	}
	
}

// MARK: Library

enum Mode: String, CaseIterable, ExpressibleByArgument {
	case debug
	case describe
	case print
	case palette
	case generate
}
