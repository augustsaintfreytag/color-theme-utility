//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 05/11/2021.
//

import Foundation

protocol TokenizedStringPaddingProvider {}

extension TokenizedStringPaddingProvider {
	
	// MARK: Configuration
	
	private static var boxPadding: Int { 1 }
	private static var leadingPadding: Int { 4 }
	
	private static var boxPaddingToken: SyntaxToken { SyntaxToken.space }
	private static var paddingToken: SyntaxToken { SyntaxToken.space }
	
	// MARK: Formatting
	
	public static func paddedString(_ string: TokenizedString) -> TokenizedString {
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
