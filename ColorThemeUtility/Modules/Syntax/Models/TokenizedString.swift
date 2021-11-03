//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 29/10/2021.
//

import Foundation
import ColorThemeFramework

/// A command line compatible string with applied formatting and colors on a
/// snippet of predefined code, usable to demo a color theme with code.
public struct TokenizedString {
	
	private let tokens: [SyntaxToken]
	
	public init(tokens: [SyntaxToken]) {
		self.tokens = tokens
	}
	
	public var padded: TokenizedString {
		return Self.paddedString(self)
	}
	
}

// MARK: String Form

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

// MARK: Padding

extension TokenizedString {
	
	private static var boxPadding: Int { 1 }
	private static var leadingPadding: Int { 4 }
	
	private static var boxPaddingToken: SyntaxToken { SyntaxToken.space }
	private static var paddingToken: SyntaxToken { SyntaxToken.space }
	
	private static func paddedString(_ string: TokenizedString) -> TokenizedString {
		var tokensByLine = string.tokens.split { token in token == SyntaxToken.newLine }.map { line in Array(line) }
		
		tokensByLine.insert([boxPaddingToken], at: 0)
		tokensByLine.append([boxPaddingToken])
		
		let maxLineLength = tokensByLine.map { line -> Int in
			return length(of: line)
		}.sorted().last ?? 0
		
		for lineIndex in tokensByLine.indices {
			let lineLength = length(of: tokensByLine[lineIndex])
			let trailingLinePadding = maxLineLength + leadingPadding - lineLength
			
			wrap(&tokensByLine[lineIndex], with: paddingToken, count: (leadingPadding, trailingLinePadding))
		}
		
		let tokens: [SyntaxToken] = Array(tokensByLine.joined(separator: [SyntaxToken.newLine]))
		return TokenizedString(tokens: tokens)
	}
	
	private static func wrap(_ collection: inout [SyntaxToken], with token: SyntaxToken, count: Int) {
		wrap(&collection, with: token, count: (leading: count, trailing: count))
	}
	
	private static func wrap(_ collection: inout [SyntaxToken], with token: SyntaxToken, count: (leading: Int, trailing: Int)) {
		let leadingTokens = Array(repeating: token, count: count.leading)
		let trailingTokens = Array(repeating: token, count: count.trailing)
		
		collection.insert(contentsOf: leadingTokens, at: 0)
		collection.append(contentsOf: trailingTokens)
	}
	
	private static func length(of line: [SyntaxToken]) -> Int {
		return line.reduce(into: 0) { length, token in
			length += token.word.count
		}
	}
	
}

// MARK: Presets

extension TokenizedString {
	
	public enum TokenizedPresets {
		
		public static var structDefinition: TokenizedString {
			return TokenizedString(tokens: [
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
