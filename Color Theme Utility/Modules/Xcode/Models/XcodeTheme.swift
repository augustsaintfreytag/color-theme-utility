//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 27/09/2021.
//

import Foundation

struct XcodeTheme {
	
	let dvtSourceTextSyntaxColors: SourceTextSyntaxColors
	
}

extension XcodeTheme: Codable {
	
	enum CodingKeys: String, CodingKey {
		case dvtSourceTextSyntaxColors = "DVTSourceTextSyntaxColors"
	}
	
}

extension XcodeTheme {
	
	struct SourceTextSyntaxColors: Codable {
		
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
		
		var allProperties: [String] {
			[
				xcodeSyntaxAttribute,
				xcodeSyntaxCharacter
			]
		}
		
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
	
}
