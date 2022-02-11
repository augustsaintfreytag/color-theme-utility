//
//  ColorThemeUtility
//
//  Created by August Saint Freytag on 10/02/2022.
//

import Foundation

public struct TextMateTheme: Theme, CustomPropertyEnumerable {
	
	public typealias Setting = TextMateThemeSetting
	public typealias Settings = TextMateThemeSettings
	
	public let uuid: String
	public let name: String
	public let settings: [Setting]
	
	public static var format: ThemeFormat { .textmate }
	
}

extension TextMateTheme: Codable {
	
	enum CodingKeys: String, CodingKey {
		case uuid = "uuid"
		case name = "name"
		case settings = "settings"
	}
	
}

// MARK: Settings

public struct TextMateThemeSetting {
	
	public typealias Settings = TextMateThemeSettings
	
	public let name: String?
	public let scope: String?
	public let settings: Settings
	
}

extension TextMateThemeSetting {
	
	init(_ settings: Settings) {
		self.init(name: nil, scope: nil, settings: settings)
	}
	
}

extension TextMateThemeSetting: Codable {
	
	enum CodingKeys: String, CodingKey {
		case name = "name"
		case scope = "scope"
		case settings = "settings"
	}
	
}

public struct TextMateThemeSettings {
	
	public let background: String?
	public let foreground: String?
	public let caret: String?
	public let invisibles: String?
	public let guide: String?
	public let hoverHighlight: String?
	public let referenceHighlight: String?
	public let lineHighlight: String?
	public let rangeHighlight: String?
	public let selection: String?
	public let inactiveSelection: String?
	public let selectionHighlight: String?
	public let findRangeHighlight: String?
	public let findMatchHighlight: String?
	public let currentFindMatchHighlight: String?
	public let wordHighlight: String?
	public let wordHighlightStrong: String?
	public let activeLinkForeground: String?
	public let gotoDefinitionLinkForeground: String?
	public let fontStyle: String?
	
	public init(background: String?, foreground: String?, caret: String?, invisibles: String?, guide: String?, hoverHighlight: String?, referenceHighlight: String?, lineHighlight: String?, rangeHighlight: String?, selection: String?, inactiveSelection: String?, selectionHighlight: String?, findRangeHighlight: String?, findMatchHighlight: String?, currentFindMatchHighlight: String?, wordHighlight: String?, wordHighlightStrong: String?, activeLinkForeground: String?, gotoDefinitionLinkForeground: String?, fontStyle: String?) {
		self.background = background
		self.foreground = foreground
		self.caret = caret
		self.invisibles = invisibles
		self.guide = guide
		self.hoverHighlight = hoverHighlight
		self.referenceHighlight = referenceHighlight
		self.lineHighlight = lineHighlight
		self.rangeHighlight = rangeHighlight
		self.selection = selection
		self.inactiveSelection = inactiveSelection
		self.selectionHighlight = selectionHighlight
		self.findRangeHighlight = findRangeHighlight
		self.findMatchHighlight = findMatchHighlight
		self.currentFindMatchHighlight = currentFindMatchHighlight
		self.wordHighlight = wordHighlight
		self.wordHighlightStrong = wordHighlightStrong
		self.activeLinkForeground = activeLinkForeground
		self.gotoDefinitionLinkForeground = gotoDefinitionLinkForeground
		self.fontStyle = fontStyle
	}
	
	public init(foreground: String?) {
		self.init(
			background: nil,
			foreground: foreground,
			caret: nil,
			invisibles: nil,
			guide: nil,
			hoverHighlight: nil,
			referenceHighlight: nil,
			lineHighlight: nil,
			rangeHighlight: nil,
			selection: nil,
			inactiveSelection: nil,
			selectionHighlight: nil,
			findRangeHighlight: nil,
			findMatchHighlight: nil,
			currentFindMatchHighlight: nil,
			wordHighlight: nil,
			wordHighlightStrong: nil,
			activeLinkForeground: nil,
			gotoDefinitionLinkForeground: nil,
			fontStyle: nil
		)
	}
	
}

extension TextMateThemeSettings: Codable {
	
	enum CodingKeys: String, CodingKey {
		case background = "background"
		case foreground = "foreground"
		case caret = "caret"
		case invisibles = "invisibles"
		case guide = "guide"
		case hoverHighlight = "hoverHighlight"
		case referenceHighlight = "referenceHighlight"
		case lineHighlight = "lineHighlight"
		case rangeHighlight = "rangeHighlight"
		case selection = "selection"
		case inactiveSelection = "inactiveSelection"
		case selectionHighlight = "selectionHighlight"
		case findRangeHighlight = "findRangeHighlight"
		case findMatchHighlight = "findMatchHighlight"
		case currentFindMatchHighlight = "currentFindMatchHighlight"
		case wordHighlight = "wordHighlight"
		case wordHighlightStrong = "wordHighlightStrong"
		case activeLinkForeground = "activeLinkForeground"
		case gotoDefinitionLinkForeground = "gotoDefinitionLinkForeground"
		case fontStyle = "fontStyle"
	}
	
}

