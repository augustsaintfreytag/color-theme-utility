//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 27/09/2021.
//

import Foundation

public struct XcodeTheme: Theme {
	
	public typealias SourceTextSyntaxColors = XcodeThemeSourceTextSyntax
	public typealias SourceTextSyntaxFonts = XcodeThemeSourceTextSyntax
	
	public let dvtConsoleDebuggerInputTextColor: String
	public let dvtConsoleDebuggerInputTextFont: String
	public let dvtConsoleDebuggerOutputTextColor: String
	public let dvtConsoleDebuggerOutputTextFont: String
	public let dvtConsoleDebuggerPromptTextColor: String
	public let dvtConsoleDebuggerPromptTextFont: String
	public let dvtConsoleExectuableInputTextColor: String
	public let dvtConsoleExectuableInputTextFont: String
	public let dvtConsoleExectuableOutputTextColor: String
	public let dvtConsoleExectuableOutputTextFont: String
	public let dvtConsoleTextBackgroundColor: String
	public let dvtConsoleTextInsertionPointColor: String
	public let dvtConsoleTextSelectionColor: String
	public let dvtDebuggerInstructionPointerColor: String
	public let dvtFontAndColorVersion: Int
	public let dvtLineSpacing: Float
	public let dvtMarkupTextBackgroundColor: String
	public let dvtMarkupTextBorderColor: String
	public let dvtMarkupTextCodeFont: String
	public let dvtMarkupTextEmphasisColor: String
	public let dvtMarkupTextEmphasisFont: String
	public let dvtMarkupTextInlineCodeColor: String
	public let dvtMarkupTextLinkColor: String
	public let dvtMarkupTextLinkFont: String
	public let dvtMarkupTextNormalColor: String
	public let dvtMarkupTextNormalFont: String
	public let dvtMarkupTextOtherHeadingColor: String
	public let dvtMarkupTextOtherHeadingFont: String
	public let dvtMarkupTextPrimaryHeadingColor: String
	public let dvtMarkupTextPrimaryHeadingFont: String
	public let dvtMarkupTextSecondaryHeadingColor: String
	public let dvtMarkupTextSecondaryHeadingFont: String
	public let dvtMarkupTextStrongColor: String
	public let dvtMarkupTextStrongFont: String
	public let dvtScrollbarMarkerAnalyzerColor: String
	public let dvtScrollbarMarkerBreakpointColor: String
	public let dvtScrollbarMarkerDiffColor: String
	public let dvtScrollbarMarkerDiffConflictColor: String
	public let dvtScrollbarMarkerErrorColor: String
	public let dvtScrollbarMarkerRuntimeIssueColor: String
	public let dvtScrollbarMarkerWarningColor: String
	public let dvtSourceTextBackground: String
	public let dvtSourceTextBlockDimBackgroundColor: String
	public let dvtSourceTextCurrentLineHighlightColor: String
	public let dvtSourceTextInsertionPointColor: String
	public let dvtSourceTextInvisiblesColor: String
	public let dvtSourceTextSelectionColor: String
	
	public let dvtSourceTextSyntaxColors: SourceTextSyntaxColors
	public let dvtSourceTextSyntaxFonts: SourceTextSyntaxFonts
	
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

public struct XcodeThemeSourceTextSyntax: CustomStringPropertyEnumerable {
	
	public let xcodeSyntaxAttribute: String
	public let xcodeSyntaxCharacter: String
	public let xcodeSyntaxComment: String
	public let xcodeSyntaxCommentDoc: String
	public let xcodeSyntaxCommentDocKeyword: String
	public let xcodeSyntaxDeclarationOther: String
	public let xcodeSyntaxDeclarationType: String
	public let xcodeSyntaxIdentifierClass: String
	public let xcodeSyntaxIdentifierClassSystem: String
	public let xcodeSyntaxIdentifierConstant: String
	public let xcodeSyntaxIdentifierConstantSystem: String
	public let xcodeSyntaxIdentifierFunction: String
	public let xcodeSyntaxIdentifierFunctionSystem: String
	public let xcodeSyntaxIdentifierMacro: String
	public let xcodeSyntaxIdentifierMacroSystem: String
	public let xcodeSyntaxIdentifierType: String
	public let xcodeSyntaxIdentifierTypeSystem: String
	public let xcodeSyntaxIdentifierVariable: String
	public let xcodeSyntaxIdentifierVariableSystem: String
	public let xcodeSyntaxKeyword: String
	public let xcodeSyntaxMark: String
	public let xcodeSyntaxMarkupCode: String
	public let xcodeSyntaxNumber: String
	public let xcodeSyntaxPlain: String
	public let xcodeSyntaxPreprocessor: String
	public let xcodeSyntaxString: String
	public let xcodeSyntaxUrl: String
	
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
