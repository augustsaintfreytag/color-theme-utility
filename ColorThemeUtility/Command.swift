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

	@Argument(help: "The main operation to perform. (options: \(Mode.allCasesHelpDescription))", completion: .default)
	var mode: Mode
	
	@Option(name: [.customShort("c"), .customLong("color")], help: "The color or sequence of colors to use as input. (comma separated)", transform: stringSequenceFromArgument)
	var inputColors: [String]?
	
	@Option(name: [.customShort("s"), .customLong("skew")], help: "The lightness direction skew to use for palette generation. (options: \(ColorTransform.allCasesHelpDescription)")
	var colorTransform: ColorTransform?
	
	@Option(name: [.customShort("n"), .customLong("number-of-colors")], help: "The number of colors created in palette generation (including provided base color).")
	var colorCount: Int?
	
	@Option(name: [.customShort("i"), .customLong("input")], help: "The theme file to use as input.")
	var inputFile: String?
	
	@Option(name: [.customShort("o"), .customLong("output")], help: "The format used for output when inspecting, converting, or generating themes. (options: \(OutputFormat.allCasesHelpDescription)")
	var outputFormat: OutputFormat?
	
	@Flag(name: [.customShort("h")], help: "Outputs data and models in a human-readable format. (default: false)")
	var humanReadable: Bool = false
	
	// MARK: Run
	
	func run() throws {
		switch mode {
		case .describeColor:
			try describeColor()
		case .describeTheme:
			try describeTheme()
		case .convertColor:
			try printColor()
		case .generatePalette:
			try generatePalette()
		case .generateTheme:
			try generateTheme()
		case .convertTheme:
			try convertTheme()
		}
	}

}

extension ColorThemeUtility: ColorFormatDetector,
								ColorModeler,
								ThemeImporter,
								ThemeCoder,
								HSLColorConverter,
								ColorExtrapolator,
								IntermediateThemeModeler,
								XcodeThemeModeler,
								TableFormatter {
	
	// MARK: Commands
	
	private func describeColor() throws {
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
	private func describeTheme() throws {
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
		
		describeXcodeTheme(theme)
	}
	
	private func describeXcodeTheme(_ theme: XcodeTheme) {
		var lines: [String] = []
		
		enumeratedPropertyDescriptions(from: theme.enumerated()).forEach { description in
			lines.append(description)
		}
		
		enumeratedPropertyDescriptions(from: theme.dvtSourceTextSyntaxColors.enumerated()).forEach { description in
			lines.append("dvtSourceTextSyntaxColors.\(description)")
		}
		
		enumeratedPropertyDescriptions(from: theme.dvtSourceTextSyntaxFonts.enumerated()).forEach { description in
			lines.append("dvtSourceTextSyntaxFonts.\(description)")
		}
		
		let splitLines: [[String]] = lines.map { line in line.split(separator: " ").map { substring in String(substring) } }
		Self.formattedLines(splitLines).forEach { line in print(line) }
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

	// TODO: Implement *convert theme* action, convert any to Xcode.

	private func convertTheme() throws {
		// Take existing theme file as input.
		// Auto-detect existing theme kind.
		// Convert theme to intermediate (if supported).
		// Convert intermediate to target theme.

		// Take existing intermediate theme file as input.
		// Convert intermediate to target theme.

		guard let inputFilePath = inputFile else {
			throw ArgumentError(description: "Missing input file path for theme to be converted.")
		}

		guard let fileData = encodedDataFromFileContents(from: inputFilePath) else {
			throw ArgumentError(description: "Could not read supplied theme file.")
		}

		guard outputFormat == .xcode else {
			throw ArgumentError(description: "Output format '\(outputFormat?.rawValue ?? "<None>")' not supported. Supported formats: 'xcode'.")
		}

		/// TODO: Consider displacing this to function, throwing `ThemeCodingError`.
		let decoder = JSONDecoder()
		let intermediateTheme = try decoder.decode(IntermediateTheme.self, from: fileData)
		let xcodeTheme = try Self.theme(from: intermediateTheme)

		print(try Self.encodedTheme(xcodeTheme, with: .plist))
	}
	
	// MARK: Utility
	
	private var colorBlock: String { "████████" }
	
	private func printColor(_ color: Color, description: String? = nil) {
		let colorDescription = colorBlock.colored(with: color)
		
		guard let key = description else {
			print(colorDescription)
			return
		}
		
		print(colorDescription + " " + key)
	}
	
	// MARK: Property Enumeration
	
	private func enumeratedPropertyDescriptions(from enumeratedProperties: [(property: String, value: String)]) -> [String] {
		return enumeratedProperties.map { property, value in
			let valueDescription = valueDescription(of: value)
			
			return "\(property) \(valueDescription)"
		}
	}
	
	// TODO: Either establish consistent auto-splitting or return components instead of pre-formed strings from these functions.
	
	private func valueDescription(of value: String) -> String {
		if let color = color(fromAutodetectedColorString: value) {
			let colorBlockDescription = colorBlock.colored(with: color)
			return "\(color.hexadecimalString) \(colorBlockDescription)"
		}
		
		return value
	}
	
	private func enumeratedColors(in model: CustomPropertyEnumerable) -> [(property: String, color: Color)] {
		return enumeratedColors(from: model.enumerated())
	}
	
	private func enumeratedColors(from enumeratedProperties: [(property: String, value: String)]) -> [(property: String, color: Color)] {
		return enumeratedProperties.reduce(into: [(property: String, color: Color)]()) { collection, element in
			let (property, value) = element
			
			guard let color = color(fromAutodetectedColorString: value) else {
				return
			}
			
			collection.append((property, color))
		}
	}
	
	private func orderedEnumeratedColors(in model: CustomPropertyEnumerable) -> [(property: String, color: Color)] {
		return orderedEnumeratedColors(from: model.enumerated())
	}
	
	private func orderedEnumeratedColors(from enumeratedProperties: [(property: String, value: String)]) -> [(property: String, color: Color)] {
		return enumeratedColors(from: enumeratedProperties).sorted { lhs, rhs in
			lhs.color < rhs.color
		}
	}
	
}

// MARK: Library

enum Mode: String, CaseIterable, ExpressibleByArgument {
	case describeTheme = "describe-theme"
	case describeColor = "describe-color"
	case convertColor = "convert-color"
	case generatePalette = "gen-palette"
	case generateTheme = "gen-theme"
	case convertTheme = "convert-theme"
}

enum OutputFormat: String, CaseIterable, ExpressibleByArgument {
	case debug
	case intermediate
	case xcode
	case vscode
}
