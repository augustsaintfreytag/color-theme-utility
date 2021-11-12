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
public protocol IntermediateThemeModeler: ColorExtrapolator {}

extension IntermediateThemeModeler {
	
	private static var unspecifiedColor: Color { Color(red: 0.975, green: 0.125, blue: 1.0) }
	
	/// Creates a theme from the given sequence of colors.
	///
	/// Currently only creates colors suitable for use in dark themes.
	public static func theme(from colors: [Color]) throws -> IntermediateTheme {
		let originColors = try originColors(from: colors)
		
		let textColors = cascadingColorSequence(from: originColors.text, numberOfColors: 3, skewing: .lighter)
		
		let commentBaseColor = transformedColor(from: originColors.text, skewing: .darker, modifier: 2.0)
		let commentColors = cascadingColorSequence(from: commentBaseColor, numberOfColors: 2, skewing: .lighter)
		
		let stringColors = cascadingColorSequence(from: originColors.strings, numberOfColors: 3, skewing: .darker)
		let typesSystemAColors = cascadingColorSequence(from: originColors.typesSystemA, numberOfColors: 2, skewing: .darker)
		let typesSystemBColors = cascadingColorSequence(from: originColors.typesSystemB, numberOfColors: 4, skewing: .darker)
		let typesProjectAColors = cascadingColorSequence(from: originColors.typesProjectA, numberOfColors: 4, skewing: .darker)
		let typesProjectBColors = cascadingColorSequence(from: originColors.typesProjectB, numberOfColors: 6, skewing: .darker)
		
		let activeLineBackgroundColor = transformedColor(from: originColors.background, skewing: .lighter, modifier: 0.5)
		let selectionBackgroundColor = transformedColor(from: originColors.keywords, applying: (0, 0.6, 0.2))
		let insertionPointColor = transformedColor(from: originColors.keywords, skewing: .lighter)
		
		return IntermediateTheme(
			header: IntermediateTheme.defaultHeader,
			version: IntermediateTheme.defaultVersion,
			foreground: textColors[0],
			background: originColors.background,
			selectionBackground: selectionBackgroundColor,
			activeLineBackground: activeLineBackgroundColor,
			insertionPoint: insertionPointColor,
			comment: commentColors[0],
			commentDocumentation: commentColors[1],
			commentSection: textColors[1],
			commentSectionHeader: originColors.keywords,
			keyword: originColors.keywords,
			functionProject: typesProjectBColors[3],
			functionSystem: typesSystemBColors[1],
			functionParameter: textColors[2],
			preprocessorProject: typesProjectBColors[5],
			preprocessorSystem: typesSystemBColors[3],
			constantProject: typesProjectBColors[4],
			constantSystem: typesSystemBColors[2],
			variableProject: typesProjectAColors[1],
			variableSystem: typesSystemAColors[1],
			typeProject: typesProjectBColors[2],
			typeSystem: typesSystemBColors[0],
			referenceTypeProject: typesProjectAColors[0],
			referenceTypeSystem: typesSystemAColors[0],
			valueTypeProject: typesProjectBColors[2],
			valueTypeSystem: typesSystemBColors[0],
			enumProject: typesProjectBColors[2],
			enumSystem: typesSystemBColors[0],
			declarationType: typesProjectBColors[0],
			declarationAny: typesProjectBColors[1],
			attribute: textColors[2],
			module: textColors[2],
			number: originColors.numbers,
			string: stringColors[0],
			character: stringColors[1],
			url: stringColors[2]
		)
	}
	
	/// Returns an asserted mapping of colors usable as origin points for
	/// theme generation.
	///
	/// Out of the supplied *9 colors*, the first is mapped as a
	/// *background color*, the second a general foreground color;
	/// subsequent values are used for syntax.
	///
	/// Verifies an input collection of colors of arbitrary length but
	/// requires exactly *9 colors* to map origin colors.
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
