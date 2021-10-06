//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 02/10/2021.
//

import Foundation

/// An error that occurred while processing and mapping themes.
public struct ThemeConversionError: Error, LocalizedError {
	
	public var errorDescription: String?
	
	public init(description: String? = nil) {
		self.errorDescription = description
	}
	
}
