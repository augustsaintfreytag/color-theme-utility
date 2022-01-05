//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 20/10/2021.
//

import Foundation

/// Functionality to create populated `XcodeTheme` structures from a
/// prepared intermediate theme model or a collection of colors.
public protocol XcodeThemeModeler {}

extension XcodeThemeModeler {
	
	// MARK: Theme Defaults
	
	private static var version: Int { 1 }
	private static var lineSpacing: Float { 1.1 }
	
	// MARK: Font Defaults
	
	private static var codeFontDefault: String { "InputMonoNarrow-Light - 12.0" }
	private static var codeFontEmphasis: String { "InputMonoNarrow-Medium - 12.0" }
	private static var codeDocFontDefault: String { "InputSansCondensed-Light - 12.0" }
	
	private static var markupFontDefault: String { ".SFNS-Regular - 11.0" }				// Also used for "link font"
	private static var markupFontEmphasis: String { ".SFNS-RegularItalic - 11.0" }
	private static var markupFontStrong: String { ".SFNS-Bold - 11.0" }
	private static var markupFontHeadingPrimary: String { ".SFNS-Regular - 26.4" }
	private static var markupFontHeadingSecondary: String { ".SFNS-Regular - 19.8" }
	private static var markupFontHeadingOther: String { ".SFNS-Regular - 15.4" }

	private static var consoleFontDefault: String { "InputMonoNarrow-Light - 11.0" }
	private static var consoleFontEmphasis: String { "InputMonoNarrow-Medium - 11.0" }
	
	// MARK: Color Defaults

	private static var analysisColor: Color { Color(red: 0.403922, green: 0.372549, blue: 1.0) }
	private static var breakpointColor: Color { Color(red: 0.290196, green: 0.290196, blue: 0.968627) }
	private static var errorColor: Color { Color(red: 0.968627, green: 0.290196, blue: 0.290196) }
	private static var runtimeIssueColor: Color { Color(red: 0.643137, green: 0.509804, blue: 1.0) }
	private static var warningColor: Color { Color(red: 0.937255, green: 0.717647, blue: 0.34902) }
	private static var diffColor: Color { Color(red: 0.556863, green: 0.556863, blue: 0.556863) }
	
	private static var markupColor: Color { Color(red: 0.501961, green: 0.501961, blue: 0.501961) }
	private static var markupBackgroundColor: Color { Color(red: 0.0980392, green: 0.0980392, blue: 0.0980392) }
	private static var markupBorderColor: Color { Color(red: 0.372549, green: 0.352941, blue: 0.376471) }

	private static var noSpecificColor: Color { Color(red: 0.8, green: 0, blue: 0.8) }
	
	// MARK: Intermediate → Xcode
	
	public static func xcodeTheme(from theme: IntermediateTheme) throws -> XcodeTheme {
		return XcodeTheme(
			dvtConsoleDebuggerInputTextColor: value(theme.foreground),
			dvtConsoleDebuggerInputTextFont: consoleFontDefault,
			dvtConsoleDebuggerOutputTextColor: value(theme.foreground),
			dvtConsoleDebuggerOutputTextFont: consoleFontEmphasis,
			dvtConsoleDebuggerPromptTextColor: value(theme.keyword),
			dvtConsoleDebuggerPromptTextFont: consoleFontEmphasis,
			dvtConsoleExecutableInputTextColor: value(theme.foreground),
			dvtConsoleExecutableInputTextFont: consoleFontDefault,
			dvtConsoleExecutableOutputTextColor: value(theme.foreground),
			dvtConsoleExecutableOutputTextFont: consoleFontEmphasis,
			dvtConsoleTextBackgroundColor: value(theme.background),
			dvtConsoleTextInsertionPointColor: value(theme.insertionPoint),
			dvtConsoleTextSelectionColor: value(theme.selectionBackground),
			dvtDebuggerInstructionPointerColor: value(breakpointColor),
			dvtFontAndColorVersion: version,
			dvtLineSpacing: lineSpacing,
			dvtMarkupTextBackgroundColor: value(theme.background),
			dvtMarkupTextBorderColor: value(markupBorderColor),
			dvtMarkupTextCodeFont: markupFontDefault,
			dvtMarkupTextEmphasisColor: value(markupColor),
			dvtMarkupTextEmphasisFont: markupFontEmphasis,
			dvtMarkupTextInlineCodeColor: value(markupColor),
			dvtMarkupTextLinkColor: value(markupColor),
			dvtMarkupTextLinkFont: markupFontDefault,
			dvtMarkupTextNormalColor: value(markupColor),
			dvtMarkupTextNormalFont: markupFontDefault,
			dvtMarkupTextOtherHeadingColor: value(markupColor),
			dvtMarkupTextOtherHeadingFont: markupFontHeadingOther,
			dvtMarkupTextPrimaryHeadingColor: value(markupColor),
			dvtMarkupTextPrimaryHeadingFont: markupFontHeadingPrimary,
			dvtMarkupTextSecondaryHeadingColor: value(markupColor),
			dvtMarkupTextSecondaryHeadingFont: markupFontHeadingSecondary,
			dvtMarkupTextStrongColor: value(markupColor),
			dvtMarkupTextStrongFont: markupFontEmphasis,
			dvtScrollbarMarkerAnalyzerColor: value(analysisColor),
			dvtScrollbarMarkerBreakpointColor: value(breakpointColor),
			dvtScrollbarMarkerDiffColor: value(diffColor),
			dvtScrollbarMarkerDiffConflictColor: value(errorColor),
			dvtScrollbarMarkerErrorColor: value(errorColor),
			dvtScrollbarMarkerRuntimeIssueColor: value(runtimeIssueColor),
			dvtScrollbarMarkerWarningColor: value(warningColor),
			dvtSourceTextBackground: value(theme.background),
			dvtSourceTextBlockDimBackgroundColor: value(theme.background),
			dvtSourceTextCurrentLineHighlightColor: value(theme.activeLineBackground),
			dvtSourceTextInsertionPointColor: value(theme.insertionPoint),
			dvtSourceTextInvisiblesColor: value(theme.comment),
			dvtSourceTextSelectionColor: value(theme.selectionBackground),
			dvtSourceTextSyntaxColors: syntaxColors(from: theme),
			dvtSourceTextSyntaxFonts: syntaxFonts(from: theme)
		)
	}
	
