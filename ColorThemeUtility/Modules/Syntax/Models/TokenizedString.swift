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

// MARK: Presets

extension TokenizedString {
	
	public enum Presets {
		
		// MARK: Code Presets
		
		public static var structDefinition: TokenizedString {
			TokenizedString(tokens: [
				.word("///", as: \.commentDocumentation), .space, .word("Model of metadata associated with stored objects.", as: \.commentDocumentation), .newLine,
				.word("struct", as: \.keyword), .space,.word("ObjectMetadata", as: \.declarationType), .word(":"), .space, .word("Hashable", as: \.referenceTypeSystem), .word(","), .space, .word("ObjectProperty", as: \.referenceTypeProject), .space, .word("{"), .space, .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("id", as: \.declarationAny), .word(":"), .space, .word("UUID", as: \.referenceTypeSystem), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("created", as: \.declarationAny), .word(":"), .space, .word("Date", as: \.referenceTypeSystem), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("owners", as: \.declarationAny), .word(":"), .space, .word("Set", as: \.referenceTypeSystem), .word("<"), .word("Owner", as: \.valueTypeProject), .word("."), .word("Identifier", as: \.valueTypeProject), .word(">"), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("data", as: \.declarationAny), .word(":"), .space, .word("String", as: \.valueTypeSystem), .newLine,
				.word("}")
			])
		}
		
		public static var protocolWithFunctionDefinition: TokenizedString {
			TokenizedString(tokens: [
				.word("typealias", as: \.keyword), .space, .word("GroupedObjects", as: \.declarationType), .space, .word("="), .space, .word("["), .word("ObjectGroup", as: \.valueTypeProject), .word(":"), .space, .word("Set", as: \.valueTypeSystem), .word("<"), .word("Object", as: \.valueTypeProject), .word(">"), .word("]"), .newLine,
				.space, .newLine,
				.word("///", as: \.commentDocumentation), .space, .word("Functionality to create collections of objects grouped by intrinsic properties.", as: \.commentDocumentation), .newLine,
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
				.word("///", as: \.commentDocumentation), .space, .word("Metadata describing a report of stored objects.", as: \.commentDocumentation), .newLine,
				.word("struct", as: \.keyword), .space, .word("ObjectReport", as: \.declarationType), .space, .word("{"), .newLine,
				.indent, .word("var", as: \.keyword), .space, .word("id", as: \.declarationAny), .space, .word("="), .space, .word("UUID", as: \.valueTypeSystem), .word("()"), .newLine,
				.indent, .word("var", as: \.keyword), .space, .word("name", as: \.declarationAny), .word(":"), .space, .word("String", as: \.valueTypeSystem), .space, .word("="), .space, .word("\"Most Recent\"", as: \.string), .newLine,
				.indent, .word("var", as: \.keyword), .space, .word("kind", as: \.declarationAny), .word(":"), .space, .word("ReportKind", as: \.valueTypeProject), .space, .word("="), .space, .word(".lastInterval", as: \.constantProject), .newLine,
				.indent, .word("var", as: \.keyword), .space, .word("numberOfEntries", as: \.declarationAny), .word(":"), .space, .word("Int", as: \.valueTypeSystem), .space, .word("="), .space, .word("400", as: \.string), .newLine,
				.word("}")
			])
		}
		
		// MARK: Editor Presets
		
		public static var xcodePreferences: TokenizedString {
			TokenizedString(tokens: [
				.word("Plain Text", as: \.foreground),
				.word("Comments", as: \.comment),
				.word("Documentation Markup", as: \.commentDocumentation),
				.word("Documentation Markup Keywords", as: \.commentSectionHeader),
				.word("Marks", as: \.commentSection),
				.word("Strings", as: \.string),
				.word("Characters", as: \.character),
				.word("Numbers", as: \.number),
				.word("Keywords", as: \.keyword),
				.word("Preprocessor Statements", as: \.preprocessorSystem),
				.word("URLs", as: \.url),
				.word("Attributes", as: \.attribute),
				.word("Type Declarations", as: \.declarationType),
				.word("Other Declarations", as: \.declarationAny),
				.word("Project Class Names", as: \.referenceTypeProject),
				.word("Project Function and Method Names", as: \.functionProject),
				.word("Project Constants", as: \.constantProject),
				.word("Project Type Names", as: \.valueTypeProject),
				.word("Project Instance Variables and Globals", as: \.variableProject),
				.word("Project Preprocessor Macros", as: \.preprocessorProject),
				.word("Other Class Names", as: \.referenceTypeSystem),
				.word("Other Function and Method Names", as: \.functionSystem),
				.word("Other Constants", as: \.constantSystem),
				.word("Other Type Names", as: \.valueTypeSystem),
				.word("Other Instance Variables and Globals", as: \.variableSystem),
				.word("Other Preprocessor Macros", as: \.preprocessorSystem),
				.word("Heading (Unspecified)")
			])
		}
		
	}
	
}
