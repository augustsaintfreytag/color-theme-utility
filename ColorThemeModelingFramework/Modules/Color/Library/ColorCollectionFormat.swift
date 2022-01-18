//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 27/11/2021.
//

import Foundation

/// The format of an ordered collection of colors.
public enum ColorCollectionFormat: String, CaseIterable {

	/// A comma-separated sequence of colors, as expected by the utility as input colors.
	case parameter

	/// A JSON-encoded form of a sequence of colors, suitable for storage.
	case json

}
