//
//  Color Theme Utility
//
//  Created by August Saint Freytag on 22/12/2021.
//

import Foundation

// MARK: Presets

extension TokenizedString {
	
	// MARK: Code Presets
	
	public enum MarkdownPresets {
		
		public static var text: TokenizedString {
			TokenizedString(tokens: [
				.word("#", as: \.keyword), .space, .word("Scene Description", as: \.commentSectionHeader), .newLine,
				.space, .newLine,
				.word("We open to the interior of a "), .word("*", as: \.keyword), .word("newsroom", as: \.globalTypeSystem), .word("*", as: \.keyword), .word(" in Paris."), .space,
				.word("It is "), .word("*", as: \.keyword), .word("daytime", as: \.globalTypeSystem), .word("*", as: \.keyword), .word(", a typically busy day. On hold, with the "), .word("*", as: \.keyword), .word("phone", as: \.globalTypeSystem), .word("*", as: \.keyword), .word(" cradled under an ear, Will sorts through a "), .word("*", as: \.keyword), .word("bundle of mail", as: \.globalTypeSystem), .word("*", as: \.keyword), .word(" dropped on his desk."), .newLine,
				.space, .newLine,
				.word("Will speaks into the "), .word("*", as: \.keyword), .word("phone", as: \.globalTypeSystem), .word("*", as: \.keyword), .word(", without pauses, \"William Bloom with the Associated Press, if I could just…\" He's put back on hold. Returning to the mail, he finds a hand-addressed envelope. He rips it open.")
			])
		}
		
	}
	
	public enum TypeScriptPresets {
		
		public static var classDefinition: TokenizedString {
			TokenizedString(tokens: [
				.word("/**", as: \.commentDocumentation), .space, .word("Model of metadata associated with stored objects.", as: \.commentDocumentation), .word("*/", as: \.commentDocumentation), .newLine,
				.word("class", as: \.keyword), .space, .word("ObjectMetadata", as: \.declarationType), .space, .word("implements", as: \.keyword), .space, .word("Hashable", as: \.referenceTypeSystem), .word(","), .space, .word("ObjectProperty", as: \.referenceTypeProject), .space, .word("{"), .newLine,
				.indent, .word("id", as: \.declarationAny), .word(":"), .space, .word("UUID", as: \.referenceTypeSystem), .newLine,
				.indent, .word("created", as: \.declarationAny), .word(":"), .space, .word("Date", as: \.referenceTypeSystem), .newLine,
				.indent, .word("owners", as: \.declarationAny), .word(":"), .space, .word("Set", as: \.referenceTypeSystem), .word("<"), .word("OwnerIdentifier", as: \.valueTypeProject), .word(">"), .newLine,
				.indent, .word("data", as: \.declarationAny), .word(":"), .space, .word("string", as: \.globalTypeSystem), .newLine,
				.indent, .space, .newLine,
				.indent, .word("constructor", as: \.keyword), .word("("),
				.word("id", as: \.functionParameter), .word(":"), .space, .word("UUID", as: \.referenceTypeSystem), .word(","), .space,
				.word("created", as: \.functionParameter), .word(":"), .space, .word("Date", as: \.referenceTypeSystem), .word(","), .space,
				.word("owners", as: \.functionParameter), .word(":"), .space, .word("Set", as: \.referenceTypeSystem), .word("<"), .word("OwnerIdentifier", as: \.valueTypeProject), .word(">"), .word(","), .space,
				.word("data", as: \.functionParameter), .word(":"), .space, .word("string", as: \.referenceTypeSystem),
				.word(")"), .space, .word("{"), .newLine,
				.indent, .indent, .word("this", as: \.variableProject), .word("."), .word("id", as: \.variableProject), .space, .word("="), .space, .word("id", as: \.variableProject), .newLine,
				.indent, .indent, .word("this", as: \.variableProject), .word("."), .word("created", as: \.variableProject), .space, .word("="), .space, .word("created", as: \.variableProject), .newLine,
				.indent, .indent, .word("this", as: \.variableProject), .word("."), .word("owners", as: \.variableProject), .space, .word("="), .space, .word("owners", as: \.variableProject), .newLine,
				.indent, .indent, .word("this", as: \.variableProject), .word("."), .word("data", as: \.variableProject), .space, .word("="), .space, .word("data", as: \.variableProject), .newLine,
				.indent, .word("}"), .newLine,
				.word("}")
			])
		}
		
		public static var typeWithFunctionDefinition: TokenizedString {
			TokenizedString(tokens: [
				.word("type", as: \.keyword), .space, .word("GroupedObjects", as: \.declarationType), .space, .word("="), .space, .word("Dictionary", as: \.referenceTypeSystem), .word("<"), .word("ObjectGroup", as: \.referenceTypeProject), .word(","), .space, .word("Set", as: \.referenceTypeSystem), .word("<"), .word("Object", as: \.valueTypeProject), .word(">"), .word(">"), .newLine,
				.space, .newLine,
				.word("/**", as: \.commentDocumentation), .space, .word("Functionality to create collections of objects grouped by intrinsic properties.", as: \.commentDocumentation), .word("*/", as: \.commentDocumentation), .newLine,
				.word("export", as: \.keyword), .space, .word("interface", as: \.keyword), .space, .word("ObjectProvider", as: \.declarationType), .space, .word("{"), .newLine,
				.indent, .word("groupedObjects", as: \.functionProject), .word("("), .word("collection", as: \.functionParameter), .word(":"), .space, .word("Object", as: \.referenceTypeProject), .word("[]"), .word(")"), .word(":"), .space, .word("GroupedObjects", as: \.valueTypeProject), .newLine,
				.word("}")
			])
		}
		
