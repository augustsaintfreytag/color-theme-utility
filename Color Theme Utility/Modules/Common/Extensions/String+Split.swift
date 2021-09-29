//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 29/09/2021.
//

import Foundation

extension String {
	
	/// Returns a sequence of substrings by dividing the string into parts of the given length.
	func split(intoSubsequencesOfLength length: Int) -> [Substring] {
		return stride(from: 0, to: count, by: length).map { strideIndex -> Substring in
			let startIndex = index(startIndex, offsetBy: strideIndex)
			let endIndex = index(startIndex, offsetBy: length, limitedBy: endIndex) ?? endIndex
			
			return self[startIndex ..< endIndex]
		}
	}
	
}

extension Array where Element == Substring {
	
	/// Returns mapped `String` type values from the collection of substrings.
	var remapped: [String] {
		return self.map { substring in String(substring) }
	}
	
}