	private static func syntaxColors(from theme: IntermediateTheme) -> XcodeTheme.SourceTextSyntaxColors {
		return XcodeTheme.SourceTextSyntaxColors(
			xcodeSyntaxAttribute: value(theme.attribute),
			xcodeSyntaxCharacter: value(theme.character),
			xcodeSyntaxComment: value(theme.comment),
			xcodeSyntaxCommentDoc: value(theme.commentDocumentation),
			xcodeSyntaxCommentDocKeyword: value(theme.commentSectionHeader),
			xcodeSyntaxDeclarationOther: value(theme.declarationAny),
			xcodeSyntaxDeclarationType: value(theme.declarationType),
			xcodeSyntaxIdentifierClass: value(theme.referenceTypeProject),
			xcodeSyntaxIdentifierClassSystem: value(theme.referenceTypeSystem),
			xcodeSyntaxIdentifierConstant: value(theme.constantProject),
			xcodeSyntaxIdentifierConstantSystem: value(theme.constantSystem),
			xcodeSyntaxIdentifierFunction: value(theme.functionProject),
			xcodeSyntaxIdentifierFunctionSystem: value(theme.functionSystem),
			xcodeSyntaxIdentifierMacro: value(theme.preprocessorProject),
			xcodeSyntaxIdentifierMacroSystem: value(theme.preprocessorSystem),
			xcodeSyntaxIdentifierType: value(theme.valueTypeProject),
			xcodeSyntaxIdentifierTypeSystem: value(theme.valueTypeSystem),
			xcodeSyntaxIdentifierVariable: value(theme.variableProject),
			xcodeSyntaxIdentifierVariableSystem: value(theme.variableSystem),
			xcodeSyntaxKeyword: value(theme.keyword),
			xcodeSyntaxMark: value(theme.commentSection),
			xcodeSyntaxMarkupCode: value(theme.comment),
			xcodeSyntaxNumber: value(theme.number),
			xcodeSyntaxPlain: value(theme.foreground),
			xcodeSyntaxPreprocessor: value(theme.preprocessorStatement),
			xcodeSyntaxString: value(theme.string),
			xcodeSyntaxUrl: value(theme.url)
		)
	}
	
	private static func syntaxFonts(from theme: IntermediateTheme) -> XcodeTheme.SourceTextSyntaxFonts {
		return XcodeTheme.SourceTextSyntaxColors(
			xcodeSyntaxAttribute: codeFontDefault,
			xcodeSyntaxCharacter: codeFontDefault,
			xcodeSyntaxComment: codeFontDefault,
			xcodeSyntaxCommentDoc: codeDocFontDefault,
			xcodeSyntaxCommentDocKeyword: codeFontEmphasis,
			xcodeSyntaxDeclarationOther: codeFontDefault,
			xcodeSyntaxDeclarationType: codeFontDefault,
			xcodeSyntaxIdentifierClass: codeFontDefault,
			xcodeSyntaxIdentifierClassSystem: codeFontDefault,
			xcodeSyntaxIdentifierConstant: codeFontDefault,
			xcodeSyntaxIdentifierConstantSystem: codeFontDefault,
			xcodeSyntaxIdentifierFunction: codeFontDefault,
			xcodeSyntaxIdentifierFunctionSystem: codeFontDefault,
			xcodeSyntaxIdentifierMacro: codeFontDefault,
			xcodeSyntaxIdentifierMacroSystem: codeFontDefault,
			xcodeSyntaxIdentifierType: codeFontDefault,
			xcodeSyntaxIdentifierTypeSystem: codeFontDefault,
			xcodeSyntaxIdentifierVariable: codeFontDefault,
			xcodeSyntaxIdentifierVariableSystem: codeFontDefault,
			xcodeSyntaxKeyword: codeFontEmphasis,
			xcodeSyntaxMark: codeFontEmphasis,
			xcodeSyntaxMarkupCode: codeFontDefault,
			xcodeSyntaxNumber: codeFontDefault,
			xcodeSyntaxPlain: codeFontDefault,
			xcodeSyntaxPreprocessor: codeFontDefault,
			xcodeSyntaxString: codeFontDefault,
			xcodeSyntaxUrl: codeFontDefault
		)
	}
	
