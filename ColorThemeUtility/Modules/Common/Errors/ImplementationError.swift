//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 04/11/2021.
//

import Foundation

/// An error related to input or functions that are planned but not yet supported or implemented.
struct ImplementationError: Error, LocalizedError {
	
	var errorDescription: String?
	
	init(description: String? = nil) {
		self.errorDescription = description
	}
	
}
