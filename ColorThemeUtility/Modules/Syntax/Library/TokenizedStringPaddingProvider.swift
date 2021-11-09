//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 05/11/2021.
//

import Foundation

protocol TokenizedStringPaddingProvider {}

extension TokenizedStringPaddingProvider {
	
	// MARK: Configuration
	
	private static var linePadding: Int { 1 }
	private static var leadingPadding: Int { 6 }
	private static var trailingPadding: Int { 6 }
	
	private static var boxPaddingToken: SyntaxToken { SyntaxToken.space }
	private static var paddingToken: SyntaxToken { SyntaxToken.space }
	
	// MARK: Formatting
	
	public static func paddedString(_ string: TokenizedString) -> TokenizedString {
		var tokensByLine = string.splitLines
		
		tokensByLine.insert([boxPaddingToken], at: 0)
		tokensByLine.append([boxPaddingToken])
		
		let maxLineLength = tokensByLine.map { line -> Int in
			length(of: line)
		}.sorted().last ?? 0
		
		for lineIndex in tokensByLine.indices {
			let lineLength = length(of: tokensByLine[lineIndex])
			let trailingLinePadding = maxLineLength + trailingPadding - lineLength
			
			wrap(&tokensByLine[lineIndex], with: paddingToken, count: (leadingPadding, trailingLinePadding))
		}
		
		return TokenizedString(lines: tokensByLine)
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
