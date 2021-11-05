//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 02/10/2021.
//

import Foundation

/// Functionality to process file paths, read and decode theme file contents into their appropriate model.
public protocol ThemeImporter: ThemeFormatDetector {}

extension ThemeImporter {
	
	// MARK: Theme In
	
	/// Auto-detects the format the encoded theme uses and decodes it to its corresponding type.
	public func decodedTheme(from data: Data) throws -> Theme {
		let format = themeFormat(for: data)
		
		switch format {
		case .intermediate:
			let decoder = JSONDecoder()
			return try decoder.decode(IntermediateTheme.self, from: data)
		case .xcode:
			let decoder = PropertyListDecoder()
			return try decoder.decode(XcodeTheme.self, from: data)
		default:
			throw ThemeCodingError(description: "Decoding theme data with format '\(format.rawValue)' is not supported.")
		}
	}
	
	// MARK: Data In
	
	/// TODO: Rework import functions to `throw` for errors, move assertion to command.
	
	/// Reads the data of an encoded theme from the file at the given path.
	public func encodedDataFromFileContents(from path: String) -> Data? {
		guard
			let themeUrl = URL(fileURLWithNonCanonicalPath: path),
			let data = encodedDataFromFileContents(from: themeUrl)
		else {
			return nil
		}
		
		return data
	}
	
	/// Reads the data of an encoded theme from the file at the given path.
	public func encodedDataFromFileContents(from url: URL) -> Data? {
		do {
			return try Data(contentsOf: url)
		} catch {
			assertionFailure("Could not load file content at url '\(url.description)'. \(error.localizedDescription)")
			return nil
		}
	}
	
}
