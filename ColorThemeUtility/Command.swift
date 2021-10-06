//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 18/09/2021.
//

import Foundation
import ArgumentParser
import Rainbow

@main
struct ColorThemeUtility: ParsableCommand {
	
	static let configuration = CommandConfiguration(
		helpNames: [.customShort("?"), .long]
	)
	
	// MARK: Arguments

	@Argument(help: "The main operation to perform. (options: describe|convert)", completion: .default)
	var mode: Mode
	
	@Option(name: [.customShort("c"), .customLong("color")], help: "The color string to convert.")
	var inputColor: String?
	
	@Option(name: [.customShort("i"), .customLong("input")], help: "The theme file as input to be processed.")
	var inputFile: String?
	
	@Flag(name: [.short], help: "Output printed descriptions in a human-readable format.")
	var humanReadable: Bool = false
	
	// MARK: Run
	
	func run() throws {
		switch mode {
		case .describe:
			try detectColorKind()
		case .print:
			try printColor()
		case .debug:
			try debugPrintTheme()
		}
	}

}

// MARK: Modes

extension ColorThemeUtility: ColorFormatDetector, ColorModeler, ThemeImporter, HSLColorConverter {
	
	func detectColorKind() throws {
		guard let inputColor = inputColor else {
			throw ArgumentError(errorDescription: "No color string given, color format could not be determined.")
		}
		
		guard let inputColorFormat = colorFormat(for: inputColor) else {
			throw ArgumentError(errorDescription: "Color format could not be determined.")
		}
		
		if humanReadable {
			print("Color string '\(inputColor)' is \(inputColorFormat.description) (\(inputColorFormat.rawValue)).")
		} else {
			print(inputColorFormat.rawValue)
		}
	}
	
	func printColor() throws {
		guard let inputColor = inputColor, let color = color(fromAutodetectedColorString: inputColor) else {
			throw ArgumentError(errorDescription: "Missing input color or given string has invalid or unsupported format.")
		}
		
		printColor(color)
		print("HSL \(color.hsl)")
		
		let convertedHsl = Self.rgbComponents(for: color.hsl)
		print("HSL from RGB: \(convertedHsl)")
	}
	
	func debugPrintTheme() throws {
		guard let inputFilePath = inputFile else {
			throw ArgumentError(errorDescription: "Missing input theme file path.")
		}
		
		guard let fileData = encodedDataFromFileContents(from: inputFilePath) else {
			throw ArgumentError(errorDescription: "Could not read supplied theme file.")
		}
		
		let decoder = PropertyListDecoder()
		guard let theme = try? decoder.decode(XcodeTheme.self, from: fileData) else {
			throw ThemeCodingError(errorDescription: "Could not decode supplied theme file as an Xcode theme model.")
		}
		
		// print(theme.formattedEncodedDebugDescription ?? "<Invalid Data>")
		
		let enumeratedColors = orderedEnumeratedColors(from: theme.dvtSourceTextSyntaxColors.enumerated())
		for (property, color) in enumeratedColors {
			printColor(color, description: property)
		}
	}
	
	private func orderedEnumeratedColors(from enumeratedColors: [(property: String, value: String)]) -> [(property: String, color: Color)] {
		return enumeratedColors.reduce(into: [(property: String, color: Color)]()) { collection, element in
			let (property, value) = element
			
			guard let color = color(fromAutodetectedColorString: value) else {
				return
			}
			
			collection.append((property, color))
		}.sorted { lhs, rhs in
			lhs.color.perception < rhs.color.perception
		}
	}
	
	private func printColor(_ color: Color, description: String? = nil) {
		let hex = color.hexadecimalString
		
		// let colorDescription = "████████".hex(hex, to: .bit24) + " \(hex), P \(color.perception), HSP \(color.hsp), HSL \(hsl.hue)/\(hsl.saturation)/\(hsl.lightness)"
		let colorDescription = "████████".hex(hex, to: .bit24) + " \(hex)"
		
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
}
