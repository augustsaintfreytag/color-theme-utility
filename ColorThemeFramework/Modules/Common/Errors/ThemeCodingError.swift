//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 02/10/2021.
//

import Foundation

/// An error related to encoding and decoding theme models.
public struct ThemeCodingError: Error, LocalizedError {
	
	public var errorDescription: String?
	
	public init(description: String? = nil) {
		self.errorDescription = description
	}
	
}
