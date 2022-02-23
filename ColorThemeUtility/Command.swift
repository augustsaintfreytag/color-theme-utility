//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 18/09/2021.
//

import Foundation
import ArgumentParser
import ColorThemeModeling
import ColorThemeCoding
import ColorThemeEnclosure

@main
struct ColorThemeUtility: ParsableCommand,
						  ColorDescriptionCommand,
						  ColorConversionCommand,
						  PaletteGeneratorCommand,
						  ThemeDescriptionCommand,
						  ThemeConversionCommand,
						  ThemeGeneratorCommand,
						  ThemePreviewCommand,
						  ThemeUnmapCommand {
	
	static let configuration = CommandConfiguration(
		abstract: "Utility to inspect and create color themes for use with various editors.",
		version: "\(Manifest.name), Version \(Manifest.versionDescription)",
		helpNames: [.customShort("?"), .long]
	)
	
	// MARK: Arguments

	@Argument(help: "The main operation to perform. (options: \(Mode.allCasesHelpDescription))", completion: .default)
	var mode: Mode
	
	@Option(name: [.customShort("c"), .customLong("color")], help: "The color or sequence of colors to use as input. (comma separated)", transform: Self.stringSequenceFromArgument)
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
	
	@Option(name: [.customShort("f"), .customLong("output-format")], help: "The format used for output when inspecting, converting, or generating colors or themes. (options: \(OutputFormat.allCasesHelpDescription))")
	var outputFormat: OutputFormat?
	
	@Option(name: [.customShort("o"), .customLong("output-directory")], help: "A directory path to write enclosed theme packages to. An output path can be reused for multiple generated themes if names differ as themes will be written into their own subdirectory.")
	var outputDirectory: String?
	
	@Option(name: [.customLong("name")], help: "The name of the generated theme, used in generated manifests and supplementary content.")
	var outputThemeName: String?
	
	@Option(name: [.customLong("description")], help: "The name of the generated theme, used in generated manifests and supplementary content.")
	var outputThemeDescription: String?
	
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
