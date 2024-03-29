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
	///
	/// Note that the `name` parameter will be transformed into a tuple type
	/// once additional values are needed as input.
	public static func theme(from colors: [Color], name: String? = nil, cascade shouldCascade: Bool = true) throws -> IntermediateTheme {
		let originColors = try originColors(from: colors)

		let defaultColorTransform: ColorTransform = shouldCascade ? .darker : .none
		
		let backgroundColor = originColors.background
		let foregroundColor = originColors.foreground

		let commentBaseColor = transformedColor(from: originColors.foreground, applying: (0, -0.05, -0.4))
		let commentColors = cascadingColorSequence(from: commentBaseColor, numberOfColors: 2, skewing: .darker)

		let keywordColor = originColors.keywords

		let referenceTypeColors = cascadingColorSequence(from: originColors.referenceTypes, numberOfColors: 3, skewing: defaultColorTransform)
		let valueTypeColors = cascadingColorSequence(from: originColors.valueTypes, numberOfColors: 3, skewing: defaultColorTransform)
		let functionColors = cascadingColorSequence(from: originColors.functions, numberOfColors: 4, skewing: defaultColorTransform)
		let constantColors = cascadingColorSequence(from: originColors.constants, numberOfColors: 3, skewing: defaultColorTransform)
		let variableColors = cascadingColorSequence(from: originColors.variables, numberOfColors: 4, skewing: defaultColorTransform)
		let stringColors = cascadingColorSequence(from: originColors.strings, numberOfColors: 3, skewing: defaultColorTransform)
		let numberColor = originColors.numbers
		
		let activeLineBackgroundColor = transformedColor(from: originColors.background, skewing: .lighter, modifier: 0.6)
		let selectionBackgroundColor = transformedColor(from: originColors.keywords, applying: (0, -0.05, -0.2))
		let insertionPointColor = transformedColor(from: originColors.keywords, applying: (0, -0.1, -0.1))
		let instructionPointerColor = transformedColor(from: originColors.keywords, applying: (0, -0.25, -0.25))

		return IntermediateTheme(
			_format: IntermediateTheme.defaultFormat,
			_version: IntermediateTheme.defaultVersion,
			_name: name,
			foreground: foregroundColor,
			background: backgroundColor,
			selectionBackground: selectionBackgroundColor,
			activeLineBackground: activeLineBackgroundColor,
			insertionPoint: insertionPointColor,
			instructionPointer: instructionPointerColor,
			comment: commentColors[1],
			commentDocumentation: commentColors[1],
			commentSection: commentColors[0],
			commentSectionHeader: commentColors[0],
			keyword: keywordColor,
			declarationAny: valueTypeColors[0],
			declarationType: referenceTypeColors[0],
			functionProject: functionColors[1],
			functionSystem: functionColors[0],
			functionParameter: constantColors[2],
			preprocessorStatement: functionColors[2],
			preprocessorProject: functionColors[3],
			preprocessorSystem: functionColors[2],
			constantProject: constantColors[1],
			constantSystem: constantColors[0],
			variableProject: variableColors[1],
			variableSystem: variableColors[0],
			globalTypeProject: variableColors[1],
			globalTypeSystem: variableColors[0],
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

	public static func colorSequence(from theme: IntermediateTheme) -> [Color] {
		let colors = originColors(from: theme)
		return colorSequence(from: colors)
	}

	private static func originColors(from theme: IntermediateTheme) -> OriginColors {
		return OriginColors(
			background: theme.background,
			foreground: theme.foreground,
			keywords: theme.keyword,
			referenceTypes: theme.declarationType,
			valueTypes: theme.declarationAny,
			functions: theme.functionSystem,
			constants: theme.constantSystem,
			variables: theme.variableSystem,
			strings: theme.string,
			numbers: theme.number
		)
	}

	private static func colorSequence(from originColors: OriginColors) -> [Color] {
		let colorSequence = [
			originColors.background,
			originColors.foreground,
			originColors.keywords,
			originColors.referenceTypes,
			originColors.valueTypes,
			originColors.functions,
			originColors.constants,
			originColors.variables,
			originColors.strings,
			originColors.numbers
		]

		assert(colorSequence.count == 10)
		return colorSequence
	}
	
}
