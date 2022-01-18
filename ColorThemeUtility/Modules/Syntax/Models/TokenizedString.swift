//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 29/10/2021.
//

import Foundation
import ColorThemeModelingFramework

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

	public static func +(_ lhs: TokenizedString, _ rhs: TokenizedString) -> TokenizedString {
		return TokenizedString(tokens: lhs.tokens + rhs.tokens)
	}
	
	public static var divider: TokenizedString {
		TokenizedString(tokens: [.space, .newLine, .space, .newLine])
	}
	
}

extension Array where Element == TokenizedString {

	public func joined(separator: TokenizedString) -> TokenizedString {
		var compositeElement = TokenizedString(lines: [])

		for (index, element) in enumerated() {
			guard index != indices.last else {
				compositeElement = compositeElement + element
				continue
			}

			compositeElement = compositeElement + element + separator
		}

		return compositeElement
	}

	public func joinedWithDivider() -> TokenizedString {
		return joined(separator: TokenizedString.divider)
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
