//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 18/09/2021.
//

import Foundation
import ArgumentParser
import ColorThemeModelingFramework
import ColorThemeCodingFramework

@main
struct ColorThemeUtility: ParsableCommand {
	
	static let configuration = CommandConfiguration(
		abstract: "Utility to inspect and create color themes for use with various editors.",
		version: "\(Manifest.name), Version \(Manifest.versionDescription)",
		helpNames: [.customShort("?"), .long]
	)
	
	// MARK: Arguments

	@Argument(help: "The main operation to perform. (options: \(Mode.allCasesHelpDescription))", completion: .default)
	var mode: Mode
	
	@Option(name: [.customShort("c"), .customLong("color")], help: "The color or sequence of colors to use as input. (comma separated)", transform: stringSequenceFromArgument)
	var inputColors: [String]?
	
	@Flag(name: [.customShort("C"), .customLong("colors-from-stdin")], help: "Read color sequence from stdin (default: false).")
	var inputColorsFromStdin: Bool = false
	
	@Option(name: [.customShort("s"), .customLong("skew")], help: "The lightness direction skew to use for palette generation. (options: \(ColorTransform.allCasesHelpDescription))")
	var colorTransform: ColorTransform?
	
	@Flag(name: [.customLong("no-palette-skew")], help: "Disables skewing colors when generating a color cascade from a base value. (default: false)")
	var disablePaletteTransform: Bool = false
	
	@Option(name: [.customShort("n"), .customLong("number-of-colors")], help: "The number of colors created in palette generation (including provided base color).")
	var colorCount: Int?
	
	@Option(name: [.customShort("t"), .customLong("theme")], help: "The theme file to use as input.")
	var inputThemeFile: String?
	
	@Flag(name: [.customShort("T"), .customLong("theme-from-stdin")], help: "Read theme file contents from stdin (default: false).")
	var inputThemeContentsFromStdin: Bool = false
	
	@Option(name: [.customShort("o"), .customLong("output")], help: "The format used for output when inspecting, converting, or generating colors or themes. (options: \(OutputFormat.allCasesHelpDescription))")
	var outputFormat: OutputFormat?
	
	@Option(name: [.customShort("p"), .customLong("preview")], help: "The sample content used to preview themes. (options: \(PreviewFormat.allCasesHelpDescription))")
	var previewFormat: PreviewFormat?
	
	@Flag(name: [.customShort("h"), .customLong("human-readable")], help: "Outputs data and models in a human-readable format. (default: false)")
	var humanReadable: Bool = false

	@Flag(name: [.customLong("no-color-correct-preview")], help: "Disables color correction for theme preview to account for differences in terminal rendering (iTerm 2). (default: false)")
	var disableColorCorrectPreview: Bool = false
	
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
		case .unmapTheme:
			try unmapTheme()
		}
	}

}

// MARK: Commands

