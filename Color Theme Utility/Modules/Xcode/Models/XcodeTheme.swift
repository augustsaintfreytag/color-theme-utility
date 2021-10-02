//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 27/09/2021.
//

import Foundation

struct XcodeTheme: Theme {
	
	typealias SourceTextSyntaxColors = XcodeThemeSourceTextSyntax
	typealias SourceTextSyntaxFonts = XcodeThemeSourceTextSyntax
	
	let dvtConsoleDebuggerInputTextColor: String
	let dvtConsoleDebuggerInputTextFont: String
	let dvtConsoleDebuggerOutputTextColor: String
	let dvtConsoleDebuggerOutputTextFont: String
	let dvtConsoleDebuggerPromptTextColor: String
	let dvtConsoleDebuggerPromptTextFont: String
	let dvtConsoleExectuableInputTextColor: String
	let dvtConsoleExectuableInputTextFont: String
	let dvtConsoleExectuableOutputTextColor: String
	let dvtConsoleExectuableOutputTextFont: String
	let dvtConsoleTextBackgroundColor: String
	let dvtConsoleTextInsertionPointColor: String
	let dvtConsoleTextSelectionColor: String
	let dvtDebuggerInstructionPointerColor: String
	let dvtFontAndColorVersion: Int
	let dvtLineSpacing: Float
	let dvtMarkupTextBackgroundColor: String
	let dvtMarkupTextBorderColor: String
	let dvtMarkupTextCodeFont: String
	let dvtMarkupTextEmphasisColor: String
	let dvtMarkupTextEmphasisFont: String
	let dvtMarkupTextInlineCodeColor: String
	let dvtMarkupTextLinkColor: String
	let dvtMarkupTextLinkFont: String
	let dvtMarkupTextNormalColor: String
	let dvtMarkupTextNormalFont: String
	let dvtMarkupTextOtherHeadingColor: String
	let dvtMarkupTextOtherHeadingFont: String
	let dvtMarkupTextPrimaryHeadingColor: String
	let dvtMarkupTextPrimaryHeadingFont: String
	let dvtMarkupTextSecondaryHeadingColor: String
	let dvtMarkupTextSecondaryHeadingFont: String
	let dvtMarkupTextStrongColor: String
	let dvtMarkupTextStrongFont: String
	let dvtScrollbarMarkerAnalyzerColor: String
	let dvtScrollbarMarkerBreakpointColor: String
	let dvtScrollbarMarkerDiffColor: String
	let dvtScrollbarMarkerDiffConflictColor: String
	let dvtScrollbarMarkerErrorColor: String
	let dvtScrollbarMarkerRuntimeIssueColor: String
	let dvtScrollbarMarkerWarningColor: String
	let dvtSourceTextBackground: String
	let dvtSourceTextBlockDimBackgroundColor: String
	let dvtSourceTextCurrentLineHighlightColor: String
	let dvtSourceTextInsertionPointColor: String
	let dvtSourceTextInvisiblesColor: String
	let dvtSourceTextSelectionColor: String
	
	let dvtSourceTextSyntaxColors: SourceTextSyntaxColors
	let dvtSourceTextSyntaxFonts: SourceTextSyntaxFonts
	
}

extension XcodeTheme: Codable {
	
