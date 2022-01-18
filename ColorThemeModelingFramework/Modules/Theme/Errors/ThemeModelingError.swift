//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 02/10/2021.
//

import Foundation

/// An error that occurred while processing and mapping themes.
public struct ThemeModelingError: Error, LocalizedError {
	
	public private(set) var errorDescription: String?
	public private(set) var kind: Kind
	
	public init(kind: Kind, description: String? = nil) {
		self.kind = kind
		self.errorDescription = description
	}
	
}

extension ThemeModelingError {
	
	public enum Kind {
		case insufficientData
		case invalidData
	}
	
}
