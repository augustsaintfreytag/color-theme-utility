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
	
	@Option(name: [.customShort("o"), .customLong("output")], help: "The format used for output when inspecting, converting, or generating colors or themes. (options: \(OutputFormat.allCasesHelpDescription))")
	var outputFormat: OutputFormat?
	
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
		guard let inputColorString = inputColors?.first, let inputColor = Self.color(fromAutodetectedColorString: inputColorString) else {
			throw ArgumentError(description: "Missing input color or given input has invalid or unsupported format.")
		}
		
		guard case .color(let outputColorFormat) = outputFormat else {
			throw ArgumentError(description: "Missing output color format for color conversion.")
		}
		
		switch outputColorFormat {
		case .floatRGBA:
			print(inputColor.floatRGBAString)
		case .hexadecimal:
			print(inputColor.hexadecimalString)
		}
	}
	
	/// Parses the given theme file and prints its contents in a readable format.
	///
	/// Options to visualize and present a theme:
	///   - `theme.formattedEncodedDebugDescription`
	///   - `theme.<key>.enumerated()`
	///
	private func describeTheme() throws {
		let themeData = try readInputThemeData()
		let themeFormat = themeFormat(for: themeData)

		do {
			switch themeFormat {
			case .intermediate:
				let decoder = JSONDecoder()
				let intermediateTheme = try decoder.decode(IntermediateTheme.self, from: themeData)

				describeIntermediateTheme(intermediateTheme)
			case .xcode:
				let decoder = PropertyListDecoder()
				let xcodeTheme = try decoder.decode(XcodeTheme.self, from: themeData)

				describeXcodeTheme(xcodeTheme)
			case .none:
				throw ThemeCodingError(description: "Could not determine format of supplied theme.")
			}
		} catch {
			throw ThemeCodingError(description: "Could not decode theme. \(error.localizedDescription)")
		}
	}

	private func describeIntermediateTheme(_ theme: IntermediateTheme) {
		var rows: [[String]] = []

		enumeratedPropertyDescriptions(from: theme.enumerated()).forEach { description in
			rows.append(description)
		}

		Self.tabulateAndPrintLines(rows)
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
		let themeData = try readInputThemeData()
		let theme = try decodedTheme(from: themeData)
		let intermediateTheme = try coercedIntermediateTheme(from: theme)
		
		let presetString = [
			TokenizedString.Presets.structDefinition,
			TokenizedString.Presets.protocolWithFunctionDefinition,
			TokenizedString.Presets.literalDeclarations
		].joinedWithDivider()

		let themedPresetString = presetString.withLineNumbers.withPadding.themedString(with: intermediateTheme)
		
		print(themedPresetString)
	}
	
	/// Tries to convert any given input theme to the specified theme format.
	private func coercedTheme(_ intermediateTheme: IntermediateTheme, to format: ThemeFormat) throws -> Theme {
		switch format {
		case .intermediate:
			return intermediateTheme
		case .xcode:
			return try Self.xcodeTheme(from: intermediateTheme)
		}
	}
	
	/// Tries to convert any given theme to an intermediate theme.
	private func coercedIntermediateTheme(from theme: Theme) throws -> IntermediateTheme {
		switch theme {
		case let intermediateTheme as IntermediateTheme:
			return intermediateTheme
		case let xcodeTheme as XcodeTheme:
			return try Self.intermediateTheme(from: xcodeTheme)
		default:
			throw ImplementationError(description: "Can not convert theme of type '\(type(of: theme))' to intermediate theme for unified conversion.")
		}
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
		
		let intermediateTheme = try Self.theme(from: inputColors)
		let outputFormat = outputFormat ?? .theme(format: .intermediate)
		
		guard case .theme(let themeFormat) = outputFormat else {
			throw ArgumentError(description: "Supplied output format must be a theme format.")
		}
		
		let outputTheme = try coercedTheme(intermediateTheme, to: themeFormat)
		
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
		default:
			throw ImplementationError(description: "Generated output theme with format '\(outputFormat)' can not be described.")
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

		guard case .theme(let outputThemeFormat) = outputFormat, outputThemeFormat == .xcode else {
			throw ArgumentError(description: "Output format '\(outputFormat?.description ?? "<None>")' not supported. Supported formats: 'xcode'.")
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

		if let color = value as? Color {
			let colorBlockDescription = colorBlock.colored(with: color)
			return ("[Color]", "\(color.hexadecimalString) \(colorBlockDescription)")
		}

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
