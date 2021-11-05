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
	
	@Option(name: [.customShort("s"), .customLong("skew")], help: "The lightness direction skew to use for palette generation. (options: \(ColorTransform.allCasesHelpDescription))")
	var colorTransform: ColorTransform?
	
	@Option(name: [.customShort("n"), .customLong("number-of-colors")], help: "The number of colors created in palette generation (including provided base color).")
	var colorCount: Int?
	
	@Option(name: [.customShort("i"), .customLong("input")], help: "The theme file to use as input.")
	var inputFile: String?
	
	@Option(name: [.customShort("o"), .customLong("output")], help: "The format used for output when inspecting, converting, or generating themes. (options: \(OutputThemeFormat.allCasesHelpDescription))")
	var outputFormat: OutputThemeFormat?
	
	@Flag(name: [.customShort("h"), .customLong("human-readable")], help: "Outputs data and models in a human-readable format. (default: false)")
	var humanReadable: Bool = false
	
	// MARK: Run
	
	func run() throws {
		switch mode {
		case .describeColor:
			try describeColor()
		case .describeTheme:
			try describeTheme()
		case .previewTheme:
			try previewTheme()
		case .convertColor:
			try convertColor()
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
		
		guard let inputColorFormat = Self.colorFormat(for: inputColor) else {
			throw ArgumentError(description: "Color format could not be determined.")
		}
		
		guard let color = Self.color(from: inputColor, format: inputColorFormat) else {
			throw ArgumentError(description: "Could not create color in detected format '\(inputColorFormat)'.")
		}
		
		if humanReadable {
			printColor(color, description: "Input '\(inputColor)' is \(inputColorFormat.description) ('\(inputColorFormat.rawValue)')")
		} else {
			print(inputColorFormat.rawValue)
		}
	}
	
	private func convertColor() throws {
		guard let inputColor = inputColors?.first, let color = Self.color(fromAutodetectedColorString: inputColor) else {
			throw ArgumentError(description: "Missing input color or given string has invalid or unsupported format.")
		}
		
		print("Not implemented.")
		Self.exit(withError: ExitCode(127))
	}
	
	/// Parses the given theme file and prints its contents in a readable format.
	///
	/// Options to visualize and present a theme:
	///   - `theme.formattedEncodedDebugDescription`
	///   - `theme.<key>.enumerated()`
	///
	private func describeTheme() throws {
		let themeData = try readInputThemeData()
		
		let xcodeTheme: XcodeTheme = try {
			do {
				let decoder = PropertyListDecoder()
				return try decoder.decode(XcodeTheme.self, from: themeData)
			} catch {
				throw ThemeCodingError(description: "Could not decode supplied theme file as an Xcode theme model. \(error.localizedDescription)")
			}
		}()
		
		describeXcodeTheme(xcodeTheme)
	}
	
	private func readInputThemeData() throws -> Data {
		guard let inputFilePath = inputFile else {
			throw ArgumentError(description: "Missing input theme file path.")
		}
		
		guard let fileData = encodedDataFromFileContents(from: inputFilePath) else {
			throw ArgumentError(description: "Could not read supplied theme file.")
		}
		
		return fileData
	}
	
	private func previewTheme() throws {
		// Limited support: Only intermediate and Xcode formats are supported.
		
		let themeData = try readInputThemeData()
		let theme = try decodedTheme(from: themeData)
		let intermediateTheme = try unifiedIntermediateTheme(from: theme)
		
		let presetString = TokenizedString.Presets.protocolWithFunctionDefinition
		let themedPresetString = presetString.padded.themedString(with: intermediateTheme)
		
		print(themedPresetString)
	}
	
	/// Tries to convert any given theme to an intermediate theme.
	private func unifiedIntermediateTheme(from theme: Theme) throws -> IntermediateTheme {
		switch theme {
		case let intermediateTheme as IntermediateTheme:
			return intermediateTheme
		case let xcodeTheme as XcodeTheme:
			return try Self.intermediateTheme(from: xcodeTheme)
		default:
			throw ImplementationError(description: "Can not convert theme of type '\(type(of: theme))' to intermediate theme for unified conversion.")
		}
	}
	
	private func describeXcodeTheme(_ theme: XcodeTheme) {
		var rows: [[String]] = []
		
		enumeratedPropertyDescriptions(from: theme.enumerated()).forEach { description in
			rows.append(description)
		}
		
		enumeratedPropertyDescriptions(from: theme.dvtSourceTextSyntaxColors.enumerated(), childrenOf: "dvtSourceTextSyntaxColors").forEach { description in
			rows.append(description)
		}
		
		enumeratedPropertyDescriptions(from: theme.dvtSourceTextSyntaxFonts.enumerated(), childrenOf: "dvtSourceTextSyntaxColors").forEach { description in
			rows.append(description)
		}
		
		Self.tabulateAndPrintLines(rows)
	}
	
	private func generatePalette() throws {
		guard let inputColor = inputColors?.first, let color = Self.color(fromAutodetectedColorString: inputColor) else {
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
		guard let inputColors = inputColors?.compactMap({ string in Self.color(fromAutodetectedColorString: string) }), !inputColors.isEmpty else {
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
		let xcodeTheme = try Self.xcodeTheme(from: intermediateTheme)

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
	
	private func enumeratedPropertyDescriptions(from enumeratedProperties: [(property: String, value: CustomStringConvertible)], childrenOf parentProperty: String? = nil) -> [[String]] {
		return enumeratedProperties.map { property, value in
			let property = { () -> String in
				guard let parentProperty = parentProperty else {
					return property
				}

				return "\(parentProperty).\(property)"
			}()
			
			let description = valueDescription(of: value)
			return [property, description.format, description.value]
		}
	}
	
	private func valueDescription(of value: CustomStringConvertible) -> (format: String, value: String) {
		let description = value.description
		
		if let color = Self.color(fromAutodetectedColorString: description) {
			let colorBlockDescription = colorBlock.colored(with: color)
			return ("[Color]", "\(color.hexadecimalString) \(colorBlockDescription)")
		}
		
		return ("[Any]", description)
	}
	
	private func enumeratedColors(in model: CustomPropertyEnumerable) -> [(property: String, color: Color)] {
		return enumeratedColors(from: model.enumerated())
	}
	
	private func enumeratedColors(from enumeratedProperties: [(property: String, value: String)]) -> [(property: String, color: Color)] {
		return enumeratedProperties.reduce(into: [(property: String, color: Color)]()) { collection, element in
			let (property, value) = element
			
			guard let color = Self.color(fromAutodetectedColorString: value) else {
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
	case describeColor = "describe-color"
	case convertColor = "convert-color"
	case generatePalette = "generate-palette"
	case describeTheme = "describe-theme"
	case generateTheme = "generate-theme"
	case previewTheme = "preview-theme"
	case convertTheme = "convert-theme"
}

typealias OutputThemeFormat = ThemeFormat
