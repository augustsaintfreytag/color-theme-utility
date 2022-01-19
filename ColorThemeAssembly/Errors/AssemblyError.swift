//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 18/01/2022.
//

import Foundation

struct AssemblyError: Error, LocalizedError, Codable {
	
	let kind: Kind
	let errorDescription: String?
	
	init(kind: Kind, description: String? = nil) {
		self.kind = kind
		self.errorDescription = description
	}
	
}

extension AssemblyError {
	
	enum Kind: String, Codable {
		case missingArguments
		case invalidArguments
		case missingImplementation
		case missingResults
		case deferred
	}
	
}
