//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 12/11/2021.
//

import Foundation

/// A form-giving structure for an ordered collection of input colors.
/// Provides a preliminary mapping for colors before being extrapolated
/// and assigned to properties in a theme model.
struct OriginColors {

	let background: Color
	let foreground: Color
	let keywords: Color
	let referenceTypes: Color
	let valueTypes: Color
	let functions: Color
	let constants: Color
	let variables: Color
	let strings: Color
	let numbers: Color

}

extension OriginColors {

	/// Creates origin colors from an ordered collection of exactly 10 color values.
	/// Directly maps colors to origin color model properties one by one.
	init?(from colors: [Color]) {
		guard colors.count == 10 else {
			return nil
		}

		self.init(
			background: colors[0],
			foreground: colors[1],
			keywords: colors[2],
			referenceTypes: colors[3],
			valueTypes: colors[4],
			functions: colors[5],
			constants: colors[6],
			variables: colors[7],
			strings: colors[8],
			numbers: colors[9]
		)
	}

}
