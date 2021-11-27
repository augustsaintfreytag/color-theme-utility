//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 02/10/2021.
//

import Foundation

/// Functionality to process file paths, read and decode theme file contents
/// into their appropriate theme type.
public protocol ThemeDecoder: ThemeFormatDetector {}

extension ThemeDecoder {

	// MARK: Theme from Path

	/// Resolves the given path string into a file URL, reads it, and decodes it into a
	/// theme of its corresponding type if possible.
	public static func decodedTheme(from path: String) throws -> Theme {
		guard let fileData = try encodedDataFromFileContents(from: path) else {
			throw ThemeCodingError(description: "Could not read supplied theme file.")
		}

		return try decodedTheme(from: fileData)
	}

	// MARK: Theme from Data
	
	/// Auto-detects the format the encoded theme uses and decodes it to its corresponding type.
	public static func decodedTheme(from data: Data) throws -> Theme {
		let format = themeFormat(for: data)
		
		switch format {
		case .intermediate:
			let decoder = JSONDecoder()
			return try decoder.decode(IntermediateTheme.self, from: data)
		case .xcode:
			let decoder = PropertyListDecoder()
			return try decoder.decode(XcodeTheme.self, from: data)
		default:
			throw ThemeCodingError(description: "Decoding theme data with format '\(format?.rawValue.description ?? "<None>")' is not supported.")
		}
	}
	
	// MARK: Data from Path
	
	/// Reads the data of an encoded theme from the file at the given path.
	public static func encodedDataFromFileContents(from path: String) throws -> Data? {
		guard
			let themeUrl = URL(fileURLWithNonCanonicalPath: path),
			let data = try encodedDataFromFileContents(from: themeUrl)
		else {
			throw ThemeCodingError(description: "Could not read encoded data from file path.")
		}
		
		return data
	}
	
	/// Reads the data of an encoded theme from the file at the given path.
	public static func encodedDataFromFileContents(from url: URL) throws -> Data? {
		do {
			return try Data(contentsOf: url)
		} catch {
			throw ThemeCodingError(description: "Could not read file contents at url '\(url.description)'. \(error.localizedDescription)")
		}
	}
	
}