		public static var literalDeclarations: TokenizedString {
			TokenizedString(tokens: [
				.word("/**", as: \.commentDocumentation), .space, .word("Metadata describing a report of stored objects.", as: \.commentDocumentation), .word("*/", as: \.commentDocumentation), .newLine,
				.word("class", as: \.keyword), .space, .word("ObjectReport", as: \.declarationType), .space, .word("{"), .newLine,
				.indent, .word("id", as: \.declarationAny), .word(":"), .space, .word("UUID", as: \.referenceTypeSystem), .space, .word("="), .space, .word("randomUUID", as: \.functionSystem), .word("()"), .newLine,
				.indent, .word("name", as: \.declarationAny), .word(":"), .space, .word("string", as: \.globalTypeSystem), .space, .word("="), .space, .word("\"Most Recent\"", as: \.string), .newLine,
				.indent, .word("kind", as: \.declarationAny), .word(":"), .space, .word("ReportKind", as: \.valueTypeProject), .space, .word("="), .space, .word("ReportKind", as: \.valueTypeProject), .word(".LastInterval", as: \.constantProject), .newLine,
				.indent, .word("numberOfEntries", as: \.declarationAny), .word(":"), .space, .word("Int", as: \.valueTypeSystem), .space, .word("="), .space, .word("400", as: \.number), .newLine,
				.word("}")
			])
		}
		
	}
	
	public enum SwiftPresets {
		
		public static var structDefinition: TokenizedString {
			TokenizedString(tokens: [
				.word("///", as: \.commentDocumentation), .space, .word("Model of metadata associated with stored objects.", as: \.commentDocumentation), .newLine,
				.word("struct", as: \.keyword), .space,.word("ObjectMetadata", as: \.declarationType), .word(":"), .space, .word("Hashable", as: \.referenceTypeSystem), .word(","), .space, .word("ObjectProperty", as: \.referenceTypeProject), .space, .word("{"), .space, .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("id", as: \.declarationAny), .word(":"), .space, .word("UUID", as: \.referenceTypeSystem), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("created", as: \.declarationAny), .word(":"), .space, .word("Date", as: \.referenceTypeSystem), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("owners", as: \.declarationAny), .word(":"), .space, .word("Set", as: \.referenceTypeSystem), .word("<"), .word("Owner", as: \.valueTypeProject), .word("."), .word("Identifier", as: \.valueTypeProject), .word(">"), .newLine,
				.indent, .word("let", as: \.keyword), .space, .word("data", as: \.declarationAny), .word(":"), .space, .word("String", as: \.globalTypeSystem), .newLine,
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
				.indent, .word("var", as: \.keyword), .space, .word("name", as: \.declarationAny), .word(":"), .space, .word("String", as: \.globalTypeSystem), .space, .word("="), .space, .word("\"Most Recent\"", as: \.string), .newLine,
				.indent, .word("var", as: \.keyword), .space, .word("kind", as: \.declarationAny), .word(":"), .space, .word("ReportKind", as: \.valueTypeProject), .space, .word("="), .space, .word(".lastInterval", as: \.constantProject), .newLine,
				.indent, .word("var", as: \.keyword), .space, .word("numberOfEntries", as: \.declarationAny), .word(":"), .space, .word("Int", as: \.valueTypeSystem), .space, .word("="), .space, .word("400", as: \.number), .newLine,
				.word("}")
			])
		}
		
	}
	
	// MARK: Editor Presets
	
	public enum XcodePreferencesPresets {
		
		public static var preferences: TokenizedString {
			TokenizedString(tokens: [
				.word("Plain Text", as: \.foreground), .newLine,
				.word("Comments", as: \.comment), .newLine,
				.word("Documentation Markup", as: \.commentDocumentation), .newLine,
				.word("Documentation Markup Keywords", as: \.commentSectionHeader), .newLine,
				.word("Marks", as: \.commentSection), .newLine,
				.word("Strings", as: \.string), .newLine,
				.word("Characters", as: \.character), .newLine,
				.word("Numbers", as: \.number), .newLine,
				.word("Keywords", as: \.keyword), .newLine,
				.word("Preprocessor Statements", as: \.preprocessorStatement), .newLine,
				.word("URLs", as: \.url), .newLine,
				.word("Attributes", as: \.attribute), .newLine,
				.word("Type Declarations", as: \.declarationType), .newLine,
				.word("Other Declarations", as: \.declarationAny), .newLine,
				.word("Project Class Names", as: \.referenceTypeProject), .newLine,
				.word("Project Function and Method Names", as: \.functionProject), .newLine,
				.word("Project Constants", as: \.constantProject), .newLine,
				.word("Project Type Names", as: \.valueTypeProject), .newLine,
				.word("Project Instance Variables and Globals", as: \.variableProject), .newLine,
				.word("Project Preprocessor Macros", as: \.preprocessorProject), .newLine,
				.word("Other Class Names", as: \.referenceTypeSystem), .newLine,
				.word("Other Function and Method Names", as: \.functionSystem), .newLine,
				.word("Other Constants", as: \.constantSystem), .newLine,
				.word("Other Type Names", as: \.valueTypeSystem), .newLine,
				.word("Other Instance Variables and Globals", as: \.variableSystem), .newLine,
				.word("Other Preprocessor Macros", as: \.preprocessorSystem), .newLine,
				.word("Heading (Unspecified)")
			])
		}
		
	}
	
}
