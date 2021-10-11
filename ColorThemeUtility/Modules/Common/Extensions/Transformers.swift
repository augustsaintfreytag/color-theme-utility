//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 11/10/2021.
//

import Foundation

func stringCollectionFromArgument(_ string: String) -> [String] {
	return string.split(separator: ",").map { substring in
		return String(substring).trimmingCharacters(in: .whitespaces)
	}
}
