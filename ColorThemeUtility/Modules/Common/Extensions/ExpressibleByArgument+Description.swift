//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 27/10/2021.
//

import Foundation
import ArgumentParser

extension ExpressibleByArgument {
	
	/// Returns a joined description of all enumerable options of the argument type for use in help texts.
	///
	/// Creates a formatted description in the form of "one|two|three|four|five".
	static var helpOptionsDescription: String {
		return allValueStrings.joined(separator: "|")
	}
	
}
