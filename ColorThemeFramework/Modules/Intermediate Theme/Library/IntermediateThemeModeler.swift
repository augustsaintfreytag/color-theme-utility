//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 11/10/2021.
//

import Foundation

/// Functionality to create populated `IntermediateTheme` structures from a
/// collection of color values as input.
///
/// The mapping procedure first assigns each of a given initial sequence of a
/// *background* and *8 colors* to high level categories, used as origin points:
///
/// - Text, Mark, Attributes (Foreground)
/// - Strings, Characters, URLs
/// - Numbers
/// - Keywords, Markup, Preprocessor
/// - Classes, Variables (References, System)
/// - Types, Functions, Constants, Preprocessor (Values, System)
/// - Classes, Variables (References, Project)
/// - Types, Functions, Constants, Preprocessor (Values, Project)
///
public protocol IntermediateThemeModeler {}

extension IntermediateThemeModeler {
	
	public static func theme(from colors: [Color]) throws -> IntermediateTheme {
		fatalError("Not implemented.")
	}
	
	private static func originColors(from colors: [Color]) throws -> OriginColors {
		guard colors.count == 9 else {
			throw ThemeModelingError(kind: .insufficientData, description: "Can not create intermediate theme, need a background and exactly 8 palette colors as input.")
		}
		
		return OriginColors(
			background: colors[0],
			text: colors[1],
			strings: colors[2],
			numbers: colors[3],
			keywords: colors[4],
			typesSystemA: colors[5],
			typesSystemB: colors[6],
			typesProjectA: colors[7],
			typesProjectB: colors[8]
		)
	}
	
}

// MARK: Library

struct OriginColors {
	
	let background: Color
	let text: Color
	let strings: Color
	let numbers: Color
	let keywords: Color
	let typesSystemA: Color
	let typesSystemB: Color
	let typesProjectA: Color
	let typesProjectB: Color
	
}