enum TextMateScopes {
	
	typealias Setting = TextMateThemeSetting
	typealias Settings = TextMateThemeSettings
	typealias SettingBlock = (_ settings: Settings) -> Setting
	
	// MARK: Comments
	
	static func comment(_ settings: Settings) -> Setting {
		Setting(name: "Comment", scope: "comment", settings: settings)
	}

	static func markupQuote(_ settings: Settings) -> Setting {
		Setting(name: "Markup Quote", scope: "markup.quote", settings: settings)
	}

	static func markupStyling(_ settings: Settings) -> Setting {
		Setting(name: "Markup Styling", scope: "markup.bold, markup.italic", settings: settings)
	}

	static func markupInline(_ settings: Settings) -> Setting {
		Setting(name: "Markup Inline", scope: "markup.inline.raw", settings: settings)
	}

	static func markupSetextHeader(_ settings: Settings) -> Setting {
		Setting(name: "Markup Setext Header", scope: "markup.heading.setext", settings: settings)
	}
	
	// MARK: Literals
	
	static func string(_ settings: Settings) -> Setting {
		Setting(name: "String", scope: "string", settings: settings)
	}

	static func number(_ settings: Settings) -> Setting {
		Setting(name: "Number", scope: "constant.numeric", settings: settings)
	}
	
	// MARK: Values

	static func builtInConstant(_ settings: Settings) -> Setting {
		Setting(name: "Built-in constant", scope: "constant.language", settings: settings)
	}

	static func libraryConstant(_ settings: Settings) -> Setting {
		Setting(name: "Library constant", scope: "support.constant", settings: settings)
	}

	static func userDefinedConstant(_ settings: Settings) -> Setting {
		Setting(name: "Constant", scope: "constant.character, constant.other", settings: settings)
	}

	static func libraryVariable(_ settings: Settings) -> Setting {
		Setting(name: "Library variable", scope: "support.other.variable", settings: settings)
	}

	static func variable(_ settings: Settings) -> Setting {
		Setting(name: "Variable", scope: "variable", settings: settings)
	}
	
	// MARK: Keywords

	static func keyword(_ settings: Settings) -> Setting {
		Setting(name: "Keyword", scope: "keyword", settings: settings)
	}
	
	// MARK: Types

	static func classType(_ settings: Settings) -> Setting {
		Setting(name: "Class", scope: "entity.name.class", settings: settings)
	}

	static func inheritedClassType(_ settings: Settings) -> Setting {
		Setting(name: "Inherited class", scope: "entity.other.inherited-class", settings: settings)
	}

	static func libraryClassType(_ settings: Settings) -> Setting {
		Setting(name: "Library class", scope: "support.class, support.type", settings: settings)
	}
	
	// MARK: Functions

	static func functionType(_ settings: Settings) -> Setting {
		Setting(name: "Function", scope: "entity.name.function", settings: settings)
	}

	static func libraryFunctionType(_ settings: Settings) -> Setting {
		Setting(name: "Library function", scope: "support.function", settings: settings)
	}
	
	// MARK: Tags

	static func functionParameter(_ settings: Settings) -> Setting {
		Setting(name: "Function parameter", scope: "variable.parameter", settings: settings)
	}

	static func tag(_ settings: Settings) -> Setting {
		Setting(name: "Tag", scope: "entity.name.tag", settings: settings)
	}

	static func tagAttribute(_ settings: Settings) -> Setting {
		Setting(name: "Tag attribute", scope: "entity.other.attribute-name", settings: settings)
	}
	
	// MARK: Miscellaneous
	
	static func storage(_ settings: Settings) -> Setting {
		Setting(name: "Storage", scope: "storage", settings: settings)
	}
	
	static func storageType(_ settings: Settings) -> Setting {
		Setting(name: "Storage type", scope: "storage.type", settings: settings)
	}
	
	// MARK: Errors

	static func invalid(_ settings: Settings) -> Setting {
		Setting(name: "Invalid", scope: "invalid", settings: settings)
	}

	static func invalidDeprecated(_ settings: Settings) -> Setting {
		Setting(name: "Invalid deprecated", scope: "invalid.deprecated", settings: settings)
	}

}
