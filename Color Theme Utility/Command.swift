//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 18/09/2021.
//

import Foundation
import ArgumentParser
import Rainbow

@main
struct ColorThemeUtility: ParsableCommand, ColorFormatDetector, ColorModeler {
	
	// MARK: Arguments

	@Argument(help: "The main operation to perform. (options: describe|convert)", completion: .default)
	var mode: Mode
	
	@Option(name: [.customShort("c"), .customLong("color")], help: "The color string to convert.")
	var inputColor: String?
	
	@Flag(name: [.short], help: "Output printed descriptions in a human-readable format.")
	var humanReadable: Bool = false
	
	// MARK: Run
	
	func run() throws {
		switch mode {
		case .describe:
			try detectColorKind()
		case .print:
			try printColor()
		}
	}
	
	// MARK: Modes
	
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
		
		let hexColor = color.hexadecimalString
		print("████████".hex(hexColor, to: .bit24) + " Red: \(color.red), Green: \(color.green), Blue: \(color.blue) (\(hexColor))")
	}

}

enum Mode: String, CaseIterable, ExpressibleByArgument {
	case describe
	case print
}