extension ColorThemeUtility: TerminalDetector,
							 ColorFormatDetector,
							 ColorModeler,
							 ThemeDecoder,
							 ThemeEncoder,
							 HSLColorConverter,
							 ColorExtrapolator,
							 IntermediateThemeModeler,
							 TerminalThemeColorCorrector,
							 XcodeThemeModeler,
							 TextMateThemeModeler,
							 TableFormatter,
							 ThemePropertyEnumerator,
							 ColorDescriptionCommand {
	
	
	// MARK: Convert Color
	
	private func convertColor() throws {
		let inputColorArgument = lineFromStdin ?? inputColors?.first
		
		guard let inputColorString = inputColorArgument, let inputColor = Self.color(fromAutodetectedColorString: inputColorString) else {
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
	
	// MARK: Describe Theme
	
	private var dividerRow: [String] { ["──────────────────────────────"] }
	
	/// Parses the given theme file and prints its contents in a readable format.
	///
	/// Options to visualize and present a theme:
	///   - `theme.formattedEncodedDebugDescription`
	///   - `theme.<key>.enumerated()`
	///
	private func describeTheme() throws {
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

	private func describeIntermediateTheme<ThemeType: Theme & CustomPropertyEnumerable>(_ theme: ThemeType) {
		let rows = enumeratedPropertyDescriptions(from: theme.enumerated())
		Self.tabulateAndPrintLines(rows)
	}

	private func describeXcodeTheme(_ theme: XcodeTheme) {
		var rows: [[String]] = []

		rows.append(contentsOf: enumeratedPropertyDescriptions(from: theme.enumerated()))
		rows.append(contentsOf: enumeratedPropertyDescriptions(from: theme.dvtSourceTextSyntaxColors.enumerated(), childrenOf: "dvtSourceTextSyntaxColors"))
		rows.append(contentsOf: enumeratedPropertyDescriptions(from: theme.dvtSourceTextSyntaxFonts.enumerated(), childrenOf: "dvtSourceTextSyntaxColors"))

		Self.tabulateAndPrintLines(rows)
	}
	
	private func describeTextMateTheme(_ theme: TextMateTheme) {
		var rows: [[String]] = []
		
		rows.append(["uuid", "[UUID]", theme.uuid])
		rows.append(["name", "[String]", theme.name])
		
		guard let masterSetting = theme.settings.first else {
			Self.tabulateAndPrintLines(rows)
			return
		}
		
		rows.append(dividerRow)
		rows.append(contentsOf: enumeratedPropertyDescriptions(from: masterSetting.settings.enumerated()))
		
		for setting in theme.settings {
			rows.append(dividerRow)
			
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
	
	/// Determines and returns a viable decoded theme from file path or contents from
	/// command arguments. Input is read from `stdin` if flag `inputColorsFromStdin` is
	/// set and uses directly supplied data otherwise.
	private func inputThemeFileFromArguments() throws -> Theme {
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
	
	// MARK: Preview Theme
	
	private func previewTheme() throws {
		let theme: Theme = try inputThemeFileFromArguments()
		var intermediateTheme = try coercedIntermediateTheme(from: theme)
		
		if !disableColorCorrectPreview, let terminal = Self.terminalApplication {
			intermediateTheme = Self.colorCorrectedTheme(intermediateTheme, for: terminal)
		}
		
		let presetString = presetString(for: previewFormat ?? .swift)
		let themedPresetString = presetString.withLineNumbers.withPadding.themedString(with: intermediateTheme)
		
		print(themedPresetString)
	}
	
	private func presetString(for format: PreviewFormat) -> TokenizedString {
		switch format {
		case .swift:
			return [
				TokenizedString.SwiftPresets.structDefinition,
				TokenizedString.SwiftPresets.protocolWithFunctionDefinition,
				TokenizedString.SwiftPresets.literalDeclarations
			].joinedWithDivider()
		case .typescript:
			return [
				TokenizedString.TypeScriptPresets.classDefinition,
				TokenizedString.TypeScriptPresets.typeWithFunctionDefinition,
				TokenizedString.TypeScriptPresets.literalDeclarations
			].joinedWithDivider()
		case .markdown:
			return TokenizedString(tokens: [.word("Not supported.")])
		case .xcode:
			return TokenizedString.XcodePreferencesPresets.preferences
		}
	}
	
	/// Tries to coerce a given generated theme to the specified theme format.
	///
	/// Coercion to intermediate theme format is lossless (data is not touched).
	///
	/// - Important: Will apply *color correction* when converting to Xcode theme
	/// format (if enabled in command configuration).
	///
	private func coercedGeneratedTheme(_ intermediateTheme: IntermediateTheme, to format: ThemeFormat) throws -> Theme {
		switch format {
		case .intermediate:
			return intermediateTheme
		case .xcode:
			return try Self.xcodeTheme(from: intermediateTheme)
		case .textmate:
			return try Self.textMateTheme(from: intermediateTheme)
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
	
	// MARK: Generate Palette
	
	private func generatePalette() throws {
		guard
			let inputColor = linesFromStdin ?? inputColors?.first,
			let color = Self.color(fromAutodetectedColorString: inputColor)
		else {
			throw ArgumentError(description: "Missing or invalid input color, need base color to generate palette.")
		}
		
		let numberOfColors = colorCount ?? 3
		let transform: ColorTransform = colorTransform ?? .lighter
		let palette = Self.cascadingColorSequence(from: color, numberOfColors: numberOfColors, skewing: transform)
		
		for (index, paletteColor) in palette.enumerated() {
			printColor(paletteColor, description: "Palette color #\(index + 1) (\(paletteColor.description))")
		}
	}
	
	// MARK: Generate Theme
	
	private func generateTheme() throws {
		let inputColors = try inputColorSequenceFromArguments()
		let intermediateTheme = try Self.theme(from: inputColors, cascade: !disablePaletteTransform)
		let outputFormat = outputFormat ?? .theme(format: .intermediate)
		
		guard case .theme(let themeFormat) = outputFormat else {
			throw ArgumentError(description: "Supplied output format must be a theme format.")
		}
		
		let outputTheme = try coercedGeneratedTheme(intermediateTheme, to: themeFormat)
		
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
	
	/// Determines and returns a viable color sequence from command arguments.
	/// Input is read from `stdin` if flag `inputColorsFromStdin` is set and uses
	/// directly supplied data otherwise.
	///
	/// Note that a *color sequence* is defined as an ordered collection of exactly 10 colors.
	private func inputColorSequenceFromArguments() throws -> [Color] {
		if inputColorsFromStdin {
			let colorDescriptions = stringSequenceFromArgument(linesFromStdin ?? "")
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
	
	// MARK: Convert Theme

	private func convertTheme() throws {
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
		print(try Self.encodedTheme(xcodeTheme, with: .plist))
	}

	// MARK: Unmap Theme

	private func unmapTheme() throws {
		// Take an existing intermediate theme and extract unskewed color values
		// to produce the initial 10 colors used to generate the theme.

		let inputTheme = try inputThemeFileFromArguments()
		let intermediateTheme = try coercedIntermediateTheme(from: inputTheme)
		let colors = Self.colorSequence(from: intermediateTheme)

		if humanReadable {
			for (index, color) in colors.enumerated() {
				printColor(color, description: "Color \(String(format: "%02d", index + 1))")
			}
		} else {
			let colorDescriptions = colors.map { color in color.hexadecimalString }
			let format: ColorCollectionFormat = {
				guard case let .colorCollection(format: colorCollectionFormat) = outputFormat else {
					return .parameter
				}

				return colorCollectionFormat
			}()

			switch format {
			case .parameter:
				print(colorDescriptions.joined(separator: ", "))
			case .json:
				let encoder = JSONEncoder()
				let data = try! encoder.encode(colorDescriptions)
				print(String(data: data, encoding: .utf8)!)
			}
		}
	}
	
}
