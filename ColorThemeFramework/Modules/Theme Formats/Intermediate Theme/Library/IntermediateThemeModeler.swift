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

		let backgroundColor = originColors.background
		let foregroundColor = originColors.foreground

		let commentBaseColor = transformedColor(from: originColors.foreground, skewing: .darker, modifier: 2.0)
		let commentColors = cascadingColorSequence(from: commentBaseColor, numberOfColors: 2, skewing: .darker)

		let keywordColor = originColors.keywords

		let referenceTypeColors = cascadingColorSequence(from: originColors.referenceTypes, numberOfColors: 3, skewing: .darker)
		let valueTypeColors = cascadingColorSequence(from: originColors.valueTypes, numberOfColors: 3, skewing: .darker)
		let functionColors = cascadingColorSequence(from: originColors.functions, numberOfColors: 4, skewing: .darker)
		let constantColors = cascadingColorSequence(from: originColors.constants, numberOfColors: 3, skewing: .darker)
		let variableColors = cascadingColorSequence(from: originColors.variables, numberOfColors: 4, skewing: .darker)
		let stringColors = cascadingColorSequence(from: originColors.strings, numberOfColors: 3, skewing: .darker)
		let numberColor = originColors.numbers
		
		let activeLineBackgroundColor = transformedColor(from: originColors.background, skewing: .lighter, modifier: 0.5)
		let selectionBackgroundColor = transformedColor(from: originColors.keywords, applying: (0, 0.6, 0.2))
		let insertionPointColor = transformedColor(from: originColors.keywords, skewing: .lighter)

		return IntermediateTheme(
			header: IntermediateTheme.defaultHeader,
			version: IntermediateTheme.defaultVersion,
			foreground: foregroundColor,
			background: backgroundColor,
			selectionBackground: selectionBackgroundColor,
			activeLineBackground: activeLineBackgroundColor,
			insertionPoint: insertionPointColor,
			comment: commentColors[1],
			commentDocumentation: commentColors[1],
			commentSection: commentColors[0],
			commentSectionHeader: commentColors[0],
			keyword: keywordColor,
			declarationType: referenceTypeColors[0],
			declarationAny: valueTypeColors[0],
			functionProject: functionColors[1],
			functionSystem: functionColors[0],
			functionParameter: constantColors[2],
			preprocessorProject: functionColors[3],
			preprocessorSystem: functionColors[2],
			constantProject: constantColors[1],
			constantSystem: constantColors[0],
			variableProject: variableColors[1],
			variableSystem: variableColors[0],
			referenceTypeProject: referenceTypeColors[2],
			referenceTypeSystem: referenceTypeColors[1],
			valueTypeProject: valueTypeColors[2],
			valueTypeSystem: valueTypeColors[1],
			attribute: variableColors[2],
			module: variableColors[3],
			number: numberColor,
			string: stringColors[0],
			character: stringColors[1],
			url: stringColors[2]
		)
	}
	
	/// Returns an asserted mapping of colors usable as origin points for
	/// theme generation.
	///
	/// Out of the supplied *10 colors*, the first is mapped as a
	/// *background color*, the second a general foreground color;
	/// subsequent values are used for syntax.
	///
	private static func originColors(from colors: [Color]) throws -> OriginColors {
		guard let originColors = OriginColors(from: colors) else {
			throw ThemeModelingError(kind: .insufficientData, description: "Can not create intermediate theme, need exactly 10 palette colors as input.")
		}
		
		return originColors
	}
	
}
