//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 29/10/2021.
//

import Foundation
import Rainbow

public struct SyntaxToken {
	
	typealias Kind = PartialKeyPath<IntermediateTheme>
	
	let kind: Kind
	let word: String
	
	// MARK: Tokenized Word
	
	static func word(_ word: String, as kind: Kind = \.foreground) -> SyntaxToken {
		return SyntaxToken(kind: kind, word: word)
	}
	
	// MARK: Tokenized White Space
	
	static var space: SyntaxToken {
		return SyntaxToken(kind: \.foreground, word: " ")
	}
	
	static var indent: SyntaxToken {
		return SyntaxToken(kind: \.foreground, word: "    ")
	}
	
	static var newLine: SyntaxToken {
		return SyntaxToken(kind: \.foreground, word: "\n")
	}
	
}

/// A command line compatible string with applied formatting and colors on a
/// snippet of predefined code, usable to demo a color theme with code.
public struct SyntaxHighlightedString {
	
	private let tokens: [SyntaxToken]
	
	public init(tokens: [SyntaxToken]) {
		self.tokens = tokens
	}
	
	public var plainString: String {
		return tokens.map { token -> String in
			return token.word
		}.joined()
	}
	
	public func printByLines() {
		let lines = tokens.map { token -> String in
			return token.word
		}.joined().split(separator: "\n")
		
		for line in lines {
			print(line)
		}
	}
	
}

extension SyntaxHighlightedString {
	
	public enum TokenizedTemplateCode {
		public static var structDefinition: SyntaxHighlightedString {
			return SyntaxHighlightedString(tokens: [
				.word("struct", as: \.keyword), .space,.word("ObjectMetadata", as: \.declarationType), .word(":"), .space, .word("Hashable", as: \.referenceTypeSystem), .word(","), .space, .word("ObjectProperty", as: \.referenceTypeProject), .space, .word("{"), .space, .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("id", as: \.declarationAny), .word(":"), .space, .word("UUID", as: \.referenceTypeSystem), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("created", as: \.declarationAny), .word(":"), .space, .word("Date", as: \.referenceTypeSystem), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("owners", as: \.declarationAny), .word(":"), .space, .word("Set", as: \.referenceTypeSystem), .word("<"), .word("Owner", as: \.valueTypeProject), .word("."), .word("Identifier", as: \.valueTypeProject), .word(">"), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("data", as: \.declarationAny), .word(":"), .space, .word("String", as: \.typeSystem), .newLine,
				.word("}")
			])
		}
	}
	
}
