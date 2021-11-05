//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 29/10/2021.
//

import Foundation
import ColorThemeFramework

/// A command line compatible string with applied formatting and colors on a
/// snippet of predefined code, usable to demo a color theme with code.
public struct TokenizedString: TokenizedStringPaddingProvider {
	
	public let tokens: [SyntaxToken]
	
	public init(tokens: [SyntaxToken]) {
		self.tokens = tokens
	}
	
	public var padded: TokenizedString {
		return Self.paddedString(self)
	}
	
}

// MARK: Themed Output

extension TokenizedString {
	
	public var plainString: String {
		return tokens.map { token -> String in
			return token.word
		}.joined()
	}
	
	public func themedString(with theme: IntermediateTheme) -> String {
		let substrings = tokens.map { token -> String in
			let color: Color = theme[keyPath: token.kind]
			
			guard token.word != SyntaxToken.newLine.word else {
				return token.word
			}
			
			return token.word
				.coloredBackground(with: theme.background)
				.colored(with: color)
		}
		
		return substrings.joined()
	}
	
}

// MARK: Presets

extension TokenizedString {
	
	public enum Presets {
		
		public static var structDefinition: TokenizedString {
			TokenizedString(tokens: [
				.word("struct", as: \.keyword), .space,.word("ObjectMetadata", as: \.declarationType), .word(":"), .space, .word("Hashable", as: \.referenceTypeSystem), .word(","), .space, .word("ObjectProperty", as: \.referenceTypeProject), .space, .word("{"), .space, .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("id", as: \.declarationAny), .word(":"), .space, .word("UUID", as: \.referenceTypeSystem), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("created", as: \.declarationAny), .word(":"), .space, .word("Date", as: \.referenceTypeSystem), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("owners", as: \.declarationAny), .word(":"), .space, .word("Set", as: \.referenceTypeSystem), .word("<"), .word("Owner", as: \.valueTypeProject), .word("."), .word("Identifier", as: \.valueTypeProject), .word(">"), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("data", as: \.declarationAny), .word(":"), .space, .word("String", as: \.typeSystem), .newLine,
				.word("}")
			])
		}
		
		public static var protocolWithFunctionDefinition: TokenizedString {
			TokenizedString(tokens: [
				.word("protocol", as: \.keyword), .space, .word("ObjectProvider", as: \.declarationType), .space, .word("{"), .newLine,
				.indent, .word("func", as: \.keyword), .space, .word("groupedObjects", as: \.declarationAny),
				.word("("), .word("_", as: \.declarationAny), .space, .word("collection", as: \.functionParameter), .word(":"), .space, .word("["), .word("Object", as: \.valueTypeProject), .word("]"), .word(")"),
				.space, .word("->"), .space, .word("["), .word("ObjectGroup", as: \.valueTypeProject), .word(":"), .space, .word("Set", as: \.valueTypeSystem), .word("<"), .word("Object", as: \.valueTypeProject), .word(">"), .word("]"), .newLine,
				.word("}")
			])
		}
		
	}
	
}
