//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 12/01/2022.
//

import Foundation
import ColorThemeModeling

/// The main color theme module, optimized for WebAssembly.
///
/// This module is built as a strict subset of the greater `ColorThemeUtility` target,
/// offering only functionality needed in an external integration version of the utility.
///
/// The module includes the following feature set:
///
/// - Color format detection (color in, description out)
/// - Color format conversion (color in, color out)
/// - Theme generation (colors in, intermediate theme out)
///
///	Functionality is kept with `Module` while exports and encoding is handled
///	in separate declarations at the top level of the target.
///
struct Module: IntermediateThemeModeler, ColorFormatDetector, ColorModeler {
	
	static func generateRandomColor() -> Color {
		return Color.random
	}
	
	static func describeColor(_ description: String) throws -> ColorFormat {
		guard let colorFormat = Self.colorFormat(for: description) else {
			throw AssemblyError(kind: .invalidArguments, description: "Color format could not be determined.")
		}
		
		return colorFormat
	}
	
	static func convertColor(_ description: String, format: ColorFormat) throws -> String {
		guard let inputColorFormat = Self.colorFormat(for: description) else {
			throw AssemblyError(kind: .invalidArguments, description: "Color format could not be determined for conversion.")
		}
		
		guard let inputColor = Self.color(from: description, format: inputColorFormat) else {
			throw AssemblyError(kind: .invalidArguments, description: "Could not create color in detected format '\(inputColorFormat)'.")
		}
		
		switch format {
		case .floatRGBA:
			return inputColor.floatRGBAString
		case .hexadecimal:
			return inputColor.hexadecimalString
		}
	}
	
	static func generateTheme(from colors: [Color]) throws -> IntermediateTheme {
		do {
			return try Self.theme(from: colors)
		} catch {
			throw AssemblyError(kind: .deferred, description: "Could not generate theme from input. \(error.localizedDescription)")
		}
	}
	
	static func generateTheme(from encodedColorData: Data) throws -> IntermediateTheme {
		do {
			let decoder = JSONDecoder()
			let inputColorDescriptions = try decoder.decode([String].self, from: encodedColorData)
			let inputColors: [Color] = inputColorDescriptions.compactMap { description in Module.color(fromAutodetectedColorString: description) }
			let theme = try Self.theme(from: inputColors)
			
			return theme
		} catch is DecodingError {
			let encodedDataDescriptions = String(data: encodedColorData, encoding: .utf8) ?? ""
			throw AssemblyError(kind: .invalidArguments, description: "Could not decode input colors from input '\(encodedDataDescriptions)'.")
		} catch {
			throw error
		}
	}
	
}

@_cdecl("main")
func main(_ argv: Int, _ argc: Int) -> Int {
	return 0
}

@_cdecl("generateRandomColor")
func generateRandomColor() {
	let results = call { Module.generateRandomColor() }
	print(unwrapAndEncode(results))
}

@_cdecl("describeColor")
func describeColor(_ pointer: UnsafePointer<CChar>) {
	let inputColorString = String(cString: pointer, encoding: .utf8) ?? ""
	let results = call { try Module.describeColor(inputColorString).rawValue }
	
	print(unwrapAndEncode(results))
}

@_cdecl("convertColor")
func convertColor(_ pointer: UnsafePointer<CChar>) {
	guard
		let argumentsDataString = String(cString: pointer, encoding: .utf8),
		let argumentsData = argumentsDataString.data(using: .utf8),
		let arguments = try? JSONDecoder().decode([String].self, from: argumentsData)
	else {
		let error = AssemblyError(kind: .invalidCoding, description: "Expected encoded argument tuple with color description and destination format.")
		print(encode(error))
		return
	}
	
	guard arguments.count == 2 else {
		let error = AssemblyError(kind: .missingArguments, description: "Decoded argument tuple is missing elements. Expected color description and destination format.")
		print(encode(error))
		return
	}
	
	let colorDescription = arguments[0]
	let colorFormat = ColorFormat(rawValue: arguments[1]) ?? .hexadecimal
	
	let results = call { try Module.convertColor(colorDescription, format: colorFormat) }
	print(unwrapAndEncode(results))
}

@_cdecl("generateTheme")
func generateTheme(_ pointer: UnsafePointer<CChar>) {
	guard
		let inputColorDataString = String(cString: pointer, encoding: .utf8),
		let inputColorData = inputColorDataString.data(using: .utf8)
	else {
		let error = AssemblyError(kind: .invalidCoding, description: "Expected arguments to be decodable as a sequence of color descriptions.")
		print(encode(error))
		return
	}
	
	let results = call { try Module.generateTheme(from: inputColorData) }
	print(unwrapAndEncode(results))
}

@_cdecl("echoMessage")
func echoMessage(_ pointer: UnsafePointer<CChar>) {
	let inputString = String(cString: pointer, encoding: .utf8) ?? "<None>"
	print("Echo: \(inputString)")
}