	enum CodingKeys: String, CodingKey {
		case dvtConsoleDebuggerInputTextColor = "DVTConsoleDebuggerInputTextColor"
		case dvtConsoleDebuggerInputTextFont = "DVTConsoleDebuggerInputTextFont"
		case dvtConsoleDebuggerOutputTextColor = "DVTConsoleDebuggerOutputTextColor"
		case dvtConsoleDebuggerOutputTextFont = "DVTConsoleDebuggerOutputTextFont"
		case dvtConsoleDebuggerPromptTextColor = "DVTConsoleDebuggerPromptTextColor"
		case dvtConsoleDebuggerPromptTextFont = "DVTConsoleDebuggerPromptTextFont"
		case dvtConsoleExectuableInputTextColor = "DVTConsoleExectuableInputTextColor"
		case dvtConsoleExectuableInputTextFont = "DVTConsoleExectuableInputTextFont"
		case dvtConsoleExectuableOutputTextColor = "DVTConsoleExectuableOutputTextColor"
		case dvtConsoleExectuableOutputTextFont = "DVTConsoleExectuableOutputTextFont"
		case dvtConsoleTextBackgroundColor = "DVTConsoleTextBackgroundColor"
		case dvtConsoleTextInsertionPointColor = "DVTConsoleTextInsertionPointColor"
		case dvtConsoleTextSelectionColor = "DVTConsoleTextSelectionColor"
		case dvtDebuggerInstructionPointerColor = "DVTDebuggerInstructionPointerColor"
		case dvtFontAndColorVersion = "DVTFontAndColorVersion"
		case dvtLineSpacing = "DVTLineSpacing"
		case dvtMarkupTextBackgroundColor = "DVTMarkupTextBackgroundColor"
		case dvtMarkupTextBorderColor = "DVTMarkupTextBorderColor"
		case dvtMarkupTextCodeFont = "DVTMarkupTextCodeFont"
		case dvtMarkupTextEmphasisColor = "DVTMarkupTextEmphasisColor"
		case dvtMarkupTextEmphasisFont = "DVTMarkupTextEmphasisFont"
		case dvtMarkupTextInlineCodeColor = "DVTMarkupTextInlineCodeColor"
		case dvtMarkupTextLinkColor = "DVTMarkupTextLinkColor"
		case dvtMarkupTextLinkFont = "DVTMarkupTextLinkFont"
		case dvtMarkupTextNormalColor = "DVTMarkupTextNormalColor"
		case dvtMarkupTextNormalFont = "DVTMarkupTextNormalFont"
		case dvtMarkupTextOtherHeadingColor = "DVTMarkupTextOtherHeadingColor"
		case dvtMarkupTextOtherHeadingFont = "DVTMarkupTextOtherHeadingFont"
		case dvtMarkupTextPrimaryHeadingColor = "DVTMarkupTextPrimaryHeadingColor"
		case dvtMarkupTextPrimaryHeadingFont = "DVTMarkupTextPrimaryHeadingFont"
		case dvtMarkupTextSecondaryHeadingColor = "DVTMarkupTextSecondaryHeadingColor"
		case dvtMarkupTextSecondaryHeadingFont = "DVTMarkupTextSecondaryHeadingFont"
		case dvtMarkupTextStrongColor = "DVTMarkupTextStrongColor"
		case dvtMarkupTextStrongFont = "DVTMarkupTextStrongFont"
		case dvtScrollbarMarkerAnalyzerColor = "DVTScrollbarMarkerAnalyzerColor"
		case dvtScrollbarMarkerBreakpointColor = "DVTScrollbarMarkerBreakpointColor"
		case dvtScrollbarMarkerDiffColor = "DVTScrollbarMarkerDiffColor"
		case dvtScrollbarMarkerDiffConflictColor = "DVTScrollbarMarkerDiffConflictColor"
		case dvtScrollbarMarkerErrorColor = "DVTScrollbarMarkerErrorColor"
		case dvtScrollbarMarkerRuntimeIssueColor = "DVTScrollbarMarkerRuntimeIssueColor"
		case dvtScrollbarMarkerWarningColor = "DVTScrollbarMarkerWarningColor"
		case dvtSourceTextBackground = "DVTSourceTextBackground"
		case dvtSourceTextBlockDimBackgroundColor = "DVTSourceTextBlockDimBackgroundColor"
		case dvtSourceTextCurrentLineHighlightColor = "DVTSourceTextCurrentLineHighlightColor"
		case dvtSourceTextInsertionPointColor = "DVTSourceTextInsertionPointColor"
		case dvtSourceTextInvisiblesColor = "DVTSourceTextInvisiblesColor"
		case dvtSourceTextSelectionColor = "DVTSourceTextSelectionColor"
		case dvtSourceTextSyntaxColors = "DVTSourceTextSyntaxColors"
		case dvtSourceTextSyntaxFonts = "DVTSourceTextSyntaxFonts"
	}
	
}

