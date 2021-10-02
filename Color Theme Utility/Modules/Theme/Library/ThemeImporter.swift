//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 02/10/2021.
//

import Foundation

/// Functionality to process file paths, read and decode theme file contents into their appropriate model.
protocol ThemeImporter {}

extension ThemeImporter {
	
	func encodedDataFromFileContents(from path: String) -> Data? {
		guard
			let themeUrl = URL(fileURLWithNonCanonicalPath: path),
			let data = encodedDataFromFileContents(from: themeUrl)
		else {
			return nil
		}
		
		return data
	}
	
	func encodedDataFromFileContents(from url: URL) -> Data? {
		do {
			return try Data(contentsOf: url)
		} catch {
			assertionFailure("Could not load file content at url '\(url.description)'. \(error.localizedDescription)")
			return nil
		}
	}
	
}
