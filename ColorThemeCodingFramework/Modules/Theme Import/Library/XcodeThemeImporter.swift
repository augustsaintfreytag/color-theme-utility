//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 18/09/2021.
//

import Foundation
import ColorThemeModelingFramework

public protocol XcodeThemeImporter: ThemeDecoder {}

extension XcodeThemeImporter {
	
	private var decoder: PropertyListDecoder {
		PropertyListDecoder()
	}
	
	public func xcodeTheme(from data: Data) -> XcodeTheme? {
		do {
			let theme = try decoder.decode(XcodeTheme.self, from: data)
			return theme
		} catch {
			print("Could not decode Xcode theme from data. \(error.localizedDescription)")
			return nil
		}
	}

}