// MARK: Text Syntax

struct XcodeThemeSourceTextSyntax {
	
	let xcodeSyntaxAttribute: String
	let xcodeSyntaxCharacter: String
	let xcodeSyntaxComment: String
	let xcodeSyntaxCommentDoc: String
	let xcodeSyntaxCommentDocKeyword: String
	let xcodeSyntaxDeclarationOther: String
	let xcodeSyntaxDeclarationType: String
	let xcodeSyntaxIdentifierClass: String
	let xcodeSyntaxIdentifierClassSystem: String
	let xcodeSyntaxIdentifierConstant: String
	let xcodeSyntaxIdentifierConstantSystem: String
	let xcodeSyntaxIdentifierFunction: String
	let xcodeSyntaxIdentifierFunctionSystem: String
	let xcodeSyntaxIdentifierMacro: String
	let xcodeSyntaxIdentifierMacroSystem: String
	let xcodeSyntaxIdentifierType: String
	let xcodeSyntaxIdentifierTypeSystem: String
	let xcodeSyntaxIdentifierVariable: String
	let xcodeSyntaxIdentifierVariableSystem: String
	let xcodeSyntaxKeyword: String
	let xcodeSyntaxMark: String
	let xcodeSyntaxMarkupCode: String
	let xcodeSyntaxNumber: String
	let xcodeSyntaxPlain: String
	let xcodeSyntaxPreprocessor: String
	let xcodeSyntaxString: String
	let xcodeSyntaxUrl: String
	
}

extension XcodeThemeSourceTextSyntax: Codable {
	
	enum CodingKeys: String, CodingKey {
		case xcodeSyntaxAttribute = "xcode.syntax.attribute"
		case xcodeSyntaxCharacter = "xcode.syntax.character"
		case xcodeSyntaxComment = "xcode.syntax.comment"
		case xcodeSyntaxCommentDoc = "xcode.syntax.comment.doc"
		case xcodeSyntaxCommentDocKeyword = "xcode.syntax.comment.doc.keyword"
		case xcodeSyntaxDeclarationOther = "xcode.syntax.declaration.other"
		case xcodeSyntaxDeclarationType = "xcode.syntax.declaration.type"
		case xcodeSyntaxIdentifierClass = "xcode.syntax.identifier.class"
		case xcodeSyntaxIdentifierClassSystem = "xcode.syntax.identifier.class.system"
		case xcodeSyntaxIdentifierConstant = "xcode.syntax.identifier.constant"
		case xcodeSyntaxIdentifierConstantSystem = "xcode.syntax.identifier.constant.system"
		case xcodeSyntaxIdentifierFunction = "xcode.syntax.identifier.function"
		case xcodeSyntaxIdentifierFunctionSystem = "xcode.syntax.identifier.function.system"
		case xcodeSyntaxIdentifierMacro = "xcode.syntax.identifier.macro"
		case xcodeSyntaxIdentifierMacroSystem = "xcode.syntax.identifier.macro.system"
		case xcodeSyntaxIdentifierType = "xcode.syntax.identifier.type"
		case xcodeSyntaxIdentifierTypeSystem = "xcode.syntax.identifier.type.system"
		case xcodeSyntaxIdentifierVariable = "xcode.syntax.identifier.variable"
		case xcodeSyntaxIdentifierVariableSystem = "xcode.syntax.identifier.variable.system"
		case xcodeSyntaxKeyword = "xcode.syntax.keyword"
		case xcodeSyntaxMark = "xcode.syntax.mark"
		case xcodeSyntaxMarkupCode = "xcode.syntax.markup.code"
		case xcodeSyntaxNumber = "xcode.syntax.number"
		case xcodeSyntaxPlain = "xcode.syntax.plain"
		case xcodeSyntaxPreprocessor = "xcode.syntax.preprocessor"
		case xcodeSyntaxString = "xcode.syntax.string"
		case xcodeSyntaxUrl = "xcode.syntax.url"
	}
	
}
