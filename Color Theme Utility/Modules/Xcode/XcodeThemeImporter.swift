//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 18/09/2021.
//

import Foundation

protocol XcodeThemeImporter: ThemeImporter {}

extension XcodeThemeImporter {
	
	private var decoder: PropertyListDecoder {
		PropertyListDecoder()
	}
	
	func xcodeTheme(from data: Data) -> EncodedXcodeTheme? {
		do {
			let theme = try decoder.decode(EncodedXcodeTheme.self, from: data)
			return theme
		} catch {
			print("Could not decode Xcode theme from data. \(error.localizedDescription)")
			return nil
		}
	}

}

protocol ThemeImporter {}

extension ThemeImporter {
	
	func encodedDataFromFileContents(from url: URL) -> Data? {
		do {
			return try Data(contentsOf: url)
		} catch {
			assertionFailure("Could not load file content at url '\(url.description)'. \(error.localizedDescription)")
			return nil
		}
	}
	
}
