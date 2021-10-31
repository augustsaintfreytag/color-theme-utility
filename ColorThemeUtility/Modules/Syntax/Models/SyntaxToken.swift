//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 31/10/2021.
//

import Foundation
import ColorThemeFramework

public struct SyntaxToken {
	
	typealias Kind = KeyPath<IntermediateTheme, Color>
	
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
