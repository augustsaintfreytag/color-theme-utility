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
	
	public init(lines: [[SyntaxToken]]) {
		self.tokens = Self.joinedLines(lines)
	}
	
}

// MARK: Union

extension TokenizedString {

	static func +(_ lhs: TokenizedString, _ rhs: TokenizedString) -> TokenizedString {
		return TokenizedString(tokens: lhs.tokens + rhs.tokens)
	}
	
	static var divider: TokenizedString {
		TokenizedString(tokens: [.space, .newLine, .space, .newLine])
	}
	
}

// MARK: Line Split & Join

extension TokenizedString {
	
	var splitLines: [[SyntaxToken]] {
		tokens.split { token in token == SyntaxToken.newLine }.map { line in Array(line) }
	}
	
	static func joinedLines(_ lines: [[SyntaxToken]]) -> [SyntaxToken] {
		return Array(lines.joined(separator: [SyntaxToken.newLine]))
	}
	
}

// MARK: Padding

extension TokenizedString {
	
	public var withPadding: TokenizedString {
		return Self.paddedString(self)
	}
	
}

// MARK: Line Numbers

extension TokenizedString {
	
	public var withLineNumbers: TokenizedString {
		var tokensByLine = tokens.split { token in token == SyntaxToken.newLine }.map { line in Array(line) }
		let numberOfLineNumberCharacters = String(tokensByLine.count).count
		
		for index in tokensByLine.indices {
			let lineNumberString = String(format: "%\(numberOfLineNumberCharacters)d", index + 1)
			let lineNumberToken = SyntaxToken(kind: \.commentDocumentation, word: lineNumberString)
			
			tokensByLine[index].insert(contentsOf: [lineNumberToken, .indent], at: 0)
		}
		
		return TokenizedString(lines: tokensByLine)
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
				.word("typealias", as: \.keyword), .space, .word("GroupedObjects", as: \.declarationType), .space, .word("="), .space, .word("["), .word("ObjectGroup", as: \.valueTypeProject), .word(":"), .space, .word("Set", as: \.valueTypeSystem), .word("<"), .word("Object", as: \.valueTypeProject), .word(">"), .word("]"), .newLine,
				.space, .newLine,
				.word("protocol", as: \.keyword), .space, .word("ObjectProvider", as: \.declarationType), .space, .word("{"), .newLine,
				.indent, .word("func", as: \.keyword), .space, .word("groupedObjects", as: \.declarationAny),
				.word("("), .word("_", as: \.declarationAny), .space, .word("collection", as: \.functionParameter), .word(":"), .space, .word("["), .word("Object", as: \.valueTypeProject), .word("]"), .word(")"),
				.space, .word("->"), .space, .word("GroupedObjects", as: \.valueTypeProject), .newLine,
				.word("}")
			])
		}
		
		// Check "other type names" vs. "global variable…" color mapping to Xcode.
		
		public static var literalDeclarations: TokenizedString {
			TokenizedString(tokens: [
				.word("struct", as: \.keyword), .space, .word("ObjectReport", as: \.declarationType), .space, .word("{"), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("id", as: \.declarationAny), .space, .word("="), .space, .word("UUID", as: \.typeSystem), .word("()"), .newLine,
				.indent, .word("var", as: \.keyword), .space, .word("name", as: \.declarationAny), .word(":"), .space, .word("String", as: \.valueTypeSystem), .space, .word("="), .space, .word("\"Most Recent\"", as: \.string), .newLine,
				.indent, .word("var", as: \.keyword), .space, .word("kind", as: \.declarationAny), .word(":"), .space, .word("ReportKind", as: \.valueTypeProject), .space, .word("="), .space, .word(".lastInterval", as: \.constantProject), .newLine,
				.indent, .word("var", as: \.keyword), .space, .word("numberOfEntries", as: \.declarationAny), .word(":"), .space, .word("Int", as: \.typeSystem), .space, .word("="), .space, .word("400", as: \.string), .newLine,
				.word("}")
			])
		}
		
	}
	
}