	// MARK: Xcode → Intermediate

	/// Creates a lossy intermediate theme representation from a given Xcode theme.
	///
	/// Note that this conversion is lossy, not all colors defined in `IntermediateTheme`
	/// are used or transferred to a created `XcodeTheme`.
	///
	/// - Note: This mapping sets `module` and `parameter` to `plain` as fallback.
	///
	public static func intermediateTheme(from theme: XcodeTheme) throws -> IntermediateTheme {
		let themeSyntax = theme.dvtSourceTextSyntaxColors
		
		return IntermediateTheme(
			format: IntermediateTheme.defaultFormat,
			version: IntermediateTheme.defaultVersion,
			foreground: try color(themeSyntax.xcodeSyntaxPlain),
			background: try color(theme.dvtSourceTextBackground),
			selectionBackground: try color(theme.dvtSourceTextSelectionColor),
			activeLineBackground: try color(theme.dvtSourceTextCurrentLineHighlightColor),
			insertionPoint: try color(theme.dvtSourceTextInsertionPointColor),
			comment: try color(themeSyntax.xcodeSyntaxComment),
			commentDocumentation: try color(themeSyntax.xcodeSyntaxCommentDoc),
			commentSection: try color(themeSyntax.xcodeSyntaxMark),
			commentSectionHeader: try color(themeSyntax.xcodeSyntaxCommentDocKeyword),
			keyword: try color(themeSyntax.xcodeSyntaxKeyword),
			declarationAny: try color(themeSyntax.xcodeSyntaxDeclarationOther),
			declarationType: try color(themeSyntax.xcodeSyntaxDeclarationType),
			functionProject: try color(themeSyntax.xcodeSyntaxIdentifierFunction),
			functionSystem: try color(themeSyntax.xcodeSyntaxIdentifierFunctionSystem),
			functionParameter: try color(themeSyntax.xcodeSyntaxPlain),
			preprocessorStatement: try color(themeSyntax.xcodeSyntaxPreprocessor),
			preprocessorProject: try color(themeSyntax.xcodeSyntaxIdentifierMacro),
			preprocessorSystem: try color(themeSyntax.xcodeSyntaxIdentifierMacroSystem),
			constantProject: try color(themeSyntax.xcodeSyntaxIdentifierConstant),
			constantSystem: try color(themeSyntax.xcodeSyntaxIdentifierConstantSystem),
			variableProject: try color(themeSyntax.xcodeSyntaxIdentifierVariable),
			variableSystem: try color(themeSyntax.xcodeSyntaxIdentifierVariableSystem),
			globalTypeProject: try color(themeSyntax.xcodeSyntaxIdentifierVariable),
			globalTypeSystem: try color(themeSyntax.xcodeSyntaxIdentifierVariableSystem),
			referenceTypeProject: try color(themeSyntax.xcodeSyntaxIdentifierClass),
			referenceTypeSystem: try color(themeSyntax.xcodeSyntaxIdentifierClassSystem),
			valueTypeProject: try color(themeSyntax.xcodeSyntaxIdentifierType),
			valueTypeSystem: try color(themeSyntax.xcodeSyntaxIdentifierTypeSystem),
			attribute: try color(themeSyntax.xcodeSyntaxAttribute),
			module: try color(themeSyntax.xcodeSyntaxPlain),
			number: try color(themeSyntax.xcodeSyntaxNumber),
			string: try color(themeSyntax.xcodeSyntaxString),
			character: try color(themeSyntax.xcodeSyntaxCharacter),
			url: try color(themeSyntax.xcodeSyntaxUrl)
		)
	}

	// MARK: Color Utility

	private static func value(_ color: Color) -> String {
		return color.floatRGBAString
	}
	
	private static func color(_ value: String) throws -> Color {
		guard let color = Color(fromFloatRGBAString: value) else {
			throw ThemeCodingError(description: "Can not decode color from expected FloatRGBA value '\(value)'.")
		}
		
		return color
	}
	
}
