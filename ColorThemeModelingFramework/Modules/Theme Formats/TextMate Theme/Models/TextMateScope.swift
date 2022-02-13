//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 11/02/2022.
//

import Foundation

enum TextMateScope {
	
	private typealias SubScope = TextMateSubScope
	
	enum Comments: SubScope {
		static var value: String { "comment" }
		
		enum Line: SubScope { static var value: String { "comment.line" } }
		enum Block: SubScope { static var value: String { "comment.block" } }
	}
	
	enum Markup {
		static var value: String { "markup" }
		
		enum Heading: SubScope { static var value: String { "markup.heading" } }
		enum Raw: SubScope { static var value: String { "markup.raw" } }
	}
	
	enum Keywords {
		static var value: String { "keyword" }
		
		enum Control: SubScope { static var value: String { "keyword.control" } }
		enum Operator: SubScope { static var value: String { "keyword.operator" } }
		enum Other: SubScope { static var value: String { "keyword.other" } }
	}
	
	enum Storage {
		static var value: String { "storage" }
		
		enum Types: SubScope { static var value: String { "storage.type" } }
		enum Modifiers: SubScope { static var value: String { "storage.modifier" } }
	}
	
	enum Constants {
		static var value: String { "constant" }
		
		enum Object: SubScope {
			static var value: String { "constant.object" }
			enum Property: SubScope { static var value: String { "constant.object.property" } }
		}
		
		enum Numeric: SubScope { static var value: String { "constant.numeric" } }
		enum Character: SubScope { static var value: String { "constant.character" } }
		enum Language: SubScope { static var value: String { "constant.language" } }
		enum Other: SubScope { static var value: String { "constant.other" } }
	}
	
	enum Variables {
		static var value: String { "variable" }
		
		enum Object: SubScope {
			static var value: String { "variable.object" }
			enum Property: SubScope { static var value: String { "variable.object.property" } }
		}
		
		enum Parameter: SubScope { static var value: String { "variable.parameter" } }
		enum Language: SubScope { static var value: String { "variable.language" } }
		enum Other: SubScope { static var value: String { "variable.other" } }
	}
	
	enum Entities {
		static var value: String { "entity" }
		
		enum Name: SubScope {
			static var value: String { "entity.name" }
			
			enum Functions: SubScope { static var value: String { "entity.name.function" } }
			enum Classes: SubScope { static var value: String { "entity.name.class" } }
			enum Tags: SubScope { static var value: String { "entity.name.tag" } }
			enum Sections: SubScope { static var value: String { "entity.name.section" } }

			enum Types: SubScope {
				static var value: String { "entity.name.type" }
				
				enum Structs: SubScope { static var value: String { "entity.name.type.struct" } }
				enum Protocols: SubScope { static var value: String { "entity.name.type.protocol" } }
				enum Typealias: SubScope { static var value: String { "entity.name.type.typealias" } }
			}
		}
		
		enum Other: SubScope {
			static var value: String { "entity.other" }
			
			enum InheritedClasses: SubScope { static var value: String { "entity.other.inherited-class" } }
			enum Attributes: SubScope { static var value: String { "entity.other.attribute-name" } }
		}
	}
	
	enum Strings {
		static var value: String { "string" }
		
		enum Quoted: SubScope { static var value: String { "string.quoted" } }
		enum Unquoted: SubScope { static var value: String { "string.unquoted" } }
		enum Interpolated: SubScope { static var value: String { "string.interpolated" } }
		enum RegularExpression: SubScope { static var value: String { "string.regexp" } }
		enum Other: SubScope { static var value: String { "string.other" } }
	}
	
	enum Support {
		static var value: String { "support" }
		
		enum Functions: SubScope { static var value: String { "support.function" } }
		enum Classes: SubScope { static var value: String { "support.class" } }
		enum Types: SubScope { static var value: String { "support.type" } }
		enum Constants: SubScope { static var value: String { "support.constant" } }
		enum Variables: SubScope { static var value: String { "support.variable" } }
		enum Other: SubScope { static var value: String { "support.other" } }
	}
	
	enum Invalid {
		static var value: String { "invalid" }
	}
	
}

protocol TextMateSubScope {
	static var value: String { get }
}

func textMateScopeSet(_ scopes: [TextMateSubScope.Type]) -> [String] {
	return scopes.map { SubScope in SubScope.value }
}

func textMateScope(_ scopes: [TextMateSubScope.Type]) -> String {
	let set = textMateScopeSet(scopes)
	return textMateScopeSelector(set)
}

func textMateScopeSelector(_ scopeDescriptions: [String]) -> String {
	return scopeDescriptions.joined(separator: ", ")
}
